class Clyde {
    PVector pos = new PVector(1*16 +8, 29*16+8);
  PVector vel = new PVector(1, 0);
  Path bestPath; // the variable stores the path the ghost will be following
  ArrayList<Node> ghostNodes = new ArrayList<Node>();//the nodes making up the path including the ghosts position and the target position
  Node start;//the ghosts position as a node
  Node end; //the ghosts target position as a node
  color colour = color(255, 100, 0);//orange
  
  boolean chase = true;//true if the ghost is in chase mode false if in scatter mode
  boolean frightened = false;//true if the ghost is in frightened mode
  int flashCount = 0;//in order to make the ghost flash when frightened this is a counter
  int chaseCount = 0;//counter for the switch between chase and scatter
  boolean returnHome = false;//if eaten return home
  boolean deadForABit = false;//after the ghost returns home it disappears for a bit
  int deadCount = 0;
  

  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Clyde() {
    setPath();
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------------

  void show() {
    //increments counts
    chaseCount ++;
    if (chase) {
      if (chaseCount > 2000) {
        chase = false;  
        chaseCount = 0;
      }
    } else {
      if (chaseCount > 700) {
        chase = true;
        chaseCount = 0;
      }
    }
    
    
    
    if (deadForABit) {
      deadCount ++;
      if (deadCount > 300) {
        deadForABit = false;
      }
    } else {//if not deadforabit then show the ghost
      if (!frightened) {
        if (returnHome) {//have the ghost be transparent if on its way home
          stroke(colour, 100); 
          fill(colour, 100);
        } else {// colour the ghost
          stroke(colour);
          fill(colour);
        }
        bestPath.show();//show the path the ghost is following
      } else {//if frightened
        flashCount ++;
        if (flashCount > 800) {//after 8 seconds the ghosts are no longer frightened
          frightened = false;
          flashCount = 0;
        }

        if (floor(flashCount / 30) %2 ==0) {//make it flash white and blue every 30 frames
          stroke(255);
          fill(255);
        } else {//flash blue
          stroke(0, 0, 200);
          fill(0, 0, 200);
        }
      }
      ellipse(pos.x, pos.y, 20, 20);//draw the ghost as a circle
    }
  }

  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //moves the ghost along the path
  void move() {
    if (!deadForABit) {//dont move if dead
      pos.add(vel);
      checkDirection();//check if need to change direction next move
    }
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------------
  
  //calculates a path from the first node in ghost nodes to the last node in ghostNodes and sets it as best path
  void setPath() {
    ghostNodes.clear();
    setNodes();
    start  = ghostNodes.get(0);
    end = ghostNodes.get(ghostNodes.size()-1);
    Path temp = AStar(start, end, vel);
    if (temp!= null) {//if not path is found then dont change bestPath
      bestPath = temp.clone();
    }
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //sets all the nodes and connects them with adjacent nodes 
  //also sets the target node
  void setNodes() {

    ghostNodes.add(new Node((pos.x-8)/16, (pos.y-8)/16));//add the current position as a node
    for (int i = 1; i< 27; i++) {//check every position
      for (int j = 1; j< 30; j++) {
        //if there is a space up or below and a space left or right then this space is a node
        if (!tiles[j][i].wall) {
          if (!tiles[j-1][i].wall || !tiles[j+1][i].wall) { //check up for space
            if (!tiles[j][i-1].wall || !tiles[j][i+1].wall) {//check left and right for space

              ghostNodes.add(new Node(i, j));//add the nodes
            }
          }
        }
      }
    }
    if (returnHome) {//if returning home then the target is just above the ghost room thing
      ghostNodes.add(new Node(13, 11));
    } else {
      if (chase) {
        if (dist((pos.x-8)/16, (pos.y-8)/16, (pacman.pos.x-8) / 16, (pacman.pos.y-8)/16) > 8) {

          ghostNodes.add(new Node((pacman.pos.x-8) / 16, (pacman.pos.y-8)/16));
        } else {

          ghostNodes.add(new Node(1, 29));
        }
      } else {//scatter
        ghostNodes.add(new Node(1, 29));
      }
    }
    
    for (int i = 0; i< ghostNodes.size(); i++) {//connect all the nodes together
      ghostNodes.get(i).addEdges(ghostNodes);
    }
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------------
  //check if the ghost needs to change direction as well as other stuff
  void checkDirection() {
    if (pacman.hitPacman(pos)) {//if hit pacman
      if (frightened) {//eaten by pacman
        returnHome = true;
        frightened = false;
      } else if (!returnHome) {//killPacman
        pacman.kill();
      }
    }


    // check if reached home yet
    if (returnHome) {
      if (dist((pos.x-8)/16, (pos.y - 8)/16, 13, 11) < 1) {
        //set the ghost as dead for a bit
        returnHome = false;
        deadForABit = true;
        deadCount = 0;
      }
    }

    if ((pos.x-8)%16 == 0 && (pos.y - 8)% 16 ==0) {//if on a critical position 

      PVector matrixPosition = new PVector((pos.x-8)/16, (pos.y - 8)/16);//convert position to an array position

      if (frightened) {//no path needs to generated by the ghost if frightened
        boolean isNode = false;
        for (int j = 0; j < ghostNodes.size(); j++) {
          if (matrixPosition.x ==  ghostNodes.get(j).x && matrixPosition.y == ghostNodes.get(j).y) {
            isNode = true;
          }
        }
        if (!isNode) {//if not on a node then no need to do anything
          return;
        } else {//if on a node
          //set a random direction
          PVector newVel = new PVector();
          int rand = floor(random(4));
          switch(rand) {
          case 0:
            newVel = new PVector(1, 0);
            break;
          case 1:
            newVel = new PVector(0, 1);
            break;
          case 2:
            newVel = new PVector(-1, 0);
            break;
          case 3:
            newVel = new PVector(0, -1);
            break;
          }
          //if the random velocity is into a wall or in the opposite direction then choose another one
          while (tiles[floor(matrixPosition.y + newVel.y)][floor(matrixPosition.x + newVel.x)].wall || (newVel.x +2*vel.x ==0 && newVel.y + 2*vel.y ==0)) {
            rand = floor(random(4));
            switch(rand) {
            case 0:
              newVel = new PVector(1, 0);
              break;
            case 1:
              newVel = new PVector(0, 1);
              break;
            case 2:
              newVel = new PVector(-1, 0);
              break;
            case 3:
              newVel = new PVector(0, -1);
              break;
            }
          }
          vel = new PVector(newVel.x/2, newVel.y/2);//halve the speed
        }
      } else {//not frightened

        setPath();

        for (int i =0; i< bestPath.path.size(); i++) {//if currently on a node turn towards the direction of the next node in the path 
          if (matrixPosition.x ==  bestPath.path.get(i).x && matrixPosition.y == bestPath.path.get(i).y) {
            
            vel = new PVector(bestPath.path.get(i+1).x - matrixPosition.x, bestPath.path.get(i+1).y - matrixPosition.y);
            vel.limit(1);

            return;
          }
        }
      }
    }
  }
}