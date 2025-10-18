// lib/models/transaction_model.dart
class TransactionModel {
  final String title;
  final double amount;
  final String type; // "Income" or "Expense"
  final DateTime date;
  final String category;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<dynamic, dynamic> map) {
    return TransactionModel(
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      type: map['type'] as String,
      date: DateTime.parse(map['date'] as String),
      category: map['category'] as String,
    );
  }
}
