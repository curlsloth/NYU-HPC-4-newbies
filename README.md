# High Performance Computing (HPC) Tutorial for Newbies 🍼 #

Andrew Chang [Postdoctoral Fellow, Department of Psychology, New York University]

*Please email me (ac8888@nyu.edu) if you have any suggestions and advice, or spot any errors!*

![1637077691279](https://github.com/user-attachments/assets/254e2bbd-b710-4e92-ad97-8bc2e52fc1c8)

[Source: NYU](https://www.nyu.edu/research/navigating-research-technology/stories/greene-supercomputer-anniversary.html)

## 0. Preface ##
This is a tutorial for computer muggles who want to use NYU's HPC, **"Greene,"** to analyze their data or fit a machine learning model. It also serves as a note for myself and my colleagues. Feel free to distribute it.

Even though we all know that HPC can speed up our research, I found that most people don't want to use it because they worry that they will spend more time learning HPC than waiting for the computation to be completed on their laptops. This tutorial is designed to give you a quick start. It will help you set up a reliable and replicable HPC environment within one afternoon, even if you are not a computer geek.

**This tutorial is a lean and lay version of [NYU HPC's official website](https://sites.google.com/nyu.edu/nyu-hpc/), integrated with my own recommendations.** This tutorial covers topics related to data science or data analysis workflows. If you are a computer wizard or witch 🧙‍♀️🧙, this is not for you. If you are interested in knowing all the commands and details like Hermione Granger 📚, this is not for you. Some functions and approaches may be outdated when you read it, so make sure that you check out the NYU HPC's official website if you encounter any issues. Also, as different HPC systems may have different OS, this tutorial may not apply to other HPCs. Despite my approaches possibly not being the most efficient or correct way to do things, I hope this tutorial can give you a good start in using HPC and boost your productivity!

### Prerequisite
- You have to request a NYU HPC account. See instructions [here](https://www.nyu.edu/life/information-technology/research-computing-services/high-performance-computing/high-performance-computing-nyu-it/hpc-accounts-and-eligibility.html).
- Familiar with basic command line commands, such as `cd`, `ls`, `pwd`, `mv`, `rm`, `cat`, `mkdir`. Command line will be the primary way you interact with HPC (see [here](https://www.codecademy.com/article/command-line-commands) for a tutorial).
- Familiar with `Conda` commands. You will uses them to manage your environment (check out [here](https://docs.anaconda.com/anaconda/getting-started/) for more instructions).
- You don't have to be familiar with `Git/GitHub` or `Python`, but it will be helpful if you have some experience with them.

## 1. What is HPC? Should I use it? ##

HPC is a system where you can request computational resources (CPUs, GPUs, RAM, nodes) for each computational job, and you can request many jobs in parallel.

### If your laptop is your kitchen at home, HPC is a restaurant. ###

While you can cook all kinds of cuisines (scripts) in your kitchen at home (laptop), you only have access to a few stoves (CPUs), and you can only cook a small portion (RAM) at a time. You don't have access to some specialized equipment (GPU), and you are the only cook (compute node). HPC is a restaurant with many cooks and equipment which can cook all kinds of cuisines. You can assemble multiple cooks (compute nodes) and reserve multiple stoves (CPUs) and specialized equipment (GPUs) to cook multiple dishes at the same time. However, a downside of a restaurant is that it can be too busy to serve you if the cooks are already busy with other customers.

![image](https://github.com/user-attachments/assets/923b2f95-7556-4102-ad30-9e227f2223af)

[Source: overcooked ](https://store.steampowered.com/app/448510/Overcooked/) (Perhaps this is the real appearance of HPC at work?)

### You probably want to use HPC if ###
- You need more CPUs or RAM to do your job.
- You need to run a time-consuming loop that can be executed independently in parallel.
- You need to get access to a GPU.

### The HPC cannot help with ###
- Speeding up a time-consuming script that cannot be parallelized. It will be equally slow on HPC.

### How helpful can HPC be? ###

I once needed to analyze 200k audio files, and the process on each file would take approximately 15 seconds. In total, it would take 34.7 days to run through all the files if my poor laptop doesn’t burn 🔥! 
So, I ended up requesting 2000 jobs, each job processing 100 files. As a result, it took less than 2 hours to complete all the jobs, including the queue time ⚡️!


## 2. Your first step in using HPC! ##

Open your terminal application [Mac default](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac#:~:text=Open%20Terminal,%2C%20then%20double%2Dclick%20Terminal.), [PC default](https://learn.microsoft.com/en-us/windows/terminal/) or [iTerm for Mac (recommended)](https://iterm2.com/), connect to the [NYU VPN](https://www.nyu.edu/life/information-technology/infrastructure/network-services/vpn.html), and log into Greene by executing this line (key in and then press enter):

```
ssh <NetID>@gw.hpc.nyu.edu ## you can skip this step if you are on the NYU network or using the NYU VPN
ssh <NetID>@greene.hpc.nyu.edu
```
> **Replace `<NetID>` of this tutorial with your own, such as `ab1234`**

Then enter your password. It should be the same as your NetID password.

If everything is correct, the login node will look something like this:
```
[<NetID>@log-3 ~]$
```

`log-3` is the login node. Please do NOT run CPU-heavy jobs on login nodes, as it serves other users as well.

Your first step is to request a compute node dedicated to serving you. Execute this line:
```
srun --cpus-per-task=1 --mem=10GB --time=04:00:00 --pty /bin/bash
```
It means that you request the node to have 1 CPU and 10 GB of RAM and serve you for 4 hours. You can change these parameters to whatever you want. **However, the more resources you request, the longer the queue time (depending on how many other jobs and resources were requested by other users).**

After a short queue, you will see the terminal displaying this:

```
[<NetID>@log-3 ~]$ srun --cpus-per-task=1 --mem=10GB --time=04:00:00 --pty /bin/bash
srun: job 48347520 queued and waiting for resources
srun: job 48347520 has been allocated resources
[<NetID>@cm015 ~]$
```

Now you have a compute node `cm015` ready to serve you. 

You can start Python by executing this line:

```
python
# Output:
# Python 3.9.16 (main, Jan  4 2024, 00:00:00)
# [GCC 11.3.1 20221121 (Red Hat 11.3.1-4)] on linux
# Type "help", "copyright", "credits" or "license" for more information.
# >>>
```
Now you can run any Python commands following `>>>` on HPC the same way as you do on your local computer.

Congratulations! Now you know the core workflow of using HPC. The following sections cover how to streamline the process to make it easier, automatic, replicable, and parallel.

> Note that since Greene is Linux-based, the commands you use will need to be Linux-based as well.

## 3. HPC data management ##

### 3-1. Greene storage options ###

There are several root directories on Greene, each with different specifications tailored for various purposes.

| Storage   | Disk Space / Number of Files     | Backed Up / Flushed                 | Recommendation                                                                                                                 |
|-----------|----------------------------------|-------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| /home     | 50 GB / 30 K                     | YES / NO                            | Store your Singularity and other frequently used keys or important results.                                                    |
| /archive  | 2 TB / 20 K                      | YES / NO                            | Long-term storage. Archive your projects as .tar or .zip or unused Singularity files. Only for infrequent access.              |
| /scratch  | 5 TB / 1 M                       | NO / Files not accessed for 60 days | Put working projects here, especially those with a small number of large files (e.g., neuroimages).                            |
| /vast     | 2 TB / 5 M                       | NO / Files not accessed for 60 days | Put working projects here, especially those involving many small files with high I/O workflows (e.g., audio or image files).   |

You can execute the `myquota` command to see the current usage of your storage.
```
myquota
# Output:
# Hostname: log-3 at Thu Jul 11 07:39:37 AM EDT 2024
# 
# Filesystem   Environment   Backed up?    Allocation         Current Usage
# Space        Variable      /Flushed?     Space / Files      Space(%) / Files(%)
# 
# /home        $HOME         Yes/No        50.0GB/30.0K       46.75GB(93.50%)/13008(43.36%)
# /scratch     $SCRATCH      No/Yes        5.0TB/1.0M         0.97GB(0.02%)/11764(1.18%)
# /archive     $ARCHIVE      Yes/No        2.0TB/20.0K        56.33GB(2.75%)/233(1.16%)
# /vast        $VAST         NO/YES        2TB/5.0M           1.38TB(69.0%)/3454787(69%)
```

#### Organizing and archieving files ####

Typically, you want to put your project folder under `/scratch` or `/vast`, and your Conda environment, Singularity (will explain later), and other personal login files under `/home`. Since data not accessed for 60 days under `/scratch` and `/vast` will be wiped out, I recommend compressing the project folder and saving it under `/archive` periodically.

Run this line to compress the folder and save it under `/archive`:
```
tar -czvf /archive/<NetID>/myProject_20240711.tgz /scratch/<NetID>/myProjectFolder
```
Run this line to uncompress the .tgz file and put it back to `/scratch`:
```
tar -xvf /archive/<NetID>/myProject_20240711.tgz /scratch/<NetID>/
```
You will see the `/scratch/<NetID>/myProjectFolder` folder is back.

Here is an [instruction](https://support.apple.com/guide/terminal/compress-and-uncompress-file-archives-apdc52250ee-4659-4751-9a3a-8b7988150530/mac) on how to tar archieve a folder on Mac/Linux.

### 3-2. Data transfer ###

According to NYU HPC's [website](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management/data-transfers), there are a number of ways to transfer data to HPC. Here, I will introduce two methods that I recommend.

#### Use Globus to transfer big data files ####

Globus has a browser-based user interface for file transfers, which is very intuitive and features automatic error monitoring. See [here](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management/data-transfers/globus) for instructions.

However, Globus can be slow when transferring a large quantity of files. In such cases, you can simply compress the entire folder on your local machine into a single tar file, upload that tar file using Globus, and then uncompressed it on HPC.

#### Use GitHub to transfer scripts (and a small number of small-sized data files) ####

Manually synchronizing script files using Globus can be error-prone, as it's easy to lose track, especially when dealing with a large number of small files. Therefore, I recommend synchronizing your scripts (and perhaps a small number of small-sized data files) using GitHub, similar to working on the same project across multiple computers.

Cloning a GitHub repository to HPC is the same as on your local machine ([instructions](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)). Just remember to [`.gitignore`](https://www.w3schools.com/git/git_ignore.asp) your data folder and anything else you don't want to share.

> **Tip:** I strongly recommend organizing your project files following the [cookiecutter-data-science template](https://github.com/drivendataorg/cookiecutter-data-science#the-resulting-directory-structure). You can do this manually if you prefer not to run the script for it. **Future you will thank you!**

## 4. Set up a replicable programming environment using Singularity and Conda ##

One of the more complex steps in using HPC is setting up the environment and installing all necessary packages. Singularity and Miniconda can simplify this process significantly. While it may take a couple of hours to complete all the steps for the first time, it will become faster and easier.

### 4-1. Use Conda to Manage Environments ###

Conda is a powerful tool for package and environment management. It allows you to create multiple environments with different versions of packages and dependencies that won't interfere with each other. Whenever you install a new package within an environment, Conda checks and updates its dependencies with other existing packages. This is particularly useful when working on multiple projects using different sets of tools, or when you want to install new packages without risking conflicts in the existing environment.

To keep this tutorial focused on HPC, I assume that you are already familiar with Conda and actively using it on your local computer. **If not, start using Conda today! See [here](https://conda.org/learn/faq/#:~:text=It%20provides%20a%20unified%20interface,compatibility%20issues%20across%20different%20platforms.) for reasons why you should use it, and check out [here](https://docs.anaconda.com/anaconda/getting-started/) for more instructions.**

### 4-2. Use Singularity to Contain Conda Environment ###

[Singularity](https://docs.sylabs.io/guides/3.5/user-guide/introduction.html) is a container platform specifically designed for HPC and has become widely adopted across many HPC systems as a standard.

Without Singularity, finding a suitable place to store your Conda environment file on HPC can be challenging. The `/home` space typically has limits on the number of files it can contain, which may not be sufficient to host all required packages. While `/scratch` and `/vast` can accommodate many files, these locations are regularly wiped clean. You wouldn't want to repeatedly recreate your Conda environment!

**Singularity acts like a container.** It appears as a single file to the HPC file system but can contain numerous files within. This allows you to store your Singularity container under `/home` without concerns about hitting file limits.

**You can even share a copy of your Singularity `.ext3` file with others to ensure reproducibility!** Your colleagues won't need to reinstall the packages you used, which may no longer be available in the future. However, note that the `.ext3` file can be quite large, depending on the initial size you requested.

### 4-3. Step-by-step Guidance ###

*This section is primarily adapted from the [NYU HPC website](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda).*

#### Step 1: Create a Directory for the Environment ####
```
mkdir /scratch/<NetID>/pytorch-example # make directory
cd /scratch/<NetID>/pytorch-example    # change the current directory to this place
```

#### Step 2: Copy an Appropriate Gzipped Overlay Image from the Overlay Directory ####

You can browse available images using `ls` to see the options available:

```
ls /scratch/work/public/overlay-fs-ext3
```

In this example, we'll use `overlay-15GB-500K.ext3.gz` as it provides sufficient storage for most Conda environments. It offers 15GB of free space and can hold up to 500K files. You can choose a different size if needed, but remember that the overlay image cannot be easily modified later. It's recommended to select one slightly larger than your current needs.

```
cp -rp /scratch/work/public/overlay-fs-ext3/overlay-15GB-500K.ext3.gz .
gunzip overlay-15GB-500K.ext3.gz
```

#### Step 3: Choose a Corresponding Singularity Image ####

Choosing a Singularity image is akin to selecting an operating system to run your code. You can change this each time you access the overlay file.

For this example, we will use the following image:

```
/scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif
```

To view available Singularity images on NYU HPC Greene, you can check the singularity images folder:

```
ls /scratch/work/public/singularity/
```

For the most recent supported versions, refer to the [TensorFlow website](https://www.tensorflow.org/install/pip).

#### Step 4: Launch the Appropriate Singularity Container in Read/Write Mode (with the `:rw` Flag) ####

```
singularity exec --overlay overlay-15GB-500K.ext3:rw /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif /bin/bash
```

The above command starts a bash shell inside the specified Singularity container, overlaid with the 15GB, 500K file system you set up earlier. This setup provides the illusion of having a writable filesystem inside what is typically a read-only Singularity container.

#### Step 5: Inside the Container, Download and Install Miniconda to /ext3/miniconda3 ####

Run these commands:

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# or try: wget --no-check-certificate https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
```

You can then remove the installation file to save space:

```
rm Miniconda3-latest-Linux-x86_64.sh
```

#### Step 6: Create a Wrapper Script /ext3/env.sh Using a Text Editor ####

Use nano to create and open the file:

```
nano /ext3/env.sh
```

Inside nano, enter the following content for the wrapper script. This script will activate your Conda environment where you can install your packages and dependencies:

```
#!/bin/bash

unset -f which

source /ext3/miniconda3/etc/profile.d/conda.sh
export PATH=/ext3/miniconda3/bin:$PATH
export PYTHONPATH=/ext3/miniconda3/bin:$PATH
```

To save the file, press `Ctrl+O`, then `Enter` to save the file, and `Ctrl+X` to exit.

#### Step 7: Activate and Update Your Conda Environment ####

Run this to activate the environment:
```
source /ext3/env.sh
```

Now that your environment is activated, you can update and install packages

```
conda update -n base conda -y
conda clean --all --yes
conda install pip -y
conda install ipykernel -y # Note: ipykernel is required to run as a kernel in the Open OnDemand Jupyter Notebooks
```
To confirm that your environment is appropriately referencing your Miniconda installation, try out the following:
```
unset -f which
which conda
# output: /ext3/miniconda3/bin/conda

which python
# output: /ext3/miniconda3/bin/python

python --version
# output: Python 3.8.5

which pip
# output: /ext3/miniconda3/bin/pip

exit
# exit Singularity
```

#### Step 8: Install Packages ####

You may now install packages into the environment with either the pip install or conda install commands. 

First, start an interactive job with adequate compute and memory resources to install packages. The login nodes restrict memory to 2GB per user, which may cause some large packages to crash.
```
srun --cpus-per-task=2 --mem=10GB --time=04:00:00 --pty /bin/bash  # request a compute node

# wait to be assigned a node

singularity exec --overlay overlay-15GB-500K.ext3:rw /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif /bin/bash

source /ext3/env.sh # activate the environment
```

**Option 1: pip install (it works, but not recommended)**

You can install PyTorch using `pip` as an example:
```
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116
pip3 install jupyter jupyterhub pandas matplotlib scipy scikit-learn scikit-image Pillow
```

**Option 2: create a new conda env with specified packages (recommended)**

*The following sections will be based on this.*

I recommend using conda to ensure compatibility among packages. Execute this command to create a Conda environment named `pytorch-ac8888` with several essential packages installed:

```
conda create -n pytorch-ac8888 pytorch jupyter jupyterhub pandas matplotlib scipy scikit-learn scikit-image Pillow
```

After the environment is created, activate it using:

```
conda activate pytorch-ac8888
```

You might wonder why we create a Conda environment within a `.ext3` file, which is already dedicated to this project. The reason is that you may need multiple environments for different analyses due to package incompatibilities. Also, having separate environments allows you to duplicate them as backups in case upgrading some packages disrupts the entire environment. This approach ensures flexibility and reproducibility in your HPC workflows.

> Refer to the [Conda documentation](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) for more details on managing Conda environments.

**Option 3: recreate a Conda env from `.yaml` file (may not alway work)**

You can export a `.yaml` file listing all the packages and versions you use on your local computer, upload it to HPC, and use it to recreate a Conda environment. This method replicates the exact same environment on HPC.

1. Use Globus to upload the `.yaml` [file](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/pytorch-ac8888_20240711.yaml) to `/scratch/<NetID>/pytorch-example/`.
   
2. Run the following command on HPC:

```
conda env create -f /scratch/<NetID>/pytorch-example/pytorch-ac8888_20240711.yaml
```

However, note that this approach may not always work perfectly. Some packages installed on your local machine might be incompatible on HPC. In such cases, you may need to relax constraints on package versions or exclude unnecessary packages from the `.yaml` file.

#### Step 9: Verify Your Setup ####

You can check the available space left on your image using the following command:

```
find /ext3 | wc -l
# output: should be something like 222076

du -sh  /ext3        
# output should be something like 6.0G    /ext3
```
Now, exit the Singularity container and then rename the overlay image. Typing `exit`and hitting enter will exit the Singularity container if you are currently inside it. You can tell if you're in a Singularity container because your prompt will be different, such as showing the prompt `Singularity>`
```
exit
mv overlay-15GB-500K.ext3 my_pytorch.ext3
```
Test your PyTorch Singularity Image
```
singularity exec --overlay /scratch/<NetID>/pytorch-example/my_pytorch.ext3:ro /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif /bin/bash -c 'source /ext3/env.sh; conda activate pytorch-ac8888; python -c "import torch; print(torch.__file__); print(torch.__version__)"'

#output: /ext3/miniconda3/envs/pytorch-ac8888/lib/python3.12/site-packages/torch/__init__.py
#output: 2.3.1.post100
```

Note that by default, you are accessing the image with the `:ro` (read-only) flag, which prevents accidental modifications to the packages in your environment. This is recommended when executing your scripts to maintain consistency.

If you need to make further modifications to the environment, you will need to change the flag to `:rw` (read-write). This allows you to write changes to the Singularity container, such as installing new packages or updating existing ones. 

## 5. Quickly run a Python script using `.bash` ##

### 5-1. Create a `.bash` Script ###

To simplify the steps required to access the Conda environment in the image, you can create a `.bash` file on your computer named `run-pytorch-ac8888.bash` and upload it to the directory `/scratch/<NetID>/pytorch-example/`. The file should resemble [this example](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/run-pytorch-ac8888.bash).


```bash
#!/bin/bash

args=''
for i in "$@"; do 
  i="${i//\\/\\\\}"
  args="${args} \"${i//\"/\\\"}\""
done

if [ "${args}" == "" ]; then args="/bin/bash"; fi

if [[ -e /dev/nvidia0 ]]; then nv="--nv"; fi

singularity \
    exec \
    --nv --overlay /scratch/<NetID>/pytorch-example/my_pytorch.ext3:ro \
    /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif \
    /bin/bash -c "
unset -f which
source /opt/apps/lmod/lmod/init/sh
source /ext3/env.sh
conda activate pytorch-ac8888
${args}
"
```

To make this script executable, run this command:
```
chmod 755  /scratch/<NetID>/pytorch-example/run-pytorch-ac8888.bash
```

Now you can access to the Conda environment simply by running:
```
/scratch/<NetID>/pytorch-example/run-pytorch-ac8888.bash
```

Check which environment is currently activated:
```
conda env list
## Output:
# # conda environments:
# #
# base                     /ext3/miniconda3
# pytorch-ac8888        *  /ext3/miniconda3/envs/pytorch-ac8888
```
The `*` sign indicates the currently activated environment.

### 5-2. Use `.bash` script to run a Python script ###

Here is a simple Python script `print_odd_even.py` for demonstration purposes, which can be downloaded [here](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/print_odd_even.py):

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

def print_odd_number(n):
    print(str(n)+" is an odd number")
    
def print_even_number(n):
    print(str(n)+" is an even number")

if __name__ == "__main__":
    # Check if the correct number of arguments are provided
    if len(sys.argv) != 2:
        print("Usage: python script.py arg1")
        sys.exit(1)

    # Extract command-line arguments
    n = int(sys.argv[1])
    
    if n%2==0:
        print_even_number(n)
    else:
        print_odd_number(n)
    
    sys.exit(0)
```

Now you can upload it to HPC `/scratch/<NetID>/pytorch-example/` and then run the following command: 

```
/scratch/<NetID>/pytorch-example/run-pytorch-ac8888.bash python /scratch/<NetID>/pytorch-example/print_odd_even.py 23
# Output: 23 is an odd number
```

There are 4 chunks in this line. To break it down:
1. `/scratch/<NetID>/pytorch-example/run-pytorch-ac8888.bash` calls the `.bash` script file.
2. `python` calls the Python interpreter.
3. `/scratch/<NetID>/pytorch-example/print_odd_even.py` is the Python script you are executing. It corresponds to `sys.argv[0]` in the Python script.
4.  `23` is the numerical input (`n`) for the function. In this example, you can replace `23` with any other integer. It corresponds to `sys.argv[1]` in the Python script.

Note that all `sys.argv[_]` inputs are automatically read as strings, so numerical inputs need to be converted to integers using `int()` in your `.py` script (or float using `float()`) .

## 6. Run the same script on multiple nodes in parallel ##

### 6-1. Submit a job array ###

One of the biggest advantages of using HPC is that you can run the same script on multiple nodes in parallel. Using job array you may submit many similar jobs with almost identical job requirement. This can be easily achieved using SLURM batch jobs:

```
#!/bin/bash

#SBATCH --job-name=testrun            # The name of the job
#SBATCH --nodes=1                     # Request 1 compute node per job instance
#SBATCH --cpus-per-task=1             # Request 1 CPU per job instance
#SBATCH --mem=2GB                     # Request 2GB of RAM per job instance
#SBATCH --time=00:10:00               # Request 10 mins per job instance
#SBATCH --output=/scratch/<NetID>/pytorch-example/slurm_output/out_%A_%a.out  # The output will be saved here. %A will be replaced by the slurm job ID, and %a will be replaced by the SLURM_ARRAY_TASK_ID
#SBATCH --mail-user=<NetID>@nyu.edu   # Email address
#SBATCH --mail-type=END               # Send an email when all the instances of this job are completed

module purge                          # unload all currently loaded modules in the environment

/scratch/<NetID>/pytorch-example/run-pytorch-ac8888.bash python /scratch/<NetID>/pytorch-example/print_odd_even.py $SLURM_ARRAY_TASK_ID
```

Save it as [`sbatch_pytorch-ac8888.s`](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/sbatch_pytorch-ac8888.s) and upload it to `/scratch/<NetID>/pytorch-example/`.

You can modify the requested resources as needed. However, requesting more resources will increase the queue time. There are also limits on the resources you can request; please refer to [this link](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/best-practices?authuser=0#h.p_ID_142).

Since the script will save output files under `/scratch/<NetID>/pytorch-example/slurm_output/`, ensure you create that folder beforehand by running `mkdir /scratch/<NetID>/pytorch-example/slurm_output`.

Now you can execute the script by running this command:

```
sbatch --array=0-99 /scratch/<NetID>/pytorch-example/sbatch_pytorch-ac8888.s
# Output: Submitted batch job 48368654
```

The `--array=0-99` option means that there will be 100 instances of the script executed, with inputs ranging from 0 to 99. Each instance will be assigned a number stored in `$SLURM_ARRAY_TASK_ID`, and then passed onto the `print_odd_even.py` script as input variable `sys.argv[1]` or `n`.

The job ID is `48368654`.

### 6-2. Check the current status of my jobs ###

You can check the status of all your jobs using this command:

```
squeue -u <NetID>
# Output: 
#             JOBID PARTITION     NAME     USER ST       TIME  NODES
#   48368654_[0-99] short,cs,  testrun  <NetID> PD       0:00      1 
```

Here are some other useful [SLURM commands](https://sites.google.com/nyu.edu/nyu-hpc/training-support/general-hpc-topics/slurm-main-commands) that can help you get information about running and pending jobs, which can guide you in requesting just enough resources next time.

```
# detailed information for a job:
scontrol show jobid -dd <JobID>

# show status of a currently running job
# (see 'man sstat' for other available JOB STATUS FIELDS)
sstat --format=TresUsageInMax%80,TresUsageInMaxNode%80 -j <JobID> --allsteps

# get stats for completed jobs 
# (see 'man sacct' for other JOB ACCOUNTING FIELDS)
sacct --units=G --format=User,JobID%24,Jobname,state,time,start,end,elapsed,TotalCPU,ReqMem,MaxRss,MaxVMSize,nnodes,ncpus,nodelist -j <JobID>

# the same information for all jobs of a user:
sacct --units=G --format=User,JobID%24,Jobname,state,time,start,end,elapsed,TotalCPU,ReqMem,MaxRss,MaxVMSize,nnodes,ncpus,nodelist -u <NetID>
```

### 6-3. Check the output of my jobs ###

When the all the jobs are done, you will receive an email titled something like this `Slurm Array Summary Job_id=48368654_* (48368654) Name=testrun Ended, COMPLETED, ExitCode [0-0]`, where `ExitCode 0` means there's no error! `ExitCode 1` means an error. `ExitCode [0-1]` means some instances have no error while some have.

You can list all the output files in the `/scratch/<NetID>/pytorch-example/slurm_output/` directory using the `ls` command:
```
ls /scratch/<NetID>/pytorch-example/slurm_output/
# out_48368654_0.out   out_48368654_25.out  out_48368654_40.out  out_48368654_56.out  out_48368654_71.out  out_48368654_87.out
# out_48368654_10.out  out_48368654_26.out  out_48368654_41.out  out_48368654_57.out  out_48368654_72.out  out_48368654_88.out
# out_48368654_11.out  out_48368654_27.out  out_48368654_42.out  out_48368654_58.out  out_48368654_73.out  out_48368654_89.out
# out_48368654_12.out  out_48368654_28.out  out_48368654_43.out  out_48368654_59.out  out_48368654_74.out  out_48368654_8.out
# ...
# (There should be a total of 100 files, each following the naming scheme out_[slurm job ID]_[SLURM_ARRAY_TASK_ID].out.)
```

You can view the content of a file using the `cat` command to check the output of our Python script:

```
cat /scratch/<NetID>/pytorch-example/slurm_output/out_48368654_0.out
# Output: 0 is an even number

cat /scratch/<NetID>/pytorch-example/slurm_output/out_48368654_23.out
# Output: 23 is an odd number
```

## 7. GPU job ##

### 7-1. Install the right GPU package ###

Before submitting a GPU job, make sure that your package is GPU-compatible, as many Python packages have different versions for GPU and CPU-only usage. For instance, in PyTorch, you need to install:
```
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```
See more [here](https://pytorch.org/get-started/locally/).

**As of Jan 25, 2025, NYU HPC currently only support up to CUDA 12.1**

### 7-2. How to request GPU? ###

You can add this line into your `.s` sbatch file:
```
#SBATCH --gres=gpu:2 # requesting 2 GPUs
```
**However, unless your job specifically requires GPU usage and you are highly experienced in utilizing it, I do not recommend requesting GPUs for the following reasons:**

1. **Long Queue Times:** Queue times for GPU jobs are typically very long because GPUs are in high demand. Even with the faster computational speed of GPUs, the extended queue times often negate their benefits.

2. **Termination for Low GPU Usage:** NYU HPC may terminate jobs that do not effectively utilize GPUs. This could require trial-and-error to optimize GPU usage, resulting in prolonged queue times for your jobs.

### 7-3. How to monitor GPU usage? ###

When the GPU job is running, use this command to access the job's node:

```bash
srun --jobid=<JOB_ID> --pty bash
```

Then use this command to monitor GPU performance in real time.

```bash
watch -n 1 nvidia-smi
```

You will see something like this, where the memory usage is 235 MiB / 46080 MiB, and the GPU utilization rate is 20%:

```
Every 1.0s: nvidia-smi

Sat Jan 25 08:51:54 2025
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.154.05             Driver Version: 535.154.05   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  Quadro RTX 8000                On  | 00000000:D8:00.0 Off |                    0 |
| N/A   39C    P0              61W / 250W |    235MiB / 46080MiB |     20%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+

+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A   1020293      C   python                                      232MiB |
+---------------------------------------------------------------------------------------+
```
### 7-4. What if my GPU job kept getting cancelled? ###

Your GPU job will be cancelled if the utility rate remains too low for an extended period (e.g., 2 hours). In pytorch (and most of the neural network models), you can often improve the utility rate by:  
1. Increasing the batch size,  
2. Increasing model complexity, and  
3. Ensuring that data loading is not a bottleneck (see [this guide](https://discuss.pytorch.org/t/how-to-prefetch-data-when-processing-with-gpu/548)).  

However, optimizing the utility rate can be challenging, requiring extensive trial-and-error, engineering effort, and waiting in the queue. For this reason, I sometimes recommend running jobs on multi-core CPUs as an alternative.

Another hacking strategy is to design your job as a "relay race" so that a cancelled job can be resumed. Most ML toolkits support resuming training from a previous checkpoint. After submitting your first job, use the `--dependency=afternotok:<JobID>` command (see [this guide](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/README.md#how-to-run-a-new-job-after-the-completion-of-a-previous-job)) to schedule a follow-up job that runs only if the previous one gets cancelled.  

Additionally, requesting shorter job durations (e.g., 2 hours) can significantly reduce GPU queue times. With this relay strategy, the shorter duration becomes less critical since subsequent jobs will pick up where the cancelled one left off.  

## 8. Miscellaneous topics ##

HPC systems offer a wide range of capabilities. Here, I'll cover the ones I've worked with before.

### How to "install" other programs or libraries?  ###

HPC systems typically use a module system to load most software into a user’s environment. This approach is particularly useful for tasks involving audio and/or video file processing.

You can use `module avail` to check the available modules on an HPC. On Greene, for example, there are hundreds of modules available.

```
module avail

# Output:
#-------------------------------------------------------- /share/apps/modulefiles ---------------------------------------------------------
#   abyss/intel/2.3.0                          google-chrome/87.0.4280.88             nwchem/openmpi/intel/7.2.0
#   admixtools/intel/7.0.2                     google-cloud-sdk/357.0.0               octopus/openmpi/intel/20240311
#   admixture/1.3.0                            google-cloud-sdk/379.0.0               octopus/openmpi/intel/20240323
#   advanpix-mct/4.9.3.15018                   googletest/1.10.0                      onetbb/intel/2020.3
#...
```

For example, if your Python packages related to audio processing require `libsndfile`, you can load it using `module load libsndfile/intel/1.0.31`. Insert this command after module purge in your `.sbatch` file like this:

```
module purge
module load libsndfile/intel/1.0.31
```
### Can I run MATLAB scripts? ###

Yes, you can. Setting up MATLAB on HPC is usually easier than Python, as it typically does not involve Singularity and Conda. You only need to use the module command to load MATLAB.

Make a few modifications in your `.sbatch` file right below the `#SBATCH` section:

```
module purge
module load matlab/2023b # There are many other versions available on Greene you can choose from

matlab -nodisplay -r "your_matlab_function($SLURM_ARRAY_TASK_ID); exit;"
```

Note that executing a MATLAB script will always return "COMPLETED, ExitCode [0]", regardless of whether it crashed or not. Therefore, make sure to check the SLURM output files for accurate status.

### Can I use Jupyter notebook on HPC? ###

Yes, you can use it via Open OnDemand! Here are the [instructions](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/open-ondemand-ood-with-condasingularity).

I recommend using this GUI to experiment directly with your scripts while utilizing HPC's resources. It can be more effective than testing on your local computer with limited resources or running debugging cycles each time you execute a `.py` file. Once you have a working pipeline, you can reorganize it into a `.py` file for scaling up.

### How to design an array job? ###

If you have a job that needs to be executed in 100k instances of the [`print_odd_even.py`](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/print_odd_even.py) script, ranging from 0 to 99,999, and each instance only takes 0.1 seconds to run, it may not be a good idea to request `--array=0-99999` as there will be 100k output files! You want to find a balance among quantity, speed, and complexity.

You may want to tweak the script as follows and request `sbatch` job with `--array=0-99`:

```python
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys

def print_odd_number(n):
    print(str(n)+" is an odd number")
    
def print_even_number(n):
    print(str(n)+" is an even number")

if __name__ == "__main__":
    # Check if the correct number of arguments are provided
    if len(sys.argv) != 2:
        print("Usage: python script.py arg1")
        sys.exit(1)

    # Extract command-line arguments
    n = int(sys.argv[1])

    # This section has been modified
    for i in range(n*1000, (n+1)*1000):
       if i%2==0:
           print_even_number(i)
       else:
           print_odd_number(i)
    
    sys.exit(0)
```

This new script makes each job instance loop through 1000 iterations per `n`. When `n=0`, this instance will loop `i` from 0 to 999. When `n=1`, this instance will loop `i` from 1000 to 1999, and so on. Therefore, it is equivalent to running 100k brief instances in parallel, but it is much more manageable with only 100 job instances. 

Although the execution time per instance is 1000 times longer, the difference is just 0.1 s vs. 100 s. Also, the total queue time and required resources of 100k jobs is almost certainly much longer and larger than 100 jobs!

### How to run a new job after the completion of a previous job?

To start a new job after the completion of a previous job, you can use the `job dependencies` feature in SLURM. This allows you to set up a dependency between jobs, ensuring the subsequent job only starts after the previous one completes successfully.

General Syntax:
```bash
sbatch --dependency=<type:job_id[:job_id][,type:job_id[:job_id]]> ...
```

Example worksflow
```bash
[<NetID>@log-3 ~]$ sbatch job1.sh
Submitted job 3345678
[<NetID>@log-3 ~]$ sbatch --dependency=afterok:3345678 job2.sh
```
In this example:
- The first job (`job1.sh`) is submitted and assigned job ID `3345678`.
- The second job (`job2.sh`) is submitted with a dependency on the successful completion (`afterok`) of job `3345678`.

For more details on job dependency types, see the [official documentation](https://slurm.schedmd.com/sbatch.html#OPT_dependency).

### Submitting a job at a specific time

If you need to submit a job to begin at a specific time (note: this specifies the submission time, not the guaranteed execution time), you can use the `--begin` option.

```bash
[<NetID>@log-3 ~]$ sbatch --begin=9:42:00 job1.sh
```
In this example, the job `job1.sh` is scheduled to start at **9:42 AM**. 

Keep in mind that the execution depends on resource availability in the queue system, so actual job start times may vary.


### Can I automatically execute git commands for each job?

Yes, you can. You can use the `subprocess` function to execute your Git commands.

```python
import subprocess
subprocess.run(['git', 'add', 'your/path/to/be/committed'], check=True)
subprocess.run(['git', 'commit', '-m', 'your commit message'], check=True)
subprocess.run(['git', 'push'], check=True)
```

The `check` parameter is a boolean value that indicates whether to check the return code of the subprocess. If `check` is set to `True` and the return code is non-zero, a `CalledProcessError` will be raised.

Note that when running an array job with Git commands targeting the same directory, it may cause conflicts, as multiple jobs may execute the Git commands simultaneously. Make sure to add different paths to avoid this.

### How to preserve data from being flushed? ###

As NYU HPC regularly removes files that have not been accessed for a while, it is important to correctly preserve your data. For projects that have been completed, you should tar the files and deposit them in `/archive` or on your local computer.

You can use this command to check which files have not been accessed, modified, or created in over 60 days.
```bash
find $SCRATCH -atime +60 -mtime +60 -ctime +60 -type f
```
(You can replace `$SCRATCH` with other roots, and/or replace `+60` with other days.)

However, for projects you are still working on, tarring all the files and then untarring them may not be the best approach. Instead, I wrote a `python` [script](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/touch_files.py) that automatically accesses all the files in a path, which will reset the access time for each file. Note that this approach will only change the files' access time, not the modification time. Additionally, here is a `sbatch` [script](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/touch_python.s) to run the `python` script.


### How to restore the data from daily snapshots? ###

You can restore the snapshot using the `rsync` command. This will make your current home directory an exact copy of a snapshot.

⚠️ **Warning**: This command will **permanently delete** any files in your current `/home/ac8888` that do not exist in the snapshot.

#### Step-by-Step Restore Guide

1.  **Check Disk Space**

    Since you were out of space before, first confirm you have enough free space. The restore will fail again if the snapshot's contents are larger than your available quota.

    ```bash
    quota -s
    ```

    If needed, delete large files from your current home directory to make room.

    ```bash
    # delete a single file
    rm my_file_to_delete.txt
    
    # delete a folder
    rm -r my_folder_to_delete
    ```

3.  **Perform a Dry Run (Safety Check)**

    Run this command first to see what changes will be made without actually doing anything. It's best to run it from outside your home directory (e.g., in `/tmp`).

    ```bash
    # The -n flag means --dry-run
    rsync -avhn --delete /home/.snapshots/@GMT-2025.07.10-05.30.55/ac8888/ /home/ac8888/
    ```

4.  **Execute the Restore**

    If you're satisfied with the dry run's output, run the same command without the `-n` to perform the actual restoration.

    ```bash
    rsync -avh --delete /home/.snapshots/@GMT-2025.07.10-05.30.55/ac8888/ /home/ac8888/
    ```

#### Command Explained

  * **`rsync`**: The tool used to synchronize directories.
  * **`-a`**: Archive mode, preserves permissions, timestamps, etc.
  * **`-v`**: Verbose mode, shows which files are being copied.
  * **`-h`**: Human-readable format for file sizes.
  * **`--delete`**: **Crucial option** that deletes files in your home directory that aren't in the snapshot.
  * **`...ac8888/`**: The trailing slash on the source is important. It tells `rsync` to copy the *contents* of the snapshot directory.


### Other packages that make HPC even easier ###

- [`submitit`](https://github.com/facebookincubator/submitit/) is a Python package designed for submitting your HPC job from your local computer via Python. Note that as this package was developed by Facebook (Meta) primarily for their internal use, it may not be applicable to other HPC systems. I have never tried it myself, but let me know if it works on the NYU HPC. *Thank [Jean-Rémi King](https://kingjr.github.io/) for suggesting this package!*
- [`singuconda`](https://github.com/beasteers/singuconda) is a package that makes setting up `Singularity` overlays with `miniconda` much easier and faster. *Thank [Bea Steers](https://beasteers.com/) for making this package and [Iran R. Roman](https://iranroman.github.io/) for the recommendation!*

### Best practices ###

I recommend this paper: [Alnasir, J. J. (2021). Fifteen quick tips for success with HPC, ie, responsibly BASHing that Linux cluster. PLOS Computational Biology, 17(8), e1009207.](https://doi.org/10.1371/journal.pcbi.1009207).

Also check out the NYU HPC's website on this topic [here](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/best-practices).

## 9. Acknowledgement ##

Shout out to NYU HPC's technical staff. They are knowledgeable, friendly, patient, and very willing to teach me. A huge thanks to them!!
