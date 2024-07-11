# NYU High Performance Computing (HPC) 4 newbies 🍼 #

Last update: July 10, 2024

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

Using an HPC is like walking into a restaurant. A host (login node) will greet you upfront. Despite that he is very capable to serve you whatever you want, the host is also busy with greeting other customers. Therefore, your first step is to tell the host to assign a dedicated waiter (job node) for you.

You can use this line: `srun --cpus-per-task=1 --mem=10GB --time=04:00:00 --pty /bin/bash`

It means that you request the node to have 1 CPU, 10 GB of RAM, and serve you for 4 hours. You can change these parameters to whatever you want. **But the more resources you requested, the longer the queue time (depending on how many other jobs and resources were requested by other users).**

Now you have a waiter. Although the waiter can cook a meal for you, the most efficient approach should be asking the waiter to recruit a few cooks in back in the kitchen for you to cook whatever you want.

