import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final total = provider.totalIncome + provider.totalExpense;
    final incomeRatio = total == 0 ? 0.0 : provider.totalIncome / total;
    final expenseRatio = total == 0 ? 0.0 : provider.totalExpense / total;

    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Keuangan'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Perbandingan Keuangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text('Pemasukan: ${_formatCurrency(provider.totalIncome)}'),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: incomeRatio, color: Colors.green, minHeight: 12),
            const SizedBox(height: 20),
            Text('Pengeluaran: ${_formatCurrency(provider.totalExpense)}'),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: expenseRatio, color: Colors.red, minHeight: 12),
          ],
        ),
      ),
    );
  }
}