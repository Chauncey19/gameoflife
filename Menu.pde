class menu {
  int x;
  int y;
  int w;
  int h;
  String texte;
  
  
  menu (int x, int y, int w, int h, String texte) {
    
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.texte=texte;
    
  }
  
  
  
  void DessinerBouttons(){
    fill(BLANC);
    rect(x, y, w, h);
    fill (0);
    textSize(18);
    textAlign(CENTER, CENTER);
    text (texte, x+90, y+12);
}


boolean dansCases(){
  return x<= mouseX && mouseX< x+w
  && y<=mouseY && mouseY <y+h;
}

}
