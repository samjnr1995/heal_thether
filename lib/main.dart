import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_thether/home/view/view.dart';
import 'package:health_thether/onboarding/view/view.dart';
import 'package:health_thether/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/provider/user_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(
  );
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  runApp(MyApp(
    hasSeenOnboarding: hasSeenOnboarding,
  ));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
    ChangeNotifierProvider<UserProvider>(
    create: (_) => UserProvider(),
    ),
      ],child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          title: 'Heal Theter',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.defaultBlue),
            useMaterial3: true,
          ),
          home: hasSeenOnboarding? const HomeScreen() : const OnboardingPage()
        ),
      ),
    );
  }
}

