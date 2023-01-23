import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(child: FittedBox(child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text('\$${price/quantity}'),
          ))),
          title: Text(title),
          subtitle: Text('Total: \$$price'),
          trailing: Text('${quantity}x'),
        ),
      ),
    );
  }
}
