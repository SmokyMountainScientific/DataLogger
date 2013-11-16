// read_serial tab.  for info, see gicentre.org/utils/chart/

void  read_serial() {
 
   for(int l=0;l<strtochar.length;l++){
      cData = strtochar[l];
      if (cData!='\n') { 
       sData3 = sData3+str(cData);
      }
      if (cData =='\n') {
        sData = split(sData3,"\t");     
        sData = trim(sData);
        if (sData.length ==2) { 
          float[] fData= float(sData);
          boolean fcatch = false;
         
          if (i==0 && fcatch == false) {
            V[i] = fData[0];
            I1[i]=fData[1]; 
          }
          if (i>0 && fcatch == false) {
            V = append(V, fData[0]);
            I1 = append(I1, fData[1]); 
          }


          i +=1;

        }   
        sData3 = " ";
      }
  }
   
 } 
