#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main_2(){
    int ret = 0;
    ret = pause();
    printf("Pause returned with %d\n", ret);
    return 0;
}

int main(){
    pid_t pid = fork();
    printf("Called by uid %d\n", getuid());
    if (!getuid() == 0) {
        setuid(0);
        printf("Changed uid to 0\n");
    }
    char *initfile = "/data/etc/init";
    char *initname = "PseudoINIT::InitEntries";
    if (pid == 0){
        execl(initfile, initname, "", NULL);
    } else if (pid > 0) {
        wait(NULL);
        main_2();
    }
    return 0;
}
