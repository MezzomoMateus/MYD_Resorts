import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    // Inicializa o databaseFactory para usar a versão FFI
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Teste do seu widget', (WidgetTester tester) async {
    // Seu código de teste aqui
  });
}
