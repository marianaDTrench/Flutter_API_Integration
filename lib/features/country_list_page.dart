import 'package:flutter/material.dart';
import 'package:flutter_world_explorer/models/country_model.dart';
import 'package:flutter_world_explorer/services/country_service.dart';
import 'package:flutter_world_explorer/features/country_detail_page.dart';

const kBg = Color(0xFFD4A96A);
const kDark = Color(0xFF3D1F00);
const kLeather = Color(0xFF5C3317);
const kSienna = Color(0xFF8B4513);
const kCard = Color(0xFFE8C98A);
const kBorder = Color(0xFFB8864E);
const kSubtext = Color(0xFF7A4F2A);

class CountryListPage extends StatefulWidget {
  const CountryListPage({super.key});

  @override
  State<CountryListPage> createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  final CountryService _service = CountryService();
  List<CountryModel> _countries = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await _service.getAllCountries();
      setState(() { _countries = result; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'World Explorer',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontStyle: FontStyle.italic,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE8C98A),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _loading ? 'Loading...' : '${_countries.length} nations charted',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFF8B6347),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator(color: kLeather));
    if (_error != null) return _buildError();
    if (_countries.isEmpty) return const Center(child: Text('No countries found.'));

    return RefreshIndicator(
      color: kLeather,
      onRefresh: _load,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.95,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          final c = _countries[index];
          return _CountryCard(country: c, onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => CountryDetailPage(code: c.cca2),
            ));
          });
        },
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: kSubtext),
          const SizedBox(height: 12),
          Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: kSubtext)),
          const SizedBox(height: 16),
          TextButton(onPressed: _load, child: const Text('Try again', style: TextStyle(color: kLeather))),
        ],
      ),
    );
  }
}

class _CountryCard extends StatelessWidget {
  final CountryModel country;
  final VoidCallback onTap;

  const _CountryCard({required this.country, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder, width: 1.5),
          boxShadow: [
            BoxShadow(color: kDark.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(2, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flag
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: Image.network(
                country.flagUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  color: kBorder,
                  child: const Icon(Icons.flag, size: 32, color: kSubtext),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: kDark,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    country.capital,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: kSubtext,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}