#!/bin/bash
#slurm installation

mkdir /var/log/slurm
mkdir /var/run/slurm
mkdir /var/spool/slurm
mkdir /etc/slurm
chown -R slurm:slurm /var/log/slurm
chown -R slurm:slurm /var/run/slurm
chown -R slurm:slurm /var/spool/slurm
chown -R slurm:slurm /etc/slurm


yum install rpm-build gcc openssl openssl-devel libssh2-devel pam-devel numactl numactl-devel hwloc hwloc-devel readline-devel rrdtool-devel ncurses-devel gtk2-devel libssh2-devel libibmad libibumad perl-Switch perl-ExtUtils-MakeMaker
yum install perl-ExtUtils-MakeMaker -y
yum install python3 -y
yum install -y slurm slurm-slurmd
mount mgmt:/etc/slurm /etc/slurm
echo 'mgmt:/etc/slurm	/etc/slurm	nfs	defaults	0 0' >> /etc/fstab

systemctl enable slurmd
systemctl start slurmd


mkdir /var/spool/slurmd
chown slurm: /var/spool/slurmd
chmod 755 /var/spool/slurmd
mkdir /var/log/slurm/
touch /var/log/slurm/slurmd.log
chown -R slurm:slurm /var/log/slurm/slurmd.log

