import 'package:flutter/material.dart';
import 'models/camera_settings.dart';
import 'services/frame_service.dart';
import 'widgets/settings_panel.dart';
import 'widgets/image_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frame Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final FrameService _frameService = FrameService();
  final List<Map<String, dynamic>> _capturedImages = [];
  bool _isConnected = false;
  late CameraSettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = CameraSettings();
    _setupFrameService();
  }

  void _setupFrameService() {
    _frameService.connectionStatus.listen((connected) {
      setState(() {
        _isConnected = connected;
      });
    });

    _frameService.imageStream.listen((imageData) {
      setState(() {
        _capturedImages.insert(0, {
          'data': imageData['imageData'],
          'settings': _currentSettings.toJson(),
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
    });

    _connectToFrame();
  }

  Future<void> _connectToFrame() async {
    try {
      await _frameService.connect();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connected to Frame')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: $e')),
      );
    }
  }

  void _updateSettings(CameraSettings newSettings) {
    setState(() {
      _currentSettings = newSettings;
    });
    _frameService.updateSettings(newSettings);
  }

  Future<void> _capturePhoto() async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not connected to Frame')),
      );
      return;
    }

    try {
      await _frameService.capturePhoto();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture photo: $e')),
      );
    }
  }

  @override
  void dispose() {
    _frameService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frame Camera'),
        actions: [
          IconButton(
            icon: Icon(_isConnected ? Icons.link : Icons.link_off),
            onPressed: _isConnected ? null : _connectToFrame,
          ),
        ],
      ),
      body: Row(
        children: [
          // Settings Panel
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SettingsPanel(
                  settings: _currentSettings,
                  onSettingsChanged: _updateSettings,
                ),
              ),
            ),
          ),
          
          // Image Gallery
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Capture Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: _isConnected ? _capturePhoto : null,
                    icon: const Icon(Icons.camera),
                    label: const Text('Capture Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                
                // Gallery
                Expanded(
                  child: ImageGallery(images: _capturedImages),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}