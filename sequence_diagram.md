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