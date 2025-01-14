import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/camera_settings.dart';

class ImageGallery extends StatelessWidget {
  final List<Map<String, dynamic>> images;

  const ImageGallery({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageData = images[index];
        final settings = CameraSettings.fromJson(imageData['settings']);
        
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Image.memory(
                base64Decode(imageData['data']),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              
              // Settings Information
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text('Capture Settings'),
                  children: [
                    ListTile(
                      title: Text('Quality'),
                      trailing: Text(settings.quality.toStringAsFixed(2)),
                    ),
                    ListTile(
                      title: Text('Auto-Exposure Iterations'),
                      trailing: Text(settings.autoExposureIterations.toString()),
                    ),
                    ListTile(
                      title: Text('Metering Mode'),
                      trailing: Text(settings.meteringMode),
                    ),
                    ListTile(
                      title: Text('Manual Exposure'),
                      trailing: Text(settings.manualExposure.toStringAsFixed(2)),
                    ),
                    ListTile(
                      title: Text('Shutter KP'),
                      trailing: Text(settings.shutterKp.toStringAsFixed(2)),
                    ),
                    ListTile(
                      title: Text('Shutter Limit'),
                      trailing: Text(settings.shutterLimit.toStringAsFixed(2)),
                    ),
                    ListTile(
                      title: Text('Gain KP'),
                      trailing: Text(settings.gainKp.toStringAsFixed(2)),
                    ),
                    ListTile(
                      title: Text('Gain Limit'),
                      trailing: Text(settings.gainLimit.toStringAsFixed(2)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}