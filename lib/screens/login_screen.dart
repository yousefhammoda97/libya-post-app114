import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (_userCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      _snack('يرجى إدخال اسم المستخدم وكلمة المرور');
      return;
    }
    setState(() => _loading = true);
    final result = await AuthService.login(_userCtrl.text.trim(), _passCtrl.text);
    setState(() => _loading = false);
    if (result['success']) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      _snack(result['message'] ?? 'فشل تسجيل الدخول');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFFD63031)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Yellow hero header
          Container(
            width: double.infinity,
            color: const Color(0xFFF5C800),
            padding: const EdgeInsets.only(top: 80, bottom: 36),
            child: Column(children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(color: const Color(0xFF1A7ABF), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.local_post_office_rounded, color: Colors.white, size: 46),
              ),
              const SizedBox(height: 14),
              const Text('Libya Post', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A3A5C))),
              const SizedBox(height: 4),
              const Text('تطبيق عمليات التوصيل', style: TextStyle(fontSize: 14, color: Color(0xFF1A3A5C))),
            ]),
          ),
          // White form
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 8),
                const Text('اسم المستخدم', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                TextField(controller: _userCtrl, textDirection: TextDirection.ltr, decoration: const InputDecoration(hintText: 'أدخل اسم المستخدم')),
                const SizedBox(height: 14),
                const Text('كلمة المرور', style: TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('تسجيل الدخول'),
                ),
                const Spacer(),
                const Center(child: Text('للاستخدام الداخلي — موظفو التوصيل فقط', style: TextStyle(fontSize: 12, color: Colors.grey))),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
