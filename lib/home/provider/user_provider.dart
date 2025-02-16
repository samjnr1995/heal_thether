import 'package:flutter/material.dart';
import '../model/model.dart';
import '../service/service.dart';

class UserProvider with ChangeNotifier {
  UserProvider() {
    fetchUsers();
  }
  final ApiService _apiService = ApiService();
  List<UserData> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<UserData> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _apiService.fetchUsers();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
