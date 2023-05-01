#!/bin/bash

## THIS INCLUDES BUSYBOX ##

## LINK TO BUSYBOX LICENSE: https://busybox.net/license.html

source ~/.bash/apk

# change the url to your liking

if [ "$1" = '' ]; then
    busybox="https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox"
else
    busybox="$1"
fi

which curl 2> /dev/null > /dev/null
[ ! "$?" = 0 ] && die "Where's curl?"

curl $busybox > busybox
chmod 755 busybox
