import 'package:sqflite/sqfl'
    'ite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:untitled/models/quote.dart';

class DbHelper {
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database??= await _initDb();

  Future<Database> _initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,'quotes.db') ;
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future _createDb (Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
    CREATE TABLE $quoteTable(
      ${QuoteFields.id} $idType, 
      ${QuoteFields.description} $textType, 
      ${QuoteFields.author} $textType, 
      ${QuoteFields.isFavorite} $boolType
    )
    ''');
  }
  Future<Quote> insert(Quote quote)  async {
    Database db = await instance.database;

    final id = await db.insert(quoteTable, quote.fromObjtoMap());
    print('quote inserted in db');
    return quote.copy(id: id);
  }

  Future<Quote> read(int id) async {
    final db= await instance.database;
    final map = await db.query(
      quoteTable,
      columns: QuoteFields.values,
      where: '${QuoteFields.id} =? ',
      whereArgs: [id],
    );
    return map.isNotEmpty? Quote.fromMaptoObj(map.first): throw Exception('ID $id is invalid');
  }
  Future<List<Quote>> readAll() async{
    final orderBy = '${QuoteFields.id} ASC';
    final db = await instance.database;
    final result = await db.query(quoteTable, orderBy: orderBy);
    return result.map((e)=>Quote.fromMaptoObj(e)).toList();
  }
  Future<int> update(Quote quote) async{
    final db = await instance.database;
    return db.update(
      quoteTable,
      quote.fromObjtoMap(),
      where: '${QuoteFields.id} =? ',
      whereArgs: [quote.id]
    );
  }
  Future<int> delete(int id) async{
    final db = await instance.database;
    return await db.delete(
      quoteTable,
      where: '${QuoteFields.id} =? ',
      whereArgs: [id],
    );
  }

  Future<int> getCount() async {
    final db = await instance.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $quoteTable');
    int? result = Sqflite.firstIntValue(x);
    return result?? 0 ;
  }

  Future close () async {
    final db =  await instance.database;
    db.close();
  }

}