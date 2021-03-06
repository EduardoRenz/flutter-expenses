import 'dart:math';

import 'package:flutter/material.dart';
import 'components/transaction_list.dart';
import './components/transaction_form.dart';
import './components/chart.dart';
import 'models/transaction.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(),
        theme: ThemeData(
            textTheme: const TextTheme(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            primarySwatch: Colors.green,
            //accentColor: Colors.amber,
            fontFamily: 'Quicksand',
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )));
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  void _deleteTransaction(String transactionId) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == transactionId);
    });
  }

  _showTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final availableHeight = MediaQuery.of(context).size.height -
        mediaQuery.padding.top -
        kToolbarHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          if (isLandscape)
            IconButton(
              icon: Icon(_showChart ? Icons.list : Icons.show_chart),
              onPressed: () {
                setState(() {
                  _showChart = !_showChart;
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showTransactionFormModal(context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_showChart || !isLandscape)
                SizedBox(
                  height: availableHeight * (isLandscape ? 0.7 : 0.3),
                  child: Card(
                    color: Colors.blue,
                    child: Chart(_recentTransactions),
                    elevation: 5,
                  ),
                ),
              if (!_showChart || !isLandscape)
                SizedBox(
                    height: availableHeight * 0.7,
                    child: TransactionList(_transactions, _deleteTransaction)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showTransactionFormModal(context);
        },
      ),
    );
  }
}
