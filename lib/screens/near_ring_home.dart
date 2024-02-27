import 'package:flutter/material.dart';
import 'package:near_ring/login/main_view_model.dart';

class NearRingHomeScreen extends StatefulWidget {
  const NearRingHomeScreen({super.key, required this.viewModel});

  final MainViewModel viewModel;
  @override
  State<NearRingHomeScreen> createState() => _NearRingHomeScreenState();
}

class _NearRingHomeScreenState extends State<NearRingHomeScreen> {
  void kakaoLogout() async {
    await widget.viewModel.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(
              widget.viewModel.user!.kakaoAccount!.profile!.profileImageUrl!),
        ),
      ),
      body: Center(
        child: TextButton(
          onPressed: kakaoLogout,
          child: const Text('로그아웃'),
        ),
      ),
    );
  }
}
