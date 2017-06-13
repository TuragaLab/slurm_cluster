#!/bin/bash

echo "Job $SLURM_JOB_ID: Got GPU(s) $CUDA_VISIBLE_DEVICES on node(s) $SLURM_NODELIST"
#nvidia-smi
sleep 5
