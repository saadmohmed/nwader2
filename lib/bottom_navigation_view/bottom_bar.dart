import 'package:flutter/material.dart';

import '../home_screen/categories.dart';
import '../home_screen/home_screen.dart';
import '../models/tabIcon_data.dart';
import 'bottom_bar_view.dart';

Widget bottomBar(animationController , context) {
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  return Column(
    children: <Widget>[
      const Expanded(
        child: SizedBox(),
      ),
      BottomBarView(
        tabIconsList: tabIconsList,
        addClick: () {

        },
        changeIndex: (int index) {
          if (index == 0 ) {
            animationController?.reverse().then<dynamic>((data) {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            });
          } else if (index == 1) {
            animationController?.reverse().then<dynamic>((data) {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categories(animationController: animationController,)),
              );

            });
          } else if (index == 2) {
            animationController?.reverse().then<dynamic>((data) {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categories(animationController: animationController,)),
              );

            });
          }else if (index == 3) {
            animationController?.reverse().then<dynamic>((data) {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Categories(animationController: animationController,)),
              );

            });
          }
        },
      ),
    ],
  );
}
