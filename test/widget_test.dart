import 'package:flutter/material.dart';  
import 'package:flutter_test/flutter_test.dart';
import 'package:myd_resorts/main.dart';  


void main() {  
  testWidgets('ResortsScreen has a title and resort cards', (WidgetTester tester) async {  
    // Carregue o aplicativo na tela de testes.  
    await tester.pumpWidget(MyApp());  

    // Verifique se o título está presente.  
    expect(find.text('MYD RESORTS'), findsOneWidget);  

    // Verifique se os cartões dos resorts estão presentes.  
    expect(find.byType(ResortCard), findsNWidgets(3)); // Verifica se existem 3 cartões.  
    
    // Verificar se o botão "CONTINUAR" está presente.  
    expect(find.text('CONTINUAR'), findsOneWidget);  
  });  

  testWidgets('ResortCard displays correct data', (WidgetTester tester) async {  
    // Carregue o aplicativo na tela de testes.  
    await tester.pumpWidget(MyApp());  

    // Verifique se um card específico está exibido corretamente.  
    expect(find.text('Resort Lagoas'), findsOneWidget);  
    expect(find.text('Lisboa, PORT'), findsOneWidget);  
    expect(find.text('⭐⭐⭐⭐'), findsOneWidget);  
    expect(find.text('\$500,00 P/dia'), findsOneWidget);  
    
    // Verificar se há um checkbox no card do resort.  
    expect(find.byType(Checkbox), findsOneWidget);  
  });  

  testWidgets('Pressing CONTINUAR button triggers action', (WidgetTester tester) async {  
    // Carregue o aplicativo na tela de testes.  
    await tester.pumpWidget(MyApp());  

    // Pressione o botão "CONTINUAR".  
    await tester.tap(find.text('CONTINUAR'));  
    await tester.pump(); // Rebuild the widget  

    // Aqui você pode adicionar verificações para ações específicas que deseja testar após pressionar o botão.  
  });  
}