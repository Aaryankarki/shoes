import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shoes/global_variable.dart';
import 'package:shoes/pages/product_detailpage.dart';
import 'package:shoes/widget/product_card.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = ["All", "Adidas", "Nike", "Bata"];
  late String selectedfilters;
  List<Map<String, dynamic>> _searchProducts = [];
  bool _issearchEnabled = false;

  @override
  void initState() {
    selectedfilters = filters[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final filteredProducts = selectedfilters == "All"
        ? _issearchEnabled
              ? _searchProducts
              : products
        : _issearchEnabled
        ? _searchProducts
        : products
              .where((product) => product['company'] == selectedfilters)
              .toList();

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.menu, size: 30),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/shoes_1.png",
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Shoes\nCollection",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _issearchEnabled = false;
                          return;
                        }

                        _issearchEnabled = true;

                        _searchProducts = filteredProducts
                            .where(
                              (e) => e['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains(value),
                            )
                            .toList();
                      });
                    
                    },
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: border,
                      focusedBorder: border,
                      enabledBorder: border,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedfilters = filter;
                        });
                      },

                      child: Chip(
                        backgroundColor: selectedfilters == filter
                            ? (const Color.fromARGB(255, 80, 173, 249))
                            : null,
                        label: Text(filter),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,

                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                    },
                    child: ProductCard(
                      title: product['title'] as String,
                      price: product['price'] as double,
                      image: product['imageUrl'] as String,
                      backgroundColor: index.isEven
                          ? Colors.blue
                          : const Color.fromARGB(255, 246, 241, 241),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
