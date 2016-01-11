import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress address;

Queue<Spectrum> specQueue;
Spectrum nextSpectrum;

class Spectrum {
  int[] fftData = new int[128];

  Spectrum() {
    for (int i = 0; i < fftData.length; i++) {
      fftData[i] = 0;
    }
  }
}

void setup() {
  size(640, 400);
  //frameRate(30);

  oscP5 = new OscP5(this, 12000);
  address = new NetAddress("127.0.0.1", 12000);

  nextSpectrum = null;
  specQueue = new Queue<Spectrum>();
}

void draw() {
  if(nextSpectrum != null) {
    specQueue.enqueue(nextSpectrum);
  }
  
  while(specQueue.size > 25) {
    specQueue.dequeue();
  }
  
  background(30);
  fill(30);
  stroke(230);
  strokeWeight(2);

  Node<Spectrum> n = specQueue.first;

  int count = 0;
  while (n != null) {
    beginShape();
    vertex(115, -100 + (count * 10) + (height / 2));
    for (int i = 0; i < 128; i++) {
      vertex(120 + (float) i * 3, 
        -100 + (count * 10) + (height / 2) - (float) (n.value.fftData[127 - i] + 1) / 5);
    }
    
    endShape();
    count++;
    n = n.next;
  }
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/bins")) {
    Spectrum s = new Spectrum();
    for (int i = 0; i < 128; i++) {
      s.fftData[i] = msg.get(i).intValue();
    }

    nextSpectrum = s;
  }
}