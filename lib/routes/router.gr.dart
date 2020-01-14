// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/router_utils.dart';
import 'package:flipper/presentation/splash/splash_screen.dart';
import 'package:flipper/presentation/home/dash_board.dart';
import 'package:flipper/presentation/splash/aftersplash.dart';
import 'package:flipper/home/bottom_sheet_sreen.dart';
import 'package:flipper/home/sale_screen.dart';
import 'package:flipper/presentation/business/create_business_screen.dart';
import 'package:auto_route/transitions_builders.dart';

class Router {
  static const splashScreen = '/';
  static const dashboard = '/dashboard';
  static const afterSplash = '/afterSplash';
  static const bottom = '/bottom';
  static const saleScreen = '/saleScreen';
  static const createBusinessScreen = '/createBusinessScreen';
  static GlobalKey<NavigatorState> get navigatorKey =>
      getNavigatorKey<Router>();
  static NavigatorState get navigator => navigatorKey.currentState;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Router.splashScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => SplashScreen(key: typedArgs),
          settings: settings,
        );
      case Router.dashboard:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => DashBoard(key: typedArgs),
          settings: settings,
        );
      case Router.afterSplash:
        return MaterialPageRoute(
          builder: (_) => AfterSplash(),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.bottom:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => BottomSheetScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.saleScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return MaterialPageRoute(
          builder: (_) => SaleScreen(key: typedArgs),
          settings: settings,
          fullscreenDialog: true,
        );
      case Router.createBusinessScreen:
        if (hasInvalidArgs<Key>(args)) {
          return misTypedArgsRoute<Key>(args);
        }
        final typedArgs = args as Key;
        return PageRouteBuilder(
          pageBuilder: (ctx, animation, secondaryAnimation) =>
              CreateBusinessScreen(key: typedArgs),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}