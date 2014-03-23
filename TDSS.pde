/* Project ::: Top-Down Space Shooter
   ----------------------------------
    
    Nikola Milenic - milenicnikola
    Danilo Djokic - danilodjokic997        
            PFE, IS Petnica
*/


/*
  TestScript
  
  Broj zivota vrati na 3 !
  Mandica vrati na t>=7300
  Ammo vrati na 0
*/

fighter[] swarm;
missile[] bullet;
dmissile[] dbullet;
shockwave[] wave;
testudon[] bswarm;
final static int NORTH = 1;
final static int EAST = 2;
final static int SOUTH = 4;
final static int WEST = 8;
int frag; // da li koristi fragmentacione rakete
int shield;//da li koristi stit
float shieldhp,nukerdy;
int nuke;// da li koristi nuke (s. nuka)
int result;
float x,y,avx,avy;
int t; 
int i;
int k;
int ammo;
int dir,lives,atod,mL;
int f;
boolean dead;
PImage friggfx;
PImage crr; //Cursor
//PImage bck;
int l;
float xt,yt,mx,my;
boolean firing; //Da li je vec pucano ?
int TotalEnemies,TT; // Broj trenutno zivih swarm-ova;
int pause,upgrade;
mandic BOSS;
boolean BOSS_;


void setup() 
{ 
  size(500,500);
  frameRate(30);  
  result = 0;
  x = width/2;
  y = height/2;
  mx=-1000;
  my=-1000;
  mL=125;
  t=7299;
  i=0;
  dir=1;
  dead=false;
  friggfx=loadImage("data/frigstup.png");
    cursor(CROSS);
  swarm  = new fighter[101];
  bswarm = new testudon[11];
  bullet = new missile[501];
  wave   = new shockwave[51];
  dbullet= new dmissile[501];
  for (int I = 1; I<=500; I++) {bullet[I] = new missile(); dbullet[I] = new dmissile();}
  for (int I = 1; I<=100;I++) swarm[I] = new fighter(false,I);
  for (int I = 1; I<=50;  I++) wave[I] = new shockwave(-100.0,-100.0,0.0,0.0,0.0,0,0,0,false);
  //bswarm[1]=new testudon(1,true);
  for (int I = 1; I<=10; I++) bswarm[I]=new testudon(I,false);
  stroke(0,255,0);
  lives=1000;
  //tbf=0;
  firing=false;
  TotalEnemies=0;
  textSize(9);
  //Restart parametri  
  frag=0;
  shield=0;
  shieldhp=5;
  pause=-1;
  upgrade=0;
  ammo=10000;
  atod=0;
  nuke=0;
  BOSS_ = false;
}
 
void draw() 
{

  
  if (pause==1)
  {
      fill(255,0,0);
      textSize(72);
      text("PAUSE", width/2-100, height/2-100);
      textSize(9);  
      return;
  }
  
  if (upgrade==1)
  {  
      fill(0,255,0);
      textSize(20);
      text("CHOOSE UPDATE:",100,100);
      text("1-FRAGMENTATION",100,130);
      text("2-SHIELD",100,160);
      text("3-NUKE (activation - <SPACE_BAR>)",100,190);
      return;
  }
  
   background(0);
  //image(bck,0,0, width,height);
  if (lives<=0)dead=true; //STA AKO TE UDARE 2 ODJEDNOM !? (TEST.BUG)
  
  //POMERANJE FREGATE
  if (dead==false)
  {
      switch(result) 
      {
        case NORTH: avy-=1; dir=1; friggfx=loadImage("data/frigmvup.png"); break;
        case EAST: avx+=1; dir =2; friggfx=loadImage("data/frigmvrt.png"); break;
        case SOUTH: avy+=1; dir=3; friggfx=loadImage("data/frigmvdn.png"); break;
        case WEST: avx-=1;  dir=4; friggfx=loadImage("data/frigmvlt.png"); break;
      }
      if (x>500) x=0;
      if (x<0) x=490;
      if (y>500) y=0;
      if (y<0) y=490;
 }
 else 
 {

    atod+=10;
    fill(255-2*atod);
     
    ellipse(x,y,atod,atod);
   
    if (atod > 2*dist(0,0,width,height))
    {
      fill(255,0,0);
      textSize(20);
      text("GAME OVER", width/2-150, height/2-100);
      //text("!", width/2-200, height/2-20); 
      textSize(18);      
      text("Click to reboot the universe.", width/2-80, height/2+100);
      if (mousePressed == true) setup();
    }
    
    if (atod>100000) atod=10000;
    
 }
 
 avx=avx*0.9;
 avy=avy*0.9;
 if (abs(avx)<0.5) avx=0;
 if (abs(avy)<0.5) avy=0;
 x+=avx;
 y+=avy;
 

  
  if (dead !=true)
  {
    //POMERANJE SHOCKWAVE-A!
    for (int I=1; I<=50; I++)
    wave[I].boom();
    stroke(0,255,0);
    fill(0,255,0);
    
    //POMERANJE SWARM-OVA!
     for (int k=1;k<=100;k++) swarm[k].move();  
     for (int k=1;k<=10;k++) bswarm[k].move();
     if (t==7300) //MANDIC !!! 
     {
     if (!BOSS_) {BOSS = new mandic(125); BOSS_ = true;for (int I=1;I<=10;I++) bswarm[I].alive=0; for (int I=1;I<=100;I++) swarm[I].alive=false;}     
     BOSS.drw(); 
     BOSS.move();
     }
    
    //POMERANJE METAKA!
    for (int I=1; I<=500; I++){ if ( bullet[I].motion == true)  bullet[I].move();
    if (dbullet[I].motion == true) dbullet[I].move();}
    stroke(0,255,0); 
    fill(255);
    image(friggfx,x,y);
    if (!BOSS_) t++;
    shieldhp+=shield/100.0;
    if (nuke>0) nukerdy+=0.0009;
    if (nukerdy>1) nukerdy=1;
    if (shieldhp>shield)shieldhp=shield;
    if (ammo<480) ammo++;

    t=t%9600;

    // GENERISANJE SWARM-OVA
    
    if (t%480==0 && !BOSS_)
    {
      int c=0;
      int KKK=TotalEnemies;
      for(int I=1; I<=int(random(t/1200)); I++)
      {
        c+=2;
        int Q=1;
        while (bswarm[Q].alive>0) Q++;
        bswarm[Q]= new testudon(Q,true);
        TT++;
      }
       
        
      
      for(int I=1; I<=t/480-c; I++) 
      {
        int Q=1;
        while(swarm[Q].alive==true) Q++;
        swarm[Q] = new fighter(true,Q);
        TotalEnemies++;
        //println(TotalEnemies);
      }
    }
  }
 //Upgrade-ovi (za sada samo fragmentacioni projektili, stit i nuke)
 if (t%2400==0) {upgrade=1; if (lives<3) lives++; println(t);}
 //Pucanje!
 
 if (mousePressed && ammo>=48 && dead==false && firing==false) 
 {
   firing=true;
    //tbf++;
    
    for (int I = 1; I<=500; I++) 
      if (bullet[I].motion==false) 
      {
        bullet[I] = new missile(x+5, y+5, mouseX, mouseY,frag);
        break; //ISPALI TACNO JEDAN METAK !!!    
      }
    ammo-=48;
        
         
 }

  
  //Barovi
  if (dead != true) 
  {
    
    //Pozadine za barove 
    fill(0,100,0,100);
    rect(10,10,240*2,10);
    fill(100,0,0,100);
    rect(10,30,480,10);
    fill(0,0,100,100);
    rect(10,90,50,10);
    rect(10,70,50,10);
    rect(10,50,50,10);
    if (shield>0){
    fill(0,100,100,100);
    rect(70,50,420,10);
    } 
    if (nuke>0) {
    fill(100,0,0,100);
    rect(10,470,480,20);}
    //barovi
    fill(0,255,0,100);
    rect(10,10,ammo,10);
    fill(255,0,0,100);
    rect(10,30,480-t%480,10);
    fill(0,0,255,100);
    if (lives>2) rect(10,90,50,10);
    if (lives>1) rect(10,70,50,10);
    if (lives>0) rect(10,50,50,10);
    if (shieldhp>=1) fill(0,255,255,100); else fill(100,100,100,100);
    if (shield>0)rect(70,50,420*shieldhp/shield,10);
    if (nuke>0){ fill(255,0,0,100); rect(10,470,480*nukerdy,20);}
    //Tekstualne oznake
    textSize(9);
    fill(0,0,255);
    text("LIVES: " + lives, 10, 120);
    fill(0,255,0);
    text("ROCKETS : " + ammo/48, 20, 20);    
    fill(255,0,0);
    text("TIME TO NEXT WAVE : " + ((480-t%480)/30), 20, 40);
    fill(0,255,255);
    if (shield>0)text("SHIELD: " + (int(shieldhp)), 80, 60);
    fill(0,0,255);
    text("Lvl. : " + t/480, width-50, height-30);
    fill(255,0,0);
    textSize(20);
    if (nukerdy==1)
    text("NUKE IS READY", 20,490);
}
  
  

}
 
void keyPressed(){
  switch(key)
  {
    case('w'):case('W'):result |=NORTH;break;
    case('d'):case('D'):result |=EAST; break;
    case('s'):case('S'):result |=SOUTH;break;
    case('a'):case('A'):result |=WEST; break;
    case('p'):case('P'):pause*=-1;
    case('1'):if (upgrade==1){frag++;  upgrade=0;}break;
    case('2'):if (upgrade==1){shield+=3;upgrade=0;}break;
    case('3'):if (upgrade==1){nuke++;  upgrade=0;}break;
    case(' '):if (nukerdy==1) {wave[1] = new shockwave(x+5*1.0,y+5*1.0, nuke*55.0,255-nuke*55.0,0.0,100,100-nuke*50,100+nuke*50,true);//stroke(nuke*55.0,255-nuke*55.0,0);line(x,y,mouseX,mouseY);
  nukerdy--;}
  }
}
 
void keyReleased(){  
  switch(key) 
  {
    case('w'):case('W'):result ^=NORTH; friggfx=loadImage("data/frigstup.png");break;
    case('d'):case('D'):result ^=EAST;  friggfx=loadImage("data/frigstrt.png");break;
    case('s'):case('S'):result ^=SOUTH; friggfx=loadImage("data/frigstdn.png");break;
    case('a'):case('A'):result ^=WEST;; friggfx=loadImage("data/frigstlt.png");break;
  }
}


void mouseReleased() {firing=false;} // Nakon ispaljenog metka, ovo je neophodno da bi se ispalio sledeci metak.

void hit(int id) 
{
  if (id>0)
   {
     if (shieldhp>=1) 
       {shieldhp--; swarm[id].vx*=-1; swarm[id].vy*=-1; swarm[id].xpos+=2*swarm[id].vx; swarm[id].ypos+=2*swarm[id].vy;
        stroke(0,255,255);
        fill(0,255,255,50);
        ellipse(x+5,y+5,30,30);
       }
     else
      {
       lives--; swarm[id].alive=false; TotalEnemies--;}}
   else
    {if (shieldhp>=1) {shieldhp--; stroke(0,255,255);fill(0,255,255,50);ellipse(x+5,y+5,30,30);} 
      else lives--;}}
class shockwave
{
  float xpos;
  float ypos,rd,gn,bu;
  int i,r,rmin,rmax;
  color c;
  boolean bl,alive;
  //konstruktor
   shockwave(float x,float y,float red,float grn,float blu,int rad,int rn,int rx,boolean b)
   {
     xpos=x;
     ypos=y;
     r=rad;
     rmin=rn;
     rmax=rx;
     rd=red;
     gn=grn;
     bu=blu;
     bl=b;
     alive=b;
   }
   void boom()
   { 
     if (alive){
     if (bl) r-=10;
     if (r<rmin) bl=false;
     if (!bl)r+=20;
     if (r>rmax) alive=false;
     stroke(c);
     fill(rd,gn,bu,300-r*1.0/rmax*255.0);
     ellipse(xpos,ypos,r+100,r+100);
     fill(0);
     ellipse(xpos,ypos,r*4/5.0+75,r*4/5.0+75);
     //pokolj
     for (int i=1;i<=100;i++){if (abs(int(sqrt(sq(swarm[i].xpos-xpos)+sq(swarm[i].ypos-ypos))))<=abs(r+1)) {swarm[i].alive=false; TotalEnemies--;}}
     if (xpos==wave[1].xpos)
     for (int i=1;i<=10;i++) if (dist(xpos,ypos,bswarm[i].xpos,bswarm[i].ypos)<=abs(r+1)) bswarm[i].alive=0;
     for(int i=1;i<=500;i++)if(dist(xpos,ypos,dbullet[i].xpos,dbullet[i].ypos)<=abs(r+1)) dbullet[i].motion=false;
     if (BOSS_)
     if (dist(mx,my,xpos,ypos)<=abs(r+1)) mL--;
     }
   }
}





class fighter
{  
  float xpos;
  float ypos;
  int id;
  float ax,vx;
  float ay,vy;
  boolean alive;
  PImage gfx;
  int dirct,tod,ai;
  //Konstuktor Metod
    fighter(boolean Alive,int j)
    {
      alive=Alive;
      
      if (Alive==true)                
      {      
        ai=int(random(2))+1;
        dirct=int(random(4))+1;  
        
        switch(dirct)
        {
         case 1: xpos=random(490);ypos=0;   break;
         case 2: xpos=random(490);ypos=490; break;
         case 3: xpos=0; ypos=random(490);  break;
         case 4: xpos=490;ypos=random(490); break;
        }
        alive=true;
        tod=0;
        id=j;
    }  
      else
      {
        xpos=-100;
        ypos=-100;        
      }
    }

  void move(){
    ax=0;
    ay=0;
    vx=vx*0.8;
    vy=vy*0.8;
  if (alive==true)
  {
   switch(ai){   
    case 1:if (abs(x-xpos)>abs(vx)) ax = 0.9*round( (x-xpos+0.01)/abs(x-xpos+0.01))*max(min(1,abs(x-xpos)),0.1);
      else
        ai=2; 
        break;
    case 2:if (abs(y-ypos)>abs(vy)) ay = 0.9*round((y-ypos+0.01)/abs(y-ypos+0.01))*max(min(1,abs(y-ypos)),0.1);
       else
        ai=1;
        break;    
     }
      for (int f=1;f<id;f++)
      {
        if(abs(swarm[f].xpos-xpos)<10 && abs(swarm[f].ypos-ypos)<10 && swarm[f].alive) 
        {
           vx=swarm[f].vy;
           ax=swarm[f].ay;
           vy=swarm[f].vx;
           ay=swarm[f].ax;  
      }
      }
      for (int f=1;f<=10;f++) if(dist(xpos+5,ypos+5,bswarm[f].xpos+8,bswarm[f].ypos+8)<=20 && bswarm[f].alive>0) {alive=false; TotalEnemies--;}
      vx+=ax;
      xpos+=vx;
      vy+=ay;
      ypos+=vy;
      
      if (ax>0) {gfx=loadImage("data/fgtrmvrt.png");}
      if (ax<0) {gfx=loadImage("data/fgtrmvlt.png");}
      if (ay>0) {gfx=loadImage("data/fgtrmvdn.png");}
      if (ay<0) {gfx=loadImage("data/fgtrmvup.png");}
      image(gfx,xpos,ypos);
      if (vx==0 && vy==0) alive=false; 
      
      if (abs(x-xpos)<10&&abs(y-ypos)<10) 
      {
        //alive=false; 
        hit(id);
        //TotalEnemies--;
        //println(TotalEnemies);
      }
  }
  else if (tod<250){tod+=20;stroke(0,255-tod,0);noFill();ellipse(xpos,ypos,tod*0.5,tod*0.5);}
  }
}


//KLASA MISSILE

class missile
{
  float xpos, ypos;
  int id;
  float vx;
  float vy;
  int shrapnel;
  boolean motion=false; //Da li je instanca ispaljena ::: FALSE-NIJE; TRUE-JESTE;
  int TimeOfFiring;
  
  missile(){motion=false;}
  
  missile (float x1, float y1, float x2, float y2,int z)
  {
    motion=true;
    shrapnel=z;
    TimeOfFiring=0;
    
    xpos = x1;
    ypos = y1 ;
    
    float Ratio = 5.00 / dist(x1,y1,x2,y2); // Cika Tales; Brzina metka zavisi od konstante (i bice upravo ta konstanta)!    
    
    float DeltaY = y2 - y1;
    float DeltaX = x2 - x1;
   
    vy = Ratio * DeltaY;
    vx = Ratio * DeltaX;  
  }
  
  void move()
  {
    if (motion!=false) 
    {
      TimeOfFiring+=50;
      TimeOfFiring%=255;
      
      xpos += vx;
      ypos += vy;
      
      fill(TimeOfFiring,0,0); // Crvena popuna
      stroke(0,255,0);
      ellipse(xpos,ypos,5,5);

      if (xpos > width || xpos < 0 || ypos > height || ypos < 0 ) 
      {motion=false; }
      else //Inace, proveri da li je neki swarm pogodjen;
      {
                for (int I=1;I<=100;I++)
                {
                  //println(dist(swarm[I].xpos, swarm[I].ypos, xpos, ypos));
                  if (dist(swarm[I].xpos+5, swarm[I].ypos+5, xpos, ypos) < 10.00 && swarm[I].alive==true) 
                  {
                    //println("POGINUO!");
                    swarm[I].alive=false;
                    TotalEnemies--;
                    //println(TotalEnemies);
                    if (shrapnel>0)
                    for (int sh=1;sh<=4*shrapnel-4*shrapnel/3;sh++)
                     for (int p = 1; p<=500; p++) 
                        if (bullet[p].motion==false) 
                         {
                            bullet[p] = new missile(xpos,ypos,xpos-10+random(20),ypos-10+random(20),shrapnel/3);
                            break;   
                         }
                    motion=false;
                    break;
                  }
                }   
                for (int I=1;I<=10;I++){
                  if (dist(bswarm[I].xpos+8,bswarm[I].ypos+8, xpos, ypos)<=20 && bswarm[I].alive>0)
                  {
                    bswarm[I].hit();
                    motion=false;
                   //Testudon je suvise masivan da bi ga eksplozija rakete pocepala i napravila srapele...(zvuci bolje nego "mrzi me da kucam")
                   } 
     
   
      
    
  


}
     
    }   
  }
}
}
//KLASA DMISSILE

class dmissile
{
  float xpos, ypos;
  int id;
  float vx;
  float vy;
  boolean motion=false; //Da li je instanca ispaljena ::: FALSE-NIJE; TRUE-JESTE;
  int TimeOfFiring;
  
  dmissile(){motion=false;}
  
  dmissile (float x1, float y1, float x2, float y2)
  {
    motion=true;
    TimeOfFiring=0;
    
    xpos = x1;
    ypos = y1 ;
    
    float Ratio = 6.00 / dist(x1,y1,x2,y2); // Cika Tales; Brzina metka zavisi od konstante (i bice upravo ta konstanta)!    
    
    float DeltaY = y2 - y1;
    float DeltaX = x2 - x1;
   
    vy = Ratio * DeltaY;
    vx = Ratio * DeltaX;  
  }
  
  void move()
  {
    if (motion!=false) 
    {
      TimeOfFiring+=50;
      TimeOfFiring%=255;
      
      xpos += vx;
      ypos += vy;
      
      fill(TimeOfFiring,0,0); // Crvena popuna
      stroke(255,255,0);
      ellipse(xpos,ypos,5,5);

      if (xpos > width || xpos < 0 || ypos > height || ypos < 0 ) 
      {motion=false; }
      else //Inace, proveri da li je neki swarm pogodjen;
      {
                                
                  //println(dist(swarm[I].xpos, swarm[I].ypos, xpos, ypos));
                  if (dist(x+5, y+5, xpos, ypos) <= 8.00) 
                  {
                    hit(0);
                    motion=false;
                   }
                   
             
      }
    }   
  }
}
//KLASA TESTUDON
class testudon
{
float xpos,tx,vx;
float ypos,ty,vy;
boolean shield,dead;
int ID,alive;
PImage tdn;
 testudon (int k,boolean a)
 {
   if (a){int i=int(random(4))+1;
   switch(i) {
     case 1: xpos=random(484); ypos=1; break;
     case 2: xpos=random(484); ypos=484; break;
     case 3: xpos=1; ypos=random(484); break;
     case 4: xpos=484; ypos=random(484); break;}} else {xpos=-100; ypos=-100;}
     shield=true;
     if (a) alive=5; else alive=0;
     dead=true;
     ID=k+1;
   }
   void hit()
   {
     if (shield){stroke(255,0,0); fill(255,0,0); ellipse(xpos+8,ypos+8,30,30);}else {alive-=frag+1;{ fill(255,255,0,100);stroke(255,255,0);ellipse(xpos+8,ypos+8,30,30);}}
   }  
   
   void move()
   {
     if (alive>0){tx=x; ty=y;
     if (t%25==0){
      if (dist(tx,ty,xpos,ypos)<150) shield=false; else shield=true;
      for (int j = 1; j<=3;   j++)
      for (int I = 1; I<=500; I++) 
      if (dbullet[I].motion==false) 
      {
        if (!shield) dbullet[I] = new dmissile(xpos+8, ypos+8, x+5+random(50)-25, y+5+random(50)-25);
        break; //ISPALI TACNO JEDAN METAK !!!    
      }}
     vx=(tx-xpos)/dist(tx,ty,xpos,ypos);
     vy=(ty-ypos)/dist(tx,ty,xpos,ypos);
     if (abs(vx)>abs(vy)) {vx=2.5*abs(vx)/(vx+0.01); vy=0*abs(vy)/(vy+0.01);}else
     {vy=2.5*abs(vy)/(vy+0.01); vx=0*abs(vx)/(vx+0.01);}
     xpos+=vx;
     ypos+=vy;
     if (abs(vx)>abs(vy)){if (vx>0) tdn = loadImage("data/tdnmvrt.png"); else tdn = loadImage("data/tdnmvlt.png");}else
     {if (vy>0) tdn = loadImage("data/tdnmvdn.png"); else tdn = loadImage("data/tdnmvup.png");}
     image(tdn,xpos,ypos);
     noFill();
     stroke(0,255,0);
     rect(xpos,ypos+20,16,4);
     fill(255,0,0);
     rect(xpos,ypos+20,16.0*alive/5,4);
     if (shield){ fill(255,255,0,100);stroke(255,255,0);ellipse(xpos+8,ypos+8,30,30);}
     for (int I=1;I<ID-1;I++) if(dist(bswarm[I].xpos,bswarm[I].ypos,xpos,ypos)<=25 && bswarm[I].alive>0){xpos-=vx; ypos-=vy;}
     } else {if (dead) wave[ID]= new shockwave(xpos,ypos,255.0,255.0,255.0,-75,-75,100,true); dead=false; TT--;}
   }
 }
     
 
   
class mandic // d4n1l0(ma kako da ne...-Nikola Milenic) 
{
  float xpf,ypf;
  float time;
  float dt;
  int L,pcnj,xp,yp,TotalLives;
  boolean hit1, hit2;
  
  mandic(int lives)
  {
    if (lives>0){
    xpf=width/2;
    ypf=0.25 * height;  
    time=0;
    dt=0.005;
    TotalLives = L = lives;
    hit1=hit2=false;
    pcnj=0;  }else {xpf=-500;ypf=-500;}
  }
  
  void drw()
  {
    L=mL;
    loadPixels();
    
    xp = int(xpf);
    yp = int(ypf); 
    mx=xpf;
    my=xpf;
    pcnj++;
    pcnj%=500;
    PImage m;
    if (pcnj%500<=200) m=loadImage("data/mandicbljujevatru.png"); else
    if (pcnj%500>=300) m=loadImage("data/mandicpucalaser.png"); else 
    m = loadImage("data/mandic.png");
    
    hit2=false;
    
    for (int x = 0; x < m.width; x++)
      for (int y = 0; y < m.height; y++)
      {
        //println(x + " " + y + " " + pixels[x+y*m.width]);
        if ( m.pixels[x + y*m.width] != m.pixels[0] ) 
        {
          if (hit1) pixels[ xp+x + (yp+y)*width] = color (255,0,0);
          else pixels[ xp+x + (yp+y)*width] = m.pixels[x + y*m.width];
          
           for (int I=1; I<=500; I++) 
           if ( bullet[I].motion == true) 
           if (dist (bullet[I].xpos, bullet[I].ypos, xp+x, yp+y)  <= 8.0 )
           {
                  bullet[I].motion = false;
                  L-=frag*2+1;
                  hit2=true;
                  if (L<=0) {BOSS_=false; t = 0; return;}
                  
                  println("Мандић губи живот");
           }
          
        }
        
       
        }
     hit1=hit2;
    
    updatePixels();
  if (pcnj<=200 && pcnj%4==0) {for (int j = 1; j<=(159-L)/25*int(random(4));   j++)
      for (int I = 1; I<=500; I++) 
      if (dbullet[I].motion==false) 
      {
        dbullet[I] = new dmissile(xp+25+random(20)-10, yp+44+random(10)-5, x+5+random(100)-50, y+5+random(100)-50);
        break; //ISPALI TACNO JEDAN METAK !!!    
      }}else
   if (pcnj>=300 && pcnj%60<=40-L/5){ for (int I = 1; I<=500; I++) 
      if (dbullet[I].motion==false) 
      {
        dbullet[I] = new dmissile(xp+13, yp+27, x+5+avx*45, y+5+avy*45); break;}for (int I = 1; I<=500; I++) 
      if (dbullet[I].motion==false) 
      {
        dbullet[I] = new dmissile(xp+38, yp+27, x+5+avx*45, y+5+avy*45); break;}}
      else if(pcnj==201) for(int I=1; I<=(150-L)/25; I++) 
      {
        int Q=1;
        while(swarm[Q].alive==true) Q++;
        swarm[Q] = new fighter(true,Q);
        TotalEnemies++;
        //println(TotalEnemies);
      }
      mL=L;
      
      noFill();
      rect(xpf,ypf+60,50,5);
      fill(255,0,0);
      rect(xpf, ypf+60, 50.0*( (L*1.0)/TotalLives ), 5.0);
      fill(0,255,0);
  }
  
  
  void move()
  {
    time+=dt;
    
    xpf = (width/2 - 50) * sin(4*time) + width/2 - 25; 
    ypf = 0.25 * height * (sin(5*time) + 1) + 25;
    
    time%=2*PI;
  }
  
}
  
