#include <stdio.h>
#define N 256
#define T 4

__global__ void vecAdd(int *A){
  int i = blockIdx.x * blockDim.x + threadIdx.x;

  if(i < N){
    A[i] = i;
  }
}

int main(int argc, char *argv[]){
  int i;
  int blocks = N/T;
  int size = N*sizeof(int);
  int a[N], *devA;

  cudaMalloc( (void**) &devA, size);

  cudaMemcpy( devA, a, size, cudaMemcpyHostToDevice);

  vecAdd<<<blocks, T>>>(devA);

  cudaMemcpy( a, devA, size, cudaMemcpyDeviceToHost);
  cudaFree(devA);

  for(i=0; i<N; i++){
    if(i != 0 && i%20 == 0) printf("\n");
    printf("%d ", a[i]);
  }
  printf("\n");
}
