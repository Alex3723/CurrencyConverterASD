import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:currency_converter/main.dart';

void main() {
  testWidgets('Verifica inserimento importo', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(TextField), '100');

    await tester.pump();

    expect(find.text('100'), findsOneWidget);
  });

  testWidgets('Verifica presenza del pulsante Dettagli', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dettagli'), findsOneWidget);
  });
}
