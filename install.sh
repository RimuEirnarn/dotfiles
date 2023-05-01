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
    mkdir -p ~/.local/bin
fi
install -t ~/.local/bin local.bin/*

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
install feh-helpers/main.c ~/.apps/c/
install feh-helpers/main.bash ~/.apps/bash/feh-helpers
ln -s ~/.apps/bash/feh-helpers ~/.local/bin

# chroot helpers
mkdir -p ~/.apps/chroot.bin
install chroot.bin/* -t ~/.apps/chroot.bin

exit 0
