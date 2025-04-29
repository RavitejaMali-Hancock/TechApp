import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const _tokenUrl = 'https://mrtpvtltd-dev-ed.develop.my.site.com/HancockTechPortal/services/oauth2/token';
  static final _storage = FlutterSecureStorage();

  static Future<bool> exchangeToken({
    required String code,
    required String codeVerifier,
    required String clientId,
    required String redirectUri,
  }) async {
    final response = await http.post(
      Uri.parse(_tokenUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'grant_type': 'authorization_code',
        'client_id': clientId,
        'code': code,
        'redirect_uri': redirectUri,
        'code_verifier': codeVerifier,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _storage.write(key: 'access_token', value: data['access_token']);
      await _storage.write(key: 'refresh_token', value: data['refresh_token']);
      await _storage.write(key: 'instance_url', value: data['instance_url']);

      return true;
    } else {
      print('❌ Token exchange failed: ${response.body}');
      return false;
    }
  }
}
