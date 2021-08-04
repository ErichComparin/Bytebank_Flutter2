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
        )
        .timeout(
          Duration(seconds: 5),
        );
    final List<dynamic> jsonTransactions = jsonDecode(response.body);
    return jsonTransactions
        .map(
          (dynamic jsonTransaction) => Transaction.fromJson(jsonTransaction),
        )
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String jsonTransaction = jsonEncode(transaction.toJson());
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

    if (response.statusCode == 400){
      throw Exception('There was an error submitting transaction');
    }

    if(response.statusCode == 401){
      throw Exception('Authentication failed');
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }
}
