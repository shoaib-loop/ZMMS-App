// File generated by FlutterFire CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android; // <- Add this line for Android
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError('This platform is not supported.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA5kBHYiuHCloxaR-KgDItoWVkWSpccVfs',
    appId: '1:763889036220:web:3665f408f7e6e7de4419b9',
    messagingSenderId: '763889036220',
    projectId: 'zmms-12fdf',
    authDomain: 'zmms-12fdf.firebaseapp.com',
    storageBucket: 'zmms-12fdf.appspot.com',
    measurementId: 'G-SGB28SK2T6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJKB-_wcijlpbwx_aJPOQpmBqbmRkClxo',
    appId: '1:763889036220:android:0d78d090803b25734419b9',
    messagingSenderId: '763889036220',
    projectId: 'zmms-12fdf',
    storageBucket: 'zmms-12fdf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDD_VENxMY310CwectQSd--p_MsV7oJFyA',
    appId: '1:763889036220:ios:e972d4b9212049eb4419b9',
    messagingSenderId: '763889036220',
    projectId: 'zmms-12fdf',
    storageBucket: 'zmms-12fdf.appspot.com',
    iosBundleId: 'com.example.zmmsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDD_VENxMY310CwectQSd--p_MsV7oJFyA',
    appId: '1:763889036220:ios:e972d4b9212049eb4419b9',
    messagingSenderId: '763889036220',
    projectId: 'zmms-12fdf',
    storageBucket: 'zmms-12fdf.appspot.com',
    iosBundleId: 'com.example.zmmsApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5kBHYiuHCloxaR-KgDItoWVkWSpccVfs',
    appId: '1:763889036220:web:c0546ea7efe14a294419b9',
    messagingSenderId: '763889036220',
    projectId: 'zmms-12fdf',
    authDomain: 'zmms-12fdf.firebaseapp.com',
    storageBucket: 'zmms-12fdf.appspot.com',
    measurementId: 'G-6RQPM34T44',
  );
}