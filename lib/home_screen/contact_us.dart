
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import 'notifications.dart';

class ContactUs extends StatefulWidget {


  const ContactUs(
      {Key? key,
         })
      : super(key: key);
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController? animationController;

  Animation<double>? topBarAnimation;

  final storage = new FlutterSecureStorage();
  ApiProvider _api = new ApiProvider();
  FocusNode textFieldFocusNode = FocusNode();

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


  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: AppTheme.background,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text(
            "اتصل بنا",
            style: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppTheme.darkText,
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
                Navigator.pop(context,true);
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

            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        userNameField(size),
                        SizedBox(
                          height: 10,
                        ),
                        userTitleField(size),
                        SizedBox(
                          height: 10,
                        ),
                        emailField(size),
                        //email & password section
                        SizedBox(
                          height: 10,
                        ),
messageField(size)
                      ]),
                ),
              ),
              SizedBox(height:MediaQuery.of(context).size.height/5.5 ,),
              Container(
                  alignment: Alignment.center,
                  height: size.height / 11,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFEFEFEF),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {

                        ApiProvider _api = new ApiProvider();
                        dynamic _loginData =
                        await _api.contact_us(name.text, email.text , message.text,title.text);
                        print(_loginData);
                        if (_loginData['status'] == true) {
                          dynamic data = _loginData['user_data'];
                          name.text = ''; email.text = ''; message.text ='';
                          Alert(

                            style: AlertStyle(titleStyle:GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                color: AppTheme.orange,
                              ),
                            ) , descStyle: GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                color: AppTheme.darkerText,
                              ),
                            ),),


                            context: context,
                            type: AlertType.success,
                            desc: _loginData['response_message'],
                            buttons: [
                              DialogButton(
                                color:AppTheme.green,
                                child: Text(
                                  "متابعة",
                                  style:GoogleFonts.getFont(
                                    AppTheme.fontName,
                                    textStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();

                        } else {
                          Alert(

                            style: AlertStyle(titleStyle:GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                color: AppTheme.orange,
                              ),
                            ) , descStyle: GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                color: AppTheme.darkerText,
                              ),
                            ),),


                            context: context,
                            type: AlertType.error,
                            title: "خطأ",
                            desc: _loginData['response_message']+'\n'+_loginData['errors'][0]["error"],
                            buttons: [
                              DialogButton(
                                color:AppTheme.green,
                                child: Text(
                                  "متابعة",
                                  style:GoogleFonts.getFont(
                                    AppTheme.fontName,
                                    textStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      letterSpacing: 0.5,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                        }                      }
                    },
                    child: Text(
                      'ارسال',
                      style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  )),

            ],
          ),
        ),
      ),
    );
  }
  Widget userTitleField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: title,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب سبب  صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'السبب',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),

            focusedBorder:OutlineInputBorder(

                borderSide: BorderSide(color: AppTheme.green)
            ) ,
            border: OutlineInputBorder(

                borderSide: BorderSide(color: AppTheme.green)
            )),
      ),
    );
  }

  Widget userNameField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: name,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب اسم  صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'الأسم',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),

            focusedBorder:OutlineInputBorder(

                borderSide: BorderSide(color: AppTheme.green)
            ) ,
            border: OutlineInputBorder(

              borderSide: BorderSide(color: AppTheme.green)
            )),
      ),
    );
  }
  Widget emailField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: email,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب  رقم جوال  صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 12,
            letterSpacing: 0.5,
            color: AppTheme.darkerText,
          ),
        ),
        maxLines: 1,
        decoration: InputDecoration(
            labelText: 'رقم الجوال',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
                color: AppTheme.darkerText,
              ),
            ),
            focusedBorder:OutlineInputBorder(

                borderSide: BorderSide(color: AppTheme.dark_grey)
            ) ,
            border: OutlineInputBorder(

                borderSide: BorderSide(color: AppTheme.dark_grey)
            )),
      ),
    );
  }
  Widget messageField(Size size) {
    return  Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: <Widget>[
          Card(
              color: AppTheme.white,
              child: TextFormField(
                controller: message,

                maxLines: 8, //or null
                decoration: InputDecoration(

                    labelText: ' التفاصيل',
                    labelStyle: GoogleFonts.getFont(
                      AppTheme.fontName,
                      textStyle: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 0.5,
                        color: AppTheme.darkerText,
                      ),
                    ),
                    focusedBorder:OutlineInputBorder(

                        borderSide: BorderSide(color: AppTheme.green)
                    ) ,
                    border: OutlineInputBorder(

                        borderSide: BorderSide(color: AppTheme.green)
                    )),
              )
          )
        ],
      ),
    );
  }

}

