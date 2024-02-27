import processing.video.*;
Capture video;
ArrayList<Blob> currentBlobs = new ArrayList<>();
ArrayList<Blob> storedBlobs = new ArrayList<>();
int idCounter = 0;
int colConstant = 150;
color c = color(255, 0, 0);

void setup(){
  size(1100, 620);
  video = new Capture(this, width, height);
  video.start();
}

void captureEvent(Capture video){
  video.read();
}

void draw(){
  video.loadPixels();
  image(video, 0, 0);
  
  //to clear the old currentBlobs
  currentBlobs.clear();
  
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){
      
      if(distSq(red(c), green(c), blue(c), red(video.get(x, y)), green(video.get(x, y)), blue(video.get(x, y))) < colConstant*colConstant){
        // to make the blob bigger or smaller
        boolean exist = false;
        for(Blob b : currentBlobs){
          if(b.isNear(x, y)){
            b.add(x, y);  
            exist = true;
            break;
          }
        }
        // if there are no currentBlobs or no near currentBlobs we create a new blob
        if(!exist || currentBlobs.isEmpty()){
          currentBlobs.add(new Blob(x, y)); 
        } 
      }
    }    
  }
  
  // to remove all the small current Blobs
  //////////////////////////////////////////////////////////////////////////////////////
  for(int i = 0; i < currentBlobs.size(); i++){
    if(currentBlobs.get(i).area() < 1500){
      currentBlobs.remove(i);
      //continue; // we have to say continue as the "removed" blob with index i DNE
    }
    //currentBlobs.get(i).display();
  }
  //////////////////////////////////////////////////////////////////////////////////////
 
  // Match the stored blobs with the current blobs
  //////////////////////////////////////////////////////////////////////////////////////

  // if there are no stored blobs and there is current blobs
  if(storedBlobs.isEmpty() && currentBlobs.size() > 0){
    for(Blob b : currentBlobs){
      b.setID(++idCounter);
      b.resetLife();
      storedBlobs.add(b);
    }  
    println("add new blob");
  }
  //else if(currentBlobs.isEmpty() && storedBlobs.size() > 0){
  //  storedBlobs.clear();
  //  println("delete all blobs");
  //}
  else if(storedBlobs.size() <= currentBlobs.size()){ // In case we have the same number or less blobs each frame
    for(Blob sB : storedBlobs){ // the nested loops are to find the closest blob for each stored blob from the current blobs
      float minDist = 100000;
      Blob closestBlob = null;
      for(Blob cB : currentBlobs){
        PVector sBCenter = sB.getCenter();
        PVector cBCenter = cB.getCenter();
        float dist = PVector.dist(sBCenter, cBCenter);
        if(dist < minDist){
          minDist = dist;
          closestBlob = cB;
        }
      }
      if(closestBlob != null){
        sB.become(closestBlob);
        sB.resetLife();
        closestBlob.isTaken = true;
      }
    }
    if(storedBlobs.size() < currentBlobs.size()){// In case we added
      for(Blob b : currentBlobs){
        if(!b.isTaken){
          b.setID(++idCounter);
          storedBlobs.add(b); 
         }
       }
     }
     //println("add");
  }
  else if(storedBlobs.size() > currentBlobs.size()){ // In case we removed
    for(Blob cB : currentBlobs){ // the nested loops are to find the closest blob for each stored blob from the current blobs
      float minDist = 100000;
      Blob closestBlob = null;
      for(Blob sB : storedBlobs){
        PVector sBCenter = sB.getCenter();
        PVector cBCenter = cB.getCenter();
        float dist = PVector.dist(sBCenter, cBCenter);
        if(dist < minDist){
          minDist = dist;
          closestBlob = sB;
        }
      }
      if(closestBlob != null){
        closestBlob.become(cB);
        closestBlob.resetLife();
        closestBlob.isAlone = false;
      }
    }
    for(int i = 0; i < storedBlobs.size(); i++){
      Blob temp = storedBlobs.get(i);
      if(temp.isAlone){
        if(temp.isDead()){
          storedBlobs.remove(i);        
        }
      }
    }
   //println("remove");
  }
  //////////////////////////////////////////////////////////////////////////////////////
 
  // display each stored blob
  //////////////////////////////////////////////////////////////////////////////////////

  for(Blob b : storedBlobs){
    if(b.getLifeSpan() == b.lifeSpanConstant){
      b.displayId();
      b.isAlone = true; // crutial to reset isAlone and make it true
      //print(b.isAlone + "  ");
    }
  }
  //println();
  //////////////////////////////////////////////////////////////////////////////////////


  textAlign(LEFT);
  textSize(24);
  text("S: " + storedBlobs.size(), 10, 25);
  text("C: " + currentBlobs.size(), 10, 50);
  
  
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2){ // as this function doesn't have sqrt so it is much faster than dist()
  return (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) + (z1 - z2)*(z1 - z2);
}
