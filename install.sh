#!/bin/bash
echo -e "\033[32m  ==================== Running the script in chroot =============== \033[0m"
apt-get update -y
IMAGE_VER="linux-image-4.4.0-98-generic"
PKG="sudo iputils-ping net-tools openssh-server  wget vim nano debconf devscripts gnupg htop $IMAGE_VER"
PASSWORD_ROOT="1"


function COMMON_PKG()
{
    for INSTALL_BASE_PKG_1 in $@ ; do
         which $INSTALL_BASE_PKG_1 >/dev/null ||  apt-get install $INSTALL_BASE_PKG_1 -y --force-yes
    done
}
COMMON_PKG $PKG

#other pkg
sudo apt-get update -y
cd /tmp/
wget http://launchpadlibrarian.net/242486760/isolinux_6.03+dfsg-11ubuntu1_all.deb 
dpkg -i isolinux_6.03+dfsg-11ubuntu1_all.deb 
sudo apt-get install -y casper lupin-casper

#set root password
echo -e "$PASSWORD_ROOT\n$PASSWORD_ROOT\n" | passwd

sudo apt-get install isolinux -y
sudo apt-get clean