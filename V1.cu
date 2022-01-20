#include <stdio.h>
#include <time.h>
#include <stdlib.h>

// Great help:
// http://www.pages.drexel.edu/~cfa22/msim/node11.html
// gcc -O3 -o name name.c


__global__ void Ising(int* G, int* L,int n){
      int i = threadIdx.x/n;
      int j = threadIdx.x%n;
      int x = G[(i-1+n)%n*n+j] + G[i*n+(j-1+n)%n] + G[i*n+j] + G[(i+1)%n*n+j] + G[i*n+(j+1)%n];
      L[i*n+j] = (x>0) - (x<0);
      printf(" I am %d, x is %d, L is %d\n", threadIdx.x, x,   L[i*n+j]);
}


void init ( int* F, int L) {
  int i,j;
  for (i=0;i<L;i++) {
    for (j=0;j<L;j++) {
      F[i*L+j]=2*(rand()%2) - 1;
    }
  }
}

void printThatShit(int* G,int n){
    for(int i=0; i < n ; i++){
        for(int j=0; j < n ; j++){
            printf("%d ",G[i*n+j]);
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
    int* F = (int*)malloc(n * n * sizeof(int));
    int* L = (int*)malloc(n * n * sizeof(int));

    int *d_F, *d_L;
    cudaMalloc(&d_F, n * n * sizeof(int));
    cudaMalloc(&d_L, n * n * sizeof(int));

    // balw tis tuxaies times ston F
    init(F,n);

    cudaMemcpy(d_F, F, n * n * sizeof(int), cudaMemcpyHostToDevice);

    // kaloume edw thn fash
    for(int i = 0; i < k ; i++ ){
        Ising<<<1,n*n>>>(d_F,d_L,n);
        int* temp = d_F;
        d_F = d_L;
        d_L = temp;
    }

    cudaMemcpy(F, d_F, n * n * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(L, d_L, n * n * sizeof(int), cudaMemcpyDeviceToHost);

    // Print That Shit
    printThatShit(F,n);
    printThatShit(L,n);


    // Free everything
    free(L);
    free(F);
    cudaFree(d_F);
    cudaFree(d_L);

}
