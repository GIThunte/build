source ./base_img.conf
source ./base_img.sh

function START_MSG()
{
    echo -e "$MSG_EXT_FOLDER$MSG_DOWN_FS: $UBUNTU_URL\n$MSG_SAVE_FS: $OUTPUT_ISO_FILE\n$MSG_EXT_FOLDER_1"
    sleep 5
}

function INIT()
{
    ########################### Load function ######################
    IF_ROOT
    PRE_INST
    COMMON $PKG
    CREATE_DIR $WORK_DIR $DOWN_BASE $FOLDER_BUILD_FS $FOLDER_BUILD_ISO $CASPER_DIR $ISOLINUX_DIR $OUTPUT_ISO $OUTPUT_ISO_FILE
    DOWN_FS $1
    MAKE_FS $IGNORE_DIR 
    CREATE_TREE_ISO
    BUILD_ISO $OUTPUT_ISO/$OUTPUT_ISO_NAME $FOLDER_BUILD_ISO
    POST_BUILD $2
}

function PARAM()
{
    ########################## check parameters #####################

    if [ ! -z $1 ]; then
        UBUNTU_URL="$1"
    fi
    ##########################
    if [ ! -z $2 ]; then
        OUTPUT_ISO_FILE="$2"
    fi
    ##########################
    shift
    INIT $UBUNTU_URL $OUTPUT_ISO_FILE
}
function TIMER()
{
    while sleep 1; do
          echo -n '* ' >&2
    done
}

function PRE()
{
    TIMER &
    TIMER_ID=$!
    START_MSG
    sudo kill $TIMER_ID
    clear
}
IF_ROOT
PRE
PARAM $1 $2 