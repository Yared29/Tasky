import 'package:Tasky/database/databaseConnection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    // Initialize database connection
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  // Inserting data to Table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  // Read active data from table
  readActiveData(table) async {
    var connection = await database;
    return await connection.rawQuery("SELECT * FROM $table WHERE isDone = 0");
  }

  // Count active data from table
  countActiveData(table) async {
    var connection = await database;
    return await connection
        .rawQuery("SELECT COUNT(*) FROM $table WHERE isDone = 0");
  }

  // Read data from table by ID
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  // Edit data from table by ID
  editData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  // Update data from active to done by ID
  updateData(table, taskId) async {
    var connection = await database;
    var data = Map<String, dynamic>();
    data['isDone'] = 1;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [taskId]);
  }

  // Update data from done to active by ID
  updateDataFromDoneToActive(table, taskId) async {
    var connection = await database;
    var data = Map<String, dynamic>();
    data['isDone'] = 0;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [taskId]);
  }

  // Read done data from table
  readDoneData(table) async {
    var connection = await database;
    return await connection.rawQuery("SELECT * FROM $table WHERE isDone = 1");
  }

  // Count done data from table
  countDoneData(table) async {
    var connection = await database;
    return await connection
        .rawQuery("SELECT COUNT(*) FROM $table WHERE isDone = 1");
  }

  // Delete data from table by ID
  deletData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }

  // Delete all done datas
  deletAllDoneData(table) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE isDone = 1");
  }
}
