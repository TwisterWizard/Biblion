#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//initialize strings to be empty. Must contain some value to avoid errors though.
char lastName[]="";
char firstName[]="";
char title[]="";
char journal[]="";
int volume;
int year;

const char* mla(){
//returns a pointer to the first character in memory
    return firstName;
}

int main(){
    //make powershell script run
    //the following runs a command in the OS shell on behalf of the program
    char powerCom[] = "powershell ./ask.ps1";
    int check = system(powerCom);//take a pointer
    if (check){//returns 0 on success
        printf("ERROR:Shell script failed\n");
    }

    //remove the environment variable we made earlier
    //powerCom[] = "powershell Remove-Item Env:CHOSEN";
    //char envName[] = "PATH";

    //Get the input sources from all fields
    //const char* chosen = getenv(envName);
    //printf("%s",chosen);
    //store them in memory
    char name[]="\0";
    scanf("%s", name);//wait for input from user

    strcpy(firstName, name);
    puts(mla());
}
