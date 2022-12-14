import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:nwader/app_theme.dart';
class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key , required this.latlng , required this.dlatlng}) : super(key: key);
  final LatLng latlng ;
  final LatLng dlatlng ;

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static  LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

void getPolyPoints() async {
  PolylinePoints polyLinePoints = PolylinePoints();
  PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates('AIzaSyCWNY4Dvhl7BNyihg4BvQK6pkILcQe91zw',
      PointLatLng(widget.dlatlng.latitude, widget.dlatlng.longitude), PointLatLng(widget.latlng.latitude, widget.latlng.longitude));
if(result.points.isNotEmpty){
  result.points.forEach(
          (PointLatLng point) => polylineCoordinates.add(
    LatLng(point.latitude, point.longitude)
  ));
  setState(() {

  });

}
}
@override
  void initState() {
    // TODO: implement initState
  getPolyPoints();
    super.initState();
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: Text(
          'مراقبة الطلب',
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
      body:GoogleMap(
        initialCameraPosition: CameraPosition(target:LatLng(widget.dlatlng!.latitude! , widget.dlatlng!.longitude!) ,zoom: 13.5),
        polylines: {
        Polyline(polylineId: PolylineId("route"),
        points: polylineCoordinates,
          color: AppTheme.green,
          width: 6

        )},
        markers: {
           Marker(
              markerId: MarkerId("source"),
              position: LatLng(widget.dlatlng!.latitude! , widget.dlatlng!.longitude!),
          ),
          Marker(
            markerId: MarkerId("source"),
            position: LatLng(widget.latlng!.latitude! , widget.latlng!.longitude!),
          ),
          Marker(
              markerId: MarkerId("destination"),
              position: widget.latlng
          )
        },
        onMapCreated: (mapController){
          _controller.complete(mapController);
        },
      ),
    );
  }
}
