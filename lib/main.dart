import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:near_ring/firebase_options.dart';
import 'package:near_ring/login/kakao_login.dart';
import 'package:near_ring/login/main_view_model.dart';
import 'package:near_ring/screens/auth.dart';
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

  //로그아웃 안 한 상태에서 앱 빌드 다시하면 오류 날때 로그아웃 하는 용도로 쓸 것
  // void kakaoLogout() async {
  //   await viewModel.logout();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   kakaoLogout();
  // }

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
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return AuthScreen(viewModel: viewModel);
            } else {
              return NearRingHomeScreen(viewModel: viewModel);
            }
          }),
    );
  }
}
