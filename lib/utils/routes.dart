import 'package:flutter/material.dart';
import 'package:simplechat/screens/auth/lending_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/main_screen.dart';
import 'constants.dart';

class Routes {
  static getRoutes() {
    return <String, WidgetBuilder>{
      route_login: (context) => LoginScreen(),
      route_main: (context) => MainScreen(),
      route_splash: (context) => LendingScreen(),
    };
  }
}