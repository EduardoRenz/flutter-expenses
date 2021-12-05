import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String title, double value) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(amountController.text);
    if (title.isNotEmpty && value != null) {
      widget.onSubmit(title, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                onSubmitted: (value) => _submitForm(),
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
              onSubmitted: (value) => _submitForm(),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: amountController,
              decoration: InputDecoration(labelText: 'Value (R\$)'),
            ),
            TextButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text(
                  "New Transaction",
                  style: TextStyle(color: Colors.purple),
                )),
          ],
        ),
      ),
    );
  }
}
