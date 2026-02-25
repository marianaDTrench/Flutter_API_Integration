import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_world_explorer/models/country_model.dart';
import 'package:flutter_world_explorer/services/country_service.dart';
import 'package:flutter_world_explorer/features/country_detail_page.dart';

const kBg = Color(0xFFD4A96A);
const kDark = Color(0xFF3D1F00);
const kLeather = Color(0xFF5C3317);
const kCard = Color(0xFFE8C98A);
const kBorder = Color(0xFFB8864E);
const kSubtext = Color(0xFF7A4F2A);

class CountryRegionPage extends StatefulWidget {
  const CountryRegionPage({super.key});

  @override
  State<CountryRegionPage> createState() => _CountryRegionPageState();
}

class _CountryRegionPageState extends State<CountryRegionPage> {
  final CountryService _service = CountryService();
  final List<Map<String, String>> _regions = [
    {'name': 'Africa', 'emoji': '🌍'},
    {'name': 'Americas', 'emoji': '🌎'},
    {'name': 'Asia', 'emoji': '🌏'},
    {'name': 'Europe', 'emoji': '🏰'},
    {'name': 'Oceania', 'emoji': '🏝️'},
  ];
  String _selectedRegion = 'Asia';
  List<CountryModel> _countries = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load(_selectedRegion);
  }

  Future<void> _load(String region) async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await _service.getByRegion(region);
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
        child: CustomScrollView(
          slivers: [
            // Header scrolls away
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                decoration: const BoxDecoration(
                  color: kDark,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Text(
                  'Regions of the World',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.greatVibes(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE8C98A),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Region tabs below header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _regions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final r = _regions[index];
                      final selected = r['name'] == _selectedRegion;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedRegion = r['name']!);
                          _load(r['name']!);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? kDark : kCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: selected ? kDark : kBorder),
                          ),
                          child: Text(
                            '${r['emoji']} ${r['name']}',
                            style: TextStyle(
                              color: selected ? const Color(0xFFE8C98A) : kSubtext,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Count label
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
                child: Text(
                  _loading ? '' : '${_countries.length} countries in $_selectedRegion',
                  style: const TextStyle(fontSize: 12, color: kSubtext, fontStyle: FontStyle.italic),
                ),
              ),
            ),

            // Grid or loading/error
            if (_loading)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: kLeather)))
            else if (_error != null)
              SliverFillRemaining(child: Center(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 40, color: kSubtext),
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: kSubtext)),
                  TextButton(onPressed: () => _load(_selectedRegion), child: const Text('Retry', style: TextStyle(color: kLeather))),
                ],
              )))
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.95,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final c = _countries[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CountryDetailPage(code: c.cca2))),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: kBorder, width: 1.5),
                            boxShadow: [BoxShadow(color: kDark.withValues(alpha: 0.2), blurRadius: 6, offset: const Offset(2, 3))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                child: Image.network(c.flagUrl, height: 100, width: double.infinity, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(height: 100, color: kBorder),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kDark, fontFamily: 'Georgia')),
                                    const SizedBox(height: 2),
                                    Text(c.capital, maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11, color: kSubtext, fontStyle: FontStyle.italic)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _countries.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}