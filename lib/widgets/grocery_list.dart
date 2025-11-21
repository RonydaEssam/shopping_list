import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'shopping-list-b0621-default-rtdb.firebaseio.com',
      'grocery-list.json',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data, Please try again later';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];

      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (MapEntry<Categories, Category> element) =>
                  element.value.name == item.value['category'],
            )
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        _isLoading = false;
      });

      print(response.body);
    } catch (error) {
      setState(() {
        _error = 'Failed to fetch data, Please try again later';
        _isLoading = false;
      });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => NewItem(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    final url = Uri.https(
      'shopping-list-b0621-default-rtdb.firebaseio.com',
      'grocery-list/${item.id}.json',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        throw Error();
      }
    } catch (err) {
      setState(() {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed Deleting!')));
        _groceryItems.insert(index, item);
      });
      return;
    }
  }

  Widget content() {
    Widget content;
    Widget emptyList = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your grocery list is empty',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Try adding some items ...',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );

    content = emptyList;

    Widget userList = ListView.builder(
      itemCount: _groceryItems.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(_groceryItems[index].id),
          direction: DismissDirection.endToStart,

          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);

            if (_groceryItems.isEmpty) {
              content = emptyList;
            }
          },

          background: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            child: Container(
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(color: Colors.red),
              child: Container(
                margin: EdgeInsets.only(right: 30),
                child: Icon(Icons.delete),
              ),
            ),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _groceryItems[index].category.color,
                  shape: BoxShape.rectangle,
                ),
              ),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          ),
        );
      },
    );

    if (_error != null) {
      return Center(
        child: Text(_error!),
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      return content = userList;
    }

    return content;
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

      body: content(),
    );
  }
}
