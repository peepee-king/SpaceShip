import ddf.minim.*;
boolean unstart=true,stop=false,add=false,cut=false,soundsOn=false;
PFont f;
PImage bg,ship,enemy,nullBlood,fullBlood,coin;
int x=175,y=650,bg_y=-800,heart=5,black_heart=0,score=0,n=2;
float[] enemy_x=new float[10],enemy_y=new float[10],coin_x=new float[3],coin_y=new float[3];
Minim minim;
AudioPlayer song1,song2;

void setup(){
  size(500,800);
  bg=loadImage("/asset/background.jpg");
  f=createFont("辰宇落雁體 Thin",40);
  
  ship=loadImage("/asset/ship.png");
  enemy=loadImage("/asset/enemy.png");
  nullBlood=loadImage("/asset/black_blood.png");
  fullBlood=loadImage("/asset/blood.png");
  coin=loadImage("/asset/coin.png");
  minim=new Minim(this);
  song1=minim.loadFile("/asset/flying.mp3");
  
  song1.play();
  song2=minim.loadFile("/asset/universal_shopping_spree.mp3");
  
  for (int i = 0; i < n; i++) {
    enemy_x[i] = random(0, width);
    enemy_y[i] = random(-height, 0);
  }
}

void draw(){
  if(unstart& !stop){
    x=175;
    y=650;
    bg_y=-800;
    heart=5;
    black_heart=0;
    score=0;
    image(bg,0,bg_y);
    textFont(f,40);
    textAlign(CENTER);
    text("Click Mouse to Start!",250,400);
    song1.play();
  }else if(!unstart & !stop){
    if(bg_y==0){
      bg_y=-800;
    }else{
      bg_y+=2;
    }
    //碰撞敵人偵測
    for(int i=0;i<n;i++){
      if(dist(x+75, y, enemy_x[i]+35, enemy_y[i]+40)<=55){
        heart-=1;
        black_heart+=1;
        enemy_x[i]=0;
        enemy_y[i]=0;
        textFont(f,60);
        textAlign(CENTER);
        text("-100",20,100);
        score-=100;
        cut=true;
      }
    }
    for(int i=0;i<3;i++){
      if(dist(x+75,y,coin_x[i]+30,coin_y[i]+30)<=35){
        coin_x[i]=0;
        coin_y[i]=0;
        score+=150;
        add=true;
      }
    }
    score+=1;
    now();
    
  }
}
void mouseClicked(){
  if (unstart &!stop){//遊戲開始
    song1.pause();
    song2.rewind();
    song2.play();
    soundsOn=true;
    now();
    unstart=!unstart;
    textFont(f,40);
    textAlign(CENTER);
    text("START",250,400);
  }else if (!unstart &stop){//結束遊戲
    now();
    textFont(f,50);
    textAlign(CENTER);
    text("The End",250,400);
    text("Score:"+str(score),250,450);
    unstart=!unstart;
    
    song2.pause();
    
  }else if(unstart &stop){//結束
    //text("",250,400);
    stop=!stop;
  }
}
void keyPressed(){
  if(key=='w' & !stop){
    y-=10;
    now();
  }else if(key=='s'& !stop & !unstart){
    y+=10;
    now();
  }else if(key=='a'& !stop & !unstart){
    x-=10;
    now();
  }else if(key=='d'& !stop & !unstart){
    x+=10;
    now();
  }else if(key==' '& !unstart){
    if(!stop){//暫停
      textFont(f,40);
      textAlign(CENTER);
      text("STOP",250,400);
      song2.pause();
    }else{//繼續
      now();
      if(!soundsOn){
        song2.play();
      }
    }
    stop=!stop;
    soundsOn=!soundsOn;
  }
}
void now(){
  image(bg,0,bg_y);
  
  if(x<=-150){
    x=500;
  }else if (x>=500){
    x=-150;
  }
  
  if(y<=5){
    y=5;
  }else if(y>=700){
    y=700;
  }
  image(ship,x,y,150,105);
  draw_blood();
  textFont(f,50);
  textAlign(RIGHT);
  text("Score "+str(score),480,50);
  set_enemy_xy();
  coin();
  if(add){
    textFont(f,60);
    textAlign(CENTER);
    text("+150",250,100);
    add=!add;
  }
  if(cut){
    textFont(f,60);
    textAlign(CENTER);
    text("-100",250,100);
    cut=!cut;
  }
}

void draw_blood(){
  int heart_x=10;
  if (heart<=0){//沒血死亡
    stop=!stop;
    textFont(f,50);
    textAlign(CENTER);
    text("DIE",250,350);
    text("Score："+score,250,400);
    song2.pause();
  }
  for(int i=0;i<heart;i++){
    image(fullBlood,heart_x,20,40,35);
    heart_x+=43;
  }
  for (int i=0;i<black_heart;i++){
    image(nullBlood,heart_x,20,40,35);
    heart_x+=43;
  }
}

void set_enemy_xy(){
  int l=1,r;
  if (score<=700){
    r=4;
  }else if(score<=1400){
    l+=2;
    r=6;
  }else if(score<=2100){
    l+=2;
    r=8;
  }else{
    r=10;
  }
  
  int m=floor(random(l,r+1));
  if(m>n){
    n=m;
  }
  for (int i = 0; i < n; i++) {
    // 如果敵人超出畫布底部，重新設定位置
    if (enemy_y[i] >= height) {
      enemy_y[i] = random(-height, 0);
      enemy_x[i] = random(0, width);
    }else{
      enemy_y[i] += random(3,9);
    }
    if(enemy_x[i]<=-30){
      enemy_x[i]=550;
    }else if(enemy_x[i]>=550){
      enemy_x[i]=-30;
    }else{
      enemy_x[i]+=random(-8,8)*random(-2,3);
    }
    image(enemy,enemy_x[i],enemy_y[i],70,70);
  }
}

void coin(){
  for (int i=0;i<3;i++){
    if((coin_x[i] <= 0 && coin_y[i] <= 0)|coin_y[i]>=height){
      coin_x[i]=random(0,height);
      coin_y[i]=random(0,width);
    }else{
      coin_y[i]+=random(0,5);
    }
    image(coin,coin_x[i],coin_y[i],65,65);
  }
}
