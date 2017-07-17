#!/bin/bash
# inotify-tools


LOG_PATH="/home/upload-tomcat-7.0.42"
FILENAME="logs/catalina.out"
ERROR_KEYS="FileNotFoundException"


inotifywait -m -e close_write ${LOG_PATH}/${FILENAME} | while read LINE
do
    LW=`tail -1 ${LOG_PATH}/${FILENAME}`
    if `echo ${LW} | grep -w "${ERROR_KEYS}" &>/dev/null`
    then
        content=`tail -n 2 ${LOG_PATH}/${FILENAME}`
        echo $content
        #python nginx_smtp.py ${content}
    fi
    
    #
done
