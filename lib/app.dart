import 'package:flutter/material.dart';
import 'package:my_current_location/map_screen.dart';

class MyCurrentLocation extends StatelessWidget {
  const MyCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Current Location',
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
