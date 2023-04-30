# Compile python source from given path.

REQPATH="pyconfig.h.in"
TARGET="$1"
LEVEL=0

log(){
    mtd="$1"
    shift 1
    if [ "$mtd" = 'i' ]; then
        printf "[ \033[32mINFO\033[0m  ] $@\n"
    elif [ "$mtd" = 'w' ]; then
        printf "[ \033[33mWARN\033[0m  ] $@\n"
    elif [ "$mtd" = 'e' ]; then    
        printf "[ \033[31mERROR\033[0m ] $@\n"
    elif [ "$mtd" = 'die' ]; then
        log e $@
        exit 1 
    else
        log i $@
    fi
    sleep 0.05
}

cdc(){
    printf "$1 $3 $2 p\n" | dc
}

lc(){
    LEVEL="$(cdc $LEVEL + 1)"
    printf "[\033[34m$LEVEL\033[0m] $@\n"
    sleep 0.5
}

lcdie(){
    x=$?
    if [ ! "$x" = 0 ]; then
        die "Error on operation $LEVEL."
    fi
    lc "$@"
}

info(){
    log i "$@"
}

warn(){
    log w "$@"
}

err(){
    log e "$@"
}

die(){
    log die "$@"
}

if [ "$UID" = 0 ]; then
    die "Must be run with non-root user then sudo will be executed."
fi

info "Finding target 'must-exist' file."
if [ -f "$TARGET/$REQPATH" ]; then
    info 'Found, going to target.'
    cd "$TARGET"
    info "Starting to compile"
    ./configure --enable-optimizations --with-lto
    lcdie "Done configuring! starting to do make"
    make
    lcdie "Done make! starting to test."
    make test
    lcdie "Test complete! Trying to install as alternate.\b"
    sudo make altinstall
    lcdie "Compiling done! The python can be started now!"
else
    die "Directory $TARGET is not a python source direcory"
fi
