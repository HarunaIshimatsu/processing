import processing.video.*;

Capture video;

int w = 640;
int h = 480;
int tolerance=20;
color targetColor=color(255,0,0);

float x;
float y;
int sumX,sumY;
int pixelNum;
float filterX,filterY;
boolean videoImage=true;
boolean detection=false;

void setup(){
  size(640,480);
  video = new Capture(this, width, height);
  video.start();
  noStroke();
  smooth();
}

void draw(){
 if(video.available()){
   video.read();
   
   scale(-1.0,1.0);
   if(videoImage){
     image(video, -w, 0);
   }else{
     background(0);
   }
   
   detection = false;
   
   for(int i=0; i<w*h; i++){
      float difRed=abs(red(targetColor)-red(video.pixels[i]));
      float difGreen=abs(green(targetColor)-green(video.pixels[i]));
      float difBlue=abs(blue(targetColor)-blue(video.pixels[i]));

      if(difRed<tolerance && difGreen<tolerance && difBlue<tolerance){
        detection=true;
      
        sumX+=(i%w);
        sumY+=(i/w);
        pixelNum++;
      }
   }
   if(detection){
     x=sumX/pixelNum;
     y=sumY/pixelNum;
     
     sumX=0;
     sumY=0;
     pixelNum=0;
     tolerance--;
     if(tolerance<2){
       tolerance=2; 
     }
     
   }else{
     tolerance++;
     if(tolerance>25){
       tolerance=25;
     }
   }
 }
 scale(-1.0,1.0);
 filterX+=(x-filterX)*0.3;
 filterY+=(y-filterY)*0.3;
 
 fill(255,0,0);
 ellipse(w-filterX,filterY,20,20);
 
 fill(targetColor);
  rect(0,0,10,10);
  //text(tolerance,20,10);
  //String s;
  //if(detection){
  //  s="detected";
  //}else{
  //  s="none";
  //}
  //text(s,40,10);
 
}

void mousePressed(){
  targetColor=video.pixels[w-mouseX+mouseY*w];
}

void keyPressed(){
  if(key=='c'){
    //video.settings();
  }
    
  if(key=='v'){//「v」キーを押して表示／非表示を切り替える
    if(videoImage){
      videoImage=false;
    }else{
      videoImage=true;
    }
  }

  /*許容値調整は自動なので以下は使わない
  if(key==CODED){
    if(keyCode==LEFT){
      tolerance-=1;
    }
    if(keyCode==RIGHT){
      tolerance+=1;
    }
  }
  */
}