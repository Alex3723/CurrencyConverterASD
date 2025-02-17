import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double conversionRate;
  final double convertedAmount;

  const DetailScreen({
    super.key,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.conversionRate,
    required this.convertedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli Conversione'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Importo Iniziale: $amount $fromCurrency',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Tasso di Cambio: 1 $fromCurrency = $conversionRate $toCurrency',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Importo Convertito: $convertedAmount $toCurrency',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Torna Indietro'),
            ),
          ],
        ),
      ),
    );
  }
}