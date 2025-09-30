
import 'package:http/http.dart' as http;
import 'week4.dart'; // import model ที่เราสร้างไว้

class ApiService {
  // ใส่ Token ของคุณที่ได้มาตรงนี้
  final String _token = "f2df2a2701e8abb1e823e03eb15f7c94cdffbbdc"; 
  final String _baseUrl = "https://api.waqi.info/feed";

  Future<AqiResponse> fetchAqiData(String cityName) async {
    // สร้าง URL ที่สมบูรณ์
    final url = Uri.parse('$_baseUrl/$cityName/?token=$_token');

    print('Requesting data from: $url'); // สำหรับ Debug

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // ถ้าสำเร็จ (200 OK) ให้แปลง JSON String เป็น Object ของเรา
      return aqiResponseFromJson(response.body);
    } else {
      // ถ้าไม่สำเร็จ ให้โยน Error
      throw Exception('Failed to load AQI data. Status code: ${response.statusCode}');
    }
  }
}