import 'package:flutter/material.dart';
import 'dart:async';

class IncomingCallPage extends StatefulWidget {
  const IncomingCallPage({super.key});

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    print('通話画面が表示されました');
    // 10分後に自動で戻す
    _timer = Timer(const Duration(minutes: 10), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/'); // グラフページに戻る
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("通話中...", style: TextStyle(color: Colors.white, fontSize: 28)),
            const SizedBox(height: 40),
            FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Icon(Icons.call_end),
            )
          ],
        ),
      ),
    );
  }
}