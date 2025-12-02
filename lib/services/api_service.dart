import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class ApiService {
  final String _baseUrl = 'https://www.apicountries.com/countries'; 

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> countriesJson = jsonDecode(response.body);
        return countriesJson.map((json) => Country.fromJson(json)).toList();

      } else {
        throw Exception('Échec du chargement des pays. Statut: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Impossible de se connecter au serveur : $e');
    }
  }
}
