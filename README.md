# NYU High Performance Computing (HPC) for Newbies 🍼 #

Last update: July 11, 2024

## 0. Preface ##
This is a tutorial for computer muggles who wants to use NYU's HPC, **"Greene"**, for their research, which is also a note for myself and my future students. 

Eventhough we all know that HPC can speed up our research, I found that most of people don't want to use it. I guess it is because they worry that they will spend more time on learning HPC then waiting the computation completed on their laptops. This tutorial is designed to mitigate this issue. It will help you set up a reliable and replicable HPC environment within an afternoon, even if you know nothing about computer science.

This tutorial is a short summary of [NYU HPC's official website](https://sites.google.com/nyu.edu/nyu-hpc/), integrating my own tips. If you are a computer wizard or witch, this might be too easy for you. If you are interested in knowing all the functions and details, this is not for you. Some functions and approaches may be outdated when you read it, so make sure that you check out the NYU HPC's official website if you encounter any issues. Also, as different HPC system may have different OS, this tutorial may not be applied to other HPCs.

Despite my approaches may not be the most efficient or correct way to do things, hope this tutorial can give you a good start of using HPC and boost your productivity!

### Prerequested knowledge ###
- Basic command line commands (such as `cd`, `ls`, `pwd`, `mv`, `rm`, `cat`). This is a neccesity as this will be the primary way you interact with HPC. But you can quickly learn them starting from [here](https://www.codecademy.com/article/command-line-commands).
- Git/GitHub (not a neccesity but will be very helpful)
- Conda (not a neccesity but will be very helpful)

## 1. What is HPC? Should I use it? ##

HPC is a system that you can request the computational resources (CPUs, GPUs, RAM, nodes) for each computational job, and you can request many sets in parallel.

### If your laptop is your kitchen at home, HPC is a restaurant. ####

While you can cook all kinds of cusines (scripts) in your kitchen at home (laptop), but you only have access to a few stoves (CPUs), you can only cook a small portion (RAM) at a time, and you cannot cook too many cusines in parallel. 

### You probably want to use HPC if ###
- insufficient CPUs or RAM in your local machine,
- you need to run a time-consuming loop, but which can actually be paralleled,
- you need to get access to a GPU.

### The HPC cannot help with ###
- speeding up a time-consuming script which cannot be paralled. It will be equally slow on HPC.

### How helpful can HPC be? ###

I once needed to analyze 200k of audio files, and the process on each file would take approximately 15 seconds. In total, it will take 34.7 days to run through all the files, if my poor laptop doesn’t burn 🔥! 
So, I ended up requesting 2000 jobs, each job process 100 files. As a result, it took less than 2 hours to complete all the jobs, including the queue time ⚡️! 

## 2. Your first step of using HPC! ##
### 2-1. What is HPC? ###

If you are using Mac, open your terminal application ([default](https://support.apple.com/guide/terminal/open-or-quit-terminal-apd5265185d-f365-44cb-8b09-71a064a42125/mac#:~:text=Open%20Terminal,%2C%20then%20double%2Dclick%20Terminal.) or [iTerm](https://iterm2.com/)), connect to [NYU VPN](https://www.nyu.edu/life/information-technology/infrastructure/network-services/vpn.html), and log into the Greene by executing this line (keyin and then press enter):

```
ssh <NetID>@gw.hpc.nyu.edu
```
(Replace `<NetID>` with your own. In my case, that will be `ssh ac8888@gw.hpc.nyu.edu`)

It will then ask you to keyin your password. 

If everything is correct, the login node will look something like this 
```
[ac8888@log-3 ~]$
```

Log into an HPC is like walking into a restaurant. A host (login node) will greet you upfront. Despite that the host of the restaurant is very capable to serve you whatever you want, the host is also busy with greeting other customers. Please do NOT run CPU heavy jobs on login nodes! Therefore, your first step is to tell the host to assign a dedicated waiter (compute node) for you.

Then execute this line: `srun --cpus-per-task=1 --mem=10GB --time=04:00:00 --pty /bin/bash`, it means that you request the node to have 1 CPU and 10 GB of RAM, and serve you for 4 hours. You can change these parameters to whatever you want. **But the more resources you requested, the longer the queue time (depending on how many other jobs and resources were requested by other users).**

Once you execute that line, you shall wait for a short time, and then will see the terminal displaying this:

```
[ac8888@log-3 ~]$ srun --cpus-per-task=1 --mem=10GB --time=04:00:00 --pty /bin/bash
srun: job 48347520 queued and waiting for resources
srun: job 48347520 has been allocated resources
[ac8888@cm015 ~]$
```

Now you have a waiter (compute node: `cm015`) ready to serve you. 

You can ask the waiter to cook a meal for you. For example, execute (type and press enter) this `python`:
```
[ac8888@cm015 ~]$ python
Python 3.9.16 (main, Jan  4 2024, 00:00:00)
[GCC 11.3.1 20221121 (Red Hat 11.3.1-4)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>>
```
Now you can use Python on HPC the same way as you do on your local machine.

Congrats! Now you know the core workflow of using HPC. The following sections are all about how to make the process much easier and automatic.

> Note that as Greene is Linux based, the command you used will need to be Linux based too.


## 3. HPC data management ##

### 3-1. Greene storage options ###

There are a few root directories on Greene, and each of them have different specifications for different usage purposes.

|Storage  |Disk Space / Number of Files        	  |Backed Up / Flushed	               |Recommendation                                                                                                                 |
|---------|-----------------------------------|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
|/home	  |50 GB / 30 K	                      |YES / NO                            |Store your singularity and other frequently used keys or important results.                                                        |
|/archive |5 TB / 1 M	        	              |NO / Files not accessed for 60 days |Long-term storage. Archive your projects as .tar or .zip or unused singularity files. Only for infrequent access                   |
|/scratch	|2 TB / 20 K	                      |YES / NO	                           |Put working projects here, especially with small number of big files (e.g., neuroimage)                                            |
|/vast	  |2 TB / 5 M	                        |NO / Files not accessed for 60 days |Put working projects here, especially the project involving many small files with high I/O workflows (e.g., audio or image files)  |

You can execute `myquota` command to see the current usage of your storages.
```
[ac8888@log-3 ~]$ myquota

Hostname: log-3 at Thu Jul 11 07:39:37 AM EDT 2024

Filesystem   Environment   Backed up?    Allocation         Current Usage
Space        Variable      /Flushed?     Space / Files      Space(%) / Files(%)

/home        $HOME         Yes/No        50.0GB/30.0K       46.75GB(93.50%)/13008(43.36%)
/scratch     $SCRATCH      No/Yes        5.0TB/1.0M         0.97GB(0.02%)/11764(1.18%)
/archive     $ARCHIVE      Yes/No        2.0TB/20.0K        56.33GB(2.75%)/233(1.16%)
/vast        $VAST         NO/YES        2TB/5.0M           1.38TB(69.0%)/3454787(69%)
```

#### Organizing and archieving files ####

Typically you want to put your project folder under `/scratch` or `/vast`, and the conda environment and singularity (will explain later) and other personal login files under `/home`. As the data not accessed for 60 under `/scratch` and `/vast` will be wiped out, I recommend compress the project folder and save under `/archive` once in a while.

Run this line to compress the folder and save it under `/archive`:
```
tar -czvf /archive/<NetID>/myProject_20240711.tgz /scratch/<NetID>/myProjectFolder
```
Run this line to uncompress the .tgz file and put it back to `scratch`:
```
tar -xvf /archive/<NetID>/myProject_20240711.tgz /scratch/<NetID>/
```
You will see `/scratch/<NetID>/myProjectFolder` is back.

Here is an [instruction](https://support.apple.com/guide/terminal/compress-and-uncompress-file-archives-apdc52250ee-4659-4751-9a3a-8b7988150530/mac) on how to tar archieve a folder using Mac/Linux.

### 3-2. Data transfer ###

According to NYU HPC's [website](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management/data-transfers), there are number of ways to transfer data to HPC. But I am only introduce the two ways that I recommend.

#### Use Globus to transfer big data files ####

Globus has a browser-based user interface to transfer the files. It is very intuitive to use and features automatic error monitoring. See [here](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management/data-transfers/globus) for the instruction. 

However, Globus can be really slow if you are transfer a large quantitive of files. In that case, you can simply compress the entire folder on the local machine as one tar file , upload that one tar file using globus, and uncompress on HPC. 

#### Use GitHub to transfer scripts (and a small number of small-sized data files) ####

Synchronizing often changed files (i.e., script files) manually using Globus can be error-prone. Also, transferring a large number of small files can be very slow via Globus. Therefore, I recommend synchronizing your scripts (and maybe a small number of small-sized data files) using GitHub. 

Yes, you can clone a GitHub repository to HPC the same way as you do on your local machine ([instruction](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)). Just remember to [`.gitignore`](https://www.w3schools.com/git/git_ignore.asp) your data folder and anything you don't want to share. 

> **Tip:** I strongly recommend organizing your project files following the [cookiecutter-data-science template](https://github.com/drivendataorg/cookiecutter-data-science#the-resulting-directory-structure), which is an intuitive way to separate your scripts, data and many other files. (You can manually do it if you don't want to run another script for it.) **The future you will thank you!**
 

## 4. Set up replicable programming environment using Singularity and Conda ##

Probably the most complicated step to use HPC is to replicate the environment and install all the related packages on it. But this is not an issue if you use Singularity and Miniconda to setup the environment. 

### 4-1. Use Conda to manage environment ###

Conda is a powerful tool for package and environment management. You can create multiple environments with different versions of packages and dependencies which won't interfere with each other. Within each environment, everytime you install a new package, its dependency with other existing ones will be checked and updated. This is especially useful if you work on multiple projects using different sets of tools, and if you want to install new packages but worrying that modification will screw up the existing environment.

To keep this tutorial focused on HPC, I am assuming that you are familiar Conda and have been activily using on your local computer. **If not, start using Conda today! See [here](https://conda.org/learn/faq/#:~:text=It%20provides%20a%20unified%20interface,compatibility%20issues%20across%20different%20platforms.) for why you should use it, and see [here](https://docs.anaconda.com/anaconda/getting-started/) for more instructions.**

### 4-2. Use Singularity to contain Conda environment ###

[Singularity](https://docs.sylabs.io/guides/3.5/user-guide/introduction.html) is a container platform specifically designed for HPC, and it has become widely used in many HPC systems and has become a standard.

Without Singularity, you don't really have a good place to put your conda environment file in HPC. The `/home` space can only contain a limited number of files, which is barely enough for a conda environment. Despite `/scratch` and `/vast` can contain many files, the files in these two places could be wiped out every 60 days. You don't want to reset your conda environment again and again! 

**Singularity acts like a containor.** For the HPC file system, it is recognized as one single file. But within this containor, you can put as many files as you want, up to it predefined space. Therefore, you can put your Singularity container under `/home` without worrying it exceeding the limit.

### 4-3. Step-by-step guidance ###

*This section is primarily modified from the [NYU HPC website](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda).*

#### Step 1: Create a directory for the environment ####
```
mkdir /scratch/<NetID>/pytorch-example
cd /scratch/<NetID>/pytorch-example
```

#### Step 2: Copy an appropriate gzipped overlay images from the overlay directory.####

You can browse available images to see available options.
```
ls /scratch/work/public/overlay-fs-ext3
```

In this example we use overlay-15GB-500K.ext3.gz as it has enough available storage for most conda environments. It has 15GB free space inside and is able to hold 500K files.
You can use another size as needed. But since this overlay image cannot be modified later (or very complicated to do so), I would choose something slightly bigger than I need at the moment.
```
cp -rp /scratch/work/public/overlay-fs-ext3/overlay-15GB-500K.ext3.gz .
gunzip overlay-15GB-500K.ext3.gz
```

#### Step 3: Choose a corresponding Singularity image ####

It is about OS system you will be using to run your code. This can be changed everytime you access to the overlay file.

For this example we will use the following image
```
/scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif
```
For Singularity image available on nyu HPC greene,  please check the singularity images folder 
```
/scratch/work/public/singularity/
```
For the most recent supported versions, please check the [Tensorflow Website](https://www.tensorflow.org/install/pip). 

#### Step 4: Launch the appropriate Singularity container in read/write mode (with the `:rw` flag) ####
```
singularity exec --overlay overlay-15GB-500K.ext3:rw /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif /bin/bash
```
The above starts a bash shell inside the referenced Singularity Container overlayed with the 15GB 500K you set up earlier. This creates the functional illusion of having a writable filesystem inside the typically read-only Singularity container.

#### Step 5: Inside the container, download and install miniconda to /ext3/miniconda3 ####

```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p /ext3/miniconda3
```
You can further run this line to remove the installation file
```
rm Miniconda3-latest-Linux-x86_64.sh
```

#### Step 6: Create a wrapper script /ext3/env.sh using a text editor ####

Use `nano` to create and open the file by typing
```
nano /ext3/env.sh
```

The wrapper script will activate your conda environment, to which you will be installing your packages and dependencies. The script should contain the following:

```
#!/bin/bash

unset -f which

source /ext3/miniconda3/etc/profile.d/conda.sh
export PATH=/ext3/miniconda3/bin:$PATH
export PYTHONPATH=/ext3/miniconda3/bin:$PATH
```

To save the file, press Ctrl+O, then Enter to save the file, and Ctrl+X to exit.

#### Step 7: Activate an update your conda environment ####

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

#### Step 8: Install packages ####

You may now install packages into the environment with either the pip install or conda install commands. 

First, start an interactive job with adequate compute and memory resources to install packages. The login nodes restrict memory to 2GB per user, which may cause some large packages to crash.
```
srun --cpus-per-task=2 --mem=10GB --time=04:00:00 --pty /bin/bash

# wait to be assigned a node

singularity exec --overlay overlay-15GB-500K.ext3:rw /scratch/work/public/singularity/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif /bin/bash

source /ext3/env.sh
# activate the environment
```

After it is running, you’ll be redirected to a compute node. From there, run singularity to setup on conda environment, same as you were doing on login node.

**Option 1: pip install (it works, but not recommended)**

You can install PyTorch using `pip` as an example:
```
pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

pip3 install jupyter jupyterhub pandas matplotlib scipy scikit-learn scikit-image Pillow
```

**Option 2: create a new conda env with specified packages (recommended)**

*This is the option we use in the following tutorial.*

I recommend using conda to ensure compatibility among packages. Execute this line: 

```
conda create -n pytorch-ac8888 pytorch jupyter jupyterhub pandas matplotlib scipy scikit-learn scikit-image Pillow
```
Where the `pytorch-ac8888` is the name of the conda environment. You can replace that with whatever you want.

After it is done, you can activate your conda environment:

```
conda activate pytorch-ac8888
```


Why creating a conda environment within a image which is already dedicated for a project? It is because very likely you will need a couple of environments to do different analyses due to incompatibility among the packages you want to use, or you may want to duplicate your environment as a safe copy before upgrading any packages.

**Option 3: recreate a conda env from `.yaml` file (may not alway work)**

You can even export a `.yaml` file listing all the packages and versions you use on your local computer, upload it the onto HPC, and use it to create a conda environment. This way will replicate the exact same environment on HPC. 

Use Globus to upload the '.yaml' [file](https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/pytorch-ac8888_20240711.yaml) to `/scratch/ac8888/pytorch-example/`, and then run the following line:

```
conda env create -f environment.yml
```

However, this may not always work, as some packages installed on your local machine may be incompatible with HPC. In that case, you may want to loose some constrains on the package versions, take out some unnecessary packages.

> Follow this [instruction](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html) for more details on how to manage conda environment.

#### Step 9: Verify your setup ####

You can see the available space left on your image with the following commands:
```
find /ext3 | wc -l
# output: should be something like 222076

du -sh  /ext3        
# output should be something like 6.0G    /ext3
```
Now, exit the Singularity container and then rename the overlay image. Typing 'exit' and hitting enter will exit the Singularity container if you are currently inside it. You can tell if you're in a Singularity container because your prompt will be different, such as showing the prompt 'Singularity>'
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

Note that now you are accessing the image with the `:ro` flag, which means it is read only. It is recommended to use `:ro` when you are executing your script, so your script won't accidentally modify the packages.

However, if you want to further modify the image, you have to change it into `:rw`.

## 5. Quickly access my singularity image and conda environment ##

To simplify the steps required to access the conda environment in the image, you can create a `.bash` file like below on your computer and upload it to HPC `/scratch/ac8888/pytorch-example/`. The file should be something like [this]((https://github.com/curlsloth/NYU-HPC-4-newbies/blob/main/run-pytorch-ac8888.bash)).

(Remember: replace `<NetID>` with your own.)

```
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
