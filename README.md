Turaga Lab Slurm Cluster
========================

User Guide
----------

To run a command on the cluster, simply call

```shell
$ run_slurm [options, see below] command args...
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
| `-d` | A docker image to run the command inside. The docker container will have `/groups/` mounted (i.e., your home directory) and `/nrs/`.             |
| `-b` | If given, you indicate that your command is a batch script. `run_slurm` will submit the batch and exit, check the status with `squeue`.          |

If you requested GPUs, the environment variable `CUDA_VISIBLE_DEVICES` will be
set when your command runs. You can use this to know which GPUs got assigned to
you. Anyway, the preferred way to work with GPUs is to use a docker image. In
this case, `nvidia-docker` is used to run your container, and you will only see
the GPUs that got assigned to you (which prevents you from using accidentally
another one).

If you submit a batch script (`-b`), [`slurm`'s `sbatch`](https://slurm.schedmd.com/sbatch.html)
will be used. In this case, `command` should be a script, starting with
`#!<path/to/interpreter>`.

### Example

Here is an example that requests 2 GPUs, and executes `nvidia-smi` in an
official nVidia docker image:

```shell
$ run_slurm -g 2 -d nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04 nvidia-smi
```

This will produce something similar to:

```
Running "/usr/bin/run_docker -d nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04 -w /groups/saalfeld/home/funkej/ nvidia-smi" on 5 CPUs, 2 GPUs, 25600 MB in /groups/saalfeld/home/funkej/, using docker image nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
8.0-cudnn6-devel-ubuntu16.04: Pulling from nvidia/cuda
bd97b43c27e3: Already exists
6960dc1aba18: Already exists
2b61829b0db5: Already exists
1f88dc826b14: Already exists
73b3859b1e43: Already exists
6cbbf78e00cc: Already exists
9a9aaca52ae8: Already exists
667b113f0fa7: Already exists
25d6389a39d4: Already exists
88caab0861b4: Already exists
3bff6d590045: Already exists
f06a57d022c5: Already exists
Digest: sha256:03ed92d9bcfedd7a44841a7c6934e74f5aad7af03592ce817ba36ffea65652e1
Status: Downloaded newer image for nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
Tue Jun 13 12:52:30 2017       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 375.51                 Driver Version: 375.51                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX TIT...  Off  | 0000:08:00.0     Off |                  N/A |
| 22%   28C    P8    15W / 250W |      0MiB / 12207MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
|   1  GeForce GTX TIT...  Off  | 0000:09:00.0     Off |                  N/A |
| 22%   26C    P8    15W / 250W |      0MiB / 12207MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID  Type  Process name                               Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

As you can see, the docker image is automatically downloaded (or updated) and
launched. Inside the docker container, `nvidia-smi` sees only the two GPUs that
got assigned to the `slurm` task.

### Low-level CLI

`run_slurm` is just a convenience wrapper for `srun` and `sbatch`, two of the
tools provided by `slurm`. You can use them directly, if you want, see the
documentation [here](https://slurm.schedmd.com/quickstart.html).

To monitor the status of the `slurm` cluster, run `spy`.

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

Finally, call `update_config.sh` from this repository, which will copy the
configuration files for `slurm`, start the daemons (if not running) and trigger
a reconfiguration of the cluster. This will keep currently running jobs.

### After a restart of a node

Make sure docker can be run by everyone in the `turaga` group:
```shell
sudo systemctl start docker.socket
```

Then start the `slurm` daemon:
```shell
sudo systemctl start slurmd
```

Finally, bring up the node again:
```shell
sudo scontrol update nodename=NODE state=idle
```
where you replace `NODE` with the actual node name.
