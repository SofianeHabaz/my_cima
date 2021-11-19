import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cima/view/components/filmCard.dart';
import 'package:my_cima/view/searchFilm.dart';

import 'db/films_db.dart';
import 'model/film.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'My Cima'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title,}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Film> allFilms;
  late List<Film> films;
  bool isLoading = false;
  bool searchActivated = false;
  var _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshFilms();
  }

  Future refreshFilms() async {
    setState(() => isLoading = true);
    this.allFilms = await FilmsDB.instance.readAllFilms();
    films = allFilms;
    setState(() => isLoading = false);
  }
  @override
  void dispose() {
    FilmsDB.instance.close();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33,33,41, 1),
      appBar: AppBar(
        actions: searchActivated ? null : [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(Icons.search), 
              onPressed: (){
                setState(() {
                  searchActivated = !searchActivated;
                });
              },
              ),
          ),
        ],
        backgroundColor: Color.fromRGBO(50,57,73,1),
        title: Text(widget.title, style: GoogleFonts.balsamiqSans(fontWeight: FontWeight.bold, fontSize: 23.0)),
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
          searchActivated ? SizedBox(height: 0.0,) : SizedBox(height: 20.0,),
          searchActivated ? Row(
            children: [
              Expanded(
                child: Container(
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
                    controller: _controller,
                    onChanged: (input) {
                      final films = allFilms.where(
                        (film){
                          final lowerTitle = film.title!.toLowerCase();
                          final lowerInput = input.toLowerCase();
                          return lowerTitle.contains(lowerInput);
                        }
                      ).toList();
                      setState(() {
                        this.films = films;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
      
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(right: 20.0,),
                icon: Icon(Icons.highlight_off_rounded, size: 30.0, color: Colors.red,),
                onPressed: (){
                  setState(() {
                    searchActivated = !searchActivated;
                    if(_controller.text != "")
                    {
                      films = allFilms;
                    }
                    
                  });                    
                  _controller.clear();
                },
              ),
            ],
          ) : SizedBox(height: 0.0,),
          //kount ne7i bih les film m database 
          /*TextButton(onPressed: ()async {await FilmsDB.instance.deleteAllFilms(); refreshFilms();}, child: Text("delete")),*/
          Expanded(
            child: Container(
              child: isLoading==true 
                ? CircularProgressIndicator() 
                :  films.isEmpty 
                ? Text("database fargha")
                : ListView.builder(
                itemCount: films.length,
                itemBuilder: (context, index){
                  return FilmCard(film: films[index], index: index);
                },
          
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(50,57,73,1),
        child: Icon(Icons.add),
        onPressed: ()  async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchFilm()),
          );
          refreshFilms();
        },
      ),
    );
  }
}
