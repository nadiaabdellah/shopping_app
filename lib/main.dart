import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ShoppingProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}


class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String category;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
  });
}






final List<Product> products = [
  Product(
    id: 1,
    name: "T-Shirt",
    price: 20,
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd5dhSSY18MgU-A1GVlEVoTcG3_9M9RLqcIKDqNqR37w&s=10",
    category: "Clothes",
    description: "A comfortable T-Shirt for everyday use.",
  ),


  Product(
    id: 2,
    name: "Running Shoes",
    price: 50,
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDP2Vsfat9KdmqC-q4UtZX_6hPLTkFuLYYMrBBCMkdnQ&s=10",
    category: "Shoes",
    description: "Lightweight shoes suitable for running.",
  ),


  Product(
    id: 3,
    name: "Watch",
    price: 80,
    image:"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7_ojrXxFm9qlZmxlTQcEit7NAX0Hdz0TM296QcsVu3Q&s=10",
    category: "Accessories",
    description: "A simple and stylish watch.",
  ),


  Product(
    id: 4,
    name: "Backpack",
    price: 40,
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREFaB6LPY2J1CvknPCDY0lo9vVSMpeeFZ1xdy6YfjwPw&s=10",
    category: "Accessories",
    description: "A useful backpack for school and work.",
  ),


  Product(
    id: 5,
    name: "Hoodie",
    price: 35,
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiAmEv5P2idvUbwd2zVFGG2TBqPdpQ6-fc4gkzCE_AHA&s=10",
    category: "Clothes",
    description: "A warm hoodie for cold days.",
  ),


  Product(
    id: 6,
    name: "Sneakers",
    price: 65,
    image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVR0ie6byZCKmXz0hQE3TB8WT6FzDQKMBHx1W-utpMSA&s=10",
    category: "Shoes",
    description: "Comfortable sneakers for daily use.",
  ),
];




class ShoppingProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  final List<Product> _favorites = [];

  List<Product> get cart => List.unmodifiable(_cart);

  void addToCart(Product product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cart.remove(product);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;

    for (Product product in _cart) {
      total += product.price;
    }

    return total;
  }

  List<Product> get favorites => List.unmodifiable(_favorites);

  void toggleFavorite(Product product) {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }

    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product);
  }
}



         
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchText = "";
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((product) {
      final categoryMatch =
          selectedCategory == "All" ||
          product.category == selectedCategory;

      final searchMatch =
          product.name.toLowerCase().contains(
                searchText.toLowerCase(),
              );

      return categoryMatch && searchMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            },
            icon: Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryButton("All"),
                categoryButton("Clothes"),
                categoryButton("Shoes"),
                categoryButton("Accessories"),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Products
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              itemCount: filteredProducts.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return ProductCard(
                  product: product,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String category) {
    final bool isSelected =
        selectedCategory == category;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (value) {
          setState(() {
            selectedCategory = category;
          });
        },
      ),
    );
  }
}


 class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingProvider>(context);

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsPage(product: product),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  product.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 8),

              Text(
                product.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "\$${product.price}",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      provider.toggleFavorite(product);
                    },
                    icon: Icon(
                      provider.isFavorite(product)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      provider.addToCart(product);

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            "${product.name} added to cart",
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_shopping_cart),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoppingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product.image,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            SizedBox(height: 20),

            Text(
              product.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "\$${product.price}",
              style: TextStyle(
                fontSize: 22,
              ),
            ),

            SizedBox(height: 10),

            Text(
              product.category,
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            SizedBox(height: 20),

            Text(
              product.description,
              style: TextStyle(
                fontSize: 17,
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  provider.addToCart(product);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        "${product.name} added to cart",
                      ),
                    ),
                  );
                },
                child: Text("Add to Cart"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ShoppingProvider>(context);

    final cart = provider.cart;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),

      body: cart.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];

                      return ListTile(
                        leading: Image.network(
                          product.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),

                        title: Text(
                          product.name,
                        ),

                        subtitle: Text(
                          "\$${product.price}",
                        ),

                        trailing: IconButton(
                          onPressed: () {
                            provider.removeFromCart(product);
                          },
                          icon: Icon(
                            Icons.delete,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "\$${provider.totalPrice}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}






class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ShoppingProvider>(context);

    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),

      body: favorites.isEmpty
          ? Center(
              child: Text(
                "No favorites yet",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final product = favorites[index];

                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),

                  title: Text(
                    product.name,
                  ),

                  subtitle: Text(
                    "\$${product.price}",
                  ),

                  trailing: IconButton(
                    onPressed: () {
                      provider.toggleFavorite(product);
                    },
                    icon: Icon(
                      Icons.favorite,
                    ),
                  ),
                );
              },
            ),
    );
  }
}













