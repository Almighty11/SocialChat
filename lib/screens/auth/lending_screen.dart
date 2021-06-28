import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import '../../models/user_model.dart';
import '../../services/common_service.dart';
import '../../services/navigator_service.dart';
import '../../services/network_service.dart';
import '../../services/pref_service.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/dimens.dart';
import '../../utils/params.dart';
import '../../utils/themes.dart';
import '../main/app_upgrade_screen.dart';

class LendingScreen extends StatefulWidget {
  const LendingScreen({Key key}) : super(key: key);

  @override
  _LendingScreenState createState() => _LendingScreenState();
}

class _LendingScreenState extends State<LendingScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _getData();
    });
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _getData() async {
    await _initPackageInfo();
    var resp = await NetworkService(context)
        .ajax('chat_status', null, isProgress: false);
    if (resp['ret'] == 10000) {
      appSettingInfo['isNearby'] = resp['result']['nearby'] == '1';
      appSettingInfo['isVideoStory'] = resp['result']['videostory'] == '1';
      appSettingInfo['isReplyComment'] = resp['result']['replycomment'] == '1';
      appSettingInfo['isVoiceCall'] = resp['result']['voicecall'] == '1';
      appSettingInfo['isVideoCall'] = resp['result']['videocall'] == '1';
      appSettingInfo['isAppVersion'] =
          checkVersion(resp['result']['appversion'], _packageInfo);
      appSettingInfo['contactEmail'] = resp['result']['email'];
      appSettingInfo['contactPhone'] = resp['result']['phone'];
      appSettingInfo['encrypt'] = resp['result']['encrypt'];

      print('appSettingInfo ===> ${appSettingInfo.toString()}');
      if (!appSettingInfo['isAppVersion']) {
        NavigatorService(context)
            .pushToWidget(screen: AppUpgradeScreen(), replace: true);
      } else {
        checkData();
      }
    }
  }

  void checkData() async {
    var loginInfo = await PreferenceService().getUserLoginInfo();
    if (loginInfo == null) {
      Navigator.of(context).pushReplacementNamed(route_login, arguments: 0);
    } else {
      switch (loginInfo['type']) {
        case 'NORMAL':
          {
            var resp = await NetworkService(context)
                .ajax('chat_login', loginInfo, isProgress: false);
            if (resp['ret'] == 10000) {
              currentUser = UserModel.fromMap(resp['result']);
              Navigator.of(context)
                  .pushReplacementNamed(route_main, arguments: 0);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(route_login, arguments: 0);
            }
          }
          break;
        case 'GOOGLE':
          {
            var resp = await NetworkService(context)
                .ajax('chat_google_login', loginInfo, isProgress: false);
            if (resp['ret'] == 10000) {
              currentUser = UserModel.fromMap(resp['result']);
              Navigator.of(context)
                  .pushReplacementNamed(route_main, arguments: 0);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(route_login, arguments: 0);
            }
          }
          break;
        case 'APPLE':
          {
            var resp = await NetworkService(context)
                .ajax('chat_apple_login', loginInfo, isProgress: false);
            if (resp['ret'] == 10000) {
              currentUser = UserModel.fromMap(resp['result']);
              Navigator.of(context)
                  .pushReplacementNamed(route_main, arguments: 0);
            } else {
              Navigator.of(context)
                  .pushReplacementNamed(route_login, arguments: 0);
            }
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            Text(
              'Simple Chat'.toUpperCase(),
              style: boldText.copyWith(fontSize: fontXLg, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
