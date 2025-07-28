import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDark;

  const RegisterView({super.key, required this.toggleTheme, required this.isDark});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  Future<void> _register() async {
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Les mots de passe ne correspondent pas');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (_) => LoginView(
          toggleTheme: (bool value) => widget.toggleTheme(value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("S'enregistrer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Nom d\'utilisateur')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
            TextField(controller: _confirmController, decoration: const InputDecoration(labelText: 'Confirmer mot de passe'), obscureText: true),
            ElevatedButton(onPressed: _register, child: const Text('S\'enregistrer')),
          ],
        ),
      ),
    );
  }
}
