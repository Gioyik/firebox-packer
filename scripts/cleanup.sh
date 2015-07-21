#!/bin/bash
SSH_USER=${SSH_USERNAME:-vagrant}

echo "cleaning up dhcp leases"
if [ -d "/var/lib/dhcp" ]; then
    rm /var/lib/dhcp/*
fi 

echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

echo "cleaning up tmp"
rm -rf /tmp/*

echo "cleanup apt cache"
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean

echo "installed packages"
dpkg --get-selections | grep -v deinstall

echo "remove Bash history"
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/${SSH_USER}/.bash_history

echo "clean up log files"
find /var/log -type f | while read f; do echo -ne '' > $f; done;

echo "clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp
