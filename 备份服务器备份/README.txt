1. ���ݷ�������ǰΪ192.168.15.212
2. ���ݽű���Ĭ��·��:  /data/scripts/tar_exec
3. ���ݽű�ִ��ʱ��
    #backup the /data/pives dirs
    20 01 * * * /bin/sh /data/scripts/tar_exec/config_backup_tar_gz.sh &>/dev/null
    