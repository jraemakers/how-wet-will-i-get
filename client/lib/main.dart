import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String _latitude = 'Unknown';
  String _longitude = 'Unknown';
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String _weatherImage = 'Unknown';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        _latitude = position.latitude.toString();
        _longitude = position.longitude.toString();
      });
      _fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    const apiKey = 'e703b4fa9b3202d8da64ac0141c7a225';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=dili&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _weatherData = data;
          _isLoading = false;
        });

        if (_weatherData!["list"][0]["main"]["rain"] == null) {
          _weatherImage = 'rain-none.png';
        } else if (_weatherData!["list"][0]["main"]["rain"] < 2.5) {
          _weatherImage = 'rain-licht.png';
        } else if (_weatherData!["list"][0]["main"]["rain"] < 7.6) {
          _weatherImage = 'rain-normal.png';
        } else {
          _weatherImage = 'rain-hard.png';
        }
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF0077B6),
        body: _isLoading
            ? const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Column(
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
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 38.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/$_weatherImage',
                        height: 180,
                        width: 180,
                      ),
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/check.png',
                      height: 180,
                      width: 150,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Divider(
                    color: Colors.white,
                    thickness: 1.0,
                  ),
                  const Center(
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 80.0, top: 15),
                        child: Text(
                          'Temp',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 80.0),
                        child: Text(
                          '${_weatherData!["list"][0]["main"]["temp"].round()}',
                          style: const TextStyle(
                            fontSize: 66,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Center(
                      child: Image.asset(
                        'assets/images/$_weatherImage',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                    ],
                    
                  ),
                ],
              ),
      ),
    );
  }
}
