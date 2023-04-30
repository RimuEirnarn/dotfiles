#!/bin/bash

source bash/apk

ask "Installing this untrusted scripts could make your files, computer, etc. in danger. Proceed?"
if [ ! "$?" = 0 ]; then
    log "Installation aborted"
    exit
fi

# Initiate local user binaries
log "Create ~/.local/bin entries"
if [ ! -e ~/.local/bin ]; then 
    cp -r local.bin ~/.local/bin
else
    cp -r local.bin/* ~/.local/bin/
fi

# Initiate my own bash includes.
log "Create ~/.bash entries"
if [ ! -e ~/.bash ]; then 
    cp -r bash ~/.bash
else
    cp -r bash/* ~/.bash/
fi

# initate apps
log "Create ~/.apps entries"
if [ ! -e ~/.apps ]; then
    mkdir -p ~/.apps/c
    mkdir -p ~/.apps/python
    mkdir -p ~/.apps/bash
fi

# feh helpers
log "Install feh helpers"
cp feh-helpers/main.c ~/.apps/c/
cp feh-helpers/main.bash ~/.apps/bash/feh-helpers
ln -s ~/.apps/bash/feh-helpers ~/.local/bin

exit 0
