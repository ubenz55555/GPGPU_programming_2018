#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <stdlib.h>

void check(cudaError x) {
  //  fprintf(stderr, "%s\n", cudaGetErrorString(x));
}

void showMatrix2(char* v1, int width, int height) {
  //  printf("---------------------\n");
   
    for (int i = 0; i < width; i++) {
	if (i != 0){
		printf(" %d\n", i);}
        for (int j = 0; j < height; j++) {
            printf("%c", v1[i * width + j]);	
        }
	if (i == 11){
	    printf(" %d\n ", i+1);}
       // printf("\n");
    }
}

__global__ void kernel(char* tab,int width, int height, int pitch) {

    int row = threadIdx.x + blockIdx.x * blockDim.x;
    int col = threadIdx.y + blockIdx.y * blockDim.y;

    if (row < width && col < height) {
        *( ((int *)(((char *)tab) + (row * pitch))) + col) = '&';
    }
}

int main()
{
    int width = 12;
    int height = 156;

    char* d_tab;
    char* h_tab;

    int realSize = width * height* sizeof(int);

    size_t pitch;
    check( cudaMallocPitch(&d_tab, &pitch, width * sizeof(int), height) );
    h_tab = (char*)malloc(realSize);
    check( cudaMemset(d_tab, 0, realSize) );

    dim3 grid(39, 12);
    dim3 block(39, 12);
    kernel <<<grid, block>>>(d_tab, width, height, pitch);

    check( cudaMemcpy2D(h_tab, width*sizeof(int), d_tab, pitch, width*sizeof(int), height, cudaMemcpyDeviceToHost) );

    showMatrix2(h_tab, width, height);
   // printf("\nPitch size: %ld\n", pitch);
    return 0;
}
