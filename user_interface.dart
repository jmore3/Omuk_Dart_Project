//Programming Languages CS3360 Dr. Cheon
import 'dart:io';
import 'web_client.dart';
	

class UserInterface{
  List<dynamic> board;
	  final xHeader = " x 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5";
	  final yHeader = "y -------------------------------";
	  final defineMoves = "Player: O, Server: X (and *)";
	  final moveInstructions = "Enter x and y (1-15, e.g., 8 10)";
	  
	  UserInterface(this.board);
	

	///Displays start menu message and gets [url] from user
  	String startup(){
	  var defaultUrl = WebClient.defaultUrl;
	  displayMessage("Welcome to Omok game!");
	  displayMessage('Enter the server URL default = [$defaultUrl]');
	  String? url = getInput();
	  return url == "" ? defaultUrl : url!;
	}
	
	///returns the [strategy] selected by user
	///[info] is information from server, includes strategy
	String getStrategy(info){
	  stdout.writeln("Select the server strategy: 1. ${info['strategies'][0]} 2. ${info['strategies'][1]} [default: 1]");
	  var strategy = stdin.readLineSync();
	  if (strategy == "") strategy = "1"; //default value
	  while(strategy != "1" && strategy != "2"){
	    stdout.writeln('Invalid selection: $strategy');
	    strategy = stdin.readLineSync();
	  }
	  strategy = strategy == "1" ? "smart" : "random";
	  stdout.writeln("Creating a new game .....");
	  return strategy;
	}
	
	///Shows a graphical representation of OMOK [board] in command line
	void displayBoard(){
	  stdout.writeln(xHeader);
	  stdout.writeln(yHeader);
	  var yCounter = 1;
	  for (int x = 0; x < board.length; x += 1) {
	    String rowInfo = "$yCounter| ";
	    for (int y = 0; y < board.length; y += 1) {
	        rowInfo += board[x][y] + " ";
	    }
	    stdout.writeln(rowInfo);
	    yCounter += 1;
	    if (yCounter == 10) yCounter = 0;
	  }
	  stdout.writeln(defineMoves);
	  stdout.writeln(moveInstructions);
	}
	

	///displays [message] on CLI
	displayMessage(message){
	  stdout.writeln(message);
	}
	  
	///returns input from user
	String? getInput(){
	  return stdin.readLineSync();
	}

}
