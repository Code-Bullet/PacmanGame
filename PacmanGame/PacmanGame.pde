//import stuff for pathfinding
import java.util.Deque;
import java.util.Iterator;
import java.util.LinkedList;

Pacman pacman;
PImage img;//background image 

Pinky pinky;
Blinky blinky;
Clyde clyde;
Inky inky;
Tile[][] tiles = new Tile[31][28]; //note it goes y then x because of how I inserted the data
int[][] tilesRepresentation = { 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
  {1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1}, 
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 6, 6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 6, 6, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 1, 1, 1, 1, 1, 0, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 0, 1, 1, 1, 1, 1, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1}, 
  {1, 8, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 8, 1}, 
  {1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1}, 
  {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1}, 
  {1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1}, 
  {1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1}, 
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1}, 
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}};//its not sexy but it does the job
//--------------------------------------------------------------------------------------------------------------------------------------------------

void setup() {
  frameRate(100);
  size(448, 496);
  img = loadImage("map.jpg");
  //initiate tiles
  for (int i = 0; i< 28; i++) {
    for (int j = 0; j< 31; j++) {
      tiles[j][i] = new Tile(16*i +8, 16*j+8);
      switch(tilesRepresentation[j][i]) {
      case 1: //1 is a wall
        tiles[j][i].wall = true;
        break;
      case 0: // 0 is a dot
        tiles[j][i].dot = true;
        break;
      case 8: // 8 is a big dot
        tiles[j][i].bigDot = true;
        break;
      case 6://6 is a blank space
        tiles[j][i].eaten = true;
        break;
      }
    }
  }

  pacman = new Pacman();
  pinky = new Pinky();
  blinky = new Blinky();
  clyde = new Clyde();
  inky = new Inky();
}
//--------------------------------------------------------------------------------------------------------------------------------------------------

void draw() {
  image(img, 0, 0);
  if (!pacman.gameOver) {
    stroke(255);

    for (int i = 0; i< 28; i++) {
      for (int j = 0; j< 31; j++) {
        tiles[j][i].show();
      }
    }
    pacman.move();

    //move and show the ghosts
    inky.show();
    inky.move();

    clyde.show();
    clyde.move();

    pinky.show();
    pinky.move();

    blinky.show();
    blinky.move();

    //show pacman last so he appears over the path lines
    pacman.show();
  }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------

void keyPressed() {//controls for pacman
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      pacman.turnTo = new PVector(0, -1);
      pacman.turn = true;
      break;
    case DOWN:
      pacman.turnTo = new PVector(0, 1);
      pacman.turn = true;
      break;
    case LEFT:
      pacman.turnTo = new PVector(-1, 0);
      pacman.turn = true;
      break;
    case RIGHT:
      pacman.turnTo = new PVector(1, 0);
      pacman.turn = true;
      break;
    }
  }
}
//--------------------------------------------------------------------------------------------------------------------------------------------------


//returns the nearest non wall tile to the input vector
//input is in tile coordinates
PVector getNearestNonWallTile(PVector target) {
  float min = 1000;
  int minIndexj = 0;
  int minIndexi = 0;
  for (int i = 0; i< 28; i++) {//for each tile
    for (int j = 0; j< 31; j++) {
      if (!tiles[j][i].wall) {//if its not a wall
        if (dist(i, j, target.x, target.y)<min) { //if its the current closest to target
          min =  dist(i, j, target.x, target.y);
          minIndexj = j;
          minIndexi = i;
        }
      }
    }
  }
  return new PVector(minIndexi, minIndexj);//return a PVector to the tile
}


//--------------------------------------------------------------------------------------------------------------------------------------------------
//returns the shortest path from the start node to the finish node
Path AStar(Node start, Node finish, PVector vel)
{
  LinkedList<Path> big = new LinkedList<Path>();//stores all paths
  Path extend = new Path(); //a temp Path which is to be extended by adding another node
  Path winningPath = new Path();  //the final path
  Path extended = new Path(); //the extended path
  LinkedList<Path> sorting = new LinkedList<Path>();///used for sorting paths by their distance to the target

  //startin off with big storing a path with only the starting node
  extend.addToTail(start, finish);
  extend.velAtLast = new PVector(vel.x, vel.y);//used to prevent ghosts from doing a u turn
  big.add(extend);


  boolean winner = false;//has a path from start to finish been found  

  while (true) //repeat the process until ideal path is found or there is not path found 
  {
    extend = big.pop();//grab the front path form the big to be extended
    if (extend.path.getLast().equals(finish)) //if goal found
    {
      if (!winner) //if first goal found, set winning path
      {
        winner = true;
        winningPath = extend.clone();
      } else { //if current path found the goal in a shorter distance than the previous winner 
        if (winningPath.distance > extend.distance)
        {
          winningPath = extend.clone();//set this path as the winning path
        }
      }
      if (big.isEmpty()) //if this extend is the last path then return the winning path
      {
        return winningPath.clone();
      } else {//if not the current extend is useless to us as it cannot be extended since its finished
        extend = big.pop();//so get the next path
      }
    } 


    //if the final node in the path has already been checked and the distance to it was shorter than this path has taken to get there than this path is no good
    if (!extend.path.getLast().checked || extend.distance < extend.path.getLast().smallestDistToPoint)
    {     
      if (!winner || extend.distance + dist(extend.path.getLast().x, extend.path.getLast().y, finish.x, finish.y)  < winningPath.distance) //dont look at paths that are longer than a path which has already reached the goal
      {

        //if this is the first path to reach this node or the shortest path to reach this node then set the smallest distance to this point to the distance of this path
        extend.path.getLast().smallestDistToPoint = extend.distance;
        
        //move all paths to sorting form big then add the new paths (in the for loop)and sort them back into big.
        sorting = (LinkedList)big.clone();
        Node tempN = new Node(0, 0);//reset temp node
        if (extend.path.size() >1) {
          tempN = extend.path.get(extend.path.size() -2);//set the temp node to be the second last node in the path
        }

        for (int i =0; i< extend.path.getLast().edges.size(); i++) //for each node incident (connected) to the final node of the path to be extended 
        {
          if (tempN != extend.path.getLast().edges.get(i))//if not going backwards i.e. the new node is not the previous node behind it 
          {     
     
            //if the direction to the new node is in the opposite to the way the path was heading then dont count this path
            PVector directionToNode = new PVector( extend.path.getLast().edges.get(i).x -extend.path.getLast().x, extend.path.getLast().edges.get(i).y - extend.path.getLast().y );
            directionToNode.limit(vel.mag());
            if (directionToNode.x == -1* extend.velAtLast.x && directionToNode.y == -1* extend.velAtLast.y ) {
            } else {//if not turning around
              extended = extend.clone();
              extended.addToTail(extend.path.getLast().edges.get(i), finish);
              extended.velAtLast = new PVector(directionToNode.x, directionToNode.y);
              sorting.add(extended.clone());//add this extended list to the list of paths to be sorted
            }
          }
        }


        //sorting now contains all the paths form big plus the new paths which where extended
        //adding the path which has the higest distance to big first so that its at the back of big.
        //using selection sort i.e. the easiest and worst sorting algorithm
        big.clear();
        while (!sorting.isEmpty())
        {
          float max = -1;
          int iMax = 0;
          for (int i = 0; i < sorting.size(); i++)
          {
            if (max < sorting.get(i).distance + sorting.get(i).distToFinish)//A* uses the distance from the goal plus the paths length to determine the sorting order
            {
              iMax = i;
              max = sorting.get(i).distance + sorting.get(i).distToFinish;
            }
          }
          big.addFirst(sorting.remove(iMax).clone());//add it to the front so that the ones with the greatest distance end up at the back
          //and the closest ones end up at the front
        }
      }
      extend.path.getLast().checked = true;
    }
    //if no more paths avaliable
    if (big.isEmpty()) {
      if (winner ==false) //there is not path from start to finish
      {
        print("FUCK!!!!!!!!!!");//error message 
        return null;
      } else {//if winner is found then the shortest winner is stored in winning path so return that
        return winningPath.clone();
      }
    }
  }
}