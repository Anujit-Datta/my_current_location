import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toast/toast.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentPosition = const LatLng(23.596928202593364, 89.85511174374604);
  List<LatLng> traveledLine = [];
  bool isLocationOn = false;

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    locationOn();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        onMapCreated: (controller) async {
          animateToCurrentPosition(controller);
        },
        initialCameraPosition: CameraPosition(
          target: currentPosition,
          zoom: 10,
        ),
        markers: {
          Marker(
              markerId: const MarkerId("My current location"),
              draggable: false,
              position: currentPosition,
              infoWindow: InfoWindow(
                title: 'My Current Location',
                snippet: currentPosition.toString(),
              )),
        },
        polylines: {
          Polyline(
              polylineId: const PolylineId("My Path"),
              points: traveledLine,
              color: Colors.blue)
        },
      ),
    );
  }





  void animateToCurrentPosition(GoogleMapController controller) async {
    for (double zoom = 5; zoom <= 22; zoom > 15 ? zoom += 1 : zoom += 0.3) {
      await Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
              CameraPosition(target: currentPosition, zoom: zoom)),
        );
      });
    }
  }

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Geolocator.requestPermission();
    } else {
      listenLocation();
    }
  }

  locationOn() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      Toast.show("Please Enable Location",
          duration: Toast.lengthLong, gravity: Toast.bottom);
      isLocationOn = await Geolocator.openLocationSettings();
      locationOn();
    }
    setState(() {});
    return;
  }

  listenLocation() async {
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
    )).listen((position) {
      print(position);
      currentPosition = LatLng(position.latitude, position.longitude);
      if (!traveledLine.contains(currentPosition)) {
        traveledLine.add(currentPosition);
      }
      setState(() {});
    });
  }
}
