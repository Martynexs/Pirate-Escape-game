class Map
{
  int map[];
  int walls[];
  int mapX, mapY;

  Map(JSONObject json)
  {

    mapX = json.getInt("width");
    mapY = json.getInt("height");

    map = new int[mapX*mapY+1];
    walls = new int[mapX*mapY+1];

    for (int i=0; i<mapY*mapX; i++)
    {
      map[i] = json.getJSONArray("data").getInt(i);
    }

    for (int i=0; i<mapY*mapX; i++)
    {
      walls[i] = json.getJSONArray("walls").getInt(i);
    }
  }
}
