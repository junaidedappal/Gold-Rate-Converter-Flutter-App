import 'package:flutter/material.dart';
import 'package:gold_rate_converter/gold_rate_converter_material_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoldRateConverterMaterialPage(),
    );
  }
}
