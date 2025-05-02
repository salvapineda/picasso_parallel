#!/usr/bin/env bash
# The name to show in queue lists for this job:
#SBATCH -J linear_opf

# Number of desired cores (can be in any node):
##SBATCH --ntasks=1

# Number of desired cores (all in same node):
#SBATCH --cpus-per-task=1

# Amount of RAM needed for this job:
#SBATCH --mem=4gb

# The time the job will be running (7 days):  
#SBATCH --time=0-04:00:00
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
#SBATCH --array=1-100

# To load some software (you can show the list with 'module avail'):
sleep $SLURM_ARRAY_TASK_ID
module purge
module load ampl/20231031_2024
module load cplex/20.1.0
module load ipopt/3.12.8
#module load tensorflow/2.13.0

# the program to execute with its parameters:
hostname
time python 11_linear_opf.py

