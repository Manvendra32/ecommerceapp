import 'dart:convert';
import 'package:ecommerce/model/product_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<String>> getCategories() async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/categories'),
    );
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products/category/$category'),
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
