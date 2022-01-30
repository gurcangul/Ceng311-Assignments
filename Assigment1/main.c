// 260201069 GÜRCAN GÜL

#include <stdio.h>
#include <math.h>
#include <time.h>
#include <stdlib.h>

struct node{
    int data;
    struct node* left;
    struct node* right;
};
int indexes = 0;
int *arr;
struct node* new_node(int x)
{
    struct node *p;
    p =malloc(sizeof(struct node));
    p->data = x;
    p->left = NULL;
    p->right = NULL;
    return p;
}

struct node* insert(struct node *root, int x);
int counter = 2;
int left = 0;
int numberOfLoop = 0;
int power =0;
struct node *rootNode;
void max_heapify(struct node *root, int x){

    if(root->left == NULL){
        root->left = insert(root->left, x);
    }
    else{
        if(root->right == NULL)
        {
            root->right = insert(root->right, x);
        }
        else{

           struct node *p = root->left;
            if(p->left == NULL || p->right == NULL){
                insert(root->left, x);
            }

            else{
                p = root->right;
                if(p->left == NULL || p->right ==NULL){
                    insert(root->right, x);
                }
                else{
                    counter++;
                    if(counter > 0){
                        left++;
                        power = pow(2,counter);
                        if(left <= power/2){
                            counter--;
                            insert(root->left, x);

                        }
                        else{
                            counter--;
                            insert(root->right, x);
                        }
                    }
                    numberOfLoop ++;
                    if(numberOfLoop == power){
                        counter++;
                        left = 0;
                        numberOfLoop = 0;
                    }
                }
            }
        }
    }
}

struct node* insert(struct node *root, int x)
{
    if(root==NULL){
        return new_node(x);
    }
    else if(x>root->data){
        int temp = x;
        x = root->data;
        root->data = temp;
        max_heapify(root, x);
    }
    else{
        max_heapify(root, x);
    }
    return root;
}

void printCurrentLevel(struct node* root, int level,  int levelOrderedArr[]);
int height(struct node* node);

void printLevelOrder(struct node* root,  int levelOrderedArr[])
{
    int h = height(root);
    int i;
    for (i = 1; i <= h; i++)
    {
        printCurrentLevel(root, i, levelOrderedArr);
    }
}
void printCurrentLevel(struct node* root, int level, int levelOrderedArr[])
{
    if (root == NULL)
        return;
    if (level == 1){
        levelOrderedArr[indexes] = root->data;
        indexes++;
    }
    else if (level > 1) {
        printCurrentLevel(root->left, level - 1, levelOrderedArr);
        printCurrentLevel(root->right, level - 1, levelOrderedArr);
    }
}

int height(struct node* node)
{
    if (node == NULL)
        return 0;
    else {
        int lheight = height(node->left);
        int rheight = height(node->right);

        if (lheight > rheight)
            return (lheight + 1);
        else
            return (rheight + 1);
    }
}

int main() {
    int size = pow(2, 28);
    arr = malloc(sizeof(int) * size);
    FILE *numberFile;
    int num, numberOfNum=0, nu;
    if ((numberFile=fopen("2pow28.txt" , "r")) == NULL)
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
        fclose(numberFile);
        clock_t start, end;
        double cpu_time_used;
        start=clock();
        int levelOrderedArr[numberOfNum];
        rootNode = new_node(arr[0]);
        for(int i=1; i<numberOfNum; i++){
            insert(rootNode, arr[i]);
        }
        printLevelOrder(rootNode, levelOrderedArr);
        end = clock();
        cpu_time_used = ((double) (end - start))/CLOCKS_PER_SEC;
        printf("\nMeasured time = %f seconds. ", cpu_time_used);

        FILE *writeFile = fopen("in-order_numbers.txt", "w");
        int k=0,l=1;
        for(int i = 0; i<numberOfNum; i++)
        {
            fprintf(writeFile, "%d ", levelOrderedArr[i]);
            k++;
            if(k==25*l)
            {
                fprintf(writeFile, "\n");
                l++;
            }
        }
        fclose(writeFile);
    }
    return 0;
}
