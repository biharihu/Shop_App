import 'package:flutter/foundation.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get items {
    return {..._item};
  }

  int get itemCount {
    return _item.length;
  }

  double get totalAmount {
    var total = 0.0;
    _item.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItems(String productId, double price, String title) {
    if (_item.containsKey(productId)) {
      // change quantity
      _item.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _item.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_item.containsKey(productId)) {
      return;
    }

    if (_item[productId].quantity > 1) {
      _item.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _item.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _item = {};
    notifyListeners();
  }
}
