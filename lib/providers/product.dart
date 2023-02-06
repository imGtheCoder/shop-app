import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
 
  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url = Uri.parse(
        'https://shop-app-d7b3b-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    final oldIsFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));

    if(response.statusCode >= 400) {
      isFavorite =oldIsFavorite;
      notifyListeners();
      throw HttpException('Could not add to favorites');      
    }
    notifyListeners();
  }
}
