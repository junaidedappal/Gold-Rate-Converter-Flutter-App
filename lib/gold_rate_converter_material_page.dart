import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoldRateConverterMaterialPage extends StatefulWidget {
  const GoldRateConverterMaterialPage({super.key});

  @override
  State<GoldRateConverterMaterialPage> createState() =>
      _GoldRateConverterMaterialPageState();
}

class _GoldRateConverterMaterialPageState
    extends State<GoldRateConverterMaterialPage> {
  double result = 0;
  double gst = 0;
  double laborCharge = 0;
  double total = 0;
  double pricePer8Grams = 0;
  double goldRatePerTroyOunce = 0; // Variable to hold the fetched gold rate
  final TextEditingController weightEditingController = TextEditingController();
  final TextEditingController pricePer8GramsEditingController =
      TextEditingController();

  @override
  void dispose() {
    weightEditingController.dispose();
    pricePer8GramsEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchGoldRate(); // Fetch gold rate when the widget initializes
  }

  Future<void> fetchGoldRate() async {
    const url = 'USE API FROM api.metalpriceapi.com';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        goldRatePerTroyOunce = data['rates']['INR'];
        // Calculate price for 8 grams initially
        pricePer8Grams = goldRatePerTroyOunce / 31.2 * 8;
        pricePer8GramsEditingController.text =
            pricePer8Grams.toStringAsFixed(2);
      });
    } else {
      throw Exception('Failed to load gold rate');
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(10),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 242, 241),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_outlined,
              color: Colors.black,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'GOLD RATE CONVERTER',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Gold Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'INR ${result.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 7, 4),
                        ),
                      ),
                      const Divider(height: 20),
                      _buildResultRow('GST (3%)', gst.toStringAsFixed(2)),
                      _buildResultRow(
                          'Labor Charge (5%)', laborCharge.toStringAsFixed(2)),
                      const Divider(height: 20),
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'INR ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: weightEditingController,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Weight in grams',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: const Icon(Icons.scale),
                        prefixIconColor: Colors.black,
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.amber,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: pricePer8GramsEditingController,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Price per 8 grams (pavan)',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: const Icon(Icons.money),
                        prefixIconColor: Colors.black,
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.amber,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    String weightText = weightEditingController.text.trim();
                    String pricePer8GramsText =
                        pricePer8GramsEditingController.text.trim();
                    if (weightText.isEmpty || pricePer8GramsText.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Input Error'),
                          content: const Text(
                              'Please enter weight and price per 8 grams.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      try {
                        double weightValue = double.parse(weightText);
                        double pricePerGram =
                            double.parse(pricePer8GramsText) / 8;
                        if (weightValue != 0 && pricePerGram != 0) {
                          setState(() {
                            result = weightValue * pricePerGram;
                            gst = result * 0.03;
                            laborCharge = result * 0.05;
                            total = result + gst + laborCharge;
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Input Error'),
                              content: const Text('Please enter valid inputs.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Input Error'),
                            content: const Text('Please enter valid inputs.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.amber),
                    foregroundColor:
                        WidgetStatePropertyAll<Color>(Colors.black),
                    minimumSize: const WidgetStatePropertyAll<Size>(
                      Size(double.infinity, 50),
                    ),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Convert',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'INR $value',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
