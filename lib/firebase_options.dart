import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: "AIzaSyD54umzX4ksDFHRSBSa-EK66vmDCztGa3s",
        authDomain: "financing-app-4c4d5.firebaseapp.com",
        projectId: "financing-app-4c4d5",
        storageBucket: "financing-app-4c4d5.firebasestorage.app",
        messagingSenderId: "891273066809",
        appId: "1:891273066809:web:6ee62718d1bf22445810e8",
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: 'SUA API KEY',
          appId: 'SEU APP ID',
          messagingSenderId: 'SEU MESSAGE ID',
          projectId: 'SEU PROJECT ID',
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: 'SUA API KEY',
          appId: 'SEU APP ID',
          messagingSenderId: 'SEU MESSAGE ID',
          projectId: 'SEU PROJECT ID',
        );
      default: 
        return FirebaseOptions (
          apiKey: 'SUA API KEY',
          appId: 'SEU APP ID',
          messagingSenderId: 'SEU MESSAGE ID',
          projectId: 'SEU PROJECT ID',
      );
    }
  }
}
