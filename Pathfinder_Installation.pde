import peasy.*;
import java.util.*;
import saito.objloader.*;
import toxi.geom.*;
import toxi.geom.mesh.subdiv.*;
import toxi.geom.mesh.*;
import toxi.processing.*;
ToxiclibsSupport gfx;
import wblut.hemesh.core.*;
import wblut.hemesh.creators.*;
import wblut.hemesh.modifiers.*;
import wblut.core.processing.*;

PeasyCam cam;
BodyTransform transform;
Choreo choreo;

boolean runMultiScreen=false;
PGraphics contentGr;
PGraphics contentGr2D;
PMatrix mat_scene; // to store initial PMatrix

PImage back;


void enableVSync() {
}

void setup() {
  size(1920, 1080, OPENGL);

  mat_scene = getMatrix();

  //  size(1600, 1200, OPENGL);
  gfx=new ToxiclibsSupport(this);
  cam = new PeasyCam(this, 330);

  frameRate(29);                                      // set unlimited frame rate
  //((PJOGL)PGraphicsOpenGL.pgl).gl.setSwapInterval(1); // enable waiting for vsync

  back = loadImage("back.jpg");
  contentGr = createGraphics(width, height, OPENGL);
  contentGr2D = createGraphics(width, height);


  // noCursor();
  contentGr2D.beginDraw();
  contentGr2D.background(0);
  contentGr2D.endDraw();

  setupVisuals();
  setupGui();  
  setupBodyPrimitives();

  setupTouchpad();

  choreo = new Choreo(this);
  //start with choreo from body 0 to body 1
  transform = new BodyTransform(body[listofBody[0]], body[listofBody[1]]);

  item = new Item();

  initVideo();
}

public void init() {
 
 frame.removeNotify();
 frame.setUndecorated(true);
 frame.addNotify();
 frame.setAlwaysOnTop(true);
 super.init();
 } 



void draw() {
    frame.setLocation(0,0);

  updateFrame();

  drawFrame(contentGr);


  if (runMultiScreen) {
    contentGr.loadPixels(); 
    arrayCopy(contentGr.pixels, contentGr2D.pixels); 
    contentGr2D.updatePixels();
  }

  cam.beginHUD();
  image(contentGr, 0, 0);
  drawMenu();

  frame.setTitle("Morpher || "+int(frameRate)+" fps");

  cam.endHUD();

  cam.beginHUD();
  drawVideo();
  cam.endHUD();

 // controlInstallation();
}



void updateFrame() {
  choreo.update();
  updateVisuals();
}


void drawMenu() {
  if (isGuiDraw) drawHUD();
}

void drawFrame(PGraphics in) {
  in.beginDraw();
  in.setMatrix(getMatrix()); // replace the PGraphics-matrix
  in.colorMode(RGB);
  in.background(backgroundCol);
  in.colorMode(HSB, 360);
  in.scale(cp5WorldScale);
  in.translate(0, 0, -5);
 
  drawVisuals(in);
  in.endDraw();
}


boolean drawPoints=true;

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

import processing.video.*;
Movie mov;


void initVideo() {
  mov = new Movie(this, "PathFinale_2.mp4");
}


void movieEvent(Movie movie) {
  mov.read();
}

void drawVideo() {
  if (mov.time() < mov.duration()) image(mov, 0, 0);
  int timeRestartVideo=10*60;//in seconds
//  if ((millis()/1000)%timeRestartVideo==0 && (mov.time() >10 || mov.time()<0)) startVideo();
  println(mov.duration() +" - "+ mov.time());
}

void startVideo() {
  mov.jump(0); 
  mov.play();
}

boolean switchRec=false;
void controlInstallation() {
  int time=5;
  int tSwitch3D = millis()%(time*1000*2)/(time*1000);


  time = 20;
  int tSwitchRecord = millis()%(time*1000*2)/(time*1000);
  boolean rem= switchRec;
  switchRec=(tSwitchRecord==0);

  if (rem!=switchRec) item.clear();

  cp53DAnim = (tSwitch3D==0);
  if (!cp53DAnim) globalRotate=0;

}

