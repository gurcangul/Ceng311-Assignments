import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.PriorityQueue;
import java.util.Scanner;
//260201069 GÜRCAN GÜL
/*
CENG 311
Fall 2021
PROGRAMMING ASSIGNMENT 1
 */
public class Main {

    public static ArrayList<Integer> readFile(){
        ArrayList<Integer> allValues = new ArrayList<>();
        String[] data=null;
        try {
            File myObj = new File("file.txt");
            Scanner myReader = new Scanner(myObj);
            while (myReader.hasNextLine()) {
                data = myReader.nextLine().split(" ");
            }

            myReader.close();
        } catch (FileNotFoundException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        for(int i=0;i<data.length;i++) {
            allValues.add(Integer.parseInt(data[i]));
        }
        return allValues;
    }

    public static void createPriorityQueue(){
        PriorityQueue<Integer> pQueue = new PriorityQueue<>();
        ArrayList<Integer> allValues = readFile();
        pQueue.addAll(allValues);
        try{
            FileWriter fw=new FileWriter("outJava.txt");
            fw.write(String.valueOf(pQueue));
            fw.close();
        }catch(Exception e){System.out.println(e);}
        System.out.println("Success...");
    }
    public static void main(String[] args) {
        long startTime = System.nanoTime();
        createPriorityQueue();
        long stopTime = System.nanoTime();
        System.out.println(stopTime - startTime + " nanoseconds");
    }
}