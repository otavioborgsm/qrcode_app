import 'dart:io';

import 'package:qrcode_app/models/scanner_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'scanner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute('''
      CREATE TABLE scanner (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        result TEXT
      );
    ''');
  }


  Future<int> create(Scanner scanner) async {
    var dbScanner = await database;
    int response = await dbScanner.insert("scanner", scanner.toJson());
    return response;
  }

  Future<int> delete(Scanner scanner) async {
      var dbScanner = await database;

      int result =
          await dbScanner.rawDelete('DELETE FROM scanner WHERE id = ?', [scanner.id]);
      return result;
  }

  Future<List<Scanner>> read() async {
    Database dbScanner = await instance.database;

    final result = await dbScanner.query("scanner");

    List<Scanner> listScanner = result.isNotEmpty 
            ? result.map((json) => Scanner.fromJson(json)).toList() 
            : [];

    return listScanner;
  }

}

  