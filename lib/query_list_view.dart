import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:tenovatersadmin/get_query.dart';
import 'package:tenovatersadmin/homePage.dart';

import 'models/Enquiry.dart';

class QueryListView extends StatefulWidget {
  @override
  _QueryListViewState createState() => _QueryListViewState();
}

class _QueryListViewState extends State<QueryListView> {
  var query;

  _getQuery() {
    query = getQuery();

    return query;
  }

  @override
  Widget build(BuildContext context) {
    try {
      Stream<SubscriptionEvent<Enquiry>> stream =
          Amplify.DataStore.observe(Enquiry.classType);
      stream.listen((event) async {
        setState(() {
          query = getQuery();
        });
      });
    } catch (e) {
      print('Query failed: $e');
    }
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerRight,
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
            Expanded(
              child: FutureBuilder(
                  future: _getQuery(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, index) {
                          print(index);
                          return Container(
                              margin: EdgeInsets.all(6),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Date: ' +
                                        snapshot.data[index].date
                                            .getDateTimeInUtc()
                                            .day
                                            .toString() +
                                        '-' +
                                        snapshot.data[index].date
                                            .getDateTimeInUtc()
                                            .month
                                            .toString() +
                                        '-' +
                                        snapshot.data[index].date
                                            .getDateTimeInUtc()
                                            .year
                                            .toString()),
                                    Text('Subject: ' +
                                        snapshot.data[index].subject),
                                    Text('Message: \n ' +
                                        snapshot.data[index].message),
                                    Container(
                                      height: 16,
                                    )
                                  ]));
                        });
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
