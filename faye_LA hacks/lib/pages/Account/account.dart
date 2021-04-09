import 'package:flutter/material.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> computeFuture = Future.value();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top: 150),
            child: Column(
              children: [

              ],
            ),
          ),
        ],
      ),
    );
  }


}