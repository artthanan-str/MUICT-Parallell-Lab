
#include <stdio.h>
#include <mpi.h>
int main(int argc, char *argv[])
{
  int LEFT, RIGHT;
  int rank, size;
  MPI_Status status;
  int interval;
  int number, start, end, sum, GrandTotal;
  int proc;

  MPI_Init( &argc, &argv );
  MPI_Comm_rank( MPI_COMM_WORLD, &rank );
  MPI_Comm_size( MPI_COMM_WORLD, &size );

  if (rank == 0) {
    printf("Enter the number of LEFT and RIGHT: ");
    fflush(stdout);
    scanf("%d %d", &LEFT, &RIGHT);
      GrandTotal = 0;
      for (proc=1; proc<size; proc++) {
          //MPI_Recv(&sum,1,MPI_INT,proc,123,MPI_COMM_WORLD,&status);
          //MPI_Reduce(&sum, &GrandTotal, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
          GrandTotal = GrandTotal+sum;
        }
        printf("Grand total = %d \n", GrandTotal);
  }
  MPI_Bcast(&LEFT, 1, MPI_INT, 0, MPI_COMM_WORLD);
  MPI_Bcast(&RIGHT, 1, MPI_INT, 0, MPI_COMM_WORLD);
 if(rank != 0){
    interval = (RIGHT - LEFT + 1)/(size - 1);
    start = (rank - 1)*interval + LEFT;
    end = start + interval-1;
    if (rank == (size-1)) {
      /* for last block */
      end = RIGHT;
    }

    sum=0; /*Sum locally on each proc*/
    for (number=start; number<=end; number++)
      sum = sum+number;
      /*send local sum to Master process*/
      printf("Rank: %d start %d, end %d, local sum %d\n", rank, start, end, sum);
    //MPI_Send(&sum,1,MPI_INT,0,123,MPI_COMM_WORLD);
    MPI_Reduce(&sum, &GrandTotal, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
 }
 MPI_Finalize();
}
