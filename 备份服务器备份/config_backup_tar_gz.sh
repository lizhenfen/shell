#!/bin/bash

CONFIG_BACKUP_DIR=/data/pives
BACK_DATADIR=/data/pives_bak
Y_MOTH=`date +%Y-%m`
TODAY=`date +%d`

function check_backup_dir(){
    if [ ! -d ${BACK_DATADIR}/${Y_MOTH} ];then
        mkdir -p ${BACK_DATADIR}/${Y_MOTH}
    fi
    if [ ! -d ${BACK_DATADIR}/${Y_MOTH}/${TODAY} ];then
        mkdir -p ${BACK_DATADIR}/${Y_MOTH}/${TODAY}
    fi
}

function gz_back(){
    filename=$1
    SRC_NAME=${CONFIG_BACKUP_DIR}/${filename}
    [ -d ${SRC_NAME} ] && ( /bin/tar zcvf ${BACK_DATADIR}/${Y_MOTH}/${TODAY}/${filename}.tar.gz ${SRC_NAME} &>/dev/null )
}



check_backup_dir

for i in `ls ${CONFIG_BACKUP_DIR}`
do
    gz_back "${i}"
done
