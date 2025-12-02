import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/api_service.dart';

class CountryProvider with ChangeNotifier {
  List<Country> _countries = []; 
  List<Country> get countries => _countries; 

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final Set<String> _favorites = {};
  Set<String> get favorites => _favorites;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  final ApiService _apiService = ApiService();

  Future<void> loadCountries() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _countries = await _apiService.fetchCountries();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
      _countries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String countryName) {
    return _favorites.contains(countryName);
  }

  void toggleFavorite(Country country) {
    if (_favorites.contains(country.name)) {
      _favorites.remove(country.name);
    } else {
      _favorites.add(country.name);
    }
    notifyListeners();
  }

  List<Country> get favoriteCountries {
    return _countries.where((country) => _favorites.contains(country.name)).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Country> get filteredCountries {
    if (_searchQuery.isEmpty) return _countries;
    final q = _searchQuery.toLowerCase();
    return _countries.where((c) {
      final name = c.name.toLowerCase();
      final capital = c.capital.toLowerCase();
      return name.contains(q) || capital.contains(q);
    }).toList();
  }
}
