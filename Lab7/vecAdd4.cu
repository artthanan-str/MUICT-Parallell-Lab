#include <stdio.h>
#define N 1024
#define T 240

__global__ void vecAdd(int *A, int *B, int *C){
  int i = blockIdx.x * blockDim.x + threadIdx.x;

  if(i < N){
    C[i] = A[i] + B[i];
  }
}

int main(int argc, char *argv[]){
  int i;
  int blocks = (N + T - 1) / T;
  int size = N*sizeof(int);
  int a[N], b[N], c[N], *devA, *devB, *devC;

  for(i=0; i<N; i++){
    a[i] = 1;
    b[i] = 2;
  }

  cudaMalloc( (void**) &devA, size);
  cudaMalloc( (void**) &devB, size);
  cudaMalloc( (void**) &devC, size);

  cudaMemcpy( devA, a, size, cudaMemcpyHostToDevice);
  cudaMemcpy( devB, b, size, cudaMemcpyHostToDevice);

  vecAdd<<<blocks, T>>>(devA, devB, devC);

  cudaMemcpy( c, devC, size, cudaMemcpyDeviceToHost);
  cudaFree(devA);
  cudaFree(devB);
  cudaFree(devC);

  for(i=0; i<N; i++){
    printf("%d ", c[i]);
  }
  printf("\n");

}
