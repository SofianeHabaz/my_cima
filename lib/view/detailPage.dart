import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cima/db/films_db.dart';
import 'package:my_cima/model/film.dart';

class DetailPage extends StatefulWidget {
  final Film? film;
  final int index;
  const DetailPage({Key? key, this.film, required this.index}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> { 
  Film? filmDB;
  bool? avaible;

  Future isAvaible(String title) async {
    filmDB = await FilmsDB.instance.readFilmByTitle(title);
    if(filmDB == null){
      setState(() {
        this.avaible = false;
      });
    } 
    else{
      setState(() {
        this.avaible = true;
      });
    } 
  }

  @override
  void initState() {
    super.initState();
    isAvaible(widget.film!.title!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33,33,41, 1),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(50,57,73,1),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left_rounded), 
          iconSize: 30.0, 
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Detail movie", style: GoogleFonts.balsamiqSans(fontWeight: FontWeight.bold, fontSize: 23.0)),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(50,57,73,1),
        child: avaible==null ? 
          null 
          : avaible! ? Icon(Icons.check, color: Colors.white) : Icon(Icons.add, color: Colors.white),
        onPressed: avaible==true ? 
          () async {
            await FilmsDB.instance.deleteFilm(filmDB!.id!);
            setState(() {
              avaible = false;
            });
          } : 
          () async {
            filmDB = await FilmsDB.instance.createFilm(widget.film!);
            setState(() {
              avaible = true;
            });
          },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0, bottom: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                widget.film!.posterURL != "N/A" ? Center(
                child: Hero(
                  tag: widget.index,
                  child: Container(
                    height: 250,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360),
                      image: DecorationImage(
                        image: NetworkImage(widget.film!.posterURL ?? ""),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(height: 0.0,),
              Center(child: Text(widget.film!.title ?? "", style: GoogleFonts.oswald(color: Colors.white, fontSize: 40.0,), textAlign: TextAlign.center)),
              SizedBox(height: 40.0,),
              widget.film!.genre != "N/A" ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(50,57,73,1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Genre", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(child: Text(widget.film!.genre ?? "", style: TextStyle(color: Colors.grey[400], fontSize: 20.0), overflow: TextOverflow.ellipsis, maxLines: 2,)),
                ],
              ) : SizedBox(height: 0,),
              SizedBox(height: 18.0,),
              widget.film!.actors != "N/A" ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(50,57,73,1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Actors", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2,),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(child: Text(widget.film!.actors ?? "", style: TextStyle(color: Colors.grey[400], fontSize: 20.0), overflow: TextOverflow.ellipsis, maxLines: 2,)),
                ],
              ) : SizedBox(height: 0,),
              SizedBox(height: 18.0,),
              widget.film!.country != "N/A" ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(50,57,73,1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Country", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(child: Text(widget.film!.country ?? "", style: TextStyle(color: Colors.grey[400], fontSize: 20.0), overflow: TextOverflow.ellipsis, maxLines: 2,)),
                ],
              ) : SizedBox(height: 0,),
              SizedBox(height: 18.0,),
              widget.film!.imbdRating != "N/A" ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(50,57,73,1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("IMBD", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10.0,),
                  Text(widget.film!.imbdRating ?? "", style: TextStyle(color: Colors.grey[400], fontSize: 20.0),),
                  Icon(Icons.star, color: Colors.amber, size: 18.0,)
                ],
              ) : SizedBox(height: 0,),
              SizedBox(height: 18.0,),
              widget.film!.internetRating != "N/A" ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(50,57,73,1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Global Rating", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 10.0,),
                  Text((widget.film!.internetRating)!.substring(0, (widget.film!.internetRating)!.indexOf('/')), style: TextStyle(color: Colors.grey[400], fontSize: 20.0),),
                  Icon(Icons.star, color: Colors.amber, size: 18.0,)
                ],
              ) : SizedBox(height: 0,),
              //SizedBox(height: 20.0,),
              widget.film!.plot != "N/A" ? Divider(height: 40.0, color: Color.fromRGBO(50,57,73,1),) : SizedBox(height: 0,),
              widget.film!.plot != "N/A" ? Text(" ${widget.film!.plot ?? ''}", style: TextStyle(color: Colors.grey[400], fontSize: 22.0)) : SizedBox(height: 0,), 
               
            ]
          ),
        ),
      ),
    );
  }
}
