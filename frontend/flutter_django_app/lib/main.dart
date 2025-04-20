
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Django',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = 'Press the button';
  bool _isLoading = false;

  Future<void> _fetchMessage() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/hello/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));  // Add timeout

      final data = jsonDecode(response.body);

      setState(() {
        _message = (response.statusCode == 200)
            ? data['message']
            : 'Server error: ${response.statusCode}';
      });

    } on SocketException {
      setState(() => _message = 'Network error: Cannot reach server');
    } on TimeoutException {
      setState(() => _message = 'Request timeout');
    } on FormatException {
      setState(() => _message = 'Invalid server response');
    } catch (e) {
      setState(() => _message = 'Unexpected error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter + Django')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _fetchMessage,
              child: Text('Get Message from Django'),
            ),
          ],
        ),
      ),
    );
  }
}