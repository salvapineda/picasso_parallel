#!/usr/bin/env bash
# The name to show in queue lists for this job:
#SBATCH -J sum_a_b_c

# Number of desired cores (can be in any node):
##SBATCH --ntasks=1

# Number of desired cores (all in same node):
#SBATCH --cpus-per-task=1

# Amount of RAM needed for this job:
#SBATCH --mem=4gb

# The time the job will be running (7 days):  
#SBATCH --time=0-00:01:00
##SBATCH --gres=:gpu:1

# If you need nodes with special features uncomment the desired constraint line:
# * to request only the machines with 80 cores and 2TB of RAM
##SBATCH --constraint=bigmem
# * to request only machines with 16 cores and 64GB with InfiniBand network
#SBATCH --constraint=cal
# * to request only machines with 24 cores and Gigabit network
##SBATCH --constraint=slim

# Set output and error files
#SBATCH --error=zzz.%A.%a.err
#SBATCH --output=zzz.%A.%a.out

# MAKE AN ARRAY JOB, SLURM_ARRAYID will take values from 1 to 100
#SBATCH --array=1-20

# To load some software (you can show the list with 'module avail'):
sleep $SLURM_ARRAY_TASK_ID
module purge
module load python/3.11.4

# the program to execute with its parameters:
hostname
time python main.py

