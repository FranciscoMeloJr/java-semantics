/*
Array initializer as part of array var declaration:

Two dim ints = {{1,2}, new int[]{3}, null}
*/

public class array_sep_39_init_decl_multidim_1 {

  public static void main(String[] args) {
    new main();
    System.out.println("Done!");
  }
}

class main {
  main() {
    int[][] m = {{1,2}, new int[]{3,4}, null};
    printMatrix(m);
  }

  void printArray(int[] v1) {
    if (v1 == null) {
      System.out.println(v1);
    } else {
      for(int i=0; i<2; i++) {
        System.out.print(v1[i] + " ");
      }
      System.out.println();
    }
  }

  void printMatrix(int[][] m) {
    for(int i=0; i<3; i++) {
      printArray(m[i]);
    }
    System.out.println();
  }
}
