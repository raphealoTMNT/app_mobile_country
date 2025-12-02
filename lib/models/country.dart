class Country {
  final String name;
  final String capital;
  final String region;
  final String flagurl;
  final String population;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.flagurl,
    required this.population,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'capital': capital,
      'region': region,
      'flagurl': flagurl,
      'population': population,
    };
  }

  factory Country.fromJson(Map<String, dynamic> json) {
    String name = 'Inconnu';
    if (json['name'] != null) {
      if (json['name'] is String) {
        name = json['name'] as String;
      } else if (json['name'] is Map) {
        name = json['name']['common']?.toString() ?? 
               json['name']['official']?.toString() ?? 
               'Inconnu';
      } else {
        name = json['name'].toString();
      }
    }
    
    String capital = 'N/A';
    if (json['capital'] != null) {
      if (json['capital'] is String) {
        capital = json['capital'] as String;
      } else if (json['capital'] is List && (json['capital'] as List).isNotEmpty) {
        capital = (json['capital'] as List)[0].toString();
      } else {
        capital = json['capital'].toString();
      }
    }
    
    String region = json['region']?.toString() ?? 'N/A';
    
    String flagurl = '';
    if (json['flags'] != null && json['flags'] is Map) {
      flagurl = json['flags']['png']?.toString() ?? 
                json['flags']['svg']?.toString() ?? '';
    } else if (json['flag'] != null) {
      flagurl = json['flag'].toString();
    }
    
    String population = json['population']?.toString() ?? '0';
    
    return Country(
      name: name,
      capital: capital,
      region: region,
      flagurl: flagurl,
      population: population,
    );
  }
}
