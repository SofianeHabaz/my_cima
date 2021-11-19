import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:my_cima/model/film.dart';

class FilmsDB{
  static final instance = FilmsDB._init();
  static Database? _database;
  FilmsDB._init();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDB("films.db");
    return _database!;
  } 

  Future<Database> _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
    CREATE TABLE $tableFilms(
      ${FilmFields.id} $idType,
      ${FilmFields.title} $textType,
      ${FilmFields.genre} $textType,
      ${FilmFields.country} $textType,
      ${FilmFields.actors} $textType,
      ${FilmFields.imbdRating} $textType,
      ${FilmFields.internetRating} $textType,
      ${FilmFields.plot} $textType,
      ${FilmFields.posterURL} $textType
    )
    ''');
  }

  Future<Film> createFilm(Film film) async{
    final db = await instance.database;
    final id = await db.insert(tableFilms, film.toJson());
    return film.copy(id: id);
  }

  Future<Film?> readFilm(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableFilms, 
      columns: FilmFields.values,
      where: '${FilmFields.id} = ?',
      whereArgs: [id],
    );
    if(maps.isNotEmpty) {
      return Film.fromJson(maps.first);
    }
    else return null;
  }

  Future<Film?> readFilmByTitle(String title) async {
    final db = await instance.database;
    final maps = await db.query(
      tableFilms, 
      columns: FilmFields.values,
      where: '${FilmFields.title} = ?',
      whereArgs: [title],
    );
    if(maps.isNotEmpty) {
      return Film.fromJson(maps.first);
    }
    else return null;
  }

  Future<List<Film>> readAllFilms() async {
    final db = await instance.database;
    final orderBy = "${FilmFields.title} ASC";
    final result = await db.query(tableFilms, orderBy: orderBy);
    if(result.isNotEmpty){
      return result.map((json) => Film.fromJson(json)).toList();
    }
    else return [];
  }

  Future<int> deleteFilm(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableFilms,
      where: "${FilmFields.id} = ?",
      whereArgs: [id],
    );
  }
  Future<int> deleteAllFilms() async {
    final db = await instance.database;
    return await db.delete(
      tableFilms,
    );
  }
  Future close() async{
    final db = await instance.database;
    db.close();
  }
}