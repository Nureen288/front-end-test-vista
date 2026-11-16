import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'providers/company_provider.dart';
import 'screens/company_list_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CompanyProvider(ApiService())..loadCompanies(),
      child: const VistaApp(),
    ),
  );
}

class VistaApp extends StatelessWidget {
  const VistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vista Test',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const CompanyListScreen(),
    );
  }
}