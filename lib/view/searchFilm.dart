import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_cima/model/film.dart';
import 'package:my_cima/view/components/filmCard.dart';

class SearchFilm extends StatefulWidget {
  const SearchFilm({ Key? key }) : super(key: key);
  @override
  _SearchFilmState createState() => _SearchFilmState();
}

class _SearchFilmState extends State<SearchFilm> {
  //Film f1 = Film("toy story", "Enfant", "USA", "sofiane habaz", "8", "7", "7kaya twila ak chayef", "https://images-na.ssl-images-amazon.com/images/I/91GuxUoAATL.jpg");
  var _controller = TextEditingController();
  StreamController<Film?> resultFilm = StreamController();
  Film? getDataResult;
  bool searchIconIsPressed = false; 
  Future<Film?> getData(String title) async {
    try{
        final response = await  http.get(Uri.parse('http://www.omdbapi.com/?apikey=46aadd37&t=$title&plot=full'))
        .timeout(Duration(seconds: 10), onTimeout: (){throw TimeoutException("the connection has timed out, please try again");});
        if(response.statusCode == 200){
            var jsonResponse = json.decode(response.body);
            print(jsonResponse);
            if(jsonResponse["Response"]=="False") return null;
            Film f = new Film(title: jsonResponse['Title'],genre: jsonResponse['Genre'],country: jsonResponse['Country'],actors: jsonResponse['Actors'], imbdRating: jsonResponse['imdbRating'], internetRating: jsonResponse['Ratings'].isNotEmpty ? jsonResponse['Ratings'][0]["Value"] : "N/A",plot: jsonResponse['Plot'],posterURL: jsonResponse['Poster']);
            return f;
        }
        else{
          throw Exception('limit of requests');
        }
    }
    on TimeoutException catch(e){
      print("Try again ${e.message}");
      Film f = new Film.parDefaut(); 
      return f;
    }
    on SocketException catch(e){
      print("no internet connction ${e.message}");
      Film f = new Film.parDefaut(); //the null title will guide us to no internet connection
      return f;
    }

  }

  @override
  void dispose() {
    resultFilm.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33,33,41, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(50,57,73,1),
        title: Text('My Cima', style: GoogleFonts.balsamiqSans(fontWeight: FontWeight.bold, fontSize: 23.0)),
        centerTitle: true,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 30,
                  color: Color.fromRGBO(50,57,73,1).withOpacity(0.2),
                ),
              ],
            ),
            child: TextField(            
              decoration: InputDecoration(
                fillColor: Colors.black,
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () async {
                    if(_controller.text != "") 
                    {
                      setState(() {
                        searchIconIsPressed = true;
                      });
                      getDataResult = await getData(_controller.text);
                      resultFilm.sink.add(getDataResult);
                    }

                  }, 
                  icon: Icon(Icons.search, color: Color.fromRGBO(33,33,41, 1),)
                ),
              ),
              controller: _controller,
            ),
          ),
          
          //FilmCard(film: f1),
          StreamBuilder(
            stream: resultFilm.stream,
            //initialData: //TODO: circle loading
            builder: (context, snapshot){
              if(snapshot.hasError)
              {
                print("erreur dans le stream result film");
                return SizedBox(height: 0.0,);
              }
              else if (snapshot.connectionState == ConnectionState.waiting){
                return searchIconIsPressed 
                         ? CircularProgressIndicator()
                         : SizedBox(height: 0.0,);
              }
              else{
                Object? f = snapshot.data ;
                print(f.runtimeType);
                f as Film?;
                print(f.runtimeType);
                if(f == null) return noResultFound();
                else if(f.title == null){//constructor.parDefaut
                  /*setState(() {
                    searchIconIsPressed = false;
                  });*/
                  return Text("no connection!");
                } 
                else return FilmCard(film: f, index: 0,);
              }
            },
          )
        ],
    ),
    );
  }

  Widget noResultFound()
  {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 80.0, color: Colors.white,),
          SizedBox(height: 5.0,),
          Text("No result found!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25.0)),
          SizedBox(height: 5.0,),
          Text("Try writing the full movie name", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 15.0)),

        ],
      ),
    );
  }
}



