import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/conversor_service.dart';
import '../utils/logger.dart';
import '../models/moeda.dart';

class CurrencyConverterScreen extends StatefulWidget {
  final CurrencyPair currencyPair;

  const CurrencyConverterScreen({
    super.key,
    required this.currencyPair,
  });

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  double exchangeRate = 0.0;
  final TextEditingController _sourceValueController = TextEditingController();
  double convertedValue = 0.0;
  bool _isLoading = true;
  DateTime? lastUpdated;

  @override
  void initState() {
    super.initState();
    _loadExchangeRate();
  }

  Future<void> _loadExchangeRate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      double rate = await CurrencyConverterService.getExchangeRate(
        widget.currencyPair.from,
        widget.currencyPair.to,
      );
      setState(() {
        exchangeRate = rate;
        _isLoading = false;
        lastUpdated = DateTime.now();
        // Recalculate converted value if there's already a value entered
        if (_sourceValueController.text.isNotEmpty) {
          _convertCurrency(_sourceValueController.text);
        }
      });
    } catch (e) {
      AppLogger.error('Error loading exchange rate', e);
      setState(() {
        exchangeRate = -1;
        _isLoading = false;
      });
    }
  }

  void _convertCurrency(String inputValue) {
    if (inputValue.isEmpty || exchangeRate <= 0) {
      setState(() {
        convertedValue = 0.0;
      });
      return;
    }

    final double? sourceValue = double.tryParse(inputValue);
    if (sourceValue != null) {
      setState(() {
        convertedValue = sourceValue * exchangeRate;
      });
    } else {
      setState(() {
        convertedValue = 0.0;
      });
    }
  }

  String _formatCurrency(String code) {
    switch (code) {
      case 'USD':
        return 'US\$';
      case 'EUR':
        return '€';
      case 'BRL':
        return 'R\$';
      default:
        return code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.currencyPair.name} Converter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExchangeRate,
            tooltip: 'Update exchange rate',
          ),
        ],
      ),
      drawer: _buildDrawer(),
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
            child: Column(
              children: [
                // Exchange rate card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.currencyPair.fromIcon,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              widget.currencyPair.toIcon,
                              color: widget.currencyPair.color,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else if (exchangeRate > 0)
                          Text(
                            'Current rate: 1 ${widget.currencyPair.from} = ${_formatCurrency(widget.currencyPair.to)} ${exchangeRate.toStringAsFixed(4)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Error loading exchange rate',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (!_isLoading &&
                            exchangeRate > 0 &&
                            lastUpdated != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Updated on ${lastUpdated!.day}/${lastUpdated!.month}/${lastUpdated!.year} at ${lastUpdated!.hour}:${lastUpdated!.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Converter card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Convert ${widget.currencyPair.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _sourceValueController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          decoration: InputDecoration(
                            labelText:
                                'Enter amount in ${widget.currencyPair.from}',
                            prefixIcon: Icon(widget.currencyPair.fromIcon),
                            hintText: '0.00',
                          ),
                          onChanged: _convertCurrency,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,4}')),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: widget.currencyPair.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: widget.currencyPair.color.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount in ${widget.currencyPair.to}:',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    widget.currencyPair.toIcon,
                                    color: widget.currencyPair.color,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_formatCurrency(widget.currencyPair.to)} ${convertedValue.toStringAsFixed(4)}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _sourceValueController.clear();
          setState(() {
            convertedValue = 0.0;
          });
        },
        backgroundColor: widget.currencyPair.color,
        child: const Icon(Icons.refresh),
        tooltip: 'Clear values',
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF1A5276),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Currency Converter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Conversions',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // List of currency pairs
          ...Currencies.pairs.map((pair) => _buildDrawerItem(pair)),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(CurrencyPair pair) {
    final bool isSelected = pair.code == widget.currencyPair.code;

    return ListTile(
      leading: Icon(
        pair.fromIcon,
        color: isSelected ? pair.color : null,
      ),
      title: Text(pair.name),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        if (!isSelected) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CurrencyConverterScreen(currencyPair: pair),
            ),
          );
        }
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About the App'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Currency Converter'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
                'This app allows you to convert values between different currencies using up-to-date exchange rates.'),
            SizedBox(height: 8),
            Text('Developed with Flutter.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
