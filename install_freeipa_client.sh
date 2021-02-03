#!/bin/bash 

yum -y install freeipa-client ipa-admintools

ipa-client-install --unattended  --realm=AIC.COM --domain=aic.com --server=mgmt.aic.com  --mkhomedir  --principal=admin  --password="fr33!p@A" --force-join  

echo "mgmt:/home	/home	nfs	defaults	0 0" >> /etc/fstab
