import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  // Open a box to store all transactions
  await Hive.openBox('transactionsBox');

  runApp(const FinanceTrackerApp());
}

class FinanceTrackerApp extends StatefulWidget {
  const FinanceTrackerApp({super.key});

  @override
  State<FinanceTrackerApp> createState() => _FinanceTrackerAppState();
}

class _FinanceTrackerAppState extends State<FinanceTrackerApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق مصروفي',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
      home: HomePage(
        isDarkMode: _isDarkMode,
        onThemeToggle: toggleTheme,
      ),

      // 👇 إعدادات اللغة والاتجاه
      locale: const Locale('ar', ''), // اللغة العربية
      supportedLocales: const [
        Locale('ar', ''), // Arabic
        Locale('en', ''), // English (optional)
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
