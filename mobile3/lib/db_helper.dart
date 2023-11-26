import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';

class SQlHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE data(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      style TEXT,
      season TEXT,
      purchase_date DATE NOT NULL DEFAULT CURRENT_DATE
    )""");
  }

  // static Future<sql.Database> db() async{
  //   return sql.openDatabase(

  //     "database_name.db",
  //     version: 1,
  //     onCreate: (sql.Database database, int version) async{
  //       await createTables(database);
  //     });
  // }

  static Future<sql.Database> db() async {
    final database = await sql.openDatabase(
      "database_name.db",
      version: 1,
      onCreate: (sql.Database db, int version) async {
        await createTables(db);
      },
    );
    return database;
  }

  static Future<int> createData(
      String name, String style, String season) async {
    final db = await SQlHelper.db(); // Assuming db() returns a valid database.

    final data = {'name': name, 'style': style, "season": season};
    final id = await db.insert('data', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQlHelper.db();
    return db.query('data', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQlHelper.db();
    return db.query('data', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int id, String name, String style, String season) async {
    final db = await SQlHelper.db();
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final data = {
      'name': name,
      'style': style,
      'season': season,
      'purchase_date': currentDate
    };
    final result =
        await db.update('data', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQlHelper.db();
    try {
      await db.delete('data', where: "id =?", whereArgs: [id]);
    } catch (e) {}
  }
}
