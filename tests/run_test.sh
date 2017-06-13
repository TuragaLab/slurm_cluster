#!/bin/bash

echo Submitting 1
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:2 --share ./test_gpu.sh &
echo Submitting 2
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:2 --share ./test_gpu.sh &
echo Submitting 3
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:2 --share ./test_gpu.sh &
echo Submitting 4
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:2 --share ./test_gpu.sh &
echo Submitting 5
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:2 --share ./test_gpu.sh &
echo Submitting 6
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:2 --share ./test_gpu.sh &
echo Submitting 7
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:2 --share ./test_gpu.sh &
echo Submitting 8
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:4 --share ./test_gpu.sh &
echo Submitting 9
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:1 --share ./test_gpu.sh &
echo Submitting 10
srun --cpus-per-task=2 --ntasks=1 --gres=gpu:1 --share ./test_gpu.sh &

wait
