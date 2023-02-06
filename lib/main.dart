import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          //create: (ctx) => Orders(),
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) => MaterialApp(
                title: 'MyShop',
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.orange,
                  fontFamily: 'Lato',
                ),
                home: auth.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (context, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen(),
                      ),
                routes: {
                  ProductsOverviewScreen.routeName: (context) =>
                      ProductsOverviewScreen(),
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (context) =>
                      UserProductsScreen(),
                  EditProductScreen.routeName: (context) => EditProductScreen(),
                })),
      ),
    );
  }
}
