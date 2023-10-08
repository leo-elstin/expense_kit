import 'package:drift_db_viewer/drift_db_viewer.dart';
import 'package:expense_kit/model/database/database.dart';
import 'package:expense_kit/view/expense/add_expense.dart';
import 'package:expense_kit/view/expense/balance_card.dart';
import 'package:expense_kit/view/expense/expense_list.dart';
import 'package:expense_kit/view/ui_extensions.dart';
import 'package:flutter/material.dart';

class ExpenseView extends StatelessWidget {
  const ExpenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(page: const AddExpense()),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          InkWell(
            child: const BalanceCard(),
            onTap: () {
              //This should be a singleton
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DriftDbViewer(database),
                ),
              );
            },
          ),
          const Expanded(child: ExpenseList()),
        ],
      ),
    );
  }
}
