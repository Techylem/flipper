import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/domain/redux/authentication/auth_actions.dart';
import 'package:flipper/presentation/settings/privacy_settings_button.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:flutter_redux/flutter_redux.dart';

import 'auth_button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Flipper", style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40.0),
              child: _LoginForm(),
            ),
            PrivacySettingsButton(),
          ],
        ),
      ),
    );
  }
}

// MARK: Login Form

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    final submitCallback = () async {
      //TODO: stop faking login
      final _user = new UserData(
          email: "sample@yegobox.com", //TODO: get this from after auth2
          username: "username",
          avatar: "Avatar",
          status: "available",
          bearerToken: "token",
          refreshToken: "refresh token");

      StoreProvider.of<AppState>(context)
          .state
          .database
          .userDao
          .insertUser(_user);
      StoreProvider.of<AppState>(context).dispatch(UserAction);
      //stop faking
    };

    final submitButton = AuthButton(
        buttonText: "Login with yegobox?", onPressedCallback: submitCallback);

    return Form(
      child: Column(
        children: <Widget>[submitButton],
      ),
    );
  }
}