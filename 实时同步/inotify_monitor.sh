#!/bin/bash
#the path of scripts/sync
SCRIPT_DIR=/data/scripts/sync
SCRIPT_NAME=conf_sync.sh

#backup the data dirs
DATA_DIR=/usr/local/nginx/conf.bak
# path's name of rsyncd server
REMOTE_DIR=192.168.15.201_nginx

# path of log
RSYNC_LOG=/var/log/rsync.log
INOTIFYWAIT=`which inotifywait`
[ "$?" -ne 0 ] && yum install inotify-tools -y
sleep 1

${INOTIFYWAIT} -rqm -e modify,create,delete ${DATA_DIR} --exclude "^.*\.(swp|swx|swpx|log|out)$" | while read file
do
     echo "$file"
    /bin/bash ${SCRIPT_DIR}/${SCRIPT_NAME} upload ${DATA_DIR} ${REMOTE_DIR}
done
