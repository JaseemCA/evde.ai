import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db_Helper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }


 
  static Future<bool> validateUser(String phone, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'phone = ? AND password = ?',
      whereArgs: [phone, password],
    );
    return result.isNotEmpty;
  }
}
