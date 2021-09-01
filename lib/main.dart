// @dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './Utils/routes.dart';
import './screens/detail_screen.dart';
import './screens/home_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Xicom Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.orange,
        backgroundColor: Colors.white,
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),
        primaryColor: Colors.blue,
        primaryIconTheme:
            Theme.of(context).primaryIconTheme.copyWith(color: Colors.white),
      ),
      initialRoute: MyRoutes.INITIAL_ROUTE,
      //Setting NAmed Routes
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case MyRoutes.INITIAL_ROUTE:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(),
              settings: settings,
            );

          //Route for Date Home Page.
          case MyRoutes.DETAIL_ROUTE:
            return CupertinoPageRoute(
              builder: (_) => DetailsScreen(),
              settings: settings,
            );

          default:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(),
              settings: settings,
            );
        }
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => HomeScreen(),
        );
      },
    );
  }

  //Method to get the data
}
