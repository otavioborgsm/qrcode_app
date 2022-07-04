import 'package:qrcode_app/models/scanner_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'scanner.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_scanner);
  }

  String get _scanner => '''
    CREATE TABLE scanner (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT,
      result TEXT
    );
  ''';

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
    final dbScanner = await database;

    final result = await dbScanner.query("scanner");

    return result.map((json) => Scanner.fromJson(json)).toList();
  }

}

  