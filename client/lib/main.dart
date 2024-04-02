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
            const Padding(
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
            const SizedBox(height: 16), // Add some space between text and image
            Padding(
              padding: const EdgeInsets.only(bottom: 38.0), // Add padding only at the bottom
              child: Center(
                child: Image.asset(
                  'assets/images/rain-none.png', // Adjust path as per your asset location
                  height: 150, // Adjust height as needed
                  width: 200, // Adjust width as needed
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/check.png', // Adjust path as per your asset location
                height: 180, // Adjust height as needed
                width: 150, // Adjust width as needed
              ),
            ),
            const SizedBox(height: 1),
            const Divider(
              color: Colors.white,
              thickness: 1.0,
            ),
            // Add text widget below the divider
            Center(
              child: Text(
                '+3HR PREDICTION',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


