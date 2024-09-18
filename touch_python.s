#!/bin/bash
#SBATCH --job-name=touch_job
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=1:00:00
#SBATCH --output=/path/to/output/touch_python.out
#SBATCH --mail-user=<your-email>
#SBATCH --mail-type=END

# touch all the files
python /path/to/script/touch_files.py /path/to/target/folder