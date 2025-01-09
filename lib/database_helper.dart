import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static final _databaseName = "app_database.db";
  static final _databaseVersion = 1;

  static final tableUsers = 'users';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');
  }

  Future<void> registerUser(String name, String email, String password) async {
    if (kIsWeb) {
      // Hive Implementation for Web
      final box = await Hive.openBox('userBox');
      if (box.containsKey(email)) {
        throw Exception('Email already registered');
      }
      await box.put(email, {'name': name, 'password': password});
      print("User registered in Hive: $name, $email");
    } else {
      // SQLite Implementation for Mobile/Desktop
      Database db = await instance.database;

      var result = await db.query(
        tableUsers,
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        throw Exception('Email already registered');
      }

      await db.insert(tableUsers, {
        'name': name,
        'email': email,
        'password': password,
      });
      print("User registered in SQLite: $name, $email");
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    if (kIsWeb) {
      // Hive Implementation for Web
      final box = await Hive.openBox('userBox');
      if (box.containsKey(email)) {
        final user = box.get(email);
        if (user['password'] == password) {
          print("User found in Hive: $user");
          return {'name': user['name'], 'email': email};
        }
      }
    } else {
      // SQLite Implementation for Mobile/Desktop
      Database db = await instance.database;

      var result = await db.query(
        tableUsers,
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (result.isNotEmpty) {
        print("User found in SQLite: ${result.first}");
        return result.first;
      }
    }
    print("Invalid user credentials for email: $email");
    return null;
  }
}
