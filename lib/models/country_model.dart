class CountryModel {
  final String name;
  final String officialName;
  final String capital;
  final String region;
  final String subregion;
  final int population;
  final String flagUrl;
  final String cca2;
  final List<String> languages;
  final String currency;

  const CountryModel({
    required this.name,
    required this.officialName,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.flagUrl,
    required this.cca2,
    required this.languages,
    required this.currency,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    // Parse capital
    final capitalList = json['capital'] as List<dynamic>?;
    final capital = capitalList != null && capitalList.isNotEmpty
        ? capitalList[0].toString()
        : 'N/A';

    // Parse languages
    final langsMap = json['languages'] as Map<String, dynamic>?;
    final languages = langsMap != null ? langsMap.values.map((e) => e.toString()).toList() : <String>[];

    // Parse currency
    final currenciesMap = json['currencies'] as Map<String, dynamic>?;
    String currency = 'N/A';
    if (currenciesMap != null && currenciesMap.isNotEmpty) {
      final first = currenciesMap.values.first as Map<String, dynamic>;
      final name = first['name'] ?? '';
      final symbol = first['symbol'] ?? '';
      currency = '$name ($symbol)';
    }

    return CountryModel(
      name: json['name']['common'] ?? 'Unknown',
      officialName: json['name']['official'] ?? 'Unknown',
      capital: capital,
      region: json['region'] ?? 'N/A',
      subregion: json['subregion'] ?? 'N/A',
      population: json['population'] ?? 0,
      flagUrl: json['flags']?['png'] ?? '',
      cca2: json['cca2'] ?? '',
      languages: languages,
      currency: currency,
    );
  }
}
