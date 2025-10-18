import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  double amount = 0;
  String type = 'Expense';
  String category = 'Food'; // default
  final categories = ['Food', 'Transport', 'Bills', 'Shopping', 'Health', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expenses")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => title = value!,
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => amount = double.parse(value!),
                validator: (value) => value!.isEmpty ? 'Enter Price' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: type,
                items: ['Income', 'Expense']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) => setState(() => type = value!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 10),
              if (type == 'Expense')
                DropdownButtonFormField<String>(
                  value: category,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) => setState(() => category = value!),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newTransaction = TransactionModel(
                      title: title,
                      amount: amount,
                      type: type,
                      date: DateTime.now(),
                      category: type == 'Expense' ? category : 'N/A',
                    );
                    Navigator.pop(context, newTransaction);
                  }
                },
                child: const Text("Add Expenses"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
