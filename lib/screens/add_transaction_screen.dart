import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'pemasukan';
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Uang Saku';
  DateTime _selectedDate = DateTime.now();

  final List<String> _incomeCategories = ['Uang Saku', 'Gaji', 'Bonus', 'Lainnya'];
  final List<String> _expenseCategories = ['Makanan', 'Transportasi', 'Pendidikan', 'Hiburan', 'Lainnya'];

  @override
  Widget build(BuildContext context) {
    final categories = _type == 'pemasukan' ? _incomeCategories : _expenseCategories;
    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi'), backgroundColor: Colors.teal),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Toggle Jenis Transaksi
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'pemasukan', label: Text('Pemasukan'), icon: Icon(Icons.add_circle)),
                  ButtonSegment(value: 'pengeluaran', label: Text('Pengeluaran'), icon: Icon(Icons.remove_circle)),
                ],
                selected: {_type},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _type = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Input Nominal dengan Validasi
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal (Rp)', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nominal wajib diisi';
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Masukkan nominal angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Dropdown Kategori
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              // Input Keterangan dengan Validasi
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Keterangan', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Keterangan wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Pilih Tanggal
              ListTile(
                tileColor: Colors.grey.shade100,
                title: Text('Tanggal: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 24),
              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newTransaction = TransactionModel(
                        type: _type,
                        amount: int.parse(_amountController.text),
                        category: _selectedCategory,
                        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                        description: _descriptionController.text,
                      );
                      Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaksi berhasil disimpan!')),
                      );
                      _amountController.clear();
                      _descriptionController.clear();
                    }
                  },
                  child: const Text('Simpan Transaksi', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}