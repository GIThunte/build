#!/bin/bash
DIR=$(dirname $(readlink -f $0))
source $DIR/base_img.conf

function IF_ROOT() #you root ?
{
    if [[ $EUID -ne 0 ]]; then
        echo "$MSG_IF_ROOT"
        exit 1
    fi
}


function PRE_INST()
{
    if [ -d $WORK_DIR ]; then
        read -p "$MSG_IF_FO" answer
        case ${answer:0:1} in
            y|Y )
                echo $MSG_RUN_SC
                sudo rm -rf $WORK_DIR
            ;;
            * )
                echo "$MSG_STOP"
                exit
            ;;
        esac
    else
        echo $MSG_RUN_SC
    fi
}

function COMMON()
{
     for INSTALL_BASE_PKG_1 in $@ ; do
         which $INSTALL_BASE_PKG_1 >/dev/null ||  apt-get install $INSTALL_BASE_PKG_1 -y --force-yes
     done
     apt-get clean
}
function IF_FILE()
{
    for FILE_EX in $@; do
       echo -ne "$MSG_CHECK_FILE \033[33m $FILE_EX \033[0m"
       if [[ -f $FILE_EX ]]; then
          echo -e " $MSG_OK_STATUS"
       else
          echo -e " $MSG_NO_EX"
          exit 1
       fi
   done

}

function IF_DIR()
{
    for D_EX in $@; do
       echo -ne "$MSG_CHECK_DIR \033[33m $D_EX \033[0m"
       if [[ -d $D_EX ]]; then
          echo -e " $MSG_OK_STATUS"
       else
          echo -e " $MSG_NO_DIR"
          exit 1
       fi
   done
}

function CREATE_DIR() #func create dir
{
    if [[ -z "$@" ]]; then
        echo "$MSG_BAD_ARG: $@"
        exit 1
    else
        for FINDFOLDER in $@
        do if [ -d $FINDFOLDER ]; then
                echo $MSG_DIR_EXT
            else
                echo "$MSG_MKDIR $FINDFOLDER" ; sudo mkdir -p $FINDFOLDER
                IF_DIR $FINDFOLDER
            fi
        done
    fi
}

function DOWN_FS()
{
    tree $WORK_DIR
    sudo debootstrap --arch=$UBUNTU_ARCH $UBUNTU_REL $DOWN_BASE $1
    IF_DIR $CHROOT_SCRIPT_DEST
    IF_FILE $CHROOT_SCRIPT
    sudo cp -v -p $DIR/$CHROOT_SCRIPT $CHROOT_SCRIPT_DEST
    IF_FILE $CHROOT_SCRIPT_DEST/$CHROOT_SCRIPT
    sudo chmod +x $CHROOT_SCRIPT_DEST/$CHROOT_SCRIPT
    sudo chroot $DOWN_BASE $END_PATH_SCRIPT
}

function MAKE_FS()
{
    sudo mksquashfs $DOWN_BASE $FOLDER_BUILD_FS/$FSQUASH_FS -e $1
    IF_FILE $FOLDER_BUILD_FS/$FSQUASH_FS
}

function CREATE_CASPER_DIR()
{
    sudo cp -v -p $FOLDER_BUILD_FS/$FSQUASH_FS $CASPER_DIR
    IF_FILE $CASPER_DIR/$FSQUASH_FS
    for GET_BOOT_FILES in $@; do
        IF_DIR $CASPER_DIR
        sudo wget $GET_BOOT_FILES -P $CASPER_DIR
    done
    IF_FILE $CASPER_DIR/$VMLINUZ_NAME $CASPER_DIR/$INITRD_NAME
}

function CREATE_ISOLINUX_DIR()
{
    for CREATE_ISO_LINUX in `ls $DIR/$DIR_FILES | xargs -n1`; do
        sudo cp -v -r -p $DIR/$DIR_FILES/$CREATE_ISO_LINUX $ISOLINUX_DIR/$CREATE_ISO_LINUX
        IF_FILE $ISOLINUX_DIR/$CREATE_ISO_LINUX
    done
}

function CREATE_TREE_ISO()
{
    CREATE_CASPER_DIR $INITRD_URL $VMLINUZ_URL
    CREATE_ISOLINUX_DIR
}

function BUILD_ISO()
{
    
    if [[ -z "$@" ]]; then
        echo "$MSG_BAD_ARG: $@"
        exit 1
    else
        genisoimage \
        -rational-rock \
        -volid "$VOLID" \
        -cache-inodes \
        -joliet \
        -hfs \
        -full-iso9660-filenames \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -output $1 \
        $2
    fi
    IF_FILE $1
}
function POST_BUILD()
{
    IF_FILE $OUTPUT_ISO/$OUTPUT_ISO_NAME
    IF_DIR $OUTPUT_ISO_FILE
    sudo cp -v -p $OUTPUT_ISO/$OUTPUT_ISO_NAME $1
    IF_FILE $OUTPUT_ISO_FILE/$OUTPUT_ISO_NAME
    sudo rm -rf $WORK_DIR
}


