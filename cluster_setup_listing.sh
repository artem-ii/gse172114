#! /bin/bash

# Connect to the University of Helsinki HPC via jump server
ssh -J nikiarte@melkinpaasi.cs.helsinki.fi nikiarte@turso.cs.helsinki.fi

# Get an interactive bash session on acompute node with limited resources
# to avoid slowing the login node down
# Will set up conda environment, install tools for downloading data, alignment and QC
# I will connect using tmux multiplier to be able to close the cluster terminal
tmux
srun -c 4 --mem=8000 --pty bash

# Load Miniconda SLURM module

module load Miniconda3

# Go to my folder in the working directory, create conda environment
# and store all the files there not to avoid cluttering home directory

cd /wrk-vakka/users/nikiarte/rnaseq_analysis
conda create --prefix ./rnaseq_task_env

# Activate environment and add necessary channels
conda activate ./rnaseq_task_env/

conda config --env --add channels bioconda
conda config --env --add channels conda-forge

conda install entrez-direct sra-tools


