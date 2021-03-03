class Exit
{
  float x, y;
  int w, h;
  PImage img;

  Exit(JSONObject json, String S, PImage i)
  {
    x = json.getJSONArray(S).getFloat(0);
    y = json.getJSONArray(S).getFloat(1);
    img = i;
    w = img.width;
    h = img.height;
  }
}
