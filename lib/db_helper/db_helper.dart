import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db_Helper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

//  static Future<Database> initDB() async {
//     String path = join(await getDatabasesPath(), 'users.db');
//     return await openDatabase(
//       path,
//       version: 3,  // Incremented version to trigger onUpgrade
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE users(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             name TEXT NOT NULL,
//             email TEXT NOT NULL,
//             phone TEXT NOT NULL,
//             password TEXT NOT NULL
//           )
//         ''');

//         // Create attendance table with exit_time column
//         await db.execute('''
//           CREATE TABLE attendance(
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             date TEXT NOT NULL,
//             checkin_time TEXT NOT NULL,
//             exit_time TEXT
//           )
//         ''');
//       },
//       onUpgrade: (db, oldVersion, newVersion) async {
//         if (oldVersion < 3) {
//           await db.execute('ALTER TABLE attendance ADD COLUMN exit_time TEXT');
//         }
//       },
//     );
//   }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          phone TEXT NOT NULL,
          password TEXT NOT NULL
        )
      ''');

       
        await db.execute('''
        CREATE TABLE attendance(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL,
          time TEXT NOT NULL
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE users ADD COLUMN email TEXT');
          await db.execute('''
          CREATE TABLE IF NOT EXISTS attendance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            time TEXT NOT NULL
          )
        ''');
        }
      },
    );
  }

  static Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<bool> validateUser(String email, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  static Future<void> insertAttendance(String date, String time) async {
    final db = await database;
    await db.insert(
      'attendance',
      {'date': date, 'time': time},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // static Future<void> updateExitTime(String date, String exitTime) async {
  //   final db = await database;
  //   await db.update(
  //     'attendance',
  //     {'exit_time': exitTime},
  //     where: 'date = ?',
  //     whereArgs: [date],
  //   );
  // }
}
