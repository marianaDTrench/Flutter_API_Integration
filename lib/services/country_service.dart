import 'package:dio/dio.dart';
import 'package:flutter_world_explorer/models/country_model.dart';

class CountryService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://restcountries.com/v3.1',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

   // Endpoint 1: Get all countries
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await _dio.get('/all?fields=name,capital,region,subregion,population,flags,cca2,languages,currencies');
      final List data = response.data;
      return data.map((e) => CountryModel.fromJson(e)).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } on DioException catch (e) {
      throw Exception('Failed to load countries: ${e.message}');
    }
  }

    // Endpoint 2: Search countries by name
  Future<List<CountryModel>> searchByName(String name) async {
    try {
      final response = await _dio.get('/name/$name');
      final List data = response.data;
      return data.map((e) => CountryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Search failed: ${e.message}');
    }
  }

    // Endpoint 3: Get countries by region
  Future<List<CountryModel>> getByRegion(String region) async {
    try {
      final response = await _dio.get('/region/$region');
      final List data = response.data;
      return data.map((e) => CountryModel.fromJson(e)).toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } on DioException catch (e) {
      throw Exception('Failed to load region: ${e.message}');
    }
  }

    // Endpoint 4: Get country by code 
          //examples sa code:
        // 'PH' → Philippines
        // 'JP' → Japan
        // 'US' → United States
        // 'BR' → Brazil
  Future<CountryModel> getByCode(String code) async {
    try {
      final response = await _dio.get('/alpha/$code');
      final List data = response.data;
      return CountryModel.fromJson(data.first);
    } on DioException catch (e) {
      throw Exception('Failed to load country detail: ${e.message}');
    }
  }
}