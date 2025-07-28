import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get db async {
    _db ??= await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertNote(Note note) async {
    final dbClient = await db;
    await dbClient.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Note>> getNotes() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  static Future<void> updateNote(Note note) async {
    final dbClient = await db;
    await dbClient.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  static Future<void> deleteNote(int id) async {
    final dbClient = await db;
    await dbClient.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static logout() {}
}
