#include <stdio.h>
#include <time.h>
#include <stdlib.h>

// Great help:
// http://www.pages.drexel.edu/~cfa22/msim/node11.html
// gcc -O3 -o name name.c

int Sign(float x){
    int s = 0;
    s = (x>0) - (x<0);
    return s;
}


void Ising(int** G, int** L,int n){
    for(int i = 0 ; i < n ; i++){
        for(int j = 0 ; j < n ; j++){
            L[i][j] = Sign(G[(i-1+n)%n][j] + G[i][(j-1+n)%n] + G[i][j] + G[(i+1)%n][j] + G[i][(j+1)%n]);
        }
    }
}


void init ( int ** F, int L) {
  int i,j;
  for (i=0;i<L;i++) {
    for (j=0;j<L;j++) {
      F[i][j]=2*(rand()%2) - 1;
    }
  }
}

void printThatShit(int** G,int n){
    for(int i=0; i < n ; i++){
        for(int j=0; j < n ; j++){
            printf("%d ",G[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char* argv[]){

    int n ,k;
    srand((unsigned int)time(NULL));

    // pairnw diastash kai iteration
    if(argc < 3){
		printf("bale 2 orismata re lulu, arithmo iteration kai diastash");
		return 0;
	}

    k = (int) strtol(argv[1],NULL,10);
    n = (int) strtol(argv[2],NULL,10);

    // pairnw kati pipes gia to pws bgazei tuxaia 0,1 kai to kanei -1 kai 1
    int** F = (int**)malloc(n * sizeof(int*));
    int** L = (int**)malloc(n * sizeof(int*));

    // Na kanoume init tous pinakes

    for (int i = 0; i < n; i++)
        F[i] = (int*)malloc(n * sizeof(int));



    for (int i = 0; i < n; i++)
        L[i] = (int*)malloc(n * sizeof(int));

    // balw tis tuxaies times ston F
    init(F,n);

    // kaloume edw thn fash
    for(int i = 0; i < k ; i++ ){
        Ising(F,L,n);
        int** temp = F;
        F = L;
        L = temp;
    }

    // Print That Shit
    printThatShit(F,n);
    printThatShit(L,n);


    // Free everything
    free(L);
    free(F);

}
