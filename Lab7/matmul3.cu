#include <stdio.h>
#include <math.h>
#define TILE_WIDTH 16

__global__ void MatrixMulKernel(float *Md, float *Nd, float *Pd, int ncols){
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;
  float PValue = 0; //PValue is used to store element of the output MatrixMulKernel
  int k = 0;

  if(row<ncols && col<ncols){
    for(k = 0; k < ncols; k++){
      float Melement = Md[row * ncols + k];
      float Nelement = Nd[k * ncols + col];
      PValue += Melement * Nelement;
    }
    Pd[row * ncols +col] = PValue;
  }
}

int main(int argc, char **argv){
  int i,j;
  int Width;

  printf("Enter Width: ");
  scanf("%d", &Width);

  int size = Width * Width * sizeof(float);
  float M[Width][Width], N[Width][Width], P[Width][Width];
  float *Md, *Nd, *Pd;
  int newValue = (Width + TILE_WIDTH -1)/TILE_WIDTH;

  for(i = 0; i < Width; i++){
    for(j = 0; j < Width; j++){
      M[i][j] = 1;
      N[i][j] = 2;
    }
  }

  cudaMalloc((void**)&Md, size);
  cudaMalloc((void**)&Nd, size);
  cudaMalloc((void**)&Pd, size);

  cudaMemcpy(Md, M, size, cudaMemcpyHostToDevice);
  cudaMemcpy(Nd, N, size, cudaMemcpyHostToDevice);

  //setup the execution configuration
  dim3 dimBlock(TILE_WIDTH, TILE_WIDTH);
  dim3 dimGrid(newValue, newValue);

  //launch the device computation thread!
  MatrixMulKernel<<<dimGrid, dimBlock>>>(Md, Nd, Pd, Width);

  //read P from the device
  cudaMemcpy(P, Pd, size, cudaMemcpyDeviceToHost);

  //free device matrices
  cudaFree(Md);
  cudaFree(Nd);
  cudaFree(Pd);

  for(i = 0; i < Width; i++){
    for(j = 0; j < Width; j++){
      printf("%.2f ", P[i][j]);
    }
    printf("\n");
  }
}
