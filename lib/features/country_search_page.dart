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

class CountrySearchPage extends StatefulWidget {
  const CountrySearchPage({super.key});

  @override
  State<CountrySearchPage> createState() => _CountrySearchPageState();
}

class _CountrySearchPageState extends State<CountrySearchPage> {
  final CountryService _service = CountryService();
  final TextEditingController _controller = TextEditingController();
  List<CountryModel> _results = [];
  bool _loading = false;
  String? _error;
  bool _searched = false;

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;
    setState(() { _loading = true; _error = null; _searched = true; });
    try {
      final result = await _service.searchByName(query);
      setState(() { _results = result; _loading = false; });
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                Text(
                  'Search Nations',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.greatVibes(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE8C98A),
                    letterSpacing: 1.2,
                  ),
                ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onSubmitted: (_) => _search(),
                          style: const TextStyle(color: kDark),
                          decoration: InputDecoration(
                            hintText: 'Enter a country name...',
                            hintStyle: TextStyle(color: kSubtext),
                            filled: true,
                            fillColor: kCard,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: kBorder)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _search,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: const Color(0xFF8B4513), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.search, color: Color(0xFFE8C98A), size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator(color: kLeather));
    if (_error != null) return Center(child: Text(_error!, style: const TextStyle(color: kSubtext)));
    if (!_searched) return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.explore, size: 56, color: Color(0xFFB8864E)),
          SizedBox(height: 12),
          Text('Chart your course...', style: TextStyle(color: Color(0xFF7A4F2A), fontSize: 16)),
        ],
      ),
    );
    if (_results.isEmpty) return const Center(child: Text('No nations found.', style: TextStyle(color: kSubtext, fontFamily: 'DM Mono')));

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final c = _results[index];
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CountryDetailPage(code: c.cca2))),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder, width: 1.5),
              boxShadow: [BoxShadow(color: kDark.withValues(alpha: 0.15), blurRadius: 5, offset: const Offset(2, 2))],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(c.flagUrl, width: 60, height: 42, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 60, height: 42, color: kBorder),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: kDark, fontFamily: 'DM Mono')),
                      Text('${c.capital} · ${c.region}', style: const TextStyle(fontSize: 12, color: kSubtext)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: kBorder),
              ],
            ),
          ),
        );
      },
    );
  }
}