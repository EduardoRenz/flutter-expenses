import 'package:expenses/components/adaptative_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String title, double value, DateTime date) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _transactionDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_amountController.text);
    final date = _transactionDate;
    if (title.isNotEmpty && value != null) {
      widget.onSubmit(title, value, date);
    }
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _transactionDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              TextField(
                  onSubmitted: (value) => _submitForm(),
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title')),
              TextField(
                onSubmitted: (value) => _submitForm(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Value (R\$)'),
              ),
              Row(children: [
                _transactionDate != null
                    ? Text(DateFormat.yMMMd().format(_transactionDate))
                    : Text('No date selected'),
                TextButton(
                  child: Text('Select date',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  onPressed: _showDatePicker,
                )
              ]),
              Container(
                  margin: EdgeInsets.only(
                      top: Theme.of(context).buttonTheme.height),
                  child: AdaptativeButton(
                    onPressed: () {
                      _submitForm();
                    },
                    text: 'New Transaction',
                  )
                  // child: ElevatedButton(
                  //     onPressed: () {
                  //       _submitForm();
                  //     },
                  //     child: const Text(
                  //       "New Transaction",
                  //     )),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
