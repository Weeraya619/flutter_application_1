// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'api_service.dart';
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
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.ubuntuTextTheme(),
      ),
      home: const AqiScreen(),
    );
  }
}

class AqiScreen extends StatefulWidget {
  const AqiScreen({super.key});

  @override
  State<AqiScreen> createState() => _AqiScreenState();
}

class _AqiScreenState extends State<AqiScreen> {
  final ApiService _apiService = ApiService();
  late Future<AqiResponse> _aqiDataFuture;

  // เมืองที่เราต้องการดึงข้อมูล
  final String _city = "bankok";

  @override
  void initState() {
    super.initState();
    // เริ่มดึงข้อมูลทันทีที่หน้าจอนี้ถูกสร้าง
    _aqiDataFuture = _apiService.fetchAqiData(_city);
  }

  // ฟังก์ชันสำหรับ Refresh ข้อมูล
  void _refreshData() {
    setState(() {
      _aqiDataFuture = _apiService.fetchAqiData(_city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Air Quality Index (AQI)'),
      ),
      body: Center(
        child: FutureBuilder<AqiResponse>(
          future: _aqiDataFuture,
          builder: (context, snapshot) {
            // กรณี: กำลังโหลดข้อมูล
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            // กรณี: เกิด Error
            else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            // กรณี: โหลดข้อมูลสำเร็จ
            else if (snapshot.hasData) {
              // ดึงข้อมูลออกมาจาก snapshot
              final aqiData = snapshot.data!.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 1. แสดงชื่อเมือง
                    Text(
                      aqiData.city.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    // Container สำหรับแสดงค่า AQI
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      decoration: BoxDecoration(
                        color: _getAqiColor(aqiData.aqi), // เปลี่ยนสีตามค่า AQI
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        // 2. แสดงค่า AQI
                        aqiData.aqi.toString(),
                        style: const TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // แสดงสถานะคุณภาพอากาศ
                    Text(
                      _getAqiStatus(aqiData.aqi),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    // 3. แสดงอุณหภูมิ
                    Text(
                      'Temperature: ${aqiData.iaqi.t.v}°C',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 40),
                    // ปุ่ม Refresh
                    ElevatedButton.icon(
                      onPressed: _refreshData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }
            // กรณีอื่นๆ (ไม่ควรเกิดขึ้น)
            return const Text('No data found.');
          },
        ),
      ),
    );
  }

  // Helper function เพื่อเปลี่ยนสีตามค่า AQI
  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow.shade700;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }
  
  // Helper function เพื่อแสดงสถานะตามค่า AQI
  String _getAqiStatus(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }
}