import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('expenses');

  Future<void> addExpense(Expense expense) async {
    await _collection.add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) async {
    await _collection.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    await _collection.doc(id).delete();
  }

  Stream<List<Expense>> getExpenses() {
    return _collection
        .orderBy('date', descending: true) // mais recente primeiro
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
}
