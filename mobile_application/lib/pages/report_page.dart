import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../models/transaction_model.dart';

class ReportPage extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ReportPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expenseTransactions =
        transactions.where((t) => t.type == 'Expense').toList();

    if (expenseTransactions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Expense Report")),
        body: const Center(
          child: Text("No expense data to display."),
        ),
      );
    }

    // Group expenses by category
    final Map<String, double> categoryTotals = {};
    for (var t in expenseTransactions) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    final totalExpense = categoryTotals.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(title: const Text("Expense Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PieChart(
              dataMap: categoryTotals,
              chartRadius: MediaQuery.of(context).size.width / 2,
              animationDuration: const Duration(seconds: 1),
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
              ),
              legendOptions: const LegendOptions(
                showLegends: true,
                legendPosition: LegendPosition.bottom,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Total Expenses: \$${totalExpense.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: categoryTotals.entries.map((entry) {
                  return ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(entry.key),
                    trailing: Text(
                      "\$${entry.value.toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
