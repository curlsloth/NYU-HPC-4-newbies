#!/bin/bash

#SBATCH --job-name=testrun
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2GB
#SBATCH --time=00:10:00
#SBATCH --output=/scratch/ac8888/pytorch-example/slurm_output/out_%A_%a.out
#SBATCH --mail-user=ac8888@nyu.edu
#SBATCH --mail-type=END

module purge

/scratch/ac8888/pytorch-example/run-pytorch-ac8888.bash python /scratch/ac8888/pytorch-example/print_odd_even.py $SLURM_ARRAY_TASK_ID
