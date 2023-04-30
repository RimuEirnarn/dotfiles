#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/dir.h>
#include <unistd.h>
#include <string.h>

// Random integer
int randint(int limit){
    int divisor = RAND_MAX/(limit+1);
    int retval;

    do { 
        retval = rand() / divisor;
    } while (retval > limit);
    srand(retval);

    return retval;
}


int main(int argc, char* argv[]){
    srand(time(NULL));
    randint(50);
    struct dirent **namelist;
    int length_dir;
    int points = 0;
    char file[1024];
    if (argc == 1){
        file[0] = '.';
        file[1] = '\0';
    } else {
        //printf("[1]: %s, %ld", argv[1], strlen(argv[1]));
        strncpy(file, argv[1], strlen(argv[1]));
        file[strlen(argv[1])+1] = '\0';
    }
    //printf("[2]: %s\n", file);

    length_dir = scandir(file, &namelist, NULL, alphasort);
    if (length_dir < 0)
        return 1;
    else {
        //for (int i=0; i<length_dir; i++){
        //        printf("[3]: %s\n", namelist[i]->d_name);
        //}
        points = randint(length_dir);
        // for a reason, let's re-randomize points...
        //points = randint(length_dir);
        if (points >= length_dir)
            points = points - length_dir;
        printf("%s", namelist[points]->d_name);
        free(namelist);
    }
    return 0;
}
