import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HowWetWillIGet extends StatefulWidget {
  const HowWetWillIGet({super.key, required this.location});

  final String location;

  @override
  _HowWetWillIGetState createState() => _HowWetWillIGetState();
}

class _HowWetWillIGetState extends State<HowWetWillIGet> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String _weatherImage = '';
  String _weatherDescription = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    const apiKey = 'e703b4fa9b3202d8da64ac0141c7a225';
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=${widget.location}&appid=$apiKey&units=metric';

    try {
      final currentWeatherResponse = await http.get(Uri.parse(weatherUrl));

      if (currentWeatherResponse.statusCode == 200) {
        final currentWeatherData = jsonDecode(currentWeatherResponse.body);

        setState(() {
          _weatherData = currentWeatherData;
          _isLoading = false;
        });

        if (_weatherData!["rain"] == null) {
          _weatherImage = 'rain-none.png';
          _weatherDescription = 'check.png';
        } else if (_weatherData!["rain"]["1h"] < 2.5) {
          _weatherImage = 'rain-licht.png';
          _weatherDescription = 'hoodie.png';
        } else if (_weatherData!["rain"]["1h"] < 7.6) {
          _weatherImage = 'rain-normal.png';
          _weatherDescription = 'protection.png';
        } else {
          _weatherImage = 'rain-hard.png';
          _weatherDescription = 'raincoat.png';
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
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 40.0),
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
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/$_weatherImage',
                          height: 180,
                          width: 180,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/$_weatherDescription',
                          height: 180,
                          width: 150,
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_weatherData!["main"]["temp"].round()}',
                            style: const TextStyle(
                              fontSize: 66,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const Text(
                            '°C',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        Text(
                          widget.location,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
