import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/model.dart';

// Custom Exception for No Internet Connection
class NoInternetException implements Exception {
  final String message;
  NoInternetException(
      [this.message =
          "No internet connection was found\n please check and try again."]);

  @override
  String toString() => message;
}

class ApiService {
  static const String apiUrl = "https://jsonplaceholder.typicode.com/users";

  Future<List<UserData>> fetchUsers() async {
    print("Fetching users from API: $apiUrl");

    try {
      final response = await http.get(Uri.parse(apiUrl));

      print("API Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Successfully fetched data from API.");
        List<dynamic> data = json.decode(response.body);

        print("Total Users Fetched: ${data.length}");
        return data.map((json) => UserData.fromJson(json)).toList();
      } else if (response.statusCode == 500) {
        print("Error: Internal server error (500).");
        throw Exception("Internal server error.");
      } else {
        print("Error: Unexpected response status: ${response.statusCode}");
        throw Exception("Unexpected response: ${response.statusCode}");
      }
    } on SocketException {
      print("Error: No internet connection.");
      throw NoInternetException();
    } on HttpException {
      print("Error: Request failed.");
      throw Exception("Request failed.");
    } catch (e) {
      print("Unexpected error occurred: $e");
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
