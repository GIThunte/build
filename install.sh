#!/bin/bash
PKG="sudo iputils-ping net-tools openssh-server  wget vim nano debconf devscripts gnupg htop"

function PKG_1()
{
    for INSTALL_BASE_PKG_1 in $@ ; do
         which $INSTALL_BASE_PKG_1 >/dev/null ||  apt-get install $INSTALL_BASE_PKG_1 -y --force-yes
    done
    apt-get clean
}
PKG_1 $PKG
