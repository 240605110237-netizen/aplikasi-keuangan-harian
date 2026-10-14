class TransactionModel {
  final int? id;
  final String type; // 'pemasukan' atau 'pengeluaran'
  final int amount;
  final String category;
  final String date; // Format YYYY-MM-DD
  final String description;

  TransactionModel({
    this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'category': category,
      'date': date,
      'description': description,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      type: map['type'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
      description: map['description'],
    );
  }
}