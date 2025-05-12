import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    print('プロフィール画面が表示されました');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          'ここにプロフィール情報を表示',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}