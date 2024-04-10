import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String _currentLocation = '';
  String _weatherImage = '';
  String _weatherDescription = '';

  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _getLocation();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    const apiKey = 'e703b4fa9b3202d8da64ac0141c7a225';
    final weatherUrl =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&cnt=1';

    try {
      final currentWeatherResponse = await http.get(Uri.parse(weatherUrl));

      if (currentWeatherResponse.statusCode == 200) {
        final currentWeatherData = jsonDecode(currentWeatherResponse.body);

        setState(() {
          _weatherData = currentWeatherData;
          _currentLocation = _weatherData!["city"]["name"];
          _isLoading = false;
        });

        if (_weatherData!["list"][0]["rain"] == null) {
          _weatherImage = 'rain-none.png';
          _weatherDescription = 'check.png';
        } else if (_weatherData!["list"][0]["rain"]["3h"] < 2.5) {
          _weatherImage = 'rain-licht.png';
          _weatherDescription = 'hoodie.png';
        } else if (_weatherData!["list"][0]["rain"]["3h"] < 7.6) {
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

  Future<void> _handleSubmit(String location) async {
    const apiKey = 'e703b4fa9b3202d8da64ac0141c7a225';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey&units=metric&cnt=2';

    try {
      final currentForecastResponse = await http.get(Uri.parse(forecastUrl));

      if (currentForecastResponse.statusCode == 200) {
        final currentForecastData = jsonDecode(currentForecastResponse.body);

        setState(() {
          _weatherData = currentForecastData;
        });

        if (_weatherData!["list"][1]["rain"] == null) {
          _weatherImage = 'rain-none.png';
          _weatherDescription = 'check.png';
        } else if (_weatherData!["list"][1]["rain"]["3h"] < 2.5) {
          _weatherImage = 'rain-licht.png';
          _weatherDescription = 'hoodie.png';
        } else if (_weatherData!["list"][1]["rain"]["3h"] < 7.6) {
          _weatherImage = 'rain-normal.png';
          _weatherDescription = 'protection.png';
        } else {
          _weatherImage = 'rain-hard.png';
          _weatherDescription = 'raincoat.png';
        }
      } else {
        throw Exception('Failed to load forecast data');
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
                    const SizedBox(height: 16),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              _currentLocation.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: TextField(
                        controller: _locationController,
                        textCapitalization: TextCapitalization.characters,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: _handleSubmit,
                        decoration: const InputDecoration(
                          hintText: 'WHERE TO?',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), 
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), 
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Center(
                        child: Image.asset(
                          'assets/images/$_weatherImage',
                          height: 180,
                          width: 180,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
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
                            '${_weatherData!["list"][0]["main"]["temp"].round()}',
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
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
