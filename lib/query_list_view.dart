import 'package:flutter/material.dart';

class QueryListView extends StatelessWidget {
  final Function getQuery;
  QueryListView({this.getQuery});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getQuery(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            print(snapshot.data);
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, int index) {
                  return Container(
                      child: Text(snapshot.data[index]
                          .message) //Text(enquiryList[index].message),
                      );
                });
          }),
    );
  }
}
