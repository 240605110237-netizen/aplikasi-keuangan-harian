import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  final List<TransactionModel> _webMemoryStorage = [];

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _database = await _initDB('financial_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        amount INTEGER NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    if (kIsWeb) {
      _webMemoryStorage.add(transaction);
      return _webMemoryStorage.length;
    }
    final db = await instance.database;
    return await db!.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    if (kIsWeb) {
      return List.from(_webMemoryStorage.reversed);
    }
    final db = await instance.database;
    final result = await db!.query('transactions', orderBy: 'date DESC, id DESC');
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  Future<int> deleteTransaction(int id) async {
    if (kIsWeb) {
      _webMemoryStorage.removeWhere((item) => item.id == id);
      return 1;
    }
    final db = await instance.database;
    return await db!.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}