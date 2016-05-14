/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/17259*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//fireworks - born of insomnia
import ddf.minim.*;

PImage bg, bg_tambah, bg_2;
Firework[] fs = new Firework[10];
boolean once, bg_kode=true;
AudioSnippet flush, meledak;
Minim file;

void setup(){
  size(400,400);
  bg = loadImage("bg1.png");
  bg_2 = loadImage("bg_kota.png");
  bg_tambah = loadImage("awan.png");
  file = new Minim(this);
  flush = file.loadSnippet("LOOKOUT.WAV");
  meledak = file.loadSnippet("LEDAKAN.WAV");
  smooth();
  for (int i = 0; i < fs.length; i++){
    fs[i] = new Firework();
  }
}

void draw(){
  noStroke();
  fill(50,0,40,20);
  image(bg_tambah, 0, 0);
  rect(0,0,width,height);
  for (int i = 0; i < fs.length; i++){
    fs[i].draw();
  }
  change_bg(bg_kode);
}
void change_bg(boolean kode){
    if(kode == true){
      image(bg,0,0);
    }
    else image(bg_2,0,0);
}
void mousePressed(){
   if (mouseButton == LEFT){
      once = false;
      for (int i = 0; i < fs.length; i++){
        flush.rewind();
        flush.play();
        if((fs[i].hidden)&&(!once)){
          fs[i].launch();
          once = true;
        }
      }
   }
   else{
       bg_kode = !bg_kode;
   }
}

class Firework{
  float x, y, oldX,oldY, ySpeed, targetX, targetY, explodeTimer, flareWeight, flareAngle;
  int flareAmount, duration;
  boolean launched,exploded,hidden;
  color flare;
  int o;
  Firework(){
    launched = false;
    exploded = false;
    hidden = true;
  }
  
  void draw(){
    if((launched)&&(!exploded)&&(!hidden)){
      launchMaths();
      strokeWeight(1);
      stroke(255);
      line(x,y,oldX,oldY);
    }
    if((!launched)&&(exploded)&&(!hidden)){
      explodeMaths();
      noStroke();
      strokeWeight(flareWeight);
      stroke(flare);
      if(o==1){
        for(int i = 0; i < flareAmount + 1; i++){
            pushMatrix();
            translate(x,y);
            point(sin(radians(i*flareAngle))*explodeTimer,cos(radians(i*flareAngle))*explodeTimer);
            popMatrix();
         }
     }else if(o==2){
       for(int i = 0; i < flareAmount + 1; i++){
            pushMatrix();
            translate(x,y);
            point((i*2)*sin(i/5.0)*explodeTimer,(i*2)*cos(i/5.0)*explodeTimer);
            popMatrix();
         }
     }else if(o==3){
       for(int i = 0; i < flareAmount + 1; i++){
            pushMatrix();
            translate(x,y);
            point((i*2)*cos(i/5.0)*explodeTimer,(i*2)*cos(i/5.0)*explodeTimer);
            popMatrix();
         }
     }else if(o==4){
        for(int i = 0; i < flareAmount + 1; i++){
            pushMatrix();
            translate(x,y);
            point((i*2)*sin(i/5.0)*explodeTimer,(i*2)*cos(flareAmount/5.0)*explodeTimer);
            popMatrix();
         }
     }else if(o==5){
        for(int i = 0; i < flareAmount + 1; i++){
            pushMatrix();
            translate(x,y);
             point(sin(radians(flareAmount*4))*explodeTimer,sin(radians(4*flareAngle))*explodeTimer);
             point(sin(radians(i*4))*explodeTimer,cos(radians(i*flareAngle))*explodeTimer);
            popMatrix();
         }
     }
    }
    if((!launched)&&(!exploded)&&(hidden)){
      //do nothing
    }
  }
  void launch(){
    x = oldX = mouseX + ((random(5)*10) - 25);
    y = oldY = height;
    targetX = mouseX;
    targetY = mouseY;
    ySpeed = random(3) + 2;
    flare = color(random(3)*50 + 105,random(3)*50 + 105,random(3)*50 + 105);
    flareAmount = ceil(random(30)) + 20;
    flareWeight = ceil(random(3));
    duration = ceil(random(4))*20 + 30;
    flareAngle = 360/flareAmount;
    launched = true;
    exploded = false;
    hidden = false;
    o=int(random(5));
    //o=5;
  }
  
  void launchMaths(){
    oldX = x;
    oldY = y;
    if(dist(x,y,targetX,targetY) > 6){
      x += (targetX - x)/2;
      y += -ySpeed;
    }else{
      explode();
    }
  }
  
  void explode(){
    meledak.rewind();
    meledak.play();
    explodeTimer = 0;
    launched = false;
    exploded = true;
    hidden = false;
  }
  
  void explodeMaths(){
    if(explodeTimer < duration){
      explodeTimer+= 0.4;
    }else{
      hide();
    }
  }
  
  void hide(){
    launched = false;
    exploded = false;
    hidden = true;
  }
}
                                                                