import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CrudDatabaseHelper {
  static final _databaseName = "crud_database.db";
  static final _databaseVersion = 1;

  static final tableDataList = 'data_list';

  CrudDatabaseHelper._privateConstructor();
  static final CrudDatabaseHelper instance = CrudDatabaseHelper._privateConstructor();

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

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableDataList (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL
      )
    ''');
  }

  Future<int> addData(String title, String description, double latitude, double longitude) async {
    Database db = await instance.database;
    return await db.insert(tableDataList, {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  Future<List<Map<String, dynamic>>> getDataList() async {
    Database db = await instance.database;
    return await db.query(tableDataList);
  }

  Future<int> updateData(int id, String title, String description, double latitude, double longitude) async {
    Database db = await instance.database;
    return await db.update(
      tableDataList,
      {
        'title': title,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteData(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableDataList,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
