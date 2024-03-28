import 'package:dio/dio.dart';

Dio createDio(String token) {
  final dio = Dio();
  dio.options.baseUrl = 'https://apiprint.webevolui.com';
  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  return dio;
}
