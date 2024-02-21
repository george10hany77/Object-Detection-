class Blob{
  
  private float minX, minY, maxX, maxY;
  private int id;
  private int lifeSpan = 100;
  private int distConstant = 35, distConst2 = 5;
  public boolean isTaken = false, isAlone = true;
  
  public Blob(float x, float y){
    minX = x;
    minY = y;
    maxX = x;
    maxY = y;
  }
  
  public Blob(float x, float y, int id){
    minX = x;
    minY = y;
    maxX = x;
    maxY = y;
    this.id = id;
  }
  
  public void add(int x, int y){
    minX = Math.min(minX, x);
    minY = Math.min(minY, y);
    maxX = Math.max(maxX, x);
    maxY = Math.max(maxY, y); 
  }
  
  public void display(){
    stroke(0);
    fill(255);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minX, minY, maxX, maxY);
  }
  
  public void display(int i){
    stroke(0);
    fill(255, 130);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minX, minY, maxX, maxY);
    
    textAlign(CENTER);
    textSize(34);
    fill(0);
    text(i, minX + (maxX - minX)/2, (minY + (maxY - minY)/2) + 10);
  }

  public void displayWithId(){
    stroke(0);
    fill(255, 130);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minX, minY, maxX, maxY);
    
    textAlign(CENTER);
    textSize(34);
    fill(0);
    text(this.id, minX + (maxX - minX)/2, (minY + (maxY - minY)/2) + 10);
  }
  
    public void displayWithIdAndLifeSpan(){
    stroke(0);
    fill(255, 130);
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minX, minY, maxX, maxY);
    
    textAlign(CENTER);
    textSize(34);
    fill(0);
    text(this.id, minX + (maxX - minX)/2, (minY + (maxY - minY)/2) + 10);
    text(this.lifeSpan, minX + (maxX - minX)/2, minY);
  }
  
  public PVector getCenter(){
    float cx = minX + (maxX - minX)/2;
    float cy = minY + (maxY - minY)/2;
    return new PVector(cx, cy);
  }
  
  public float getMinX(){
    return minX;
  }

  public float getMaxX(){
    return maxX;
  }
  
  public float getMinY(){
    return minY;
  }
  
  public float getMaxY(){
    return maxY;
  }
  
  public boolean isNear(int x, int y){// from the nearest edge of the blob and the given x, y "clamping"
    float cx = max(min(x, maxX), minX);
    float cy = max(min(y, maxY), minY);
    if(distSq(cx, cy, x, y) < distConstant*distConstant){
      return true;
    }else return false;
  }
  
  public boolean isNear(Blob b){// from the center of the given blob and the center of "this" blob
    PVector myCenter = this.getCenter();
    PVector bCenter = b.getCenter();
    if(distSq(myCenter.x, myCenter.y, bCenter.x, bCenter.y) < distConst2*distConst2){
      return true;
    }else return false;
  }
  
  public void become(Blob newBlob){
    this.minX = newBlob.getMinX();
    this.maxX = newBlob.getMaxX();
    this.minY = newBlob.getMinY();
    this.maxY = newBlob.getMaxY();
  }
  
  public int getID(){
    return this.id;  
  }

  public void setID(int id){
    this.id = id;  
  }
  
  public void setLifeSpan(int life){
    this.lifeSpan = life;  
  }
  
  public int getLifeSpan(){
    return this.lifeSpan;  
  }
  
  public float area(){
    return (maxX - minX) * (maxY - minY); 
  }
  
  public boolean isDead(){
    this.lifeSpan--; 
    return (this.lifeSpan < 0);   
  }
  
  private float distSq(float x1, float y1, float x2, float y2){ // as this function doesn't have sqrt so it is much faster than dist()
    return (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2);
  }
  

  
}
