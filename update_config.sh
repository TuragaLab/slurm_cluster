#!/bin/bash

for node in slowpoke{1,2,3,4} turagas-ws{1,2,3,4,5}
do \
  echo
  echo "============= Updating configuration on ${node}"
  echo
  # copy all the configuration files, and make sure slurm and munge are running
  # (does nothing, if already running)
  ssh -t ${node} "( \
    cd $(pwd) && \
    sudo cp config/slurm.conf /etc/slurm-llnl/ && \
    sudo cp config/gres.conf /etc/slurm-llnl/ && \
    sudo cp config/cgroup.conf /etc/slurm-llnl/ && \
    sudo cp config/munge.key /etc/munge/ && \
    sudo chmod u=r,g=,o= /etc/munge/munge.key && \
    sudo chown munge:munge /etc/munge/munge.key && \
    sudo cp bin/run_slurm /usr/bin && \
    sudo cp bin/run_docker /usr/bin && \
    sudo cp bin/spy /usr/bin && \
    sudo apt-get install python-paramiko -y && \
    echo 'All configuration updated' && \
    (sudo mkdir /dev/cpuset || true) && \
    (sudo mount -t cpuset cpuset /dev/cpuset || true) && \
    echo 'cpusets mounted at /dev/cpuset' && \
    sudo systemctl start munge && \
    sudo systemctl start slurmctld && \
    sudo systemctl start slurmd)"
done

echo "Reconfiguring slurm..."
sudo scontrol reconfigure

echo "Done. Current cluster configuration:"
sinfo
