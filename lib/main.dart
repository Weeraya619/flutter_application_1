import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'week4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQI App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C2C2C),
          elevation: 0,
        ),
        textTheme: GoogleFonts.ubuntuTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const AqiScreen(),
    );
  }
}

Color _getAqiColor(int aqi) {
  if (aqi <= 50) return Colors.green;
  if (aqi <= 100) return Colors.yellow.shade700;
  if (aqi <= 150) return Colors.orange;
  if (aqi <= 200) return Colors.red;
  if (aqi <= 300) return Colors.purple;
  return Colors.brown;
}

String _getAqiStatus(int aqi) {
  if (aqi <= 50) return 'Good';
  if (aqi <= 100) return 'Moderate';
  if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
  if (aqi <= 200) return 'Unhealthy';
  if (aqi <= 300) return 'Very Unhealthy';
  return 'Hazardous';
}


class AqiScreen extends StatefulWidget {
  const AqiScreen({super.key});

  @override
  State<AqiScreen> createState() => _AqiScreenState();
}

class _AqiScreenState extends State<AqiScreen> {
  Future<AqiDataPoint>? _aqiDataFuture;

  final TextEditingController _cityController = TextEditingController();
  final String _city = "bangkok";

  @override
  void initState() {
    super.initState();
    _fetchDataForCity(_city);
    _cityController.text = _city;
  }

  void _fetchDataForCity(String city) {
    setState(() {
      _aqiDataFuture = AqiDataPoint.fetchData(city);
    });
  }

  void _searchCity() {
    if (_cityController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      _fetchDataForCity(_cityController.text.trim());
    }
  }
  

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Air Quality Index (AQI)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchCard(),
            const SizedBox(height: 20),
            _buildAqiResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      color: const Color(0xFF2C2C2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'Enter city name...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _searchCity(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchCity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAqiResult() {
    if (_aqiDataFuture == null) {
      return const Center(child: Text("Please search for a city."));
    }

    return FutureBuilder<AqiDataPoint>(
      future: _aqiDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'Could not find data for "${_cityController.text}".\nPlease try another city.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          final aqiData = snapshot.data!;
          return Column(
            children: [
              Text(aqiData.cityName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                  color: _getAqiColor(aqiData.aqi),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [ BoxShadow( color: _getAqiColor(aqiData.aqi), blurRadius: 15, offset: const Offset(0, 5),) ]
                ),
                child: Text(aqiData.aqi.toString(), style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Text(
                _getAqiStatus(aqiData.aqi),
                style: TextStyle(color: _getAqiColor(aqiData.aqi), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoChip(Icons.thermostat, '${aqiData.temperature.toStringAsFixed(1)}°C', 'Temperature'),
                  _buildInfoChip(Icons.water_drop_outlined, '${aqiData.humidity.toStringAsFixed(1)}%', 'Humidity'),
                ],
              ),
            ],
          );
        }
        return const Center(child: Text("No data."));
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        Text(label, style: TextStyle(color: Colors.grey[400])),
      ],
    );
  }
}
