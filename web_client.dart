///Programming Languages CS3360 Dr. Cheon
import 'package:http/http.dart' as http;
import 'parse.dart';
	

class WebClient{
	static final defaultUrl = "https://www.cs.utep.edu/cheon/cs3360/project/omok"; ///default url
	var gameUrl; ///final url saved for future use
	var infoResponse; ///stores game info response from server
	var pid; ///player id of the current game a user is on. 
	  
	WebClient();
	
	///returns true if [url] is valid and can connects to Omok Server
	///returns 
	Future<bool> processUrl(String url) async {
	  if (url == ""){
	    url = defaultUrl;
	  }
	  bool valid = Uri.tryParse(url + "/info")?.hasAbsolutePath ?? false;
	  if (!valid){
	    return false;
	  }
	  var response = await http.get(Uri.parse(url + "/info"));
	

	  if(response.body[0] == "<"){ //checking if response can be sent to json.decode
	    return false;
	  }
	  infoResponse = Parse.decode(response.body);
	  if(!infoResponse.containsKey("strategies")){ //checking info has strategies key
	    return false;
	  }
	  gameUrl = url;
	  return true;
	}
	
	///returns response from server for a new game given [strategy]
	Future<dynamic> newGame(strategy) async {
	    dynamic response = await http.get(Uri.parse(gameUrl + "/new/?strategy=$strategy"));
	    response = Parse.decode(response.body);
	    pid = response['pid'];
	    return response;
	}
	
	///returns response from server given a new user [move]
	Future<dynamic> makePlayerMove(move) async{
	    var response = await http.get(Uri.parse(gameUrl + "/play/?pid=$pid&move=${move[0]},${move[1]}"));
	    return Parse.decode(response.body);
	}
}
