import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/expense.dart';

void main() {
  runApp(const AuroraSpendFlowApp());
}

class AuroraSpendFlowApp extends StatelessWidget {
  const AuroraSpendFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Aurora Spend Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF9B5DE5),
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        cardTheme: const CardTheme(
          color: Color(0xFF1F1E26),
          elevation: 0,
        ),
      ),
      home: const ExpenseTrackerDashboard(),
    );
  }
}

class ExpenseTrackerDashboard extends StatefulWidget {
  const ExpenseTrackerDashboard({super.key});

  @override
  State<ExpenseTrackerDashboard> createState() => _ExpenseTrackerDashboardState();
}

class _ExpenseTrackerDashboardState extends State<ExpenseTrackerDashboard> {
  final List<Expense> _registeredExpenses = [
    Expense(
      id: 'e1',
      title: 'Gourmet Ramen Dinner',
      amount: 24.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: ExpenseCategory.food,
    ),
    Expense(
      id: 'e2',
      title: 'Co-working Monthly Desk',
      amount: 150.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: ExpenseCategory.work,
    ),
    Expense(
      id: 'e3',
      title: 'Cinema & Popcorn Night',
      amount: 18.75,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: ExpenseCategory.leisure,
    ),
    Expense(
      id: 'e4',
      title: 'Electric & Utility Bill',
      amount: 64.20,
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: ExpenseCategory.bills,
    ),
  ];

  double get _totalSpending {
    return _registeredExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  Map<ExpenseCategory, double> get _categoryTotals {
    final Map<ExpenseCategory, double> totals = {};
    for (var cat in ExpenseCategory.values) {
      totals[cat] = 0.0;
    }
    for (var expense in _registeredExpenses) {
      totals[expense.category] = (totals[expense.category] ?? 0.0) + expense.amount;
    }
    return totals;
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1F1E26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => AddExpenseModal(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _deleteExpense(Expense expense) {
    final int index = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${expense.title}" deleted.'),
        duration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFF1F1E26),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFF00D2D3),
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(index, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double maxCategoryTotal = _categoryTotals.values.isEmpty
        ? 1.0
        : _categoryTotals.values.reduce((curr, next) => curr > next ? curr : next);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aurora Spend',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
            ),
            Text(
              'Beautiful Smart Tracker',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Color(0xFF9B5DE5)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Dynamic Glassmorphism Balance Display
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B5DE5), Color(0xFF54A0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B5DE5).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'TOTAL EXPENDITURE',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_totalSpending.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, py: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${_registeredExpenses.length} Items',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Dynamic Horizontal Chart Representation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category Analysis',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: ExpenseCategory.values.map((category) {
                          final double total = _categoryTotals[category] ?? 0.0;
                          final double ratio = maxCategoryTotal > 0 ? total / maxCategoryTotal : 0;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: 80,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2D2B36),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.bottomCenter,
                                      heightFactor: ratio.clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Expense.getCategoryColor(category),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Expense.getCategoryColor(category).withOpacity(0.4),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Icon(
                                    Expense.getCategoryIcon(category),
                                    size: 16,
                                    color: Expense.getCategoryColor(category),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Dynamic Expense List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Swipe to delete',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            // Dynamic Scrollable Expense List
            Expanded(
              child: _registeredExpenses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.spa_outlined, size: 64, color: Colors.grey.shade700),
                          const SizedBox(height: 16),
                          const Text(
                            'No expenses registered yet.',
                            style: TextStyle(color: Colors.white50, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _registeredExpenses.length,
                      itemBuilder: (ctx, index) {
                        final expense = _registeredExpenses[index];
                        return Dismissible(
                          key: ValueKey(expense.id),
                          background: Container(
                            color: const Color(0xFFEE5253).withOpacity(0.85),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: const Icon(Icons.delete_forever, color: Colors.white, size: 28),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) => _deleteExpense(expense),
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Expense.getCategoryColor(expense.category).withOpacity(0.2),
                                child: Icon(
                                  Expense.getCategoryIcon(expense.category),
                                  color: Expense.getCategoryColor(expense.category),
                                ),
                              ),
                              title: Text(
                                expense.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              subtitle: Text(
                                DateFormat('MMM dd, yyyy').format(expense.date),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              trailing: Text(
                                '-\$${expense.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFFEE5253),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddExpenseOverlay,
        backgroundColor: const Color(0xFF9B5DE5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Spend', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class AddExpenseModal extends StatefulWidget {
  final Function(Expense) onAddExpense;

  const AddExpenseModal({required this.onAddExpense, super.key});

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount != null && enteredAmount > 0;
    if (_titleController.text.trim().isEmpty || !amountIsValid || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please check your fields. Title, valid positive Amount and Date are required.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        id: DateTime.now().toString(),
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'New Expense',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              maxLength: 50,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Expense Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: TextStyle(color: Colors.white),
                      labelText: 'Amount',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No date chosen'
                            : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_today, color: Color(0xFF9B5DE5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('Category:', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<ExpenseCategory>(
                    value: _selectedCategory,
                    dropdownColor: const Color(0xFF1F1E26),
                    underline: Container(
                      height: 1,
                      color: const Color(0xFF9B5DE5),
                    ),
                    items: ExpenseCategory.values.map((category) {
                      return DropdownMenuItem<ExpenseCategory>(
                        value: category,
                        child: Text(
                          Expense.getCategoryName(category),
                          style: TextStyle(color: Expense.getCategoryColor(category)),
                        ),
                      ); 
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitExpenseData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B5DE5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Save Expense',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ); 
  }
}
