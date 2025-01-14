import 'package:flutter/material.dart';
import '../models/camera_settings.dart';

class SettingsPanel extends StatefulWidget {
  final CameraSettings settings;
  final Function(CameraSettings) onSettingsChanged;

  const SettingsPanel({
    Key? key,
    required this.settings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  late CameraSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  void _updateSettings() {
    widget.onSettingsChanged(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Camera Settings', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            
            // Quality Slider
            Text('Quality'),
            Slider(
              value: _settings.quality,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: _settings.quality.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _settings.quality = value;
                  _updateSettings();
                });
              },
            ),

            // Auto-Exposure Iterations
            Text('Auto-Exposure Iterations'),
            Slider(
              value: _settings.autoExposureIterations.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: _settings.autoExposureIterations.toString(),
              onChanged: (value) {
                setState(() {
                  _settings.autoExposureIterations = value.round();
                  _updateSettings();
                });
              },
            ),

            // Metering Mode
            Text('Metering Mode'),
            DropdownButton<String>(
              value: _settings.meteringMode,
              items: ['center', 'average', 'spot'].map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _settings.meteringMode = value!;
                  _updateSettings();
                });
              },
            ),

            // Manual Exposure
            Text('Manual Exposure'),
            Slider(
              value: _settings.manualExposure,
              min: 0.0,
              max: 100.0,
              label: _settings.manualExposure.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _settings.manualExposure = value;
                  _updateSettings();
                });
              },
            ),

            // Shutter Settings
            Text('Shutter KP'),
            Slider(
              value: _settings.shutterKp,
              min: 0.0,
              max: 5.0,
              label: _settings.shutterKp.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  _settings.shutterKp = value;
                  _updateSettings();
                });
              },
            ),

            Text('Shutter Limit'),
            Slider(
              value: _settings.shutterLimit,
              min: 0.0,
              max: 200.0,
              label: _settings.shutterLimit.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _settings.shutterLimit = value;
                  _updateSettings();
                });
              },
            ),

            // Gain Settings
            Text('Gain KP'),
            Slider(
              value: _settings.gainKp,
              min: 0.0,
              max: 5.0,
              label: _settings.gainKp.toStringAsFixed(2),
              onChanged: (value) {
                setState(() {
                  _settings.gainKp = value;
                  _updateSettings();
                });
              },
            ),

            Text('Gain Limit'),
            Slider(
              value: _settings.gainLimit,
              min: 0.0,
              max: 200.0,
              label: _settings.gainLimit.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _settings.gainLimit = value;
                  _updateSettings();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}