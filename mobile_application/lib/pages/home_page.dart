import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_page.dart';
import 'report_page.dart'; // ✅ Import the Report Page

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box transactionsBox;

  @override
  void initState() {
    super.initState();
    transactionsBox = Hive.box('transactionsBox');
  }

  List<TransactionModel> get transactions {
    return transactionsBox.values
        .map((t) => TransactionModel.fromMap(Map<String, dynamic>.from(t)))
        .toList();
  }

  void addTransaction(TransactionModel transaction) {
    transactionsBox.add(transaction.toMap());
    setState(() {});
  }

  void deleteTransaction(int index) {
    transactionsBox.deleteAt(index);
    setState(() {});
  }

  double get totalBalance {
    double balance = 0;
    for (var t in transactions) {
      balance += t.type == "Income" ? t.amount : -t.amount;
    }
    return balance;
  }

  double get totalIncome =>
      transactions.where((t) => t.type == "Income").fold(0, (sum, t) => sum + t.amount);

  double get totalExpense =>
      transactions.where((t) => t.type == "Expense").fold(0, (sum, t) => sum + t.amount);

  String selectedFilter = "All";

  List<TransactionModel> get filteredTransactions {
    if (selectedFilter == "All") return transactions;
    return transactions.where((t) => t.type == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Dashboard"),
        backgroundColor: Colors.green.shade300,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 💰 Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text("Total Balance",
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(
                      "\$${totalBalance.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _summaryBox("Income", totalIncome, Colors.green),
                        _summaryBox("Expense", totalExpense, Colors.red),
                      ],
                    ),
                    const SizedBox(height: 15),
                    // ✅ Added Report Button here
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReportPage(transactions: transactions),
                          ),
                        );
                      },
                      icon: const Icon(Icons.pie_chart, color: Colors.white),
                      label: const Text(
                        "View Report",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),
            // 🔘 Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _filterButton("All"),
                _filterButton("Income"),
                _filterButton("Expense"),
              ],
            ),

            const SizedBox(height: 15),

            // 📋 Transaction List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: transactionsBox.listenable(),
                builder: (context, Box box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text("No transactions yet"));
                  }

                  final filtered = filteredTransactions;

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final transaction = filtered[index];
                      return Dismissible(
                        key: Key(transaction.title + index.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => deleteTransaction(index),
                        child: TransactionTile(
                          transaction: transaction,
                          onDelete: () => deleteTransaction(index),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ➕ Floating Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTransaction = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
          if (newTransaction != null) {
            addTransaction(newTransaction);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _summaryBox(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label,
            style:
                TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text("\$${amount.toStringAsFixed(2)}",
            style: TextStyle(color: color, fontSize: 18)),
      ],
    );
  }

  Widget _filterButton(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.green.shade300,
        onSelected: (_) {
          setState(() {
            selectedFilter = label;
          });
        },
      ),
    );
  }
}
