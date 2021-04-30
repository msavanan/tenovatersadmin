import 'dart:async';

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:amplify_flutter/amplify.dart';

import 'models/Enquiry.dart';

Future<List<dynamic>> getQuery() async {
  try {
    //await Amplify.DataStore.clear();
    return await Amplify.DataStore.query(Enquiry.classType, sortBy: [
      QuerySortBy(
        order: QuerySortOrder.ascending,
        field: 'date',
      )
    ]);
  } catch (e) {
    print('Query failed: $e');
  }
}

/*Stream<SubscriptionEvent<Enquiry>>*/ observeQuery() {
  try {
    Stream<SubscriptionEvent<Enquiry>> stream =
        Amplify.DataStore.observe(Enquiry.classType);
    print('${stream.length}');
    stream.listen((event) async {
      print(
          '---------------------------------------------------------------------');
      print(event.item.date);
      print(event.item.runtimeType);
      return true;
      print(
          '---------------------------------------------------------------------');
      return true;
    });
  } catch (e) {
    print('Query failed: $e');
  }
  return false;
}
