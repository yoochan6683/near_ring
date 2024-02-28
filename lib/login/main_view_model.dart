import 'package:firebase_auth/firebase_auth.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_talk.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:near_ring/login/firebase_auth_remote_data_source.dart';
import 'package:near_ring/login/social_login.dart';

class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false; //처음에 로그인 안 되어 있음
  kakao.User? user; //카카오톡에서 사용자 정보를 저장하는 객체 User를 nullable 변수로 선언

  MainViewModel(this._socialLogin);

  Future bringUser() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        //토큰이 존재하고 유효하면 다음줄이 실행, 없거나 에러가 나면 catch
        await UserApi.instance.accessTokenInfo();

        //토큰이 존재하고 유효할 경우 user 정보 불러옴
        user = await kakao.UserApi.instance.me();
      } catch (error) {
        //토큰이 유효하지 않은 경우
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }

        await _socialLogin.login();
      }
    } else {
      //발급된 토큰이 없는 경우
      await _socialLogin.login();
    }
  }

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
