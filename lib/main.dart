import 'package:flutter/material.dart';

void main() {
  runApp(BudgetCalculatorApp());
}

class BudgetCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BudgetCalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BudgetCalculatorScreen extends StatefulWidget {
  @override
  _BudgetCalculatorScreenState createState() => _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  // Controllers to read input from text fields
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  double? _balance;
  String? _message;
  Color? _messageColor;

  void _calculateBalance() {
    setState(() {
      // Validate input fields
      if (_incomeController.text.isEmpty ||
          _rentController.text.isEmpty ||
          _foodController.text.isEmpty ||
          _transportController.text.isEmpty ||
          _otherController.text.isEmpty) {
        _message = "Please fill in all fields.";
        _messageColor = Colors.red;
        _balance = null;
        return;
      }

      // Convert text to double
      double? income = double.tryParse(_incomeController.text);
      double? rent = double.tryParse(_rentController.text);
      double? food = double.tryParse(_foodController.text);
      double? transport = double.tryParse(_transportController.text);
      double? other = double.tryParse(_otherController.text);

      // Check for invalid inputs
      if (income == null ||
          rent == null ||
          food == null ||
          transport == null ||
          other == null) {
        _message = "Please enter valid numeric values.";
        _messageColor = Colors.red;
        _balance = null;
        return;
      }

      if (income <= 0) {
        _message = "Monthly income must be positive.";
        _messageColor = Colors.red;
        _balance = null;
        return;
      }

      // Calculate balance
      _balance = income - (rent + food + transport + other);

      // Update message and color based on balance
      if (_balance! < 0) {
        _message = "You are overspending!";
        _messageColor = Colors.red;
      } else {
        _message = "You are within budget!";
        _messageColor = Colors.green;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Calculator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Monthly Income", _incomeController),
            _buildTextField("Rent / EMI", _rentController),
            _buildTextField("Food Expenses", _foodController),
            _buildTextField("Transport Expenses", _transportController),
            _buildTextField("Other Expenses", _otherController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBalance,
              child: Text("Calculate Balance"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 20),
            if (_balance != null) ...[
              Text(
                "Remaining Balance: ₹${_balance!.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _balance! < 0 ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                _message ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: _messageColor,
                ),
              ),
            ] else if (_message != null) ...[
              Text(
                _message!,
                style: TextStyle(
                  fontSize: 16,
                  color: _messageColor,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // Helper method to create text fields
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
