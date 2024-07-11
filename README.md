# NYU High Performance Computing (HPC) for Newbies 🍼 #

Last update: July 11, 2024

## 0. Preface ##
This is a tutorial for computer muggles who wants to use NYU's HPC, **"Greene"**, for their research, which is also a note for myself and my future students. 

Eventhough we all know that HPC can speed up our research, I found that most of people don't want to use it. I guess it is because they worry that they will spend more time on learning HPC then waiting the computation completed on their laptops. This tutorial is designed to mitigate this issue. It will help you set up a reliable and replicable HPC environment within an afternoon, even if you know nothing about computer science.

If you are a computer wizard or witch, this might be too easy for you. If you are interested in knowing all the functions and details, this is not for you. This tutorial is a short summary of [NYU HPC's official website](https://sites.google.com/nyu.edu/nyu-hpc/), including the topics and tips I personally find useful. Some functions and approaches may be outdated when you read it, so make sure that you check out the NYU HPC's official website if you encounter any issues. Also, as different HPC system may have different OS, this tutorial may not be applied to other HPCs.

Despite my approaches may not be the most efficient or correct way to do things, hope this tutorial can give you a good start of using HPC and boost your productivity!

## 1. What is HPC and do I need to use it? ##

HPC is a system that you can request the computational resources (CPUs, GPUs, RAM, nodes) for each computational job, and you can request many sets in parallel.

### You probably want to use HPC if ###
- insufficient CPUs or RAM in your local machine,
- you need to run a time-consuming loop, but which can actually be paralleled,
- you need to get access to a GPU.

### The HPC cannot help with ###
- speeding up a time-consuming script which cannot be paralled. It will be equally slow on HPC.

### How helpful can HPC be? ###

I once needed to analyze 200k of audio files, and the process on each file would take approximately 15 seconds. In total, it will take 34.7 days to run through all the files, if my poor laptop doesn’t burn 🔥! 
So, I ended up requesting 2000 jobs, each job process 100 files. As a result, it took less than 2 hours to complete all the jobs, including the queue time ⚡️! 

## 2. How to conceptualize and understand HPC? ##
### If your laptop is your kitchen at home, HPC is a restaurant. ###

While you can cook all kinds of cusines (scripts) in your kitchen at home (laptop), but you only have access to a few stoves (CPUs), you can only cook a small portion (RAM) at a time, and you cannot cook too many cusines in parallel. 

Using an HPC is like walking into a restaurant. A host (login node) will greet you upfront. 

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

Despite that the host of the restaurant is very capable to serve you whatever you want, the host is also busy with greeting other customers. Please do NOT run CPU heavy jobs on login nodes! Therefore, your first step is to tell the host to assign a dedicated waiter (job node) for you.

Then execute this line: `srun --cpus-per-task=1 --mem=10GB --time=04:00:00 --pty /bin/bash`, it means that you request the node to have 1 CPU and 10 GB of RAM, and serve you for 4 hours. You can change these parameters to whatever you want. **But the more resources you requested, the longer the queue time (depending on how many other jobs and resources were requested by other users).**

Once you execute that line, you shall wait for a short time, and then will see the terminal displaying this:

```
[ac8888@log-3 ~]$ srun --cpus-per-task=1 --mem=10GB --time=04:00:00 --pty /bin/bash
srun: job 48347520 queued and waiting for resources
srun: job 48347520 has been allocated resources
[ac8888@cm015 ~]$
```

Now you have a waiter node (`cm015`) ready to serve you. 

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

**Note that as Greene is Linux based, the command you used will need to be Linux based too.**


## 3. HPC data management ##

## 3-1. Greene storage options ##

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

## 3-2. Data transfer ##

According to NYU HPC's [website](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management/data-transfers), there are number of ways to transfer data to HPC. But I am only introduce 2 ways that I find them useful.

### Use Globus to transfer big data files ###

Globus has a browser-based user interface to transfer the files. It is very intuitive to use and features automatic error monitoring. See [here](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/hpc-storage/data-management/data-transfers/globus) for the instruction. 

However, Globus can be really slow if you are transfer a large quantitive of files. In that case, you can simply compress the entire folder on the local machine as one tar file , upload that one tar file using globus, and uncompress on HPC. Here is the [instruction](https://support.apple.com/guide/terminal/compress-and-uncompress-file-archives-apdc52250ee-4659-4751-9a3a-8b7988150530/mac) for Mac/Linux.

### Use GitHub to transfer scripts (and a small number of small-sized data files) ###

Synchronizing often changed files (i.e., script files) manually using Globus can be error-prone. Also, transferring a large number of small files can be very slow via Globus. Therefore, I recommend synchronizing your scripts (and maybe a small number of small-sized data files) using GitHub. 

Yes, you can clone a GitHub repository to HPC the same way as you do on your local machine ([instruction](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)). Just remember to [`.gitignore`](https://www.w3schools.com/git/git_ignore.asp) your data folder and anything you don't want to share. 

***Tip:** I strongly recommend organizing your project files following the [cookiecutter-data-science template](https://github.com/drivendataorg/cookiecutter-data-science#the-resulting-directory-structure), which is an intuitive way to separate your scripts, data and many other files. (You can manually do it if you don't want to run another script for it.) **The future you will thank you!**
