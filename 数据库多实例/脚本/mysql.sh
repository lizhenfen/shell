#!/bin/bash
# chkconfig: 2345 64 36
# description: A very fast and reliable SQL database engine.


#must not be null
port=3307
#must be null
datadir=/data/mysql/data/${port}
confdir=/data/mysql/conf/${port}

mysqld_pid_file_path=${confdir}/mysql.pid
mode=$1

case "$mode" in
    'start')
        MYSQLDRUNNING=0
        if [ -f "$mypidfile" ]; then
            mysqld_pid=`cat "$mysqld_pid_file_path" 2>/dev/null`
            if [ -n "$mysqld_pid" ] && [ -d "/proc/$mysqld_pid" ] ; then
                MYSQLDRUNNING=1
                echo "Mysql Server had started"
                exit 0
            fi
        fi
        echo "Starting MySQL (Mysql Server)"
        if test -x `which mysqld_safe`
        then
          `which mysqld_safe` --defaults-file=${confdir}/my.cnf >/dev/null &
           return_value=$?

          exit $return_value
        fi
        ;;

    'stop')
        if test -s "$mysqld_pid_file_path"
        then
            mysqld_pid=`cat "$mysqld_pid_file_path"`

            if (kill -0 $mysqld_pid 2>/dev/null)
            then
              echo $echo_n "Shutting down MySQL (Percona Server)"
              kill $mysqld_pid
              sleep 2
              return_value=$?
            else
              echo "MySQL (Percona Server) server process #$mysqld_pid is not running!"
              rm "$mysqld_pid_file_path"
            fi
        else
          echo "MySQL (Percona Server) PID file could not be found!"
        fi
        exit $return_value
        ;;

    'reload'|'force-reload')
        if test -s "$mysqld_pid_file_path" ; then
          read mysqld_pid <  "$mysqld_pid_file_path"
          kill -HUP $mysqld_pid && echo "Reloading service MySQL (Percona Server)"
          touch "$mysqld_pid_file_path"
        else
          echo "MySQL (Percona Server) PID file could not be found!"
          exit 1
        fi
        ;;
    'status')
        # First, check to see if pid file exists
        if test -s "$mysqld_pid_file_path" ; then 
          read mysqld_pid < "$mysqld_pid_file_path"
          if kill -0 $mysqld_pid 2>/dev/null ; then 
            echo  "MySQL (Percona Server) running ($mysqld_pid)"
            exit 0
          else
            echo "MySQL (Percona Server) is not running, but PID file exists"
            exit 1
          fi
        else
          # Try to find appropriate mysqld process
          mysqld_pid=`pidof $libexecdir/mysqld`

          # test if multiple pids exist
          pid_count=`echo $mysqld_pid | wc -w`
          if test $pid_count -gt 1 ; then
            log_failure_msg "Multiple MySQL running but PID file could not be found ($mysqld_pid)"
            exit 5
          elif test -z $mysqld_pid ; then 
            if test -f "$lock_file_path" ; then 
              log_failure_msg "MySQL (Percona Server) is not running, but lock file ($lock_file_path) exists"
              exit 2
            fi 
            log_failure_msg "MySQL (Percona Server) is not running"
            exit 3
          else
            log_failure_msg "MySQL (Percona Server) is running but PID file could not be found"
            exit 4
          fi
        fi
        ;;
    *)
        # usage
        basename=`basename "$0"`
        echo "Usage: $basename  {start|stop|restart|reload|force-reload|status}  [ MySQL (Percona Server) options ]"
        exit 1
        ;;
esac
