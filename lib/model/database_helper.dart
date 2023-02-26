// ignore_for_file: depend_on_referenced_packages

import 'todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper.privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
            CREATE TABLE todo(
            id INTEGER PRIMARY KEY,
            task TEXT NOT NULL,
            priority TEXT NOT NULL)
          ''',
        );
      },
      version: 1,
    );
  }

  // CREATE METHOD
  Future<int> insertToDo(ToDo todo) async {
    Database db = await instance.database;

    return await db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //Total Tasks

  readAllUsers() async {
    Database db = await instance.database;
    return db.query('todo');
  }

  // READ METHOD
  Future<List<ToDo>> getAllToDos() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('todo');

    return List.generate(maps.length, (i) {
      return ToDo(
        id: maps[i]['id'],
        task: maps[i]['task'],
        priority: maps[i]['priority'],
      );
    });
  }

  // UPDATE METHOD
  Future<int> updateToDo(ToDo todo) async {
    Database db = await instance.database;
    return await db.update(
      'todo',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // DELETE METHOD
  Future<int> deleteToDo(int id) async {
    Database db = await instance.database;

    return await db.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
