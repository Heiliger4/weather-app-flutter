// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:project_name/models/weather_model.dart';
import '../services/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('eda11fcd154caa4ceffd983d0249b011');
  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;

  // Fetch weather based on user input
  _fetchWeather() async {
    final cityName = _cityController.text;
    if (cityName.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch weather data'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Get weather animation based on condition
  Widget getWeatherAnimation(String? condition, double? temperature) {
    if (temperature != null) {
      if (temperature >= 20 && temperature <= 30) {
        return Lottie.asset('assets/sunny.json');
      } else if (temperature < 10) {
        return Lottie.asset('assets/thunder.json');
      } else if (temperature >= 10 && temperature < 15) {
        return Lottie.asset('assets/cloud.json');
      } else if (temperature >= 15 && temperature < 20) {
        return Lottie.asset('assets/rainy.json');
      }
    }
    return Lottie.asset('assets/sunny.json');
  }

  // Modern temperature display widget
  Widget _buildTemperatureCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "${_weather?.temperature.round()}°C",
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            _weather?.mainCondition ?? '',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // Modern weather detail item with better contrast
  Widget _buildDetailItem(IconData icon, String title, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Search Section
                  Column(
                    children: [
                      const Text(
                        'Weather Forecast',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'Enter city or country',
                          labelStyle: const TextStyle(color: Colors.blue),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.blue),
                            onPressed: _fetchWeather,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchWeather,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 16),
                        ),
                        child: const Text(
                          'Get Weather',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),

                  // Weather Display
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 40),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.blue,
                            strokeWidth: 5,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Fetching weather for ${_cityController.text}...',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_weather != null)
                    Column(
                      children: [
                        const SizedBox(height: 30),
                        // City name
                        Text(
                          _weather?.cityName ?? '',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Animation
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: getWeatherAnimation(
                            _weather?.mainCondition,
                            _weather?.temperature,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Temperature card
                        _buildTemperatureCard(),
                        const SizedBox(height: 30),
                        // Weather details
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: [
                            _buildDetailItem(
                              Icons.water_drop,
                              'Humidity',
                              '${_weather?.humidity ?? 0}%',
                              Colors.blue.shade600,
                            ),
                            _buildDetailItem(
                              Icons.air,
                              'Wind Speed',
                              '${_weather?.windSpeed ?? 0} m/s',
                              Colors.blue.shade500,
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}