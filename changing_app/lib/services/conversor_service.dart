import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterService {
  // Method to get exchange rate for any currency pair
  static Future<double> getExchangeRate(String from, String to) async {
    final url =
        Uri.parse('https://economia.awesomeapi.com.br/json/last/$from-$to');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final String key = '$from$to';
      return double.parse(jsonBody[key]['bid']);
    } else {
      throw Exception('Error fetching exchange rate: ${response.statusCode}');
    }
  }

  // Specific methods for each currency pair
  static Future<double> getEuroToReal() async {
    return getExchangeRate('EUR', 'BRL');
  }

  static Future<double> getEuroToDollar() async {
    return getExchangeRate('EUR', 'USD');
  }

  static Future<double> getDollarToEuro() async {
    return getExchangeRate('USD', 'EUR');
  }

  static Future<double> getRealToDollar() async {
    return getExchangeRate('BRL', 'USD');
  }

  static Future<double> getDollarToReal() async {
    return getExchangeRate('USD', 'BRL');
  }
}
