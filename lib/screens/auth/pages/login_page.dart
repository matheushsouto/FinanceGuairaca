import 'package:financing_app/screens/auth/pages/expenses_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/auth_service.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;
  bool _success = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.9,
              maxHeight: size.height * 0.9,
            ),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet, size: 80, color: Colors.blueAccent),
                      const SizedBox(height: 16),
                      Text(
                        'Finance App',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blueAccent),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v != null && v.contains('@') ? null : 'Digite um email válido',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (v) => v != null && v.length >= 6 ? null : 'A senha deve ter no mínimo 6 caracteres',
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                      if (_success) ...[
                        const SizedBox(height: 16),
                        Text(
                          'Login efetuado com sucesso!',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                      const SizedBox(height: 24),
                      auth.isLoading
                          ? const CircularProgressIndicator()
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _signIn,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text('Entrar', style: TextStyle(fontSize: 16)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: _signUp,
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      side: const BorderSide(color: Colors.blueAccent),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    child: const Text(
                                      'Criar Conta',
                                      style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _error = null;
      _success = false;
    });

    try {
      await context.read<AuthService>().signIn(_email.text.trim(), _password.text.trim());

      // Redireciona para ExpensesPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ExpensesPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _handleFirebaseError(e));
    } catch (e) {
      setState(() => _error = 'Erro inesperado: ${e.toString()}');
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _error = null;
      _success = false;
    });

    try {
      await context.read<AuthService>().signUp(_email.text.trim(), _password.text.trim());

      // Redireciona para ExpensesPage após criar conta
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ExpensesPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _handleFirebaseError(e));
    } catch (e) {
      setState(() => _error = 'Erro inesperado: ${e.toString()}');
    }
  }

  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado para esse email.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Esse email já está cadastrado.';
      case 'invalid-email':
        return 'Email inválido.';
      default:
        return e.message ?? 'Erro de autenticação';
    }
  }
}
