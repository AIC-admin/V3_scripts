instdisk="/dev/sda"
modprobe ext4 >& /dev/null
modprobe ext4dev >& /dev/null
if grep ext4dev /proc/filesystems > /dev/null; then
	FSTYPE=ext3
elif grep ext4 /proc/filesystems > /dev/null; then
	FSTYPE=ext4
else
FSTYPE=ext3
fi
BOOTFSTYPE=ext4
EFIFSTYPE=vfat
if uname -r|grep ^3.*el7 > /dev/null; then
	FSTYPE=xfs
	BOOTFSTYPE=xfs
	EFIFSTYPE=efi
fi

if [ `uname -m` = "ppc64" ]; then
	echo 'part None --fstype "PPC PReP Boot" --ondisk '$instdisk' --size 8' >> /tmp/partitionfile

fi

if [ -d /sys/firmware/efi ]; then
	echo 'bootloader --driveorder='$instdisk >> /tmp/partitionfile
	echo 'part /boot/efi --size 50 --ondisk '$instdisk' --fstype $EFIFSTYPE' >> /tmp/partitionfile
else
	echo 'bootloader' >> /tmp/partitionfile
fi

echo "part /boot --size 512 --fstype $BOOTFSTYPE --ondisk $instdisk" >> /tmp/partitionfile
echo "part swap --recommended --ondisk $instdisk" >> /tmp/partitionfile
echo "part / --size 204800 --ondisk $instdisk --fstype $FSTYPE" >> /tmp/partitionfile
echo "part /storage --size 1 --grow --ondisk $instdisk --fstype $FSTYPE --fsoptions='uqnoenforce,gqnoenforce,defaults'" >> /tmp/partitionfile
