import 'package:financing_app/app_routes.dart';
import 'package:financing_app/services/firebase_initializer.dart';
import 'package:financing_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Finance App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
