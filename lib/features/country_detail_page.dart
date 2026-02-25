import 'package:flutter/material.dart';
import 'package:flutter_world_explorer/models/country_model.dart';
import 'package:flutter_world_explorer/services/country_service.dart';

const kBg = Color(0xFFD4A96A);
const kDark = Color(0xFF3D1F00);
const kLeather = Color(0xFF5C3317);
const kCard = Color(0xFFE8C98A);
const kBorder = Color(0xFFB8864E);
const kSubtext = Color(0xFF7A4F2A);

class CountryDetailPage extends StatefulWidget {
  final String code;
  const CountryDetailPage({super.key, required this.code});

  @override
  State<CountryDetailPage> createState() => _CountryDetailPageState();
}

class _CountryDetailPageState extends State<CountryDetailPage> {
  final CountryService _service = CountryService();
  CountryModel? _country;
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
      final result = await _service.getByCode(widget.code);
      setState(() { _country = result; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator(color: kLeather));
    if (_error != null) return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: kSubtext),
          const SizedBox(height: 12),
          Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: kSubtext)),
          TextButton(onPressed: _load, child: const Text('Retry', style: TextStyle(color: kLeather))),
        ],
      ),
    );

    final c = _country!;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 230,
          pinned: true,
          backgroundColor: kDark,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFE8C98A)),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              c.name,
              style: const TextStyle(
                color: Color(0xFFE8C98A),
                fontWeight: FontWeight.bold,
                fontFamily: 'DM Mono',
                
                fontSize: 17,
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(c.flagUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: kLeather),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, kDark.withValues(alpha: 0.85)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Official name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kBorder),
                  ),
                  child: Text(
                    c.officialName,
                    style: const TextStyle(fontSize: 13, color: kSubtext, fontWeight: FontWeight.bold, fontFamily: 'DM Mono'),
                  ),
                ),
                const SizedBox(height: 16),

                // Info card
                Container(
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder, width: 1.5),
                    boxShadow: [BoxShadow(color: kDark.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(2, 3))],
                  ),
                  child: Column(
                    children: [
                      _InfoRow(label: '🏛️  Capital', value: c.capital),
                      _Divider(),
                      _InfoRow(label: '🌍  Region', value: c.region),
                      _Divider(),
                      _InfoRow(label: '📍  Subregion', value: c.subregion),
                      _Divider(),
                      _InfoRow(label: '👥  Population', value: _formatPop(c.population)),
                      _Divider(),
                      _InfoRow(label: '💰  Currency', value: c.currency),
                      _Divider(),
                      _InfoRow(label: '🗣️  Languages', value: c.languages.join(', ')),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatPop(int pop) {
    if (pop >= 1000000) return '${(pop / 1000000).toStringAsFixed(1)}M';
    if (pop >= 1000) return '${(pop / 1000).toStringAsFixed(1)}K';
    return pop.toString();
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 115, child: Text(label, style: const TextStyle(color: kSubtext, fontSize: 13, fontStyle: FontStyle.italic))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: kDark, fontFamily: 'Georgia'))),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFD4A96A), indent: 16, endIndent: 16);
  }
}