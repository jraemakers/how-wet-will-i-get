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
            SizedBox(height: 16), // Add some space between text and image
            Center(
              child: Image.asset(
                'assets/images/rain-none.png', // Adjust path as per your asset location
                height: 180, // Adjust height as needed
                width: 200, // Adjust width as needed
              ),
            ),
              Center(
              child: Image.asset(
                'assets/images/check.png', // Adjust path as per your asset location
                height: 200, // Adjust height as needed
                width: 150, // Adjust width as needed
              ),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.white,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}


