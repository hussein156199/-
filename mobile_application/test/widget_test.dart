import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build the FinanceTrackerApp and trigger a frame.
    await tester.pumpWidget(const FinanceTrackerApp());

    // Verify that the app's main title appears.
    expect(find.text('Finance Dashboard'), findsOneWidget);
  });
}
