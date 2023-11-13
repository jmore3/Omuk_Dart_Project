//Programming Languages CS3360 Dr. Cheon
import 'dart:io';


class Board{
	///mimics omok board with a 15x15 2d array
	List gameBoard = List.generate(15, (_) => List.filled(15, "."));
	///stores last move the server made so '*' can be changed to 'X'
	var lastServermove = [-1, -1];


	Board();
	///updates board with player [move]
	void makePlayerMove(move){
		gameBoard[move[0]][move[1]] = "O";
	}

	///updates server with server [move]
  	///changes [lastServerMove] from * to X
  	void makeServerMove(move){
    		stdout.writeln("server move");
    		stdout.writeln(move);
    		if (lastServermove[0] != -1){
    		  gameBoard[lastServermove[0]][lastServermove[1]] = "X";
    		}
    		gameBoard[move[0]][move[1]] = "*";
    		lastServermove[0] = move[0];
    		lastServermove[1] = move[1];
  }
  ///gets [row] of winning moves and updates them to W on board
  void winningMove(row){
    for(int i = 0; i < row.length; i += 2){
      gameBoard[row[i]][row[i+1]] = "W";
    }
  }
}
