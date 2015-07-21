#!/bin/bash -eux

echo "Disk usage before minimization"
df -h

echo "Installed packages before cleanup"
dpkg --get-selections | grep -v deinstall

# Remove some packages to get a minimal install
echo "Removing all linux kernels except the currrent one"
dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v $(uname -r) | xargs apt-get -y purge
echo "Removing linux source"
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge
echo "Removing default system Ruby"
apt-get -y purge ruby ri doc
echo "Removing other oddities"
apt-get -y purge popularity-contest installation-report landscape-common ubuntu-serverguide

# Clean up the apt cache
apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean

# Clean up orphaned packages with deborphan
apt-get -y install deborphan
while [ -n "$(deborphan --guess-all --libdevel)" ]; do
    deborphan --guess-all --libdevel | xargs apt-get -y purge
done
apt-get -y purge deborphan dialog

echo  "Removing caches"
find /var/cache -type f -exec rm -rf {} \;

echo "Disk usage after cleanup"
df -h
