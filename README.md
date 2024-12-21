# Currency Converter Application

This project demonstrates how to build a **Currency Converter** application using **Flutter** for the frontend and **Spring Boot** with **GraphQL** for the backend. The application allows users to convert currencies in real-time by fetching exchange rates through an external API and providing a user-friendly interface.

---

## Features

### Frontend (Flutter):
- User-friendly interface for currency conversion.
- Dropdown menus to select base and target currencies.
- Input field for the amount to convert.
- Real-time display of converted currency values.

### Backend (Spring Boot + GraphQL):
- GraphQL API to fetch and provide currency exchange rates.
- External API integration for live exchange rates.
- Endpoint to handle currency conversion logic.
- Scalable architecture for efficient data management.

---

## Tech Stack

### Frontend:
- **Flutter**
  - State management: `Provider`.
  - Networking: `http` package for API requests.

### Backend:
- **Java**
  - Framework: **Spring Boot**
  - GraphQL Implementation: **Spring Boot GraphQL**
  - Dependency Management: **Maven**
  - External API: **ExchangeRatesAPI** (or any preferred currency exchange API).

### Database (Optional):
- **H2 Database** (for local development or caching exchange rates).

---

## Prerequisites

### Backend:
1. Install [Java 17](https://adoptopenjdk.net/).
2. Install [Maven](https://maven.apache.org/).

### Frontend:
1. Install [Flutter](https://flutter.dev/docs/get-started/install).
2. Set up an emulator or connect a physical device.

---

## Getting Started

### Backend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/alissonte/changing-backend.git
   cd changing-converter-backend
   ```

2. Build the project:
   ```bash
   mvn clean install
   ```

3. Run the application:
   ```bash
   mvn spring-boot:run
   ```

4. Access the GraphQL Playground:
   - URL: `http://localhost:8080/graphql`

5. Example GraphQL Query:
   ```graphql
   query ConvertCurrency {
     convertCurrency(base: "USD", target: "EUR", amount: 100) {
       base
       target
       rate
       convertedAmount
     }
   }
   ```

### Frontend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/changing-frontend.git
   cd changing-frontend
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

---

## Folder Structure

### Backend:
```
- src/
  - main/
    - java/
      - com.aralves.tech.currency/
        - controllers/  # GraphQL Resolvers
        - services/     # Business Logic
        - models/       # Data Models
    - resources/
      - application.yml # Configuration
```

### Frontend:
```
- lib/
  - screens/
    - home_screen.dart
  - widgets/
    - currency_dropdown.dart
  - models/
    - currency_model.dart
  - services/
    - graphql_service.dart
```

---

## API Integration

### Backend:
1. Use `RestTemplate` or `WebClient` in Spring Boot to fetch live exchange rates.
2. Example external API call:
   ```java
   String url = "https://api.currencyapi.io/latest?base=" + base;
   RestTemplate restTemplate = new RestTemplate();
   ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
   ```

### Frontend:
1. Use the `graphql_flutter` package to interact with the GraphQL API:
   ```dart
   import 'package:graphql_flutter/graphql_flutter.dart';

   Future<double> fetchExchangeRate(String base, String target) async {
     final query = '''
       query {
         convertCurrency(base: "$base", target: "$target", amount: 1) {
           rate
         }
       }
     ''';

     final response = await client.query(QueryOptions(document: gql(query)));
     return response.data['convertCurrency']['rate'];
   }
   ```

---

## Example Screenshots

### Frontend:
- **Home Screen**: Dropdowns for currency selection, input field for amount, and display of converted value.

### Backend:
- **GraphQL Playground**: Querying the API for currency conversion.

---

## Future Enhancements
1. Add user authentication for saving conversion history.
2. Implement caching for frequent API requests to reduce latency.
3. Support for offline mode using local storage (e.g., SQLite in Flutter).

---

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
