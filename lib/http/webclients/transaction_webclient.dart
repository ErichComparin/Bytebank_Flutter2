import 'dart:convert';

import 'package:al2_bytebank/http/webclient.dart';
import 'package:al2_bytebank/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebclient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client
        .get(
          Uri.http(
            baseUrl,
            basePath,
          ),
        );
    final List<dynamic> jsonTransactions = jsonDecode(response.body);
    return jsonTransactions
        .map(
          (dynamic jsonTransaction) => Transaction.fromJson(jsonTransaction),
        )
        .toList();
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    final String jsonTransaction = jsonEncode(transaction.toJson());

    await Future.delayed(Duration(seconds: 2));

    final Response response = await client.post(
      Uri.http(
        baseUrl,
        basePath,
      ),
      headers: {
        'Content-type': 'application/json',
        'password': password,
      },
      body: jsonTransaction,
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpException(_getMessage(response.statusCode));
  }

  String? _getMessage(int statusCode) => _statusCodeResponses[statusCode];

  static final Map<int, String> _statusCodeResponses = {
    400: 'There was an error submitting transaction',
    401: 'Authentication failed',
    500: 'Transaction already exists',
  };
}

class HttpException implements Exception {
  final String? message;

  HttpException(this.message);
}