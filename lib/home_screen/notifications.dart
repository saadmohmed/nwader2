import 'dart:ffi';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import '../model/Ad.dart';

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController? animationController;

  Animation<double>? topBarAnimation;

  final storage = new FlutterSecureStorage();
  ApiProvider _api = new ApiProvider();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;

  dynamic _state = '';
  bool status = true;
  int quantity = 0;

  double address_opacity = 1;
  double payment_opacity = 1;

  Icon arrow_down = Icon(
    Icons.arrow_downward_sharp,
    color: AppTheme.white,
  );
  Icon arrow_up = Icon(Icons.arrow_upward_sharp, color: AppTheme.white);

  String? payment_method = 'ar';
  String? address;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  TextEditingController phone = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text(
            'حسابي',
            style: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppTheme.green,
              ),
            ),
          ),
          leading: GestureDetector(
            onTap: () async {
              _key.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset('assets/icons/menu-icon.png'),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_sharp,
                  color: AppTheme.green,
                ),
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //to give space from top
              ExpandableNotifier(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: AppTheme.green,
                        child: ScrollOnExpand(
                          scrollOnExpand: true,
                          scrollOnCollapse: false,
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              tapBodyToCollapse: true,
                            ),
                            header: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            // width: MediaQuery.of(context)
                                            //     .size
                                            //     .width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              color: AppTheme.green,
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 30,
                                            child: Container(
                                              height: 200,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: AppTheme.white,
                                                borderRadius:
                                                BorderRadius.circular(50.0),
                                              ),

                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppTheme.white,
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.notifications,
                                                  color: AppTheme.green,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                            collapsed: Text(
                              'sssssssssssssssddddddddddddddddddddddds',
                              softWrap: true,
                              maxLines: 2,
                              textDirection: TextDirection.rtl,
                              // overflow: TextOverflow.ellipsis,
                            ),
                            expanded: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                for (var _ in Iterable.generate(5))
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        'asdasdsad',
                                        softWrap: true,
                                        overflow: TextOverflow.fade,
                                      )),
                              ],
                            ),
                            builder: (_, collapsed, expanded) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Expandable(
                                  collapsed: collapsed,
                                  expanded: expanded,
                                  theme: const ExpandableThemeData(
                                      crossFadePoint: 0),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
