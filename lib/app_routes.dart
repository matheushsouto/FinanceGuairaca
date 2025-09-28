import 'package:flutter/material.dart';
import '../screens/auth/pages/login_page.dart';

class AppRoutes {
  // Nome da rota
  static const login = '/login';

  // Mapa de rotas
  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
  };
}
