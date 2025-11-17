import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_data.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
      ),
      body: ListView.builder(
        itemCount: groceryItem.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ListTile(
              title: Text(groceryItem[index].name),
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: groceryItem[index].category.color,
                  shape: BoxShape.rectangle,
                ),
              ),
              trailing: Text(groceryItem[index].quantity.toString()),
            ),
          );
        },
      ),
    );
  }
}
