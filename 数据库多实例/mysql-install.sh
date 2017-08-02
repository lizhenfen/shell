#!/bin/bash

port=3307

mysqlinstall=/usr/bin/mysql_install_db
datadir=/data/mysql/data
confdir=/data/mysql/conf/${port}
shellf=/data/mysql/bin/mysql-default.sh


if [ ! -d ${datadir}/${port} ]
then
    mkdir -p ${datadir}/${port}
fi

if [ ! -d ${confdir} ];then
    mkdir -p ${confdir}
fi

if [ ! -f ${confdir}/my.cnf ];then
    /bin/cp ${confdir%/*}/my.cnf ${confdir}/
    sed -i 's/3306/'`echo ${port}`'/g' ${confdir}/my.cnf
fi

if [ `ls ${datadir}/${port} | grep mysql | wc -l` -eq 1 ];then
    echo "mysql data exists...."
    exit 0
fi
chown -R mysql.mysql ${datadir}/${port}
chown -R mysql.mysql ${confdir}

echo "initing mysql data..."
${mysqlinstall} --datadir=${datadir}/${port} --defaults-file=${confdir}/my.cnf &>/dev/nulll
REL=$?
if [ "$REL" -eq 0 ];then
    echo "mysql data init successfully"
    echo "creating start shell...."
    /bin/cp ${shellf} /data/mysql/bin/mysql-${port}.sh &>/dev/null
    sed -i 's/port=.*/port='`echo ${port}`'/g' /data/mysql/bin/mysql-${port}.sh
    
    echo "start shell created successfully."
else
    echo "mysql data init failed, please connect admin."
fi

