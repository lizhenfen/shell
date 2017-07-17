#!/bin/bash

for d in `docker ps | awk -F" " 'NR>1{print $NF}'`
do 
    dname=${d}
    did=`docker inspect ${d} | grep -w "Id" | awk -F":" '{print $2}' | tr -d '",'`
    pid=`docker inspect ${d} | grep -w "Pid" | awk -F":" '{print $2}' | tr -d ','`
    natport=`docker inspect vats-service-order | grep -w "HostPort" | uniq | awk -F":" '{print $2}' | tr -d '"'`
    port=`docker inspect ${d} | grep -w "HTTP_PORT" | awk -F"=" '{print $2}' | tr -d '",'`
    if [[ ${natport} != '' ]];then
        docker_port=${natport}
    else
        docker_port=${port}
    fi
    echo ${dname}
    echo ${did}
    echo ${pid}
    echo ${docker_port}
done
