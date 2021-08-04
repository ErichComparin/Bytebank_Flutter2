import 'package:flutter/material.dart';

class TransactionAuthDialog extends StatefulWidget {
  final Function(String password) onConfirm;
  final TextEditingController _passwordController = TextEditingController();

  TransactionAuthDialog({required this.onConfirm});

  @override
  _TransactionAuthDialogState createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Authenticate',
      ),
      content: TextField(
        controller: widget._passwordController,
        obscureText: true,
        maxLength: 4,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 64,
          letterSpacing: 24,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          child: Text('Confirm'),
          onPressed: () {
            widget.onConfirm(widget._passwordController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
