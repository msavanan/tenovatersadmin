import 'dart:async';
import 'package:amplify_flutter/amplify.dart';
import 'models/Enquiry.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';

/*Future<List<dynamic>> getQuery() async {
  try {
    //await Amplify.DataStore.clear();
    return await Amplify.DataStore.query(Enquiry.classType);
  } catch (e) {
    print('Query failed: $e');
  }
} */

Stream<SubscriptionEvent<Enquiry>> getQuery() {
  try {
    Stream<SubscriptionEvent<Enquiry>> stream =
        Amplify.DataStore.observe(Enquiry.classType);
    /*stream.listen((event) {
      print(event.item.toString());
    });*/
    return stream;
  } catch (e) {
    print('Query failed: $e');
  }
}
