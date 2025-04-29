import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();

    final tempController = WebViewController();
    await tempController.loadRequest(
      Uri.parse('https://mrtpvtltd-dev-ed.develop.my.site.com/HancockTechPortal/secur/logout.jsp'),
    );

    await Future.delayed(const Duration(seconds: 2));

    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 50, color: Colors.blue),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: 2, // 2 columns
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildMenuCard('Inbox', Icons.inbox, () {
              // TODO: Open Inbox page
            }),
            _buildMenuCard('Sent', Icons.send, () {
              // TODO: Open Sent page
            }),
            _buildMenuCard('Group', Icons.group, () {
              // TODO: Open Group page
            }),
            _buildMenuCard('Draft', Icons.edit, () {
              // TODO: Open Drafts page
            }),
          ],
        ),
      ),
    );
  }
}
