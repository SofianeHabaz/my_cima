final String tableFilms = 'films';
class FilmFields{//columns
  static final List<String> values = [id, title, genre, country, actors, imbdRating, internetRating, plot, posterURL];

  static final String id = '_id';
  static final String title = 'title';
  static final String genre = 'genre';
  static final String country = 'country';
  static final String actors = 'actors';
  static final String imbdRating = 'imbdRating';
  static final String internetRating = 'internetRating';
  static final String plot = 'plot';
  static final String posterURL = 'posterURL';
}
class Film{
  int? id;
  String? title, genre, country, actors, posterURL, imbdRating, internetRating, plot;
  Film({this.id, required this.title, required this.genre, required this.country, required this.actors, required this.imbdRating, required this.internetRating, required this.plot, required this.posterURL});
  Film.parDefaut(){
    this.id = null;
    this.title = null;
    this.genre = null;
    this.country = null;
    this.actors = null;
    this.imbdRating = null;
    this.internetRating= null;
    this.plot = null;
    this.posterURL = null;
  }

  Film copy({
    int? id, 
    String? title, genre, country, actors, posterURL, imbdRating, internetRating, plot
  }) => Film(id: id ?? this.id, title: title ?? this.title, genre: genre ?? this.genre , country: country ?? this.country, actors: actors ?? this.actors, imbdRating: imbdRating ?? this.imbdRating, internetRating: internetRating ?? this.internetRating, plot: plot ?? this.plot, posterURL: posterURL ?? this.posterURL);
  
  static Film fromJson(Map<String, Object?> json) => Film(
    id: json[FilmFields.id] as int?,
    title: json[FilmFields.title] as String?,
    genre: json[FilmFields.genre] as String?,
    country: json[FilmFields.country] as String?,
    actors: json[FilmFields.actors] as String?,
    imbdRating: json[FilmFields.imbdRating] as String?,
    internetRating: json[FilmFields.internetRating] as String?,
    plot: json[FilmFields.plot] as String?,
    posterURL: json[FilmFields.posterURL] as String?,
  );
  Map<String, Object?> toJson() => {
    FilmFields.id: id,
    FilmFields.title: title,
    FilmFields.genre: genre,
    FilmFields.country: country,
    FilmFields.actors: actors,
    FilmFields.imbdRating: imbdRating,
    FilmFields.internetRating: internetRating,
    FilmFields.plot: plot,
    FilmFields.posterURL: posterURL,
  };
}
