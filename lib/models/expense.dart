import 'package:flutter/material.dart';

enum ExpenseCategory {
  food,
  travel,
  leisure,
  work,
  bills,
  education
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  static IconData getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.travel:
        return Icons.flight_takeoff;
      case ExpenseCategory.leisure:
        return Icons.sports_esports;
      case ExpenseCategory.work:
        return Icons.work;
      case ExpenseCategory.bills:
        return Icons.receipt_long;
      case ExpenseCategory.education:
        return Icons.school;
    }
  }

  static Color getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return const Color(0xFFFF9F43);
      case ExpenseCategory.travel:
        return const Color(0xFF00D2D3);
      case ExpenseCategory.leisure:
        return const Color(0xFF9B5DE5);
      case ExpenseCategory.work:
        return const Color(0xFF54A0FF);
      case ExpenseCategory.bills:
        return const Color(0xFFEE5253);
      case ExpenseCategory.education:
        return const Color(0xFF10AC84);
    }
  }

  static String getCategoryName(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return 'Food & Dining';
      case ExpenseCategory.travel:
        return 'Travel';
      case ExpenseCategory.leisure:
        return 'Leisure & Fun';
      case ExpenseCategory.work:
        return 'Work / Business';
      case ExpenseCategory.bills:
        return 'Bills & Utilities';
      case ExpenseCategory.education:
        return 'Education';
    }
  }
}
