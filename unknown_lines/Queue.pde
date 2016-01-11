// Implementing my own queue to refresh data strutures knowledge

class Node<T> {
  T value;
  Node next;
  
  Node(T value) {
    this.value = value;
    this.next = null;
  }
}

class Queue<T> {
  Node<T> first;
  Node<T> last;
  int size;
  
  Queue() {
    first = null;
    last = null;
    size = 0;
  }
  
  void enqueue(T value) {
    Node node = new Node(value);
    
    if(size == 0) { 
      first = node;
      last = node;
    } else {
      last.next = node;
      last = node;
    }
    
    size++;
  }
  
  void dequeue() {
    if(size > 1) {
      first = first.next;
      size--;
    } else if(size == 1) {
      first = null;
      last = null;
      size = 0;
    }
  }
}