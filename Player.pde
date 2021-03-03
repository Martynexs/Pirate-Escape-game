class Player
{
  //Properties
  float x, y;
  int w, h;
  float speedX, speedY, maxSpeed, maxJump, jumpSpeed;
  PImage img;
  int jump=0;
  int direction=1; // 1-right 0-left
  int currentFrame, loopFrames, animationOffset, delay;

  //Constructor
  Player()
  {
    recreate = false;
    x = 300;
    y = 200;
    speedX = 0;
    speedY = 0;
    maxSpeed = 5;
    maxJump = 200;
    jumpSpeed = 10;

    currentFrame = 0;
    loopFrames=4;
    animationOffset = 9;
    delay = 0;
  }

  //Methods
  //Updates information abouth the character
  void update(Map map, Exit door)
  {      
    //Free fall
    speedY = maxSpeed;

    //Character movement based on buttons pressed
    if (up)
    {
      if (jump < maxJump && jumpLock == false)
      {
        speedY = -jumpSpeed;
        jump -= speedY;
      }
    } else if (down)
    {
      speedY = maxSpeed;
    } 

    if (left && right)
    {
      speedX = 0;
    } else if (!left && !right)
    {
      speedX = 0;
    } else if (left)
    {
      direction = 0;
      speedX = -maxSpeed;
    } else if (right)
    {;
      direction = 1;
      speedX = maxSpeed;
    }
    
    //When player goest outside map bounds
    if (x-cameraX + speedX < 0 || x-cameraX + w + speedX > map.mapX*tileX) speedX = 0;
    if (y-cameraY + speedY < 0 || y-cameraY + h + speedY > map.mapY*tileY) speedY = 0;
    
    
    //Colission
    int top = tilePos(x+w/2+speedX, y+speedY, map.mapX);
    int bot = tilePos(x+w/2+speedX, y+h+speedY, map.mapX);
    int lef = tilePos(x+speedX, y+h/2+speedY, map.mapX);
    int rig = tilePos(x+w+speedX, y+h/2+speedY, map.mapX);

    if (speedX > 0 && map.walls[rig] == 1) speedX=0; //When colides with a wall on the right
    else if (speedX < 0 && map.walls[lef] == 1) speedX=0; //When colides with a wall on the left

    if (speedY > 0 && (map.walls[bot] == 1)) //When colides with floor
    {
      jumpLock = false;
      jump = 0;
      speedY=0;
    } else if (speedY > 0 && map.walls[bot] == 30 && y+h-cameraY <= (bot/map.mapX)*tileY+3) //When colides with a platform
    {
      jumpLock = false;
      jump = 0;
      speedY=0;
    } else if (speedY < 0 && map.walls[top] == 1) speedY=0; //When colides with ceiling

    if (speedY > 0) jumpLock = true;

    cameraX -= speedX;
    cameraY -= speedY;
    
    //When enters the door to the next level
    if (touchDoor(x-cameraX, y-cameraY, w, h, door) == true && action == true)
    {
      reset();
      levelnr++;
    }


    //Animation update
    if (speedY<0) animationOffset = 4;
    else if (speedX!=0) animationOffset = 0;
    else animationOffset = 8;


    if (delay == 0)
    {
      currentFrame = (currentFrame+1)%loopFrames;
    }
    delay = (delay+1)%10;


    //When player touches the spike
    if (map.walls[bot] == 8 || map.walls[lef] == 8 || map.walls[rig] == 8 || map.walls[top] == 8)
    {
      jumpLock = false;
      jump = 0;
      levelnr = -1;
      direction = 1;
      currentFrame = 0;
      animationOffset = 24;
    }
    
  }
  
  //Draws the character on the screen
  void display(Exit door)
  {
    if (direction == 0) animationOffset+=12;
    img = animation[currentFrame+animationOffset];
    w = img.width;
    h = img.height; 
    image(img, x, y);

    if (touchDoor(x-cameraX, y-cameraY, w, h, door))
    {
      textSize(30);
      fill(200);
      text("Press Q", door.x+cameraX+5, door.y+cameraY-20);
    }
  }
}

//Calculates tile position
int tilePos(float x, float y, int mapX)
{
  int tilex, tiley;
  int temp = 0;
  while (temp < x-cameraX)
  {
    temp+=tileX;
  }
  tilex = temp/tileX-1;
  temp=0;
  while (temp < y-cameraY)
  {
    temp+=tileY;
  }
  tiley=temp/tileY-1;
  return tiley*mapX+tilex;
}

//Checks if the player is touching the door
boolean touchDoor(float x, float y, int w, int h, Exit door)
{
  float distX = abs((door.x+door.w/2) - (x+w/2));
  float distY = abs((door.y+door.h/2) - (y+h/2));
  float halfw = door.w/2 + w/2;
  float halfh = door.h/2 + h/2;

  if (distX < halfw && distY < halfh) return true; 
  return false;
}
