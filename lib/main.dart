import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:tenovatersadmin/homePage.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AmplifyAuthCognito auth = AmplifyAuthCognito();
  AmplifyDataStore amplifyDataStore =
      AmplifyDataStore(modelProvider: ModelProvider.instance);

  bool configured = false;
  bool authenticated = false;

  @override
  initState() {
    super.initState();

    Amplify.addPlugins([auth, amplifyDataStore, AmplifyAPI()]);

    Amplify.configure(amplifyconfig).then((value) {
      print("Amplify Configured");
      setState(() {
        configured = true;
      });
    }).catchError(print);
  }

  Future<void> _checkSession() async {
    print("Checking Auth Session...");
    try {
      var session = await auth.fetchAuthSession();
      authenticated = session.isSignedIn;
    } catch (error) {
      print(error);
    }
    _setupAuthEvents();
  }

  void _setupAuthEvents() {
    Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      switch (hubEvent.eventName) {
        case "SIGNED_IN":
          {
            print("HUB: USER IS SIGNED IN");
            setState(() {
              authenticated = true;
            });
          }
          break;
        case "SIGNED_OUT":
          {
            print("HUB: USER IS SIGNED OUT");
            setState(() {
              authenticated = false;
            });
          }
          break;
        case "SESSION_EXPIRED":
          {
            print("HUB: USER SESSION EXPIRED");
            setState(() {
              authenticated = false;
            });
          }
          break;
        default:
          {
            print("HUB: CONFIGURATION EVENT");
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: Scaffold(body: HomePage()));
  }
}
