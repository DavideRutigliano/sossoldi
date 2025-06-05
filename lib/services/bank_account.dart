import 'dart:convert';

import '../model/bank_account.dart';
import 'base_service.dart';

class BankAccountService extends BaseService {
  static const basePath = '/api/v1/accounts';

  Future<List<BankAccount>> selectAll() async {
    final response = await get(basePath);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => BankAccount.fromJson(json)).toList();
    }
    return [];
  }

  Future<BankAccount?> selectMain() async {
    final response = await get('$basePath/main');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null) return null;
      return BankAccount.fromJson(data);
    }
    return null;
  }

  Future<BankAccount?> insert(BankAccount account) async {
    final response = await post(basePath, account.toJson());
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return BankAccount.fromJson(data);
    }
    return null;
  }

  Future<BankAccount?> updateItem(BankAccount account) async {
    final response = await put('$basePath/${account.id}', account.toJson(update: true));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BankAccount.fromJson(data);
    }
    return null;
  }

  Future<void> deactivateById(int id) async {
    final response = await delete('$basePath/$id');
    if (response.statusCode != 204) {
      return;
    }
  }

  Future<List> getTransactions(int accountId, int limit) async {
    final response = await get('$basePath/$accountId/transactions', queryParameters: {'limit': limit});
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data;
    }
    return [];
  }

  Future<List> accountDailyBalance(
    int accountId, {
    DateTime? dateRangeStart,
    DateTime? dateRangeEnd,
  }) async {
    final Map<String, dynamic> params = {};
    if (dateRangeStart != null) {
      params['start'] = dateRangeStart.toIso8601String().substring(0, 10);
    }
    if (dateRangeEnd != null) {
      params['end'] = dateRangeEnd.toIso8601String().substring(0, 10);
    }
    final response = await get('$basePath/$accountId/daily_balance', queryParameters: params);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data;
    }
    return [];
  }
}
