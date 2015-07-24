#!/bin/bash
/usr/share/debconf/fix_db.pl
apt-get -y update

echo "add repositories"
add-apt-repository ppa:ubuntu-mozilla-daily/ppa -y
add-apt-repository -y ppa:nilarimogard/webupd8 -y
add-apt-repository -y ppa:webupd8team/java -y
apt-get -y update

echo "force update repo"
apt-get -y install git
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /bin/repo
chmod a+x /bin/repo

echo "install prerequisite libraries"
/usr/share/debconf/fix_db.pl
apt-get install -y autoconf2.13 bison bzip2 ccache curl flex gawk gcc g++ g++-multilib lib32z1 lib32ncurses5 lib32bz2-1.0 lib32ncurses5-dev lib32z1-dev libgl1-mesa-dev libx11-dev libasound2 make zip android-tools-adb python-software-properties libxml2-utils
apt-get install -y libgl1-mesa-dev libglapi-mesa:i386 libgl1-mesa-glx:i386
sudo ln -s /usr/lib/i386-linux-gnu/libX11.so.6 /usr/lib/i386-linux-gnu/libX11.so
sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
sudo apt-get install -y binutils-gold

echo "set ccache max size"
ccache --max-size 3GB

echo "add android device rules"
if [ -f /etc/udev/rules.d/51-android.rules ]
then
    rm /etc/udev/rules.d/51-android.rules
fi

cat <<EOF >> /etc/udev/rules.d/51-android.rules
#Acer
SUBSYSTEM=="usb", ATTR{idVendor}=="0502", MODE="0666", GROUP="vagrant"
#ASUS
SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", MODE="0666", GROUP="vagrant"
#Dell
SUBSYSTEM=="usb", ATTR{idVendor}=="413c", MODE="0666", GROUP="vagrant"
#Foxconn
SUBSYSTEM=="usb", ATTR{idVendor}=="0489", MODE="0666", GROUP="vagrant"
#Garmin-Asus
SUBSYSTEM=="usb", ATTR{idVendor}=="091e", MODE="0666", GROUP="vagrant"
#Google
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="vagrant"
#HTC
SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", MODE="0666", GROUP="vagrant"
#Huawei
SUBSYSTEM=="usb", ATTR{idVendor}=="12d1", MODE="0666", GROUP="vagrant"
#K-Touch
SUBSYSTEM=="usb", ATTR{idVendor}=="24e3", MODE="0666", GROUP="vagrant"
#KT Tech
SUBSYSTEM=="usb", ATTR{idVendor}=="2116", MODE="0666", GROUP="vagrant"
#Kyocera
SUBSYSTEM=="usb", ATTR{idVendor}=="0482", MODE="0666", GROUP="vagrant"
#Lenevo
SUBSYSTEM=="usb", ATTR{idVendor}=="17EF", MODE="0666", GROUP="vagrant"
#LG
SUBSYSTEM=="usb", ATTR{idVendor}=="1004", MODE="0666", GROUP="vagrant"
#Motorola
SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", MODE="0666", GROUP="vagrant"
#NEC
SUBSYSTEM=="usb", ATTR{idVendor}=="0409", MODE="0666", GROUP="vagrant"
#Nvidia
SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0666", GROUP="vagrant"
#OTGV
SUBSYSTEM=="usb", ATTR{idVendor}=="2257", MODE="0666", GROUP="vagrant"
#Pantech
SUBSYSTEM=="usb", ATTR{idVendor}=="10A9", MODE="0666", GROUP="vagrant"
#Philips
SUBSYSTEM=="usb", ATTR{idVendor}=="10A9", MODE="0666", GROUP="vagrant"
#PMC-Sierra
SUBSYSTEM=="usb", ATTR{idVendor}=="04da", MODE="0666", GROUP="vagrant"
#Qualcomm
SUBSYSTEM=="usb", ATTR{idVendor}=="05c6", MODE="0666", GROUP="vagrant"
#SK Telesys
SUBSYSTEM=="usb", ATTR{idVendor}=="1f53", MODE="0666", GROUP="vagrant"
#Samsung
SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="vagrant"
#Sharp
SUBSYSTEM=="usb", ATTR{idVendor}=="04dd", MODE="0666", GROUP="vagrant"
#Sony Ericsson
SUBSYSTEM=="usb", ATTR{idVendor}=="0fce", MODE="0666", GROUP="vagrant"
#Toshiba
SUBSYSTEM=="usb", ATTR{idVendor}=="0930", MODE="0666", GROUP="vagrant"
#ZTE
SUBSYSTEM=="usb", ATTR{idVendor}=="19d2", MODE="0666", GROUP="vagrant"
EOF
chmod a+r /etc/udev/rules.d/51-android.rules

echo "add spectrum rule"
if [ ! -d .android ]
then
    mkdir .android
echo 0x1782 > .android/adb_usb.ini
fi

echo "restar services"
service udev restart

echo "install java"
/usr/share/debconf/fix_db.pl
apt-get purge -y openjdk*
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get install -y oracle-java7-installer

echo "install xfce desktop"
/usr/share/debconf/fix_db.pl
apt-get install lxde-core lightdm-gtk-greeter -y

echo "remove Ubuntu start manager"
/usr/share/debconf/fix_db.pl
update-rc.d -f lightdm remove

echo "clean all unrequired packages"
apt-get autoremove -y
