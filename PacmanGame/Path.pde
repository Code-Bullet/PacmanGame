class Path {
  LinkedList<Node> path = new LinkedList<Node>();//a list of nodes 
  float distance = 0;//length of path
  float distToFinish =0;//the distance between the final node and the paths goal
  PVector velAtLast;//the direction the ghost is going at the last point on the path

  //--------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Path() {
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
  //adds a node to the end of the path
  void addToTail(Node n, Node endNode)
  {
    if (!path.isEmpty())//if path is empty then this is the first node and thus the distance is still 0
    {
      distance += dist(path.getLast().x, path.getLast().y, n.x, n.y);//add the distance from the current last element in the path to the new node to the overall distance
    }

    path.add(n);//add the node
    distToFinish = dist(path.getLast().x, path.getLast().y, endNode.x, endNode.y);//recalculate the distance to the finish
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
 //retrun a clone of this 
  Path clone()
  {
    Path temp = new Path();
    temp.path = (LinkedList)path.clone();
    temp.distance = distance;
    temp.distToFinish = distToFinish;
    temp.velAtLast = new PVector(velAtLast.x, velAtLast.y);
    return temp;
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
   //removes all nodes in the path
  void clear()
  {
    distance =0;
    distToFinish = 0;
    path.clear();
  }
  //--------------------------------------------------------------------------------------------------------------------------------------------
  //draw lines representing the path
  void show() {
    strokeWeight(2);
    for (int i = 0; i< path.size()-1; i++) {
      line(path.get(i).x*16 +8, path.get(i).y*16 +8, path.get(i+1).x*16 +8, path.get(i+1).y*16 +8);//
    }
    ellipse((path.get(path.size() -1).x*16)+8, (path.get(path.size() -1).y*16)+8, 5, 5);
  }
}