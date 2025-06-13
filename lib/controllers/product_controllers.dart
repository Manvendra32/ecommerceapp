import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var categories = <String>[].obs;
  var products = <Product>[].obs;
  var cart = <Product, int>{}.obs;

  var isLoading = true.obs;
  var productQuantities = <int, RxInt>{};

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      var result = await ApiService.getCategories();
      categories.assignAll(result);
    } finally {
      isLoading(false);
    }
  }

  void fetchProductsByCategory(String category) async {
    try {
      isLoading(true);
      var result = await ApiService.getProductsByCategory(category);
      products.assignAll(result);
    } finally {
      isLoading(false);
    }
  }

  RxInt getQuantityForProduct(Product product) {
    if (!productQuantities.containsKey(product.id)) {
      if (cart.containsKey(product)) {
        productQuantities[product.id] = cart[product]!.obs;
      } else {
        productQuantities[product.id] = 1.obs;
      }
    }
    return productQuantities[product.id]!;
  }

  void incrementProductQuantity(Product product) {
    getQuantityForProduct(product).value++;
  }

  void decrementProductQuantity(Product product) {
    if (getQuantityForProduct(product).value > 1) {
      getQuantityForProduct(product).value--;
    }
  }

  void addToCart(Product product) {
    final quantity = getQuantityForProduct(product).value;
    if (cart.containsKey(product)) {
      cart[product] = cart[product]! + quantity;
    } else {
      cart[product] = quantity;
    }

    Get.snackbar(
      "Added to Cart",
      "${product.title} (x$quantity) has been added",
      backgroundColor: Colors.green[100],
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(12),
      icon: Icon(Icons.shopping_cart, color: Colors.green),
    );
  }

  void removeFromCart(Product product) {
    cart.remove(product);
    productQuantities.remove(product.id);

    Get.snackbar(
      "Removed from Cart",
      "${product.title} has been removed",
      backgroundColor: Colors.red[100],
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(12),
      icon: Icon(Icons.delete, color: Colors.red),
    );
  }

  void incrementQuantity(Product product) {
    if (cart.containsKey(product)) {
      cart[product] = cart[product]! + 1;
      getQuantityForProduct(product).value = cart[product]!;
    }
  }

  void decrementQuantity(Product product) {
    if (cart.containsKey(product) && cart[product]! > 1) {
      cart[product] = cart[product]! - 1;
      getQuantityForProduct(product).value = cart[product]!;
    } else {
      removeFromCart(product);
    }
  }

  // double get totalPrice => cart.fold(0, (sum, item) => sum + item.price);
  double get totalPrice =>
      cart.entries.fold(0, (sum, item) => sum + item.key.price * item.value);
}
