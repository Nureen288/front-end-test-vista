// Backend address. Chrome can reach localhost directly.
// For an Android emulator run with: --dart-define=API_URL=http://10.0.2.2:3000
const String apiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://localhost:3000',
);
