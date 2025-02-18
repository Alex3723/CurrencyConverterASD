import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double convertedAmount;

  const DetailScreen({
    super.key,
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
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
              'Importo inserito: $amount $fromCurrency',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Valuta di partenza: $fromCurrency',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Valuta di destinazione: $toCurrency',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Risultato della conversione: $convertedAmount $toCurrency',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
