import 'dart:core';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Dates {
  DateTime date;
  int isPassed;
  String id;

  Dates({
    required this.id,
    required this.date,
    required this.isPassed,
  });
}

class DatabaseService {
  static Database? _db;

  static final DatabaseService instance = DatabaseService._constructor();
  DatabaseService._constructor();

  final String tableName = 'dates';

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final DatabaseDirPath = await getDatabasesPath();
    final DatabasePath = join(DatabaseDirPath, 'dates.db');

    final database =
        await openDatabase(DatabasePath, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          isPassed INTEGER NOT NULL
        )
        ''');
    });
    return database;
  }

  Future<void> addDate(
    DateTime date,
    int isPassed,
  ) async {
    final db = await database;
    await db.insert(tableName, {
      'date': date.toIso8601String(),
      'isPassed': isPassed,
    });
  }

  Future<List<Map<String, dynamic>>> getDates() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);
    List<Dates> dates = List.generate(maps.length, (index) {
      return Dates(
        id: maps[index]['id'].toString(),
        date: DateTime.parse(maps[index]['date']),
        isPassed: maps[index]['isPassed'],
      );
    });

    return maps;
  }

  Future<void> removeDate(String id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateIsPassed(String id, int isPassed) async {
    final db = await database;
    await db.update(tableName, {'isPassed': isPassed},
        where: 'id = ?', whereArgs: [id]);
  }
}
