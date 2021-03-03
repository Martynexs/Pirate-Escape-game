/**
* @author Martynas Valatka PS 1 kursas 4 gr. 2 pogrupis
* A game about a pirate trying to escape a ship. 
*/

//Current level/screen
int levelnr=0;

Player P;
boolean recreate = true;

JSONObject json;

//Movement variables
boolean up, down, left, right, action;
boolean jumpLock=false;

//Screen size variables
int screenSizeX = 640;
int screenSizeY = 576;

//Images
PImage imgTiles;
PImage doorimg, startimg;
PImage spike;

//Tiles variables
int tileX=64, tileY=64;
PImage[] tiles;

//Camera position
float cameraX = 0;
float cameraY = 0;

//Animation variables
PImage animation[];
int frames;

void setup()
{
  frames = 25;
  animation = new PImage[25];
  for (int i=0; i<frames; i++)
  {
    animation[i] = loadImage("Animation/"+(i+1)+".png");
  }

  doorimg = loadImage("Door.png");
  startimg = loadImage("Start.png");
  spike = loadImage("Spike.png");

  size(640, 576);

  up = false;
  down = false;
  left = false;
  right = false;
  action = false;

  imgTiles = loadImage("Tiles.png");
  tiles = new PImage[31];
  getTiles();
}

void draw()
{

  Exit door;
  Exit start;
  Map map;
  map = null;
  door = null;
  start = null;

  switch(levelnr)
  {
  case 0:
    titleScreen();
    break;

  case -2:
    background(100);
    mapeditor();
    break;

  case -1:
    gameOver();
    break;

  case 1:
    json = loadJSONObject("Levels.json").getJSONObject("level1");
    break;

  case 2:
    json = loadJSONObject("Levels.json").getJSONObject("level2");
    break;

  case 3:
    json = loadJSONObject("Levels.json").getJSONObject("level3");
    break;

  case 4:
    json = loadJSONObject("Levels.json").getJSONObject("level4");
    break;

  case 5:
    json = loadJSONObject("Levels.json").getJSONObject("level5");
    break;

  case 6:
    victory();
    break;
  }

  if (levelnr > 0 && levelnr <= 5)
  {
    background(#323443);
    map = new Map(json);
    door = new Exit(json, "door", doorimg);
    start = new Exit(json, "start", startimg);
    if (recreate == true)
    {
      P = new Player();
      cameraX = P.x - json.getJSONArray("start").getInt(0);
      cameraY = P.y - json.getJSONArray("start").getInt(1);
    }
    drawMap(map, door, start);
    P.update(map, door);
    P.display(door);
  }
}

void keyPressed()
{
  switch(key)
  {
  case 'w': //UP
    up = true;
    break;

  case 'a': //LEFT
    left = true;
    break;

  case 's': //DOWN
    down = true;
    break;

  case 'd': //RIGHT
    right = true;
    break;

  case 'q': //Action
    action = true;
    break;
  }
}

void keyReleased()
{
  switch(key)
  {
  case 'w': //UP
    up = false;
    jumpLock = true;
    break;

  case 'a': //LEFT
    left = false;
    break;

  case 's': //DOWN
    down = false;
    break;

  case 'd': //RIGHT
    right = false;
    break;

  case 'q':
    action = false;
    break;
  }
}

//Get tiles from tile map
void getTiles()
{
  int index=0;
  for (int y=0; y<imgTiles.height; y+=tileY)
  {
    for (int x=0; x<imgTiles.width; x+=tileX)
    {
      tiles[index] = imgTiles.get(x, y, 64, 64);
      index++;
    }
  }
}

//Draw map on the screen
void drawMap(Map map, Exit door, Exit start)
{
  float x=cameraX, y=cameraY;
  for (int i=0; i<map.mapY; i++)
  {
    for (int j=0; j<map.mapX; j++)
    {
      image(tiles[map.map[i*map.mapX+j]-1], x, y);
      x+=tileX;
    }
    y+=tileY;
    x=cameraX;
  }

  x=cameraX; 
  y=cameraY;
  for (int i=0; i<map.mapY; i++)
  {
    for (int j=0; j<map.mapX; j++)
    {
      if (map.walls[i*map.mapX+j] == 30) image(tiles[29], x, y);
      if (map.walls[i*map.mapX+j] == 8) image(spike, x, y);
      x+=tileX;
    }
    y+=tileY;
    x=cameraX;
  }

  image(doorimg, door.x+cameraX, door.y+cameraY);
  image(startimg, start.x+cameraX, start.y+cameraY);
  textSize(20);
  fill(200);
  text("Level " + levelnr, start.x+cameraX+10, start.y+cameraY-10);
}

//Draw title screen
void titleScreen()
{
  PImage title = loadImage("Title screen.png");
  image(title, 0, 0);

  fill(#123456, 0);
  if (mouseX >= 196 && mouseY >= 250 && mouseX <= 196+255 && mouseY <= 250+46) fill(#654321, 100); //Play button
  rect(196, 250, 255, 46);

  fill(#123456, 0);
  if (mouseX >= 195 && mouseY >= 319 && mouseX <= 195+255 && mouseY <= 319+46) fill(#654321, 100); //Edit button
  rect(195, 319, 255, 46);
}

//Draw game over screen
void gameOver()
{
  PImage title = loadImage("Game over.png");
  tint(200, 20);
  image(title, 0, 0);
  if (action == true)
  {
    reset();
    levelnr = 0;
  }
}

//Draw victory screen
void victory()
{
  PImage victory = loadImage("victory.png");
  image(victory, 0, 0);
  if (mousePressed == true)
  {
    reset();
    levelnr = 0;
  }
}

//Reset the game
void reset()
{
  cameraX = 0;
  cameraY = 0;
  jumpLock = false;
  noTint();
  recreate = true;
}

void mouseClicked()
{
  if (levelnr == 0)
  {
    if (mouseX >= 196 && mouseY >= 250 && mouseX <= 196+255 && mouseY <= 250+46) levelnr = 1;
    if (mouseX >= 195 && mouseY >= 319 && mouseX <= 195+255 && mouseY <= 319+46) levelnr = -2;
  }
}


//********************************************************************MAP EDITOR****************************************************************

int selectedx=-10;
int selectedy=-10;
int selectednr=0;
boolean select = false;

int selectedlvl=0;
int mapedit[] = new int[420];
int wallsedit[] = new int[420];
int startX=-1, startY=-1;
int endX=-1; 
int endY=-1;
boolean loaded = false;

JSONObject selectedmap;
JSONObject file;

void mapeditor()
{
  PImage grid = loadImage("Grid.png"); // 420 x 420 // 20 x 20
  image(grid, 0, 0);
  PImage editorTiles = loadImage("Tilesnew.png"); // 192 x 160 // 6 x 5
  image(editorTiles, 420+10, 0);
  PImage buttons = loadImage("level buttons.png");
  image(buttons, 420+10, 160+10);
  buttons = loadImage("save buttons.png");
  image(buttons, 10, 420+20);


  //Buttons
  //164 ilgis 44 plotis
  if (mouseX >= 23 && mouseX <= 10+164 && mouseY >= 449 && mouseY <= 449+44) //Save
  {
    fill(#FF0000, 100);
    noStroke();
    rect(23, 449, 164, 44);
    if (mousePressed == true && selectedlvl > 0)
    {
      file = loadJSONObject("Levels.json");
      for (int i=0; i<400; i++)
      {
        selectedmap.getJSONArray("data").setInt(i, mapedit[i]);
        selectedmap.getJSONArray("walls").setInt(i, wallsedit[i]);
      }
      selectedmap.getJSONArray("start").setInt(0, startX); 
      selectedmap.getJSONArray("start").setInt(1, startY);
      selectedmap.getJSONArray("door").setInt(0, endX);
      selectedmap.getJSONArray("door").setInt(1, endY);
      file.setJSONObject("level"+selectedlvl, selectedmap);
      saveJSONObject(file, "Levels.json");
    }
  }
  if (mouseX >= 23 && mouseX <= 10+164 && mouseY >= 498 && mouseY <= 498+44) //Home
  {
    fill(#FF0000, 100);
    noStroke();
    rect(23, 498, 164, 44);
    if (mousePressed == true)
    {
      resetEditor();
      levelnr = 0;
    }
  }

  //Level selection
  if (selectedlvl == 1 || (mouseX >= 441 && mouseX <= 441+164 && mouseY >= 178 && mouseY <= 178+44)) //lvl 1
  {
    fill(#FF0000, 100);
    noStroke();
    rect(441, 178, 164, 44);
    if (mousePressed == true && selectedlvl != 1)
    {
      selectedlvl = 1;
      selectedmap = loadJSONObject("Levels.json").getJSONObject("level1");
      loaded = false;
    }
  }
  if (selectedlvl == 2 || (mouseX >= 441 && mouseX <= 441+164 && mouseY >= 227 && mouseY <= 227+44)) //lvl 2
  {
    fill(#FF0000, 100);
    noStroke();
    rect(441, 227, 164, 44);
    if (mousePressed == true && selectedlvl != 2)
    {
      selectedlvl = 2;
      selectedmap = loadJSONObject("Levels.json").getJSONObject("level2");
      loaded = false;
    }
  }
  if (selectedlvl == 3 || (mouseX >= 441 && mouseX <= 441+164 && mouseY >= 276 && mouseY <= 276+44)) //lvl 3
  {
    fill(#FF0000, 100);
    noStroke();
    rect(441, 276, 164, 44);
    if (mousePressed == true && selectedlvl != 3)
    {
      selectedlvl = 3;
      selectedmap = loadJSONObject("Levels.json").getJSONObject("level3");
      loaded = false;
    }
  }
  if (selectedlvl == 4 || (mouseX >= 441 && mouseX <= 441+164 && mouseY >= 325 && mouseY <= 325+44)) //lvl 4
  {
    fill(#FF0000, 100);
    noStroke();
    rect(441, 325, 164, 44);
    if (mousePressed == true && selectedlvl != 4)
    {
      selectedlvl = 4;
      selectedmap = loadJSONObject("Levels.json").getJSONObject("level4");
      loaded = false;
    }
  }
  if (selectedlvl == 5 || (mouseX >= 441 && mouseX <= 441+164 && mouseY >= 375 && mouseY <= 375+44)) //lvl 5
  {
    fill(#FF0000, 100);
    noStroke();
    rect(441, 375, 164, 44);
    if (mousePressed == true && selectedlvl != 5)
    {
      selectedlvl = 5;
      selectedmap = loadJSONObject("Levels.json").getJSONObject("level5");
      loaded = false;
    }
  }

  //Load map
  if (selectedlvl > 0 && loaded == false)
  {
    for (int i=0; i<400; i++)
    {
      mapedit[i] = selectedmap.getJSONArray("data").getInt(i);
      wallsedit[i] = selectedmap.getJSONArray("walls").getInt(i);
    }
    startX = selectedmap.getJSONArray("start").getInt(0); 
    startY = selectedmap.getJSONArray("start").getInt(1);
    endX = selectedmap.getJSONArray("door").getInt(0);
    endY = selectedmap.getJSONArray("door").getInt(1);
    loaded = true;
  }

  //Display editing map
  int tilenr=-1;
  for (int y=0; y<420; y+=21)
  {
    for (int x=0; x<420; x+=21)
    {
      tilenr++;
      if (mapedit[tilenr] > 0) image(tiles[mapedit[tilenr]-1], x, y, tiles[mapedit[tilenr]-1].width/3, tiles[mapedit[tilenr]-1].height/3);
      if (wallsedit[tilenr] == 8) image(spike, x, y, spike.width/3, spike.height/3);
      else if (wallsedit[tilenr] == 30) image(tiles[29], x, y, tiles[29].width/3, tiles[29].height/3);
    }
  }
  if (startX >= 0 && startY >=0) image(startimg, startX/3, startY/3, startimg.width/3, startimg.height/3);
  if (endX >= 0 && endY >=0) image(doorimg, endX/3, endY/3, doorimg.width/3, doorimg.height/3);


  //Select tile
  tilenr=0;
  for (int y=0; y<160; y+=32)
  {
    for (int x=430; x<192+430; x+=32)
    {
      tilenr++;
      if (mouseX >= x && mouseY >= y && mouseX <= x+32 && mouseY <= y+32)
      {
        fill(#8e8e96, 100);
        noStroke();
        rect(x, y, 32, 32);
        if (mousePressed == true)
        {
          selectedx = x;
          selectedy = y;
          selectednr = tilenr;
        }
      }
      if (selectedx == x && selectedy == y)
      {
        selectedx = x;
        selectedy = y;
        selectednr = tilenr;
        //fill(#8e8e96, 100);
        noFill();
        stroke(#FF0000);
        rect(selectedx, selectedy, 32, 32);
        select = true;
      }
    }
  }

  //Show on map + edit map
  tilenr = -1;
  for (int y=0; y<420; y+=21)
  {
    for (int x=0; x<420; x+=21)
    {
      tilenr++;
      if (mouseX >= x && mouseY >= y && mouseX <= x+21 && mouseY <= y+21)
      {
        fill(#FF0000, 100);
        //noStroke();
        rect(x, y, 21, 21);
        if (selectednr == 23) //Door exit
        {
          image(doorimg, mouseX, mouseY, doorimg.width/3, doorimg.height/3);
          if (mousePressed == true)
          {
            endX = mouseX*3;
            endY = mouseY*3;
          }
        } else if (selectednr == 24) //Door start
        {
          image(startimg, mouseX, mouseY, startimg.width/3, startimg.height/3);
          if (mousePressed == true)
          {
            startX = mouseX*3;
            startY = mouseY*3;
          }
        } else if (selectednr == 29) //Spike
        {
          image(spike, x, y, spike.width/3, spike.height/3);
          if (mousePressed == true) wallsedit[tilenr] = 8;
        } else if (selectednr != 0)
        {
          image(tiles[selectednr-1], x, y, tiles[selectednr-1].width/3, tiles[selectednr-1].height/3);
          if (mousePressed == true && selectednr == 30) wallsedit[tilenr] = 30;
          else if (mousePressed == true && ( selectednr==1 || selectednr==2 || selectednr==3 || 
            selectednr==7 || selectednr==8 || selectednr==9 || 
            selectednr==13 || selectednr==14 || selectednr==15 || 
            selectednr==19 || selectednr==20 ||  
            selectednr==25 || selectednr==26 ))
          {
            wallsedit[tilenr] = 1;
            mapedit[tilenr] = selectednr;
          } else if (mousePressed == true && selectednr > 0)
          {
            wallsedit[tilenr] = 0;
            mapedit[tilenr] = selectednr;
          }
        }
      }
    }
  }
}

void resetEditor()
{
  selectedx=-10;
  selectedy=-10;
  selectednr=0;
  select = false;

  selectedlvl=0;
  mapedit = new int[420];
  wallsedit = new int[420];
  startX=-1;
  startY=-1;
  endX=-1; 
  endY=-1;
  loaded = false;

  selectedmap = null;
}
