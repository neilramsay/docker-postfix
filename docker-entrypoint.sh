#!/bin/bash

set -e -o pipefail

source docker-utils.sh

# Starting
if [ -f /usr/local/bin/syslog-stdout.py ]; then
    echo "Starting syslog-stdout"
    python /usr/local/bin/syslog-stdout.py
else
    echo "syslog-stdout missing. Postfix logging may be lost"
fi
echo

# Copied from Postgres Docker Entry Script
# https://github.com/docker-library/postgres/blob/master/docker-entrypoint.sh
#
# Make this image extensible
echo "Running extension configuration/scripts"
for f in /docker-entrypoint.d/*; do
    case "$f" in
        *.sh)
            echo "$0: executing shell script - $f";
            . "$f" ;;
        *.cf | *.map)
            echo "$0: copying to /etc/postfix - $f"
            cp "$f" /etc/postfix/ ;;
        /docker-entrypoint.d/*) ;;
        *)      echo "$0: ignoring $f -- don't know how to process it" ;;
    esac
done
echo "Complete"
echo

if [ "$1" = "/usr/lib/postfix/master" ]; then
    echo "##################################"
    echo "Start of Non-Default Configuration"
    echo "##################################"
    postconf -n
    echo "################################"
    echo "End of Non-Default Configuration"
    echo "################################"
    echo
else
    echo "Executing custom command, so skipping Postfix configuration dump"
    echo
fi

# Replace this entry point script process with the desired program
echo "End of Entrypoint script. Executing $*"
echo
exec "$@"
