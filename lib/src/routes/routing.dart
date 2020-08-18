import 'package:flutter/widgets.dart';
import 'package:koompi_hotspot/src/app.dart';
import 'package:koompi_hotspot/src/components/navbar.dart';
import 'package:koompi_hotspot/src/screen/create_account/create_email.dart';
import 'package:koompi_hotspot/src/screen/login/login_page.dart';

class AppRouting{


  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{ /* Login Screen */
    '/': (context) => Splash(),
    '/navbar': (context) => Navbar(),
    '/signUpScreen': (context) => CreateEmail(),
    '/loginScreen': (context) => LoginPage(),
  };
}