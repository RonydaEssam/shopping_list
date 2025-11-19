import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_data.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  void _addItem() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => NewItem(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: groceryItem.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
