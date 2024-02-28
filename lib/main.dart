import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:near_ring/firebase_options.dart';
import 'package:near_ring/login/kakao_login.dart';
import 'package:near_ring/login/main_view_model.dart';
import 'package:near_ring/screens/auth.dart';
import 'package:near_ring/screens/loading.dart';
import 'package:near_ring/screens/near_ring_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  KakaoSdk.init(nativeAppKey: dotenv.env['NATIVE_APP_KEY']);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        fontFamily: 'GmarketSans',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: firebase.FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return AuthScreen(viewModel: viewModel);
            } else {
              return FutureBuilder(
                  future: viewModel.bringUser(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingScreen();
                    }
                    return NearRingHomeScreen(viewModel: viewModel);
                  });
            }
          }),
    );
  }
}
