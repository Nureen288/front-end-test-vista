import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/company.dart';
import '../models/service.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Future<List<Company>> getCompanies() async {
    final data = await _send(
      () => _client.get(Uri.parse('$apiBaseUrl/companies')),
    );

    return (data as List<dynamic>)
        .map((c) => Company.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  Future<Company> createCompany({
    required String name,
    required String registrationNumber,
  }) async {
    final data = await _send(
      () => _client.post(
        Uri.parse('$apiBaseUrl/companies'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'name': name,
          'registrationNumber': registrationNumber,
        }),
      ),
    );

    return Company.fromJson(data as Map<String, dynamic>);
  }

  Future<Service> createService({
    required int companyId,
    required String name,
    required String description,
    required double price,
  }) async {
    final data = await _send(
      () => _client.post(
        Uri.parse('$apiBaseUrl/services'),
        headers: _jsonHeaders,
        body: jsonEncode({
          'companyId': companyId,
          'name': name,
          'description': description,
          'price': price,
        }),
      ),
    );

    return Service.fromJson(data as Map<String, dynamic>);
  }

  // Sends the request, decodes the JSON and turns any failure into an ApiException
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(const Duration(seconds: 10));
      final body = response.body.isEmpty ? null : jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      }
      throw ApiException(_errorMessage(body, response.statusCode));
    } on TimeoutException {
      throw ApiException('The server took too long to respond. Please try again.');
    } on http.ClientException {
      throw ApiException('Cannot reach the server. Check that the backend is running.');
    } on FormatException {
      throw ApiException('Unexpected response from the server.');
    }
  }

  // The backend sends { message, errors? }, so show the field errors if there are any
  String _errorMessage(dynamic body, int statusCode) {
    if (body is Map<String, dynamic>) {
      final errors = body['errors'];
      if (errors is List && errors.isNotEmpty) {
        return errors.map((e) => e['message']).join('\n');
      }
      if (body['message'] is String) {
        return body['message'] as String;
      }
    }
    return 'Request failed (status $statusCode)';
  }
}