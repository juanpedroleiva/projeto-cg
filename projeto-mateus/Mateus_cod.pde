void setup() {
  size(1600,300);
  noLoop();
}

void draw() {
   PImage img = loadImage("0280.jpg"); 
   PImage img2 = loadImage("0280.png");
   PImage img3 = createImage(img2.width, img2.height, RGB);
   PImage img4 = createImage(img.width, img.height, RGB);
   
   // Filtro de Escala de Cinza
   for(int y = 0; y < img.height; y++) {
     for(int x = 0; x < img.width; x++) {
         int pos = y*img.width + x;
         int media = (int) (red(img.pixels[pos]) + 
                            green(img.pixels[pos]) + 
                            blue(img.pixels[pos])) / 3;
         img3.pixels[pos] = color(blue(img.pixels[pos]));
     }
   }
   // Filtro de Brilho
   for(int y = 0; y < img.height; y++) {
     for(int x = 0; x < img.width; x++) {
         int pos = y*img.width + x;
         int brilho = (int) red(img3.pixels[pos]) + 100;
         if (brilho > 255) brilho = 255;
         else if(brilho < 0) brilho = 0;
         img3.pixels[pos] = color(brilho);
     }
   }
   // Filtro de Limiarização
   for(int y = 0; y < img.height; y++) {
     for(int x = 0; x < img.width; x++) {
         int pos = y*img.width + x;
         if(red(img3.pixels[pos]) > 254) 
           img3.pixels[pos] = color(255);
         else 
           img3.pixels[pos] = color(0);
     }
   }
       // Copia os pixels da imagem original onde o ground truth é branco
    for(int y = 0; y < img.height; y++) {
      for(int x = 0; x < img.width; x++) {
        int pos = y * img.width + x;
        if (red(img3.pixels[pos]) > 254) {
          img4.pixels[pos] = img.pixels[pos];
        } else {
          img4.pixels[pos] = color(0); // pixels que não são brancos são colocados em preto
        }
      }
    }
    img4.updatePixels();
  
    int vPositivos = 0;
    int falsoPositivos = 0;
    int falsoNegativos = 0;
    
    for (int y = 0; y < img2.height; y++) {
      for (int x = 0; x < img2.width; x++) {
        int pos = y * img2.width + x;
    
        // Verifica se o pixel é um objeto no ground truth
        boolean obj = red(img2.pixels[pos]) > 250;
    
        // Verifica se o pixel é um objeto na imagem segmentada
        boolean objSegmentada = red(img3.pixels[pos]) > 250;
    
        if (obj && objSegmentada) {
          vPositivos++;
        } else if (obj && !objSegmentada) {
          falsoPositivos++;
        } else if (!obj && objSegmentada) {
          falsoNegativos++;
        }
      }
    }

    println("Verdadeiros positivos: " + vPositivos);
    println("Falsos positivos: " + falsoPositivos);
    println("Falsos negativos: " + falsoNegativos);
   
   image(img,0,0);
   image(img2,400,0);
   image(img3,800,0);
   image(img4,1200,0);
   save("GroundTruth_mateus.jpg");
}
