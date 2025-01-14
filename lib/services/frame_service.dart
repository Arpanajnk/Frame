import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/camera_settings.dart';

class FrameService {
  static const String _wsUrl = 'ws://frame.local:8080';
  WebSocketChannel? _channel;
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _imageDataController = StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  Stream<Map<String, dynamic>> get imageStream => _imageDataController.stream;

  Future<void> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _connectionStatusController.add(true);
      
      _channel!.stream.listen(
        (data) {
          final decodedData = jsonDecode(data);
          if (decodedData['type'] == 'image') {
            _imageDataController.add(decodedData);
          }
        },
        onError: (error) {
          _connectionStatusController.add(false);
          disconnect();
        },
        onDone: () {
          _connectionStatusController.add(false);
          disconnect();
        },
      );
    } catch (e) {
      _connectionStatusController.add(false);
      rethrow;
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _connectionStatusController.add(false);
  }

  Future<void> capturePhoto() async {
    if (_channel == null) throw Exception('Not connected to Frame');
    
    _channel!.sink.add(jsonEncode({
      'command': 'capture',
    }));
  }

  Future<void> updateSettings(CameraSettings settings) async {
    if (_channel == null) throw Exception('Not connected to Frame');
    
    _channel!.sink.add(jsonEncode({
      'command': 'updateSettings',
      'settings': settings.toJson(),
    }));
  }

  void dispose() {
    disconnect();
    _connectionStatusController.close();
    _imageDataController.close();
  }
}