 #!/bin/bash

export MUNGEUSER=1001
groupadd -g $MUNGEUSER munge
useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SlurmUSER=1002
groupadd -g $SlurmUSER slurm
useradd  -m -c "Slurm workload manager" -d /var/lib/slurm -u $SlurmUSER -g slurm  -s /bin/bash slurm

#munge authentication

mkdir /etc/munge
mkdir /var/log/munge
yum clean all
yum update -y
yum install -y munge munge-libs munge-devel
mount -t nfs mgmt:/etc/munge /etc/munge
echo 'mgmt:/etc/munge   /etc/munge      nfs     defaults        0 0' >> /etc/fstab
systemctl restart nfs

chown munge: /etc/munge/munge.key
chmod 400 /etc/munge/munge.key

chown -R munge: /etc/munge/ /var/log/munge/ 
chmod 0700 /etc/munge/ /var/log/munge/


systemctl enable munge
systemctl start munge
systemctl status munge

