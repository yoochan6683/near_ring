import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:near_ring/login/firebase_auth_remote_data_source.dart';
import 'package:near_ring/login/social_login.dart';

class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false; //처음에 로그인 안 되어 있음
  kakao.User? user; //카카오톡에서 사용자 정보를 저장하는 객체 User를 nullable 변수로 선언

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login(); //로그인되어 있는지 확인
    if (isLogined) {
      user = await kakao.UserApi.instance.me(); //사용자 정보 받아오기

      final customToken = await _firebaseAuthDataSource.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(customToken);
    }
  }

  Future logout() async {
    await _socialLogin.logout(); //로그아웃 실행
    isLogined = false; //로그인되어 있는지를 저장하는 변수 false값 저장
    user = null; //user 객체 null
    await FirebaseAuth.instance.signOut();
  }
}
