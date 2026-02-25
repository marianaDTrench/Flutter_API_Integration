import 'package:flutter/material.dart';
import 'package:flutter_world_explorer/features/country_list_page.dart';
import 'package:flutter_world_explorer/features/country_search_page.dart';
import 'package:flutter_world_explorer/features/country_region_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5C3317)),
        scaffoldBackgroundColor: const Color(0xFFD4A96A),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    CountryListPage(),
    CountrySearchPage(),
    CountryRegionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3D1F00),
          border: Border(top: BorderSide(color: const Color(0xFF8B4513).withOpacity(0.5), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: const Color(0xFF3D1F00),
          selectedItemColor: const Color(0xFFE8C98A),
          unselectedItemColor: const Color(0xFF8B6347),
          selectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Regions'),
          ],
        ),
      ),
    );
  }
}