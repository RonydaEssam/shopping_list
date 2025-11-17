import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carb,
  sweets,
  spices,
  hygiene,
  other,
}

class Category {
  final String name;
  final Color color;

  const Category({required this.name, required this.color});
}
