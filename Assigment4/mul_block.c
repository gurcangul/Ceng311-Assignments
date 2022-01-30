// C program to multiply two square matrices. 
#include <stdio.h> 
#include <stdlib.h>
#include <time.h> 
#define N 1000
#define BLOCKSIZE 100  

void block(int si, int sj, int sk, double **mat1, double **mat2, double **res) 
{ 
    int i, j, k; 
    //printf("%d %d %d\n", si, sj, sk);
    for (i = si; i < si+BLOCKSIZE; i++) 
    { 
        for (j = sj; j < sj+BLOCKSIZE; j++) 
        { 
            double temp = res[i][j];
            for (k = sk; k < sk+BLOCKSIZE; k++) 
                temp += mat1[i][k]*mat2[k][j]; 
	    res[i][j] = temp;
        } 
    } 
} 

// This function multiplies mat1 and mat2, 
// and stores the result in res 
void multiply(double **mat1, double **mat2, double **res) 
{ 
    int i, j, k; 
    for (i = 0; i < N; i+=BLOCKSIZE) 
    { 
        for (j = 0; j < N; j+=BLOCKSIZE) 
        { 
            for (k = 0; k < N; k+=BLOCKSIZE) 
		block(i, j, k, mat1, mat2, res);
        } 
    } 
} 

  
int main() 
{ 
    double *mat1[N]; 
    double *mat2[N]; 
    double *res[N]; // To store result 

    int i, j;

    for (i = 0; i < N; i++) 
    { 
        mat1[i] = (double *) malloc(N * sizeof(double));
	mat2[i] = (double *) malloc(N * sizeof(double)); 
 	res[i] = (double *) malloc(N * sizeof(double)); 
        for (j = 0; j < N; j++) 
        { 
            mat1[i][j]= i+1; 
	    mat2[i][j]= j+1; 
        } 
    } 
    
    clock_t start = clock();
    multiply(mat1, mat2, res); 
    clock_t end = clock();
    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Time elapsed is %f seconds\n", time_spent);

    /*printf("Matrix multiplication complete \n"); 
    printf("Result matrix is \n"); 
    for (i = 0; i < N; i++) 
    { 
        for (j = 0; j < N; j++) 
           printf("%f ", res[i][j]); 
        printf("\n"); 
    }*/
  
    return 0; 
} 
