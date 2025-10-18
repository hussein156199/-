import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onDelete;

  const TransactionTile({super.key, required this.transaction, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(
          transaction.type == "Income"
              ? Icons.arrow_downward
              : Icons.arrow_upward,
          color: transaction.type == "Income" ? Colors.green : Colors.red,
        ),
        title: Text(transaction.title),
        subtitle: Text(
          "${transaction.type} • ${transaction.date.toLocal().toString().split(' ')[0]}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: transaction.type == "Income" ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
