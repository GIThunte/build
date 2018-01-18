# build

##############################################

BEFORE USING THE CONFIGURATION FILE LEADLY CAREFULLY base_img.conf



The default iso path is /srv/BUILD/base_img.iso
Ubuntu: xenial amd64


To change the image content (install programs, etc.), use the file install.sh 
(for example, if you want to add the htop installation, add the line
"sudo apt-get install htop" in this file).

To start, use:
    sudo bash start.sh

Tested on ubuntu 16.04!!!!

##############################################