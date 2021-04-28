import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:tenovatersadmin/get_query.dart';
import 'package:tenovatersadmin/homePage.dart';
import 'models/Enquiry.dart';

import 'package:amplify_api_plugin_interface/amplify_api_plugin_interface.dart';

class QueryListView extends StatefulWidget {
  @override
  _QueryListViewState createState() => _QueryListViewState();
}

class _QueryListViewState extends State<QueryListView> {
  clear() async {
    try {
      await Amplify.DataStore.clear();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Enquiry> enquiry = [];
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder(
                stream:
                    Amplify.DataStore.observe(Enquiry.classType), //getQuery(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  enquiry.add(snapshot.data.item);
                  print(enquiry);
                  return ListView(
                      children: enquiry
                          .map((e) => Container(
                              margin: EdgeInsets.all(6),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: ' +
                                      e.date.getDateTimeInUtc().day.toString() +
                                      '-' +
                                      e.date
                                          .getDateTimeInUtc()
                                          .month
                                          .toString() +
                                      '-' +
                                      e.date
                                          .getDateTimeInUtc()
                                          .year
                                          .toString()),
                                  Text('Subject: ' + e.subject),
                                  Text('Message: \n ' + e.message),
                                  Container(
                                    height: 16,
                                  )
                                ],
                              )))
                          .toList());
                }),
          ),
          Container(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (currentFocus.hasFocus) {
                  currentFocus.unfocus();
                }
                try {
                  await Amplify.Auth.signOut();
                } on AuthException catch (e) {
                  print(e.message);
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
              child: Text('Sign Out'),
            ),
          ),
        ],
      ),
    ));
  }
}
