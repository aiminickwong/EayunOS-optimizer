LOCKFILE='/etc/ovirt-optimizer/lastwatch'
if [ ! -f $LOCKFILE ]
then
    echo '0' > $LOCKFILE
fi

if [ $(echo "($(date +"%s") - $(cat $LOCKFILE))>64"|bc) = "1" ]
then
    echo 'watchdog begins'
    while true
    do
        echo $(date +"%s") > $LOCKFILE
        if [ -f /var/run/ovirt-optimizer.pid ]
        then
            sleep 30s
        else
            echo 'optimizer not running, starting...'
            service ovirt-optimizer restart
        fi
    done
else
    echo 'watchdog already running'
fi
