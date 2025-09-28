import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  AuthService() {
    _auth.authStateChanges().listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
