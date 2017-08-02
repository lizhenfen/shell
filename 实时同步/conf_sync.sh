#!/bin/bash

RSYNCD_SERVER="192.168.15.212"

RSYNC_CMD=`which rsync`
[ "$?" -ne 0 ] && yum install rsync -y



function check_src(){
   [ -z `echo ${SRC##*/}` ] || SRC=${SRC}/

}

function upload(){
    ${RSYNC_CMD} -aLz --delete --exclude "*.log|*.out" ${SRC} ${RSYNCD_SERVER}::data/${DEST} &>/dev/null
    [ "$?" -ne 0 ] &&  exit 1 || exit 0

}


function download(){
    ${RSYNC_CMD} -az --delete  ${RSYNCD_SERVER}::data/${SRC} ${DEST} &>/dev/null
    [ "$?" -ne 0 ] &&  exit 1 || exit 0

}


function usage(){
    echo "Usage: $0 [upload|download] src_Path dest_path"
}



function main(){
    if [ $# != 3 ];then
        usage && exit 1
    fi
    METHOD=$1
    SRC=$2
    DEST=$3
    #check src format
    check_src
    
    ${METHOD} ${SRC} ${DEST} &>/dev/null
    [ "$?" -ne 0 ] && usage
}

main $1 $2 $3
