# Vista Test - Flutter Frontend

Flutter app for managing companies and their services. It talks to the REST API in the `back-end-test-vista` repository.

## Features

- List all companies with their services
- Create a company (name and registration number)
- Create a service under a company (name, description, price, company selector)
- Form validation, loading indicators and error messages from the API

## Requirements

- Flutter SDK 3.50 or newer
- Google Chrome (the app is run in the browser)
- The backend from `back-end-test-vista` running on `http://localhost:3000`

## Setup

1. Start the backend first. Follow the README in the backend repository (MySQL must be running).

2. Install dependencies:

   ```
   flutter pub get
   ```

3. Run the app in Chrome:

   ```
   flutter run -d chrome
   ```

## Changing the API address

The default API address is `http://localhost:3000`. To use another address, pass it when running:

```
flutter run -d chrome --dart-define=API_URL=http://192.168.0.10:3000
```

For an Android emulator, use `http://10.0.2.2:3000` because `localhost` points to the emulator itself.

## Project structure

```
lib/
  main.dart                app entry, provider setup
  config.dart              API base url
  models/                  Company and Service models
  services/api_service.dart  HTTP calls and error handling
  providers/               state management (provider)
  screens/                 CompanyListScreen, CreateCompanyScreen, CreateServiceScreen
  widgets/                 shared widgets
  utils/validators.dart    form validators
```

## Notes

- State management is done with `provider` (`CompanyProvider`).
- API errors (validation, duplicate registration number, server down) are shown to the user as messages.
- The UI uses a centered max-width layout so it stays readable on wide browser windows and small screens.
- The app uses the standalone `material_ui` package, since Flutter 3.50 deprecated the built-in Material library.