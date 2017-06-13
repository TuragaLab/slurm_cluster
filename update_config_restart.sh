#!/bin/bash

sudo cp config/slurm.conf /etc/slurm-llnl/
sudo cp config/gres.conf /etc/slurm-llnl/
sudo cp config/munge.key /etc/munge/
sudo chmod u=r,g=,o= /etc/munge/munge.key

sudo cp bin/run_slurm /usr/bin
sudo cp bin/run_docker /usr/bin

sudo /etc/init.d/slurm-llnl restart
sudo /etc/init.d/munge restart
