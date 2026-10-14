import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transaction_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  String _formatCurrency(int amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi'), backgroundColor: Colors.teal),
      body: provider.transactions.isEmpty
          ? const Center(child: Text('Belum ada riwayat transaksi.'))
          : ListView.builder(
        itemCount: provider.transactions.length,
        itemBuilder: (context, index) {
          final item = provider.transactions[index];
          final isIncome = item.type == 'pemasukan';
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                isIncome ? Icons.arrow_circle_down : Icons.arrow_circle_up,
                color: isIncome ? Colors.green : Colors.red,
                size: 36,
              ),
              title: Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${item.category} | ${item.date}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatCurrency(item.amount),
                    style: TextStyle(color: isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      if (item.id != null) {
                        provider.deleteTransaction(item.id!);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}