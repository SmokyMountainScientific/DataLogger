/*  DataLogGraph_1_0
 *   GUI for graphing serial data. 
 *   Based on BHickman potentiostat GUI
 *   modified by Jack Summers 
 *  For use with AnalogReadSerialOut-test Energia sketch 
 *    Com port selection tool works
 *    Data logged to file OK. Nov 15, 2012
 *    Having trouble graphing in real time.
 *    unless run = false 
 */
 
///////////////////////////////////////// Imports/////////////////////////////////
import org.gicentre.utils.gui.TextPopup; // for warning window
import org.gicentre.utils.stat.*;    // For chart classes.
import org.gicentre.utils.multisketch.*; // for integration window
import controlP5.*;
import processing.serial.*;
import java.io.*;                        // this is needed for BufferedWriter
/////////////////////////////////////////Classes//////////////////////////////////
XYChart lineChart;  

ControlP5 cp5,cp5b,cp5c;
Serial serial;
//Textarea myTextarea;   // com port and status window
Textarea myTextarea2;   // save file path window

DropdownList ports;              //Define the variable ports and mode as a Dropdownlist.
//DropdownList ports, mode;              //Define the variable ports and mode as a Dropdownlist.
//////////////////////////////////variables//////////////////////

char[] strtochar;
//char cData;
String sData3 ="";
//String[] sData = new String[3];  //String sData;
float[] V = {0};
float[] I1 = {0};


int Ss;                          //The dropdown list will return a float value, which we will connvert into an int. we will use this int for that).
String[] comList ;               //A string to hold the ports in.
String[] comList2;               // string to compare comlist to and update
boolean serialSet;               //A value to test if we have setup the Serial port.
boolean Comselected = false;     //A value to test if you have chosen a port in the list.
boolean gotparams = false;

boolean run = false;           // start run at bang
float p1;
float p2;

String ComP;
int serialPortNumber;
String file1 = "logdata.txt";
String file2;
String file;
String[] sData = new String[3];  //String sData;
String sData2 = " ";
char cData;


String Go = "1";
String star = "*";
int i =0;
int p = 0;           //stop signal
int updatechart;
/*float[] V = {0};
float[] I1 = {0};
float[] I2 = {0};
float[] Idif = {0};
float[] newV = {0};
float[] newI1 = {0};
float[] newI2 = {0};
float[] newIdif = {0};
*/
//////////////font variables///////////////////////////////
  PFont font = createFont("arial", 20);
  PFont font2 = createFont("arial", 16);
  PFont font3 = createFont("arial",12); 
  PFont font4 = createFont("andalus",16);
/////////////// setup ////////////////////////////////////////
void setup() {

  setup_bangs();
  charts_gic_setup();
  myTextarea2 = cp5.addTextarea("txt2")  // status and com port text area
    .setPosition(30, 50)
      .setSize(100, 20)   //was 30
        .setFont(createFont("arial", 12)) //(font)
          .setLineHeight(10)
            .setColor(#030302)
              .setColorBackground(#CEC6C6)
                .setColorForeground(#AA8A16)//#CEC6C6                 
                    ;
    frameRate(2000);
  size(730, 550); 
//  textFont(font2);
//  frame.setResizable(true);

//////////////////////////////////////////Dropdownlist////////////////////////////////////////
  ports = cp5.addDropdownList("list-1", 10, 30, 100, 84)
    .setBackgroundColor(color(200))
      .setItemHeight(10) 
        .setBarHeight(20) 
          .setColorBackground(color(60))
            .setColorActive(color(255, 128))
              .setUpdate(true)
                ;
  ports.captionLabel().set("Select COM port");
  ports.captionLabel().style().marginTop = 3;
  ports.captionLabel().style().marginLeft = 3;
  ports.valueLabel().style().marginTop = 3;
  comList = serial.list(); 
  for (int i=0; i< comList.length; i++)
  {
    ports.addItem(comList[i], i);
  } 
 }
///////////////////End Setup/////////////////////////////


void draw() {

background(0);
 
textFont(font4,18); 

pushMatrix();
 fill(#DEC507);
text("Smoky Mountain",30,height-65);
 text("Scientific",58,height-50);
 popMatrix(); 
 pushMatrix();
 textFont(font,12);

 fill(#DEC507);
 text("https://github.com/WheeSci",20,height-23);
 popMatrix(); 
 textFont(font2);
 
fill(#EADFC9);               // background color
//  noStroke();    
 rect(200, 70, 475, 450);    // chart background
 fill(250,250,250);             //Chart heading color
    textSize(16);
    text("Titration Data", 220, 60);
//    lineChart.draw(220, 70, 430, 430);    //early lineChart
    
/*    }
        catch(Exception e){
      if(V.length >2){
        V = subset(V,1);
        I1= subset(I1,1);
        I2= subset(I2,1);
        Idif = subset(Idif,1);
        println("exception");  
*/
if (run == true) {        
    println("begin run");   // shows up in bottom window
    
      println(163);         // Go = 1
      // moved up
      delay(100);

//serial.write(Go);   
serial.write('2');     // value of 2 added to prevent non-specific trigger

  println(169);//////////////////// read serial data ////////////////
       i=0;  //  p=0;                        // global variable, iterate serial read and initiate chart draw.
         updatechart = i;           // update graph every 2 data
        logData(file1, "", false);     // log data to file 1, do not append, start new file

          while (cData!='&'&& cData !='@') {         ////////read parameter input until LaunchPad transmits '&'/////////
      
            if (serial.available () <= 0) {  }

            if (serial.available() > 0) { 
              cData =  serial.readChar();     // cData is character read from serial comm. port
              sData2 = str(cData);                //sData2  is string of cData 
              logData(file1, sData2, true);     // at this point we are logging the parameters

           if (cData == '&') {             //  Launchpad sends & char at end of serial write
                 println("parameters received");
                 gotparams = true;  
      //        delay(500);   
                   }}
 }  // end of while loop with params
                   
 while (cData !='@') {         ////////read parameter input until LaunchPad transmits '@'/////////
   
            if (serial.available () <= 0) {  }

            if (serial.available() > 0) { 
              cData =  serial.readChar();     // cData is character read from serial comm. port
              sData2 = str(cData);                //sData2  is string of cData 
              logData(file1, sData2, true);     // at this point we are logging data
              strtochar = sData2.toCharArray();
   //           read_serial();                   // inserted Nov 16-JSS, gave null pointer exception
            if (cData == '@') {
              run = false;    // stops program
              println("stop-189");
              gotparams = false;
              myTextarea2.setColor(#036C09);
              myTextarea2.setText("FINISHED");
           }
         // }   }    /// end of while (cData not @) loop
  //          }

       println(206);     
   //////////// graph data //////////////////////////////////////////////
 if (run == true) {  // redundant?-no.  graph does not update after @
 read_serial(); 
 } 
       println(210);    
     if (V.length>12 && V.length==I1.length) { 
         print("maxI = ");
         println(max(I1));    
      
            //    if(i>=updatechart+2){
                lineChart.setMaxX(max(V));
                lineChart.setMaxY(max(I1)); 
                lineChart.setMinX(min(V));
                lineChart.setMinY(min(I1));  
                lineChart.setData(V, I1);  
                try{  
//                lineChart.draw(230, 120, 450, 450);
                 lineChart.draw(220, 70, 430, 430);
                }
                catch(Exception e){
                  if(V.length >2){
                    V = subset(V,1);
                    I1= subset(I1,1);
                    println("exception");  
                  } 
                }
                updatechart = i;
                }   // End of if (V.length stuff
              }     // end of if serial.available 
             }       /// end of while (cData not @) loop
          }          // end of if run = true
  lineChart.draw(220, 70, 430, 430);   //moving this in one bracket does not work.
  }  


