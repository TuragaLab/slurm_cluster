Turaga Lab Slurm Cluster
========================

User Guide
----------

To run a command on the cluster, simply call

```shell
$ run_slurm command args...
```

This will execute `command args...` somewhere in the cluster, and block until
the command finished. Unless you have to wait for resources to become
available, you will not notice that the command is not run locally: You will
see `stdout` and `stderr`, and the `run_slurm` returns with the exit code of
your command.

### `run_slurm` Arguments

| Name | Description
|:----:|:-------------------------------------------------------------------------------------------------------------------------------------------------|
| `-c` | The number of CPUs to request, default 5.                                                                                                        |
| `-g` | The number of GPUs to request, default 1.                                                                                                        |
| `-m` | Amount of memory to request in MB, default 25600.                                                                                                |
| `-w` | The working directory, if different from current.                                                                                                |
| `-d` | A docker image to run the command inside. The docker container will have `/groups/` mounted (i.e., your home directory).                         |
| `-b` | If given, the command will run in the background, and `run_slurm` will exit immediately. You can check the status of your command with `squeue`. |

If you requested GPUs, the environment variable `CUDA_VISIBLE_DEVICES` will be
set when your command runs. You can use this to know which GPUs got assigned to
you. Anyway, the preferred way to work with GPUs is to use a docker image. In
this case, `nvidia-docker` is used to run your container, and you will only see
the GPUs that got assigned to you (which prevents you from using accidentally
another one).

### Low-level CLI

`run_slurm` is just a convenience wrapper for `srun` and `sbatch`, two of the
tools provided by `slurm`. You can use them directly, if you want, see the
documentation [here](https://slurm.schedmd.com/quickstart.html).

Administrator Guide
-------------------

### Setup a `slurm` node

Install `slurm` and `munge`:

```shell
sudo apt-get install slurm-llnl munge
```

Make `/var/log/munge` accessible all the way for munge (requrired `o=rX` for
`/var/log`).

Edit `config/slurm.conf` and add a line for the new node.

Finally, call `update_config_restart.sh` from this repository, which will copy
the configuration files for `slurm` and (re)start the daemon.
