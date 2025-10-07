import 'package:financing_app/models/expense.dart';
import 'package:financing_app/services/expense_service.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final ExpenseService _service = ExpenseService();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showExpenseDialog({Expense? expense }) {
    if (expense != null) {
      _titleController.text = expense.title;
      _amountController.text = expense.amount.toString();
    } else {
      _titleController.clear();
      _amountController.clear();
    }

    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text(expense != null ? 'Editar Despesa' : 'Nova despesa'),
        content: Form (
          key: _formKey,
          child: Column (
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titulo'),
                validator: (v) => 
                  v != null && v.isNotEmpty ? null : 'Informe o título',
              ),              
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (v) => 
                v != null && double.tryParse(v) != null 
                  ? null
                  : 'Valor invalido',
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          )
          ElevatedButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;

              final newExpense = Expense(
                id: expense?.id ?? '',
                title: _titleController.text.trim(),
                amount: double.parse(_amountController.text.trim()),
                date: DateTime.now(),
              );

              if (expense == null) {
                await _service.addExpense(newExpense);
              } else {
                await _service.updateExpense(newExpense);
              }

              Navigator.pop(context);
            },
            child: Text(expense != null ? 'Atualizar' : 'Adicionar'),
          ) 
        ],
      )
    );
  }
}