class CameraSettings {
  double quality;
  int autoExposureIterations;
  String meteringMode;
  double manualExposure;
  double shutterKp;
  double shutterLimit;
  double gainKp;
  double gainLimit;

  CameraSettings({
    this.quality = 1.0,
    this.autoExposureIterations = 3,
    this.meteringMode = 'center',
    this.manualExposure = 0.0,
    this.shutterKp = 1.0,
    this.shutterLimit = 100.0,
    this.gainKp = 1.0,
    this.gainLimit = 100.0,
  });

  Map<String, dynamic> toJson() => {
        'quality': quality,
        'autoExposureIterations': autoExposureIterations,
        'meteringMode': meteringMode,
        'manualExposure': manualExposure,
        'shutterKp': shutterKp,
        'shutterLimit': shutterLimit,
        'gainKp': gainKp,
        'gainLimit': gainLimit,
      };

  factory CameraSettings.fromJson(Map<String, dynamic> json) => CameraSettings(
        quality: json['quality'] ?? 1.0,
        autoExposureIterations: json['autoExposureIterations'] ?? 3,
        meteringMode: json['meteringMode'] ?? 'center',
        manualExposure: json['manualExposure'] ?? 0.0,
        shutterKp: json['shutterKp'] ?? 1.0,
        shutterLimit: json['shutterLimit'] ?? 100.0,
        gainKp: json['gainKp'] ?? 1.0,
        gainLimit: json['gainLimit'] ?? 100.0,
      );
}