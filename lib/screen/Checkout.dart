import 'package:flutter/material.dart';
import '../model/Item.dart';
import "package:provider/provider.dart";
import "../provider/shoppingcart_provider.dart";

class Checkout extends StatelessWidget {
  const Checkout({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isCartEmpty = context.watch<ShoppingCart>().cart.isEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Item Details"),
          if (isCartEmpty)
            const Text("No items to checkout")
          else
            getItems(context),
          const Divider(height: 4, color: Colors.black),
          Flexible(
              child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                computeCost(),
                if (!isCartEmpty)
                  ElevatedButton(
                      onPressed: () {
                        context.read<ShoppingCart>().removeAll();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Payment successful!")));
                      },
                      child: const Text("Pay now!"))
              ]))),
          TextButton(
            child: const Text("Go back to Product Catalog"),
            onPressed: () {
              Navigator.pushNamed(context, "/products");
            },
          ),
        ],
      ),
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    return products.isEmpty
        ? const Text('No items to checkout!')
        : Expanded(
            child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.food_bank),
                    title: Text(products[index].name),
                    trailing: Text(
                      products[index].price.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16),
                    ), // Display the price instead of the delete icon
                  );
                },
              )),
            ],
          ));
  }

  Widget computeCost() {
    return Consumer<ShoppingCart>(builder: (context, cart, child) {
      return Text("Total: ${cart.cartTotal}");
    });
  }
}
