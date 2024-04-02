import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF0077B6),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 68.0),
              child: Center(
                child: Text(
                  'HOW WET WILL I GET?',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            SizedBox(height: 400),
            Divider(
              color: Colors.white,
              thickness: 1.0,
            ),
            // Add Image widget
            Center(
              child: Image.asset(
                'assets/images/rain-hard.png', // Adjust path as per your asset location
                height: 100, // Adjust height as needed
                width: 100, // Adjust width as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}


