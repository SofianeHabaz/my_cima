import 'package:flutter/material.dart';
import 'package:my_cima/model/film.dart';
import 'package:my_cima/view/detailPage.dart';

class FilmCard extends StatelessWidget {
  final Film? film;
  final int index;
  const FilmCard({ Key? key , this.film, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(film: film, index: index)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), 
          color: Color.fromRGBO(50,57,73,1),
        ),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Hero(
                      tag: index,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 35.0,
                        backgroundImage: film!.posterURL != "N/A" ? NetworkImage(film!.posterURL ?? "", ) : null,
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(film!.title ?? "", style: TextStyle(color: Colors.white, fontSize: 22.0), overflow: TextOverflow.ellipsis, maxLines: 2,),
                          SizedBox(height: 4.0,),
                          Text(film!.genre ?? "", style: TextStyle(color: Colors.grey, fontSize: 15.0),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              film!.imbdRating!="N/A" ? Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.star, color: Colors.amber, size: 18.0,)),
                      TextSpan(text: film!.imbdRating, style: TextStyle(fontSize: 22.0)),                    
                    ]
                  ),
                ),
              ) : SizedBox(height: 0.0,),
              
    
            ],
          ),
        ),
        
      ),
    );
  }
}

