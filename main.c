// 260201069

#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

struct node{   // product struct

    int data;
    struct node* left;
    struct node* right;

};

struct node* search(struct node *root, int x)
{
    if(root==NULL || root->data==x) //if root->data is x then the element is found
        return root;
    else if(x>root->data) // x is greater, so we will search the right subtree
        return search(root->right, x);
    else //x is smaller than the data, so we will search the left subtree
        return search(root->left,x);
}

struct node* new_node(int x)
{
    struct node *p;
    p =malloc(sizeof(struct node));
    p->data = x;
    p->left = NULL;
    p->right = NULL;

    return p;
}

int parent(int i) {
    return (i - 1) / 2;
}

// return the index of the left child
int left_child(int i) {
    return 2*i + 1;
}

// return the index of the right child
int right_child(int i) {
    return 2*i + 2;
}
void swap(int *x, int *y) {
    int temp = *x;
    *x = *y;
    *y = temp;
}
void insert(int *arr, int data, int *n) {
    int size = pow(2, 28);
    arr[*n] = data;
    *n = *n + 1;
    int i = *n - 1;
    while (i != 0 && arr[parent(i)] < arr[i]) {
        swap(&arr[parent(i)], &arr[i]);
        i = parent(i);
    }
}

struct node* max_heapify(int *arr, int i, int n){printf("ayten6");

    int size = pow(2, 28);printf("ayten6");

    struct node *p = malloc(sizeof(struct node));printf("ayten556");

    p->left->data = left_child(i);printf("ayten8");
printf("data= %d",p->left->data);

    p->right->data = right_child(i);printf("ayten67");

printf("ayten6");
    // find the largest among 3 nodes
    int largestNumber = i;

    // check if the left node is larger than the current node
    if (p->left->data <= n && arr[p->left->data] > arr[largestNumber]) {
        largestNumber = p->left->data;
    }

    // check if the right node is larger than the current node
    if (p->right->data <= n && arr[p->right->data] > arr[largestNumber]) {
        largestNumber = p->right->data;
    }

    // swap the largest node with the current node
    // and repeat this process until the current node is larger than
    // the right and the left node
    if (largestNumber != i) {
        int temp = arr[i];
        arr[i] = arr[largestNumber];
        arr[largestNumber] = temp;
        max_heapify(arr, largestNumber, n);
    }

}

// converts an array into a heap
struct node* build_max_heap(int *arr, int n) {printf("ayten1");

    int size = pow(2, 28);
    int i;printf("ayten2");
    for (i = n/2; i >= 0; i--) {printf("ayten3");
        max_heapify(arr, i, n);
    }printf("ayten4");
}


// prints the heap
void print_heap(int *arr, int n) {
    int size = pow(2, 28);

    int i;
    for (i = 0; i < n; i++) {
        printf("%d\n", arr[i]);
    }
    printf("\n");
}



int main() {
    int *arr; // new_num array was created as the number of integers in the file.
    int size = pow(2, 28);
    arr = malloc(sizeof(int) * 15);

    FILE *numberFile;
    int num, numberOfNum=0, nu;
    if ((numberFile=fopen("numbers.txt" , "r")) == NULL)
        printf("Server or files are not found.\n");
    else
    {
        while (fscanf(numberFile,"%d",&nu)!=EOF)
        {
            numberOfNum++;  // Number of integers in the txt file
        }
        fclose(numberFile);
    }
    if ((numberFile=fopen("numbers.txt" , "r")) == NULL)
        printf("Server or files are not found.\n");
    else {

        for (int i = 0; i < numberOfNum; i++) {
            fscanf(numberFile, "%d", &num);
            arr[i] = num;  // All integers assigned to numbers list
        }
        printf("Sayıları okudu   m \n");
        for(int i=0;i<numberOfNum;i++){
            printf("adadada %d\n",arr[i]);
        }
        fclose(numberFile);
        clock_t start, end;
        double cpu_time_used;
        start=clock();
        printf("number of num = %d ", numberOfNum);
        build_max_heap(arr,numberOfNum);
        int size = 0;

        end = clock();
        cpu_time_used = ((double) (end - start))/CLOCKS_PER_SEC;
        printf("\nMeasured time = %f seconds. ", cpu_time_used);

        FILE *writeFile = fopen("in-order_numbers.txt", "w");
        int k=0,l=1;
        for(int i = 0; i<numberOfNum; i++)
        {
            fprintf(writeFile, "%d ", arr[i]);
            k++;
            if(k==25*l)
            {
                fprintf(writeFile, "\n");
                l++;
            }
        }
        fclose(writeFile);
    }
    print_heap(arr, numberOfNum);
    return 0;
}

