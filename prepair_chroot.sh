source base_img.conf
source base_img.sh
CPU_INFO_FILE="/proc/cpuinfo"
CPU_INFO_DFILE="$DOWN_BASE$CPU_INFO_FILE"
SOURCES_LIST="/etc/apt/sources.list"
SOURCES_DLIST="$DOWN_BASE$SOURCES_LIST"


#copy cpuinfo file or sources list file 
IF_FILE $CPU_INFO_FILE 
sudo cp -v -p $CPU_INFO_FILE $CPU_INFO_DFILE  
IF_FILE $CPU_INFO_DFILE
IF_FILE $SOURCES_LIST
sudo cp -v -p $SOURCES_LIST $SOURCES_DLIST
IF_FILE $SOURCES_DLIST

#create
sudo cp -v -u $DOWN_BASE/boot/vmlinuz-4.4.0-98-generic image/casper/vmlinuz
sudo cp -v -u $DOWN_BASE/boot/initrd.img-4.4.0-98-generic image/casper/initrd.gz