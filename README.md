# The first thing to do is read the file base_img.conf. In this file you should be interested in the following lines:


OUTPUT_FOLDER="/srv" : Image save directory ;
OUTPUT_ISO_FILE="$OUTPUT_FOLDER/BUILD" : The iso image ;



The default iso path is /srv/BUILD/base_img.iso;
Ubuntu: xenial amd64


To change the image content (install programs, etc.), use the file install.sh 
(for example, if you want to add the htop installation, add the line
"sudo apt-get install htop" in this file).

To start, use:
   # sudo bash start.sh

# Tested on ubuntu 16.04!!!!

You can also use the following parameters at startup:

sudo bash start.sh [The URL from which the file system will be loaded] [the path where the destination image will be saved]

eg:

sudo bash start.sh http://archive.ubuntu.com/ubuntu/ /home/user/build



################################################
