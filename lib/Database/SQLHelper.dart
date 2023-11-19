import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

import '../Model/Note.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""Create table Notes(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT ,
    content TEXT,
    dateadded Date
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'PHBL1.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Return all Note in Notes table
  static Future<List<Map<String, dynamic>>> getAll() async {
    Note note;
    final db = await SQLHelper.db();
    return db.query('Notes', orderBy: "id DESC");

  }

  // Create a Note in Notes table
  static Future<int> createNote(String title, String content) async {
    DateTime date = DateTime.now();
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'content': content,
      'dateadded': date.toIso8601String()
    };
    final id = await db.insert('Notes', data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    print(id);

    return id;
  }

// Delete a Note in Notes table
  static Future<void> deleteNote(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('Notes', where: "id=?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Đã có lỗi xảy ra, vui lòng thử lại: $err");
    }
  }

  // Update a Note in Notes table
  static Future<int> updateNote(int id, String title, String content) async {
    DateTime date = DateTime.now();
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'content': content,
      'dateadded': date.toIso8601String()
    };
    final result =
        await db.update('Notes', data, where: "id=?", whereArgs: [id]);
    return result;
  }

// Return a Note in Note table by id
  static Future<Map<String, Object?>?> getNote(int id) async {
    final db = await SQLHelper.db();
    final res = await db.query('Notes', where: "id=?", whereArgs: [id]);
    if (res.isNotEmpty) return res.first;
    return null;
  }
}
