1. 备份服务器当前为192.168.15.212
2. 备份脚本的默认路径:  /data/scripts/tar_exec
3. 备份脚本执行时间
    #backup the /data/pives dirs
    20 01 * * * /bin/sh /data/scripts/tar_exec/config_backup_tar_gz.sh &>/dev/null
    