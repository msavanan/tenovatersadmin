import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:tenovatersadmin/query_list_view.dart';
import 'package:tenovatersadmin/userForm/user_text_form_field.dart';
import 'package:tenovatersadmin/userForm/validator.dart';
import 'package:tenovatersadmin/widgets/headerWidget.dart';

import 'dart:developer' as dev;

import 'get_query.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _signInKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double spacer = height / 40;

    void snackBarMessenger(String error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }

    void _signIn() async {
      String error = "Error Signing in";
      try {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Signing in...')));
        SignInResult res = await Amplify.Auth.signIn(
            username: _emailController.text.trim(),
            password: _passwordController.text.trim());

        dev.log('Sign In Result: ' + res.toString(),
            name: 'com.amazonaws.amplify');

        print(res.isSignedIn);
        if (res.isSignedIn) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return Container(
                height: MediaQuery.of(context).size.height * .3,
                child: QueryListView());
          }));
        }
      } on UserNotFoundException catch (e) {
        error = 'Incorrect UserName';
        snackBarMessenger(error);
      } on NotAuthorizedException catch (e) {
        error = 'Incorrect username or password.';
        snackBarMessenger(error);
      } on AuthException catch (e) {
        print(e);
        snackBarMessenger(error);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(width, height * 0.2), child: HeaderWidget()),
        body: Container(
          height: height * 0.7,
          child: SingleChildScrollView(
            child: Form(
              key: _signInKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                        top: height * 0.05),
                    child: Column(children: [
                      UserTextField(
                        hintTxt: 'E-mail',
                        labelTxt: 'E-mail*',
                        validator: emailValidator,
                        controller: _emailController,
                      ),
                      Container(height: spacer),
                      UserTextField(
                        hintTxt: 'Passsword',
                        labelTxt: 'Passsword*',
                        validator: passwordValidator,
                        obscureTxt: true,
                        controller: _passwordController,
                      ),
                      Container(height: spacer),
                    ]),
                  ),
                  Container(height: spacer),
                  ElevatedButton(
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (currentFocus.hasFocus) {
                          currentFocus.unfocus();
                        }
                        if (_signInKey.currentState.validate()) {
                          _signIn();
                        }
                      },
                      child: Container(
                          height: 50,
                          width: width * 0.5,
                          child: Center(
                            child: Text(
                              'Log In',
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                          ))),
                  Container(height: spacer),
                  GestureDetector(
                      onTap: () {},
                      child: Container(
                          height: 50, child: Text('Forgot PassWord'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
