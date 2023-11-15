//Programming Languages CS3360 Dr. Cheon
	import 'package:omok/user_interface.dart';
	import 'package:omok/web_client.dart';
	import 'board.dart';

///Controller class transfers data from web_client to user_interface
class Controller{
  var ui; ///userInterface object that interacts with user
  var webClient; ///gets information from server
  var board; ///represents OMOK board

  Controller(){
	  board = Board();
	  ui = UserInterface(board.gameBoard);
	  webClient = WebClient();
	}

	///starting point for the game
	///if connection is made to server and player selects strategy
	///then this will call the play method
	Future<void> run() async {
		var url = ui.startup();
		ui.displayMessage("attempting to connect to server");
		bool validUrl = await webClient.processUrl(url);
		while(!validUrl){
			ui.displayMessage("invalid url try again");
			url = ui.getInput();
			if (url == "") url = WebClient.defaultUrl;
			ui.displayMessage("attempting to connect to server");
			validUrl = await webClient.processUrl(url);
    		}
    		var infoResponse = await webClient.infoResponse;
    		var strategy = ui.getStrategy(infoResponse);
    		var newGameResponse = await webClient.newGame(strategy);
    		if(!newGameResponse['response']){
      			ui.displayMessage(newGameResponse['reason']);
      			return;
    		}
    		play();
  	}

  	///while loop iterates until the game is over
	///gets player move and gets response from server, updates accordingly
  	Future<void> play() async {
    		while(true){
      			ui.displayBoard();
      			var playerMove = promptMove();
      			if(playerMove == null) continue;
      			var move = [-1, -1];
      			move[0] = int.parse(playerMove[0]);
      			move[1] = int.parse(playerMove[1]);
      			var moveResponse = await webClient.makePlayerMove(playerMove);
      			if(!moveResponse['response']){
        		ui.displayMessage(moveResponse['reason']);
        		continue;
      		}
      		if(moveResponse['ack_move']["isDraw"]){
        		ui.displayMessage("DRAW");
        		return;
      		}
      		if(moveResponse['ack_move']["isWin"]){
        		board.winningMove(moveResponse['ack_move']['row']);
        		ui.displayMessage("Winning Player Move!");
        		ui.displayBoard();
        		return;
      		}
      		if(moveResponse['move']["isWin"]){
        		board.makePlayerMove(move);
        		board.winningMove(moveResponse['move']['row']);
        		ui.displayMessage("Winning Computer Move!");
        		ui.displayBoard();
        		return;
      		}
      		board.makePlayerMove(move);
      		board.makeServerMove([moveResponse['move']['x'], moveResponse['move']['y']]);
    		}
  	}

  ///asks user for input and makes sure it's valid
  List<String>? promptMove(){
      var playerMove = ui.getInput();
      playerMove = playerMove.split(" ");
  
      //check if two items were entered
      if (playerMove.length != 2){
	ui.displayMessage("need to enter x and y (i.e. 10 11)");
        return null;
      }

      //check if integer was entered
      if(!isNumeric(playerMove[0]) || !isNumeric(playerMove[1])){
        ui.displayMessage("invalid input, insert number 1-15");
        return null;
      }

      //checks if integer is valid board index
      if(int.parse(playerMove[0]) <= 0 || int.parse(playerMove[0]) > board.gameBoard.length){
        ui.displayMessage("invalid input, insert number 1-15");
        return null;
      }
      if(int.parse(playerMove[1]) <= 0 || int.parse(playerMove[1]) > board.gameBoard.length){
        ui.displayMessage("invalid input, insert number 1-15");
        return null;
      }
      playerMove[0] = updatePlayerMove(playerMove[0]);
      playerMove[1] = updatePlayerMove(playerMove[1]);

      //checks if space is already filled
      if (board.gameBoard[int.parse(playerMove[0])][int.parse(playerMove[1])] != "."){
        ui.displayMessage("space is already filled");
        return null;
      }
      return playerMove;
  }

  ///Interface has 1 based indexing so this adjusts for 0 based
  String updatePlayerMove(s){
    s = int.parse(s) - 1;
    return s.toString();
  }

  ///checks if string [s] is numeric using a try and catch statement
  bool isNumeric(String s){
    try {
      int.parse(s);
      return true;
    } catch(e){
      return false;
    }
  }
}
