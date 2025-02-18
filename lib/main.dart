import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:currency_converter/detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Convertitore di Valuta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CurrencyConverter(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({super.key});

  @override
  State<CurrencyConverter> createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';
  double _convertedAmount = 0.0;
  bool _isLoading = false;
  String? _error;

  final List<String> _currencies = ['EUR', 'USD', 'GBP'];

  final String _apiKey = 'fa83865828aea6d72d320ebd';

  Future<void> _convert() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final url = Uri.parse(
        'https://v6.exchangerate-api.com/v6/$_apiKey/latest/$_fromCurrency');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final double conversionRate =
            data['conversion_rates']?[_toCurrency] ?? 1.0;

        setState(() {
          double amount = double.tryParse(_amountController.text) ?? 0.0;
          _convertedAmount = amount * conversionRate;
        });
      } else {
        setState(() {
          _error = 'Errore nella richiesta al server';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Errore: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Converti Valuta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Importo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                DropdownButton<String>(
                  value: _fromCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      _fromCurrency = newValue!;
                    });
                  },
                  items:
                      _currencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                IconButton(
                  icon: const Icon(Icons.price_change_sharp),
                  onPressed: () {
                    setState(() {
                      String temp = _fromCurrency;
                      _fromCurrency = _toCurrency;
                      _toCurrency = temp;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: _toCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      _toCurrency = newValue!;
                    });
                  },
                  items:
                      _currencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_error == null && !_isLoading)
              Text(
                'Risultato: $_convertedAmount $_toCurrency',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _convert,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Converti'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      amount: double.tryParse(_amountController.text) ?? 0.0,
                      fromCurrency: _fromCurrency,
                      toCurrency: _toCurrency,
                      convertedAmount: _convertedAmount,
                    ),
                  ),
                );
              },
              child: const Text('Dettagli'),
            ),
          ],
        ),
      ),
    );
  }
}
