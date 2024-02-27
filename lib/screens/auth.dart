import 'package:flutter/material.dart';
import 'package:near_ring/login/main_view_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.viewModel});

  final MainViewModel viewModel;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isOnLogin = false;

  void kakaoLogin() async {
    setState(() {
      _isOnLogin = true;
    });
    await widget.viewModel.login();
    setState(() {
      _isOnLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //타이틀
            Text(
              '가까워지면 울리는',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 50,
            ),
            //로그인 앵무새 그림
            Image.asset(
              'assets/images/login_image.png',
              width: 200,
            ),
            const SizedBox(
              height: 50,
            ),
            //로그인 버튼
            if (!_isOnLogin)
              Card(
                child: InkWell(
                  onTap: kakaoLogin,
                  child: Image.asset(
                    'assets/images/kakao_login_large_wide.png',
                    height: 50,
                  ),
                ),
              ),
            if (_isOnLogin) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
