import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwader/auth_screen/Login.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import '../model/Ad.dart';

class ProductDetails extends StatefulWidget {
  final String id;
  final dynamic config;
  const ProductDetails(
      {Key? key,
      this.animationController,
      required this.id,
      required this.config})
      : super(key: key);

  final AnimationController? animationController;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  Animation<double>? topBarAnimation;
  DropItem? _selectedValue ;
  DropItem? _selectedCut;
  final storage = new FlutterSecureStorage();
  ApiProvider _api = new ApiProvider();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  dynamic _state = '';
  bool status = true;
  int quantity = 1;
  bool is_sluted = false;
  bool alive = false;
  bool covered = false;
  bool without_c = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text(
            '',
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
                Navigator.pop(context, true);
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            //to give space from top
            // getAppBarUI(),
            SizedBox(
              height: 10,
            ),

            //page content here
            FutureBuilder(
                future: _api.getProductData(widget.id),
                builder: (context, snapshot) {

                  if (snapshot.hasData) {
                    dynamic data = snapshot.data;

                    List<Ad> ads = [];
                    List<DropItem> countryList = [];
                    List<DropItem> cuts = [];

                    if (data['def_images'] != null) {
                      data["def_images"].forEach((element) {
                        ads.add(Ad(
                            id: element["id"],
                            title: '',
                            image: element["image_url"]));
                      });
                    } else {
                      ads.add(Ad(
                          id: data['id'], title: '', image: data['image_url']));
                    }
                    //            DropItem(
                    // key: '2',
                    // item: Row(
                    //   children: [Text('asdasds')],
                    // ))
                    int index2 = 0;
                    int i2 = 0;
                    if (widget.config["cut_types"] != null) {
                      widget.config["cut_types"].forEach((element) {
                        if(_selectedCut?.key == element['id'].toString()){
                          index2 = i2;
                        }
                        i2++;
                        cuts.add(DropItem(
                            key: element['id'].toString(),
                            item: Row(
                              children: [
                                SizedBox(width: 5,),
                                Text(element['name'])
                              ],
                            )));
                      });
                    } else {
                      cuts = [];
                    }
                    int index = 0;
                    int i = 0;
                    data["variants"].forEach((element) {
                      if(_selectedValue?.key == element['id'].toString()){
                        index = i;
                      }
                      i++;
                      countryList.add(DropItem(
                        key: element["id"].toString(),
                        item: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  style: GoogleFonts.getFont(
                                    AppTheme.fontName,
                                    textStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppTheme.nearlyBlack,
                                    ),
                                  ),
                                  '?????????? ${element['weight'].toString()}  ${element['weight_to'].toString()}  ????????'),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 7,
                            ),
                            Text(
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: AppTheme.orange,
                                  ),
                                ),
                                '${element['price'].toString()}  ??.??')
                          ],
                        ),
                      ));
                    });
                     _selectedValue = countryList[index];
                     _selectedCut = cuts[index2];

                    return Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                          color: AppTheme.background_c,
                        ),
                        child: SingleChildScrollView(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 720,
                              ),
                              Positioned(
                                  top: 10,
                                  right: 1,
                                  left: 1,
                                  child: ProductSlider(
                                    ads: ads,
                                    isFav:data["in_favorite"].toString(),
                                    id:data["id"].toString()
                                  )),
                              Positioned(
                                  top: 230,
                                  child: Padding(

                                    padding: const EdgeInsets.only(left:8.0 ,right: 10.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width /
                                          1.5,
                                          child: Text(
                                            data['name'].toString(),
                                            style: GoogleFonts.getFont(
                                              AppTheme.fontName,
                                              textStyle: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 23,
                                                color: AppTheme.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width:
                                        //       MediaQuery.of(context).size.width /
                                        //           10,
                                        // ),
                                        SizedBox(
                                          width:
                                          MediaQuery.of(context).size.width /
                                              3.6,
                                          child: Text(
                                            data['price'].toString() + ' ??.??',
                                            style: GoogleFonts.getFont(
                                              AppTheme.fontName,
                                              textStyle: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                                color: AppTheme.orange,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              Positioned(
                                  top: 280,
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '????????????',
                                              style: GoogleFonts.getFont(
                                                AppTheme.fontName,
                                                textStyle: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color: AppTheme.darkerText,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: AppTheme.green,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: QuantityInput(
                                                  decoration: const InputDecoration(

                                                    fillColor: AppTheme.white,
                                                  ),
                                                buttonColor: Colors.white,
                                                  iconColor: AppTheme.orange,
                                                  inputWidth: 40,
                                                  value: quantity,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      quantity = int.parse(value
                                                          .replaceAll(',', ''));
                                                    });
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 8.0),
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                '????',
                                                style: GoogleFonts.getFont(
                                                  AppTheme.fontName,
                                                  textStyle: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontName,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: AppTheme.darkerText,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: FlutterSwitch(
                                                  width: 70,
                                                  height: 40,
                                                  toggleSize: 45,
                                                  inactiveColor: AppTheme.green,
                                                  activeColor: AppTheme.orange,
                                                  value: alive,
                                                  onToggle: (bool value) {
                                                    setState(() {
                                                      alive = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(
                                                '??????????',
                                                style: GoogleFonts.getFont(
                                                  AppTheme.fontName,
                                                  textStyle: TextStyle(
                                                    fontFamily:
                                                        AppTheme.fontName,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    color: AppTheme.darkerText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Positioned(
                                top: 340,
                                right: 10,
                                child: Text(
                                  textAlign: TextAlign.left,
                                  '????????????  ??????????',
                                  style: GoogleFonts.getFont(
                                    AppTheme.fontName,
                                    textStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ),
                              ),
                              data['has_variants'] == 1
                                  ? Positioned(
                                      top: 370,
                                      left: 10,
                                      right: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .copyWith()
                                                .size
                                                .width,
                                            decoration: ShapeDecoration(
                                              color: AppTheme.white,
                                              shape: RoundedRectangleBorder(),
                                            ),
                                            child: Container(
                                              child: DropdownButton<DropItem>(
                                                // isDense: true,
                                                isExpanded: true,
                                                value: _selectedValue,
                                                icon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                iconSize: 30,
                                                elevation: 20,
                                                style: TextStyle(
                                                    color: Colors.black),

                                                onChanged:
                                                    (DropItem? newValue) {
                                                  setState(() {
                                                    _selectedValue = newValue;
                                                    print(newValue);
                                                  });
                                                },
                                                items: countryList.map<
                                                        DropdownMenuItem<
                                                            DropItem>>(
                                                    (DropItem value) {
                                                  return DropdownMenuItem<
                                                      DropItem>(
                                                    value: value,
                                                    child: value.item,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  : SizedBox(),
                              Positioned(
                                top: 440,
                                right: 10,
                                child: Text(
                                  textAlign: TextAlign.left,
                                  '???????????? ?????? ??????????????',
                                  style: GoogleFonts.getFont(
                                    AppTheme.fontName,
                                    textStyle: TextStyle(
                                      fontFamily: AppTheme.fontName,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: AppTheme.darkerText,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 480,
                                  right: 10,
                                  left: 10,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .copyWith()
                                            .size
                                            .width,
                                        decoration: ShapeDecoration(
                                          color: AppTheme.white,
                                          shape: RoundedRectangleBorder(),
                                        ),
                                        child: Container(
                                          child: DropdownButton<DropItem>(
                                            // isDense: true,
                                            isExpanded: true,
                                            value: _selectedCut,
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
                                            iconSize: 30,
                                            elevation: 20,
                                            style:
                                                TextStyle(color: Colors.black),

                                            onChanged: (DropItem? newValue) {
                                              setState(() {
                                                _selectedCut = newValue;
                                                print(newValue?.key);
                                              });
                                            },
                                            items: cuts.map<
                                                    DropdownMenuItem<DropItem>>(
                                                (DropItem value) {
                                              return DropdownMenuItem<DropItem>(
                                                value: value,
                                                child: value.item,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              // Positioned(
                              //     // left: 1?0,
                              //     top: 540,
                              //     // right: 10,
                              //     child: Container(
                              //       child: Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.center,
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.center,
                              //         children: [
                              //           SizedBox(
                              //             width: MediaQuery.of(context)
                              //                     .size
                              //                     .width /
                              //                 4,
                              //             child: Text(
                              //               '???????? ?????????? ',
                              //               textAlign: TextAlign.right,
                              //               style: GoogleFonts.getFont(
                              //                 AppTheme.fontName,
                              //                 textStyle: TextStyle(
                              //                   fontFamily: AppTheme.fontName,
                              //                   fontWeight: FontWeight.w700,
                              //                   fontSize: 16,
                              //                   color: AppTheme.darkerText,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //           Padding(
                              //             padding: const EdgeInsets.all(8.0),
                              //             child: FlutterSwitch(
                              //               width: 80,
                              //               height: 40,
                              //               toggleSize: 45,
                              //               inactiveColor: AppTheme.grey,
                              //               activeColor: AppTheme.orange,
                              //               value: covered,
                              //               onToggle: (bool value) {
                              //                 setState(() {
                              //                   covered = value;
                              //                 });
                              //               },
                              //             ),
                              //           ),
                              //           SizedBox(
                              //             width: MediaQuery.of(context)
                              //                     .size
                              //                     .width /
                              //                 5,
                              //             child: Text(
                              //               '???? ??????????',
                              //               textAlign: TextAlign.left,
                              //               style: GoogleFonts.getFont(
                              //                 AppTheme.fontName,
                              //                 textStyle: TextStyle(
                              //                   fontFamily: AppTheme.fontName,
                              //                   fontWeight: FontWeight.w700,
                              //                   fontSize: 16,
                              //                   color: AppTheme.darkerText,
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     )),
                              Positioned(
                                  // left: 10,
                                  top: 570,
                                  // right: 100,
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              5,
                                          child: Text(
                                            '??????????',
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.getFont(
                                              AppTheme.fontName,
                                              textStyle: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: AppTheme.darkerText,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FlutterSwitch(
                                            width: 80,
                                            height: 40,
                                            toggleSize: 45,
                                            inactiveColor: AppTheme.green,
                                            activeColor: AppTheme.orange,
                                            value: without_c,
                                            onToggle: (bool value) {
                                              setState(() {
                                                without_c = value;
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              6.4,
                                          child: Text(
                                            '??????????',
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.getFont(
                                              AppTheme.fontName,
                                              textStyle: TextStyle(
                                                fontFamily: AppTheme.fontName,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: AppTheme.darkerText,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Positioned(
                                bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                      color: AppTheme.green,
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          print('Product ID==>' +
                                              data['id'].toString());
                                          print('Quantity==>' +
                                              quantity.toString());
                                          print('Weight===>' +
                                              _selectedValue!.key);
                                          print('Cut===>' + _selectedCut!.key);
                                          print('Suated===>' +
                                              is_sluted.toString());
                                          print('alive===>' + alive.toString());
                                          print('without_c===>' +
                                              without_c.toString());
                                          print('covered===>' +
                                              without_c.toString());

                                          // bool alive = false;
                                          // bool covered = false;
                                          // bool without_c = false;
                                          dynamic token =
                                              await _api.get_token();
                                          if (token == null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()),
                                            );
                                          }
                                          dynamic p = await _api.add_to_cart(
                                              data["id"].toString(),
                                              is_sluted.toString(),
                                              2,
                                              _selectedCut?.key.toString(),
                                              quantity,
                                              _selectedValue?.key.toString());
                                          if (p['status'] == true) {
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
                                              title: "",
                                              desc: p['response_message'],
                                              buttons: [
                                                DialogButton(
                                                  color:AppTheme.green,
                                                  child: Text(
                                                    "????????????",
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

                                          }
                                        },
                                        child: Text(
                                          '?????? ?????? ??????????',
                                          style: GoogleFonts.getFont(
                                            AppTheme.fontName,
                                            textStyle: TextStyle(
                                              fontFamily: AppTheme.fontName,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 25,
                                              color: AppTheme.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(topBarOpacity),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                  offset: const Offset(1.1, 1.1),
                  blurRadius: 10.0),
            ],
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 16,
                    right: 0,
                    top: 16 - 8.0 * topBarOpacity,
                    bottom: 12 - 8.0 * topBarOpacity),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        _key.currentState!.openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset('assets/icons/menu-icon.png'),
                      ),
                    ),
                    SizedBox(
                      width: 280,
                    ),
                    SizedBox(
                      height: 38,
                      width: 38,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
class ProductSlider extends StatefulWidget {
  final List<Ad> ads;
  final String isFav;
  final String id;

  const ProductSlider({Key? key, required this.ads , required this.isFav , required this.id}) : super(key: key);

  @override
  State<ProductSlider> createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  @override
  String  favorite = 'null';

  Widget build(BuildContext context) {
    final int _current = 0;
    final CarouselController _controller = CarouselController();
ApiProvider _api = new ApiProvider();
print(widget.isFav);
    return CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          viewportFraction: 1.0,
        ),
        items: widget.ads.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              i.image),
                          fit: BoxFit.fill),
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:favorite == 'null' ? widget.isFav == '1'
                            ? Container(
                              child: Positioned(
                          top: 10,
                          left: 15,
                          child: GestureDetector(
                              onTap: ()async{
                                dynamic token = await _api.get_token();
                                if(token == null){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                }
                                dynamic data = await _api.add_to_favorite(widget!.id.toString());
                                if(data['status'] == true){
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
                                    title: "",
                                    desc: data['response_message'],
                                    buttons: [
                                      DialogButton(
                                        color:AppTheme.green,
                                        child: Text(
                                          "????????????",
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

                                  setState(() {
                                    if(favorite == '1'){
                                      favorite = '0';

                                    }else{
                                      favorite = '1';

                                    }
                                  });
                                }
                              },
                              child: Container(
                                child:
                                Image.asset('assets/icons/wish-red-icon.png'),
                              ),
                          ),
                        ),
                            )
                            : Container(
                              child: Positioned(
                          top: 10,
                          left: 15,
                          child: GestureDetector(
                              onTap: ()async{
                                dynamic token = await _api.get_token();
                                if(token == null){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                }
                                dynamic data = await _api.add_to_favorite(widget!.id.toString());
                                if(data['status'] == true){

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
                                    title: "",
                                    desc: data['response_message'],
                                    buttons: [
                                      DialogButton(
                                        color:AppTheme.green,
                                        child: Text(
                                          "????????????",
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
                                  setState(() {
                                    if(favorite == '1'){
                                      favorite = '0';

                                    }else{
                                      favorite = '1';

                                    }
                                  });
                                }

                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/icons/wish-icon.png'),
                              ),
                          ),
                        ),
                            ) : favorite == '1' ?  Container(
                          child: Positioned(
                            top: 10,
                            left: 15,
                            child: GestureDetector(
                              onTap: ()async{
                                dynamic token = await _api.get_token();
                                if(token == null){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                }
                                dynamic data = await _api.add_to_favorite(widget!.id.toString());
                                if(data['status'] == true){

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
                                    title: "",
                                    desc: data['response_message'],
                                    buttons: [
                                      DialogButton(
                                        color:AppTheme.green,
                                        child: Text(
                                          "????????????",
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
                                  setState(() {
                                    if(favorite == '1'){
                                      favorite = '0';

                                    }else{
                                      favorite = '1';

                                    }
                                  });
                                }
                              },
                              child: Container(
                                child:
                                Image.asset('assets/icons/wish-red-icon.png'),
                              ),
                            ),
                          ),
                        ):  Container(
                          child: Positioned(
                            top: 10,
                            left: 15,
                            child: GestureDetector(
                              onTap: ()async{
                                dynamic token = await _api.get_token();
                                if(token == null){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()),
                                  );
                                }
                                dynamic data = await _api.add_to_favorite(widget!.id.toString());
                                if(data['status'] == true){

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
                                    title: "",
                                    desc: data['response_message'],
                                    buttons: [
                                      DialogButton(
                                        color:AppTheme.green,
                                        child: Text(
                                          "????????????",
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
                                  setState(() {
                                    if(favorite == '1'){
                                      favorite = '0';

                                    }else{
                                      favorite = '1';

                                    }
                                  });
                                }

                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: Image.asset('assets/icons/wish-icon.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              );
            },
          );
        }).toList());
  }
}




class DropItem {
  late String key;
  late Row item;
  DropItem({required this.key, required this.item});
}
