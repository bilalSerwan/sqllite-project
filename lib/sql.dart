import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ignore: camel_case_types
class sqllite {
  Database? _mydb;
  Future<Database?> get _database async {
    // ignore: unnecessary_null_comparison
    if (_mydb == null) {
      _mydb = await initialDB();
      return _mydb;
    } else {
      return _mydb;
    }
  } //get

  Future<Database> initialDB() async {
    String DBPath = await getDatabasesPath();
    String pathOfDB = join(DBPath, 'bilal.db');
    Database database = await openDatabase(
      pathOfDB,
      version: 1,
      onCreate: _oncreate,
      onUpgrade: (db, oldVersion, newVersion) => null,
    );
    return database;
  } //initialDB

  void _oncreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE works (`id` INTEGER PRIMARY KEY AUTOINCREMENT ,`title` TEXT NOT NULL ,`description` TEXT , `ischecked` BOOLEAN NOT NULL )');
    print('Create database And table ======================================');
  } //_oncreate

  Future<List<Map>> Selecttable(String sql) async {
    _mydb = await _database;
    var response = await _mydb!.rawQuery(sql);
    return response;
  }

  Future<int> Inserttable(String sql) async {
    _mydb = await _database;
    int response = await _mydb!.rawInsert(sql);
    return response;
  }

  Future<int> DeleteRawtable(String sql) async {
    _mydb = await _database;
    int response = await _mydb!.rawDelete(sql);
    return response;
  }

  Future<int> UpdateRawTable(String sql) async {
    _mydb = await _database;
    int response = await _mydb!.rawUpdate(sql);
    return response;
  }
}//class