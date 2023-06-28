import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:personal_expenses_app/widgets/new_transaction.dart';
import './widgets/transanction_list.dart';
import './models/transanction.dart';
import './widgets/chart.dart';
import 'package:flutter/services.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        errorColor: Colors.red,
        brightness: Brightness.light,
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 75.23,
    //   date: DateTime.now(),
    // ),
  ];

  bool showChart = false;

  List<Transaction> recentTransactions() {
    return userTransactions.where((tx) {
      return tx.date!.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void addNewTransaction(String txTitle, double txAmount, DateTime pickedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: pickedDate,
    );

    setState(() {
      userTransactions.add(newTx);
    });
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return NewTransaction(addNewTransaction);
      },
    );
  }

  void deleteTransaction(String id) {
    setState(() {
      userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> buildLandscapeContent(MediaQueryData mediaQuery, AppBar appBar) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Show Chart'),

            // Adaptive for automatically render itself to platform
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: showChart,
              onChanged: (val) {
                setState(() {
                  showChart = val;
                });
              },
            ),
          ],
        ),
      ),
      showChart
          ? Container(
              width: (mediaQuery.size.width) * 0.8,
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.8,
              child: Chart(
                recentTransactions(),
              ),
            )
          : Container(
              padding: EdgeInsets.all(8),
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.9,
              child: TransactionList(userTransactions, deleteTransaction),
            ),
    ];
  }

  List<Widget> buildPortraitContent(MediaQueryData mediaQuery, AppBar appBar) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.28,
        child: Chart(
          recentTransactions(),
        ),
      ),
      Container(
        padding: EdgeInsets.all(4),
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.72,
        child: TransactionList(userTransactions, deleteTransaction),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => startAddNewTransaction(context),
          icon: Icon(
            Icons.add,
          ),
          color: Colors.white,
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape) ...buildLandscapeContent(mediaQuery, appBar),
            if (!isLandscape) ...buildPortraitContent(mediaQuery, appBar),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Platform.isIOS // Checking platform
          ? Container()
          : FloatingActionButton(
              onPressed: () => startAddNewTransaction(context),
              child: Icon(
                Icons.add,
              ),
            ),
    );
  }
}
