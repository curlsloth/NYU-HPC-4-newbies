#!/bin/bash

# ANSI color codes for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Configuration ---
# Your NYU NetID. If you leave this empty, the script will ask you each time.
NETID= 
# The SSH alias for the Greene login node from your ~/.ssh/config file.
LOGIN_HOST="greene.hpc.nyu.edu" 
# The host you want to create in your config for VSCode.
COMPUTE_HOST="greene-compute"
# --- End of Configuration ---

# If NETID is not set in the script, prompt the user for it.
if [ -z "$NETID" ]; then
    read -p "Please enter your NYU NetID: " NETID
    if [ -z "$NETID" ]; then
        echo "NetID cannot be empty. Exiting."
        exit 1
    fi
fi

echo -e "${YELLOW}Step 1: Submitting SLURM 'sleep' job on ${LOGIN_HOST}...${NC}"

# SSH into the login node and submit the sbatch job.
# We capture the output to get the Job ID.
job_submission_output=$(ssh ${NETID}@${LOGIN_HOST} 'sbatch --parsable --time=06:00:00 --mem=16GB --wrap "sleep infinity"')

# Check if the job submission was successful
if ! [[ "$job_submission_output" =~ ^[0-9]+$ ]]; then
    echo "Error submitting SLURM job. Response was:"
    echo "$job_submission_output"
    exit 1
fi

job_id=$job_submission_output
echo -e "${GREEN}Successfully submitted job with ID: ${job_id}${NC}"

echo -e "\n${YELLOW}Step 2: Waiting for the job to be assigned to a compute node...${NC}"

# Loop until the squeue command returns a node name for our running job
node_name=""
while [ -z "$node_name" ]; do
    sleep 5 # Wait for 5 seconds between checks
    printf "."
    # Get the node name for the running job. 
    # -h suppresses the header, -o "%N" formats output to only show the node.
    node_name=$(ssh ${NETID}@${LOGIN_HOST} "squeue -j ${job_id} --states=RUNNING -h -o '%N'")
done

echo -e "\n${GREEN}Job is running on compute node: ${node_name}${NC}"

echo -e "\n${YELLOW}Step 3: Updating your local ~/.ssh/config file...${NC}"

# Define the local SSH config file path
config_file=~/.ssh/config
backup_file="${config_file}.bak"
# Only create a backup if one doesn't already exist
if [ ! -f "$backup_file" ]; then
    echo "Creating a backup of your original SSH config at ${backup_file}"
    cp "$config_file" "$backup_file"
fi

# This is a robust way to replace the block without messing up the rest of the file.
# 1. Create a temporary file.
# 2. Use awk to print every line from the original file *except* the old greene-compute block.
# 3. Append the new, correct block to the temporary file.
# 4. Replace the original file with the temporary one.
temp_file=$(mktemp)

# The awk command finds the block starting with "Host greene-compute" until the next blank line and skips it.
awk "BEGIN{p=1} /^Host ${COMPUTE_HOST}$/{p=0} p; /^[ \t]*$/{p=1}" "$config_file" > "$temp_file"

# Append the new configuration block to the temp file
cat >> "$temp_file" <<EOF

Host ${COMPUTE_HOST}
    HostName ${node_name}
    User ${NETID}
    ProxyJump ${NETID}@${LOGIN_HOST}
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    LogLevel ERROR
EOF

# Overwrite the original config file with the updated version
mv "$temp_file" "$config_file"

echo -e "${GREEN}Successfully updated ${config_file}!${NC}"

echo -e "\n${GREEN}✅ All done! You can now connect to your compute node in VSCode using the host:${NC} ${YELLOW}${COMPUTE_HOST}${NC}"