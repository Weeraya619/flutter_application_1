// ไฟล์ aqi_model.dart (หรือชื่อไฟล์ที่คุณใช้)
import 'dart:convert'; // สำหรับ jsonDecode
import 'package:http/http.dart' as http; // สำหรับการเรียก API

class AqiDataPoint {
  final int aqi;
  final String cityName;
  final double temperature;
  final double humidity;

  AqiDataPoint({
    required this.aqi,
    required this.cityName,
    required this.temperature,
    required this.humidity,
  });

  // factory constructor: ทำหน้าที่แปลง Map (JSON) เป็น Object
  // ส่วนนี้ยังคงเหมือนเดิม เพราะมีหน้าที่ของมันอยู่แล้ว
  factory AqiDataPoint.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data == null) {
      throw Exception('Invalid JSON format: "data" field is missing.');
    }
    
    return AqiDataPoint(
      aqi: data['aqi'] ?? 0, // ใช้ ?? 0 เพื่อป้องกันค่า null
      cityName: data['city']['name'] ?? 'Unknown City',
      temperature: (data['iaqi']['t']?['v'] as num? ?? 0).toDouble(),
      humidity: (data['iaqi']['h']?['v'] as num? ?? 0).toDouble(), // *** แก้ไข: API ส่วนใหญ่ใช้ 'h' ไม่ใช่ 'hu.h' ***
    );
  }

  // --- ส่วนที่เพิ่มเข้ามา ---
  // static method: ทำหน้าที่ดึงข้อมูลจาก API แล้วสร้าง Object ของตัวเอง
  static Future<AqiDataPoint> fetchData(String cityName) async {
    // 1. กำหนดค่า Token และ URL ที่นี่
    const String token = "f2df2a2701e8abb1e823e03eb15f7c94cdffbbdc";
    final url = Uri.https(
      'api.waqi.info',
      '/feed/$cityName/',
      {'token': token},
    );

    print('Requesting data from: $url'); // สำหรับ Debug

    try {
      // 2. เรียก API
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 3. ถ้าสำเร็จ แปลง JSON String เป็น Map
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // 4. เรียกใช้ factory constructor ของตัวเองเพื่อสร้าง Object แล้ว return
        return AqiDataPoint.fromJson(jsonResponse);
      } else {
        // ถ้าไม่สำเร็จ โยน Error
        throw Exception('Failed to load AQI data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // ดักจับ Error อื่นๆ เช่น ไม่มีอินเทอร์เน็ต
      throw Exception('An error occurred: $e');
    }
  }
}