import 'package:flutter/material.dart';

import '../constants.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Container(
        height: height * 0.4,
        padding: EdgeInsets.only(left: height * 0.05, top: height * 0.15),
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        width: width,
        child: Text(
          'Tenevators Group',
          style: TextStyle(fontSize: width * 0.075),
        ));
  }
}
