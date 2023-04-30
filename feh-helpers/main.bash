#!/bin/bash

BG_FOLDER="$1"

check_dwm(){
    pidof dwm >> /dev/null 2>> /dev/null
    printf "$?"
}

log(){
    echo "$1"
    logger -i "$1"
}

if [ "$BG_FOLDER" = "" ]; then
    echo "Where's the directory?"
    exit 1
fi

while [ "$(check_dwm)" == "0" ]; do
    i="$(find $BG_FOLDER -type f | shuf -n 1)"
    log "Set dwm/X11 wallpaper of $DISPLAY with $i then sleep for 5 minutes"
    feh --bg-fill "$i"
    sleep 300
done
