#!/bin/bash

for node in slowpoke{1,2,3} turagas-ws{1,2,3,4,5}
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
    sudo cp config/munge.key /etc/munge/ && \
    sudo chmod u=r,g=,o= /etc/munge/munge.key && \
    sudo chown munge:munge /etc/munge/munge.key && \
    sudo cp bin/run_slurm /usr/bin && \
    sudo cp bin/run_docker /usr/bin && \
    sudo cp bin/spy /usr/bin && \
    sudo /etc/init.d/slurm-llnl start && \
    sudo /etc/init.d/munge start)"
done

echo "Reconfiguring slurm..."
sudo scontrol reconfigure

echo "Done. Current cluster configuration:"
sinfo
