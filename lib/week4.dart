// aqi_model.dart
import 'dart:convert';

// ฟังก์ชันช่วยแปลง JSON String เป็น Object
AqiResponse aqiResponseFromJson(String str) => AqiResponse.fromJson(json.decode(str));

class AqiResponse {
    String status;
    Data data;

    AqiResponse({
        required this.status,
        required this.data,
    });

    factory AqiResponse.fromJson(Map<String, dynamic> json) => AqiResponse(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );
}

class Data {
    int aqi;
    City city;
    Iaqi iaqi;

    Data({
        required this.aqi,
        required this.city,
        required this.iaqi,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        aqi: json["aqi"],
        city: City.fromJson(json["city"]),
        iaqi: Iaqi.fromJson(json["iaqi"]),
    );
}

class City {
    String name;

    City({
        required this.name,
    });

    factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
    );
}

class Iaqi {
    Temperature t;

    Iaqi({
        required this.t,
    });

    factory Iaqi.fromJson(Map<String, dynamic> json) => Iaqi(
        t: Temperature.fromJson(json["t"]),
    );
}

class Temperature {
    double v;

    Temperature({
        required this.v,
    });

    factory Temperature.fromJson(Map<String, dynamic> json) => Temperature(
        v: (json["v"] as num).toDouble(),
    );
}