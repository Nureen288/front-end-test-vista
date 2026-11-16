import 'package:flutter/foundation.dart';

import '../models/company.dart';
import '../services/api_service.dart';

class CompanyProvider extends ChangeNotifier {
  final ApiService _api;

  CompanyProvider(this._api);

  List<Company> _companies = [];
  bool _isLoading = false;
  String? _error;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCompanies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _companies = await _api.getCompanies();
    } on ApiException catch (e) {
      _error = e.message;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // The create methods throw ApiException so the form screens can show the error themselves
  Future<void> addCompany({
    required String name,
    required String registrationNumber,
  }) async {
    final company = await _api.createCompany(
      name: name,
      registrationNumber: registrationNumber,
    );
    _companies = [..._companies, company];
    notifyListeners();
  }

  Future<void> addService({
    required int companyId,
    required String name,
    required String description,
    required double price,
  }) async {
    final service = await _api.createService(
      companyId: companyId,
      name: name,
      description: description,
      price: price,
    );

    final index = _companies.indexWhere((c) => c.id == companyId);
    if (index != -1) {
      _companies[index].services.add(service);
    }
    notifyListeners();
  }
}