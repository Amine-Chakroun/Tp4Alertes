import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp4_alertes/main.dart';

void main() {
  const channel = MethodChannel('alerte/notifier');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      switch (call.method) {
        case 'actionInitiale':
          return null;
        case 'demanderPermission':
          return true;
        case 'notifier':
          return 42;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('PageAlertes affiche les actions et le bouton d\'alerte',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: PageAlertes()));

    expect(find.text('TP 4 – Alertes natives'), findsOneWidget);
    expect(find.text('Autoriser'), findsOneWidget);
    expect(find.text('Envoyer une alerte'), findsOneWidget);
    expect(find.text('aucune'), findsOneWidget);

    await tester.tap(find.text('Envoyer une alerte'));
    await tester.pump();

    expect(find.textContaining('Alerte envoyée'), findsOneWidget);
  });
}
