# Frame Camera App

A Flutter application for controlling Frame camera settings and capturing photos. This app provides a user-friendly interface for adjusting camera parameters, capturing images, and viewing them in a scrollable gallery with their associated settings.

## Features

### Camera Control
- Real-time connection to Frame camera
- Photo capture with current settings
- Live connection status monitoring

### Adjustable Camera Settings
- **Quality**: Fine-tune image quality (0.0-1.0)
- **Auto-Exposure/Gain Iterations**: Control exposure automation (1-10 iterations)
- **Metering Mode**: Choose between center, average, and spot metering
- **Manual Exposure**: Direct exposure control
- **Shutter Settings**:
  - Shutter KP (Proportional Gain)
  - Shutter Limit
- **Gain Settings**:
  - Gain KP (Proportional Gain)
  - Gain Limit

### Image Gallery
- Scrollable list of captured photos
- Settings information stored with each image
- Expandable details panel showing capture settings
- Chronological ordering (newest first)

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- A Frame camera accessible on your network

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd frame_camera_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Configuration

By default, the app attempts to connect to Frame at `ws://frame.local:8080`. If your Frame camera is at a different address, update the `_wsUrl` constant in `lib/services/frame_service.dart`.

## Project Structure

```
lib/
├── models/
│   └── camera_settings.dart     # Camera settings data model
├── services/
│   └── frame_service.dart       # Frame WebSocket communication
├── widgets/
│   ├── settings_panel.dart      # Camera controls UI
│   └── image_gallery.dart       # Photo gallery with settings display
└── main.dart                    # Main app with layout and state management
```

## Usage

1. Launch the app
2. The app will automatically attempt to connect to Frame
3. Use the settings panel on the left to adjust camera parameters
4. Click the "Capture Photo" button to take a picture
5. View captured photos and their settings in the gallery on the right

## Communication Protocol

The app communicates with Frame using WebSocket connections:

### Commands
- Connect: Establishes WebSocket connection
- Capture: Triggers photo capture
- Update Settings: Sends new camera settings

### Data Format
```json
{
  "command": "updateSettings",
  "settings": {
    "quality": 1.0,
    "autoExposureIterations": 3,
    "meteringMode": "center",
    "manualExposure": 0.0,
    "shutterKp": 1.0,
    "shutterLimit": 100.0,
    "gainKp": 1.0,
    "gainLimit": 100.0
  }
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
```mermaid
sequenceDiagram
    participant App as Flutter App
    participant SP as Settings Panel
    participant FS as Frame Service
    participant Frame as Frame Camera
    participant IG as Image Gallery

    %% Initial Connection
    App->>FS: connect()
    FS->>Frame: WebSocket Connection
    Frame-->>FS: Connection Established
    FS-->>App: connectionStatus(true)
    
    %% Settings Update Flow
    SP->>App: onSettingsChanged(settings)
    App->>FS: updateSettings(settings)
    FS->>Frame: {"command": "updateSettings", settings: {...}}
    Frame-->>FS: Settings Applied
    
    %% Photo Capture Flow
    App->>FS: capturePhoto()
    FS->>Frame: {"command": "capture"}
    Frame-->>FS: Image Data
    FS-->>App: imageStream(imageData)
    App->>IG: Update Gallery
    
    %% Error Handling
    Note over Frame,FS: Connection Lost
    Frame--xFS: Connection Error
    FS-->>App: connectionStatus(false)
    App->>App: Show Error Message
    
    %% Reconnection
    App->>FS: connect()
    FS->>Frame: WebSocket Connection
    Frame-->>FS: Connection Established
    FS-->>App: connectionStatus(true)
    
    %% Image Display with Settings
    Note over App,IG: For each captured image
    App->>IG: Display Image
    App->>IG: Show Settings Panel
    IG-->>App: User Expands Settings
    App->>IG: Display Detailed Settings
    
