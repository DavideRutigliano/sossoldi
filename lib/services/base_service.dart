import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

abstract class BaseService {
  static Future<String?> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('api_url');
    
    if (url != null && url.isNotEmpty) {
      return url;
    }
    return null;
  }
  
  Future<Uri> _createUri(String path, {Map<String, dynamic>? queryParameters}) async {
    String? baseUrl = await _getBaseUrl();
    if (baseUrl == null || baseUrl.isEmpty) {
      baseUrl = 'http://127.0.0.1:8080';
    }
    
    if (!path.startsWith('/')) {
      path = '/$path';
    }

    String fullUrl = baseUrl + path;

    Map<String, String>? stringParams;
    if (queryParameters != null) {
      stringParams = {};
      queryParameters.forEach((key, value) {
        stringParams![key] = value.toString();
      });
    }
    
    return Uri.parse(fullUrl).replace(queryParameters: stringParams);
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final uri = await _createUri(path, queryParameters: queryParameters);
    final response = await http.get(uri);
    return response;
  }

  Future<http.Response> post(String path, dynamic body, {Map<String, dynamic>? queryParameters}) async {
    final uri = await _createUri(path, queryParameters: queryParameters);
    final bodyJson = jsonEncode(body);
    final response = await http.post(uri, body: bodyJson);
    return response;
  }

  Future<http.Response> put(String path, dynamic body, {Map<String, dynamic>? queryParameters}) async {
    final uri = await _createUri(path, queryParameters: queryParameters);
    final bodyJson = jsonEncode(body);
    final response = await http.put(uri, body: bodyJson);
    return response;
  }

  Future<http.Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    final uri = await _createUri(path, queryParameters: queryParameters);
    final response = await http.delete(uri);
    return response;
  }
}
