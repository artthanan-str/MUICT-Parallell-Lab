#include <stdio.h>
#define N 1000
#define M 256

__global__ void vecAdd(int *A){
  int i;
  for(i = threadIdx.x; i<N; i+=M){
    A[i] += 1;
  }
}

int main(int argc, char *argv[]){
  int i;
  int size = N*sizeof(int);
  int a[N], *devA;

  for(i=0; i<N; i++){
    a[i] = 2*i+1;
  }

  cudaMalloc( (void**) &devA, size);
  cudaMemcpy( devA, a, size, cudaMemcpyHostToDevice);

  vecAdd<<<1, M>>>(devA);

  cudaMemcpy( a, devA, size, cudaMemcpyDeviceToHost);
  cudaFree(devA);

  for(i=0; i<N; i++){
    if(i%26 == 0) printf("\n");
    printf("%d ", a[i]);
  }
  printf("\n");
}
