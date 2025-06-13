import 'package:ecommerce/controllers/product_controllers.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final ProductController controller = Get.find();

  ProductDetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final quantity = controller.getQuantityForProduct(product);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Product Details",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              product.title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              product.description,
              style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[800]),
            ),
            const SizedBox(height: 10),

            // Price
            Text(
              '₹${product.price}',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),

            // Quantity Selector
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () =>
                        controller.decrementProductQuantity(product),
                  ),
                ),
                const SizedBox(width: 16),
                Obx(
                  () => Text(
                    '${quantity.value}',
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.withOpacity(0.1),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () =>
                        controller.incrementProductQuantity(product),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.addToCart(product),
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: Text(
                  'Add to Cart',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
