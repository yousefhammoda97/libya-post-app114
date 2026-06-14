import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _baseUrl = 'https://tracking.libyapost.ly:7040/api/govems';
  static const _keyToken = 'api_token';
  static const _keyUserId = 'user_id';
  static const _keyUsername = 'username';
  static const _keyRole = 'role';
  static const _keyOffice = 'office_cd';

  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api_login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_keyToken, data['token']);
        await prefs.setString(_keyUserId, data['user_id'].toString());
        await prefs.setString(_keyUsername, data['username'] ?? username);
        await prefs.setString(_keyRole, data['role'] ?? 'delivery');
        await prefs.setString(_keyOffice, data['post_office_code'] ?? '');
        return {'success': true};
      }
      return {'success': false, 'message': data['message'] ?? 'فشل تسجيل الدخول'};
    } catch (e) {
      return {'success': false, 'message': 'تعذّر الاتصال بالخادم'};
    }
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) != null;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? '';
  }

  static Future<String> getOffice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyOffice) ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
