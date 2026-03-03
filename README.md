# 🌍 World Explorer — Flutter App

A Flutter application that integrates the **REST Countries API** to let users explore nations across the globe through a polished, atlas-inspired UI.

---

## API Choice

**API Name:** REST Countries  
**Base URL:** `https://restcountries.com/v3.1`  
**Documentation:** https://restcountries.com  
**Auth Required:** None  
**Response Format:** JSON  

REST Countries provides rich, structured JSON data about every nation in the world — covering capitals, regions, populations, languages, currencies, and flag images. It requires no authentication and supports HTTPS, making it ideal for a multi-endpoint Flutter integration.

---

## Endpoints Integrated

| # | Method | Path | Feature |
|---|--------|------|---------|
| 1 | GET | `/all?fields=name,capital,region,subregion,population,flags,cca2,languages,currencies` | List all countries |
| 2 | GET | `/name/{name}` | Search countries by name |
| 3 | GET | `/region/{region}` | Filter countries by region |
| 4 | GET | `/alpha/{code}` | Get country detail by 2-letter code (e.g. `PH`, `JP`, `US`) |

All four endpoints are reachable from distinct screens in the app via a bottom navigation bar.

---

## App Structure

```
lib/
├── main.dart                    # App entry point & bottom nav shell
├── models/
│   └── country_model.dart       # Dart model — parses all JSON fields
├── services/
│   └── country_service.dart     # API service layer using Dio
└── features/
    ├── country_list_page.dart   # Endpoint 1 — full country grid
    ├── country_search_page.dart # Endpoint 2 — search by name
    ├── country_region_page.dart # Endpoint 3 — filter by region
    └── country_detail_page.dart # Endpoint 4 — detail by alpha code
```

### Navigation

A `BottomNavigationBar` provides access to three top-level sections:

- **Explore** — browse all countries in a 2-column grid
- **Search** — search any country by name with live results
- **Regions** — filter by continent (Africa, Americas, Asia, Europe, Oceania)

Tapping any country card navigates to the **Detail** screen, which calls Endpoint 4.

---

## Implementation Details

### HTTP Client
Uses the [`dio`](https://pub.dev/packages/dio) package with a single `BaseOptions` configuration:
```dart
final Dio _dio = Dio(BaseOptions(
  baseUrl: 'https://restcountries.com/v3.1',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));
```

### Data Model
`CountryModel` maps all JSON fields to typed Dart properties — no raw JSON is ever passed to the UI layer. Handles nullable fields gracefully (e.g., missing capitals, currencies, or languages default to `'N/A'` or empty lists).

### Service / Repository Layer
`CountryService` centralizes all API calls. Widgets never call `dio` directly — they only interact with the service's typed return values (`Future<List<CountryModel>>`, `Future<CountryModel>`).

### Error Handling
Every endpoint is wrapped in `try/catch` with `DioException` handling:
- **Network errors** display an offline icon with a **Retry** button.
- **404 responses** (e.g., no search results) return an empty list instead of throwing.
- **Parse errors** surface a readable error message.
- **Loading states** show a `CircularProgressIndicator` while data is in flight.

---

## UI / Theme

The app uses a **vintage cartography / leather atlas** aesthetic:

| Role | Color |
|------|-------|
| Background | `#D4A96A` (parchment gold) |
| Headers / Nav | `#3D1F00` (dark mahogany) |
| Cards | `#E8C98A` (aged paper) |
| Borders | `#B8864E` (antique bronze) |
| Subtext | `#7A4F2A` (faded ink) |

Typography mixes **Georgia** (serif, body) with **Great Vibes** (Google Fonts cursive, page titles) and **DM Mono** for country names, evoking an old-world explorer's logbook. Flag images are loaded directly from the API's PNG URLs.

---

## Dependencies

```yaml
dependencies:
  dio: ^5.4.0          # HTTP client
  google_fonts: ^6.2.1 # Great Vibes cursive font
  cupertino_icons: ^1.0.8
```

---

## Getting Started

```bash
flutter pub get
flutter run
```

No API key or environment configuration is required.

---

## Grading Checklist (Self-Assessment)

| # | Criterion | Status |
|---|-----------|--------|
| 1 | API from public-apis list (REST Countries) | ✅ |
| 2 | Returns JSON; base URL and docs identifiable | ✅ |
| 3 | 4 endpoints integrated | ✅ |
| 4 | Each endpoint reachable in the app | ✅ |
| 5 | Single HTTP client with consistent base URL | ✅ |
| 6 | JSON mapped to `CountryModel` (no raw JSON in UI) | ✅ |
| 7 | `CountryService` repository layer (not in widgets) | ✅ |
| 8 | Error handling + loading states on every screen | ✅ |
