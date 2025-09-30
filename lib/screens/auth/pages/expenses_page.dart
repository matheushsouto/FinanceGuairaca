
import 'package:financing_app/models/expense.dart';
import 'package:financing_app/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  void _showExpenseDialog({Expense? expense}) {
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
        title: Text(expense != null ? 'Editar Despesa' : 'Nova Despesa'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    v != null && v.isNotEmpty ? null : 'Informe o título',
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (v) => v != null && double.tryParse(v) != null
                    ? null
                    : 'Valor inválido',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
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
                await _service.updateExpense(newExpense.copyWith(id: expense.id));
              }

              Navigator.pop(context);
            },
            child: Text(expense != null ? 'Atualizar' : 'Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseDialog(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Expense>>(
        stream: _service.getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final expenses = snapshot.data ?? [];
          if (expenses.isEmpty) {
            return const Center(child: Text('Nenhuma despesa cadastrada'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final exp = expenses[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    exp.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(exp.date),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'R\$ ${exp.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _showExpenseDialog(expense: exp),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _service.deleteExpense(exp.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

extension on Expense {
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
}
