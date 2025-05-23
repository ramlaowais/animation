import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final String description;
  final String imagePath;
  bool isFavorite;

  FoodItem({required this.name, required this.description, required this.imagePath, this.isFavorite = false});
}

class FoodListScreen extends StatefulWidget {
  @override
  _FoodListScreenState createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> with SingleTickerProviderStateMixin {
  List<FoodItem> foodItems = [
    FoodItem(name: "Burger", description: "Cheesy and delicious", imagePath: "assets/food1.png"),
    FoodItem(name: "fries", description: "Juicy beef patty", imagePath: "assets/food2.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food List')),
      body: ListView.builder(
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return FoodListItem(
            food: foodItems[index],
            onFavoriteToggle: () {
              setState(() {
                foodItems[index].isFavorite = !foodItems[index].isFavorite;
              });
            },
          );
        },
      ),
    );
  }
}

class FoodListItem extends StatefulWidget {
  final FoodItem food;
  final VoidCallback onFavoriteToggle;

  const FoodListItem({Key? key, required this.food, required this.onFavoriteToggle}) : super(key: key);

  @override
  _FoodListItemState createState() => _FoodListItemState();
}

class _FoodListItemState extends State<FoodListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.8,
      upperBound: 1.2,
    );

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  void _handleDoubleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(widget.food.imagePath, width: 60, height: 60, fit: BoxFit.cover),
        title: Text(widget.food.name),
        subtitle: Text(widget.food.description),
        trailing: GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Icon(
              Icons.favorite,
              color: widget.food.isFavorite ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
