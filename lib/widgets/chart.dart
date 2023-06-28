import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transanction.dart';
import '../models/transanction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date!.day == weekday.day &&
            recentTransactions[i].date!.month == weekday.month &&
            recentTransactions[i].date!.year == weekday.year) {
          totalSum = totalSum + recentTransactions[i].amount!.toDouble();
        }
      }

      print(DateFormat.E().format(weekday));
      print(totalSum);

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactions.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactions);

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(
        20,
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactions.map((el) {
            return Flexible(
              // flex: 1, default
              fit: FlexFit.tight,
              child: ChartBar(
                  el['day'].toString(),
                  (el['amount'] as double),
                  totalSpending == 0
                      ? 0.0
                      : ((el['amount'] as double) / totalSpending)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
