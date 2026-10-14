import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../helpers/database_helper.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  int get totalIncome => _transactions
      .where((item) => item.type == 'pemasukan')
      .fold(0, (sum, item) => sum + item.amount);

  int get totalExpense => _transactions
      .where((item) => item.type == 'pengeluaran')
      .fold(0, (sum, item) => sum + item.amount);

  int get totalBalance => totalIncome - totalExpense;

  Future<void> fetchTransactions() async {
    _transactions = await DatabaseHelper.instance.getAllTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.insertTransaction(transaction);
    await fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    await fetchTransactions();
  }
}