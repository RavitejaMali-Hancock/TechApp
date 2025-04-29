import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'token_service.dart';
import 'pkce_helper.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({Key? key}) : super(key: key);

  @override
  State<LoginWebView> createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  late final WebViewController _controller;
  late final String _codeVerifier;
  late final String _codeChallenge;

  final String clientId = '3MVG9ux34Ig8G5eqIauOrPZUkXrLqF8t_mzuuttPTOBPSURRrIdS4flBhi_mKh5mW89HrH50B.Hs212PyJI6l';
  final String redirectUri = 'myapp://login-callback';

  @override
  void initState() {
    super.initState();
    _codeVerifier = PKCEHelper.generateCodeVerifier();
    _codeChallenge = PKCEHelper.generateCodeChallenge(_codeVerifier);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (navRequest) {
          final url = navRequest.url;
          if (url.startsWith(redirectUri)) {
            final uri = Uri.parse(url);
            final code = uri.queryParameters['code'];

            if (code != null) {
              TokenService.exchangeToken(
                code: code,
                codeVerifier: _codeVerifier,
                clientId: clientId,
                redirectUri: redirectUri,
              ).then((success) {
                if (success && mounted) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              });
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(buildLoginUrl()));
  }

  String buildLoginUrl() {
    return 'https://mrtpvtltd-dev-ed.develop.my.site.com/HancockTechPortal/services/oauth2/authorize'
        '?response_type=code'
        '&client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&scope=openid%20api%20refresh_token'
        '&code_challenge=$_codeChallenge'
        '&code_challenge_method=S256';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salesforce Login')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
