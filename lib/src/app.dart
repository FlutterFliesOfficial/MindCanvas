import 'dart:async';
import 'package:august_plus/src/screen/home/home.dart';
import 'package:august_plus/src/screen/pages/Doctor/doctor_home.dart';
import 'package:august_plus/src/size_configuration.dart';
import 'package:august_plus/src/theme/app_theme.dart';
import 'package:august_plus/src/video/service/sdk_intializer.dart';
import 'package:august_plus/utils/errordialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather.dart';
import '../service/auth/components/signin.dart';
import '../utils/global.dart';
import 'constant/map_api_key.dart';
import 'screen/splash/components/splash_body.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      title: 'Mind-Canvas',
      home: const HandleOnboarding(),
      routes: {
        '/home': (context) => const Home(),
        '/splash': (context) => const SplashBody(),
        '/login': (context) => const Home(),
        '/dochome': (context) => const DoctorHomePage(),
      },
    );
  }
}

class HandleOnboarding extends StatefulWidget {
  const HandleOnboarding({Key? key}) : super(key: key);

  @override
  State<HandleOnboarding> createState() => _HandleOnboardingState();
}

class _HandleOnboardingState extends State<HandleOnboarding> {
  // late UserDataStore _dataStore;
  // bool _isLoading = false;
  late WeatherFactory wf;
  @override
  void initState() {
    super.initState();
    SDKIntializer.hmssdk.build();
    setTimer();
    requestPermission();
    wf = WeatherFactory(
      "752c76ba36af06e471e0cb73908fa033",
      language: Language.ENGLISH,
    );
    getKey();
  }

  getKey() async {
    await MapKey.readyApiKey();
  }

  // ignore: prefer_typing_uninitialized_variables
  var currentLocation;

  requestPermission() async {
    // ignore: avoid_print
    print("Asking Permission");
    await Permission.location.request();
    await setPermission();
    await Permission.camera.request();
    await Permission.microphone.request();
    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
  }

  setPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      // ignore: avoid_print
      print("Got Permission Request from User");
      if (sharedPreferences.getDouble("lat") == null &&
          sharedPreferences.getDouble("long") == null) {
        getLocation();
        if (kDebugMode) {
          print("Calling get location");
        }
      }
    } else {
      const ErrorDialog(
        message: 'We want this to give you some geographical service',
      );
    }
    //TODOS :HANDLE PERMISSION
  }

  void getLocation() {
    Geolocator.getCurrentPosition().then((currrloc) async {
      currentLocation = currrloc;
      // ignore: avoid_print
      print("Got the location");
      await sharedPreferences.setDouble("lat", currentLocation.latitude);
      await sharedPreferences.setDouble("long", currentLocation.longitude);
    });
  }

  // Future<bool> joinRoom() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   bool isJoinSuccessful = await JoinService.join(SDKIntializer.hmssdk);
  //   if (!isJoinSuccessful) {
  //     return false;
  //   }
  //   _dataStore = UserDataStore();
  //   _dataStore.startListen();
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   return true;
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFB7C8FE),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/one.jpg'),
          Center(
            child: Text(
              'MindCanvas',
              style: splashTextStyle(),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40.0),
          ),
          const CircularProgressIndicator(
            color: Colors.blue,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  void setTimer() {
    Timer(const Duration(seconds: 2), () {
      if (firebaseAuth.currentUser != null) {
        if (sharedPreferences.getString('role') == 'Patient') {
          //patient
          Navigator.pushNamed(context, '/home');
        } else {
          Navigator.pushNamed(context, '/dochome');
        }
      } else {
        Navigator.pushNamed(context, '/splash');
      }
    });
  }
}
