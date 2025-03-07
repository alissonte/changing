import 'package:flutter/material.dart';
import '../models/moeda.dart';
import 'dart:math';

class AddCurrencyPairScreen extends StatefulWidget {
  const AddCurrencyPairScreen({super.key});

  @override
  State<AddCurrencyPairScreen> createState() => _AddCurrencyPairScreenState();
}

class _AddCurrencyPairScreenState extends State<AddCurrencyPairScreen> {
  final _formKey = GlobalKey<FormState>();

  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  String _name = '';

  final List<String> _availableCurrencies = [
    'USD',
    'EUR',
    'BRL',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Exchange'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create a new currency pair',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // From Currency Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'From Currency',
                      border: OutlineInputBorder(),
                    ),
                    value: _fromCurrency,
                    items: _availableCurrencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _fromCurrency = value;
                          _updateName();
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // To Currency Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'To Currency',
                      border: OutlineInputBorder(),
                    ),
                    value: _toCurrency,
                    items: _availableCurrencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _toCurrency = value;
                          _updateName();
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Name Field
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Pair Name (optional)',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., US Dollar to Euro',
                    ),
                    initialValue: _name,
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),

                  const Spacer(),

                  // Preview Card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Preview:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getIconForCurrency(_fromCurrency),
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.grey,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _getIconForCurrency(_toCurrency),
                                color: _generateRandomColor(),
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _name.isEmpty
                                ? '$_fromCurrency to $_toCurrency'
                                : _name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Add Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addCurrencyPair,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add Currency Pair'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateName() {
    String fromName = _getCurrencyFullName(_fromCurrency);
    String toName = _getCurrencyFullName(_toCurrency);
    setState(() {
      _name = '$fromName to $toName';
    });
  }

  String _getCurrencyFullName(String code) {
    switch (code) {
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'BRL':
        return 'Brazilian Real';
      case 'GBP':
        return 'British Pound';
      case 'JPY':
        return 'Japanese Yen';
      case 'CAD':
        return 'Canadian Dollar';
      case 'AUD':
        return 'Australian Dollar';
      case 'CHF':
        return 'Swiss Franc';
      default:
        return code;
    }
  }

  IconData _getIconForCurrency(String code) {
    switch (code) {
      case 'EUR':
        return Icons.euro;
      case 'GBP':
        return Icons.currency_pound;
      case 'JPY':
        return Icons.currency_yen;
      default:
        return Icons.attach_money;
    }
  }

  Color _generateRandomColor() {
    final List<Color> colors = [
      const Color(0xFF2ECC71),
      const Color(0xFF3498DB),
      const Color(0xFFF1C40F),
      const Color(0xFFE74C3C),
      const Color(0xFF9B59B6),
    ];

    return colors[Random().nextInt(colors.length)];
  }

  void _addCurrencyPair() {
    if (_formKey.currentState!.validate()) {
      final String code = '$_fromCurrency-$_toCurrency';
      final String name =
          _name.isEmpty ? '$_fromCurrency to $_toCurrency' : _name;

      // Add the new currency pair to the list
      Currencies.addCustomPair(
        CurrencyPair(
          code: code,
          name: name,
          from: _fromCurrency,
          to: _toCurrency,
          fromIcon: _getIconForCurrency(_fromCurrency),
          toIcon: _getIconForCurrency(_toCurrency),
          color: _generateRandomColor(),
        ),
      );

      Navigator.pop(context, true);
    }
  }
}
