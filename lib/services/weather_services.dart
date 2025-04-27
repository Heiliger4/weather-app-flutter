import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_name/models/weather_model.dart';

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String API_KEY;

  WeatherService(this.API_KEY);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$API_KEY&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather dataeee');
    }
  }

  // Optionally, you could implement getCurrentCity method if you still want it
}
