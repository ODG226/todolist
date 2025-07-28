import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'home_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  final Function(bool) toggleTheme;
  const LoginView({super.key, required this.toggleTheme});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString('username');
    final storedPass = prefs.getString('password');

    if (_usernameController.text == storedUser && _passwordController.text == storedPass) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
    } else {
      setState(() => _error = 'Nom d\'utilisateur ou mot de passe incorrect');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Connexion'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => widget.toggleTheme(!isDark),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 120,
                          autoPlay: true,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                        ),
                        items: [
                          'assets/banner3.png',
                          'assets/banner.jpg',
                          'assets/banner2.png',
                        ].map((item) => Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )).toList(),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),

            const Icon(Icons.login, size: 64, color: Colors.indigo),
                  const SizedBox(height: 8),
                  const Text(
                    "Bienvenue sur NoteApp !",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Veuillez vous connecter pour continuer",
                    style: TextStyle(fontSize: 16),
                  ),
            const SizedBox(height: 20),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => _login(),
              child: const Text('Se connecter'),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterView(
                    toggleTheme: widget.toggleTheme,
                    isDark: isDark,
                  ),
                ),
              ),
              child: const Text("Créer un compte"),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'A propos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail_outlined),
            label: 'Contact',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            showAboutDialog(
              context: context,
              applicationName: 'NoteApp',
              applicationVersion: '1.0.0',
              children: [
                const Text('NoteApp est une application de prise de notes simple et efficace.')
              ],
            );
          } else if (index == 1) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Contact'),
                content: const Text('Pour toute question, contactez-nous à contact@noteapp.com'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}