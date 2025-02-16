import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_thether/home/view/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/text_styles.dart';



class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  int currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
//here this function check if user has already seen the onboarding screen so we can hide it
  void _completeOnboarding(BuildContext context) {
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 1;
                    currentIndex = index;
                  });
                },
                itemCount: 2,
                itemBuilder: (context, index) {
                  return AnimatedOnboardingContent(
                    imagePath: _getImagePath(index),
                    title: _getTitle(index),
                    description: _getDescription(index),
                    isVisible: currentIndex == index,
                  );
                },
              ),
            ),
            Column(
              children: [
                SizedBox(height: 40.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _pageController.jumpToPage(2),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.headerStyle
                            .copyWith(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 2,
                      effect: const WormEffect(
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 7,
                        dotColor: Colors.grey,
                        activeDotColor: Color(0xff043582),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (isLastPage) {
                          _completeOnboarding(context);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Text(
                        isLastPage ? 'Start' : 'Next',
                        style: AppTextStyles.headerStyle.copyWith(
                            fontSize: 14.sp, color: const Color(0xff043582)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getImagePath(int index) {
    switch (index) {
      case 0:
        return 'assets/board.png';
      case 1:
        return 'assets/onboarding.png';
      default:
        return '';
    }
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Welcome';
      case 1:
        return 'Quick Database';
      default:
        return '';
    }
  }
// using switch case to return a particular onboarding message, don/t forget index in dart starts from 0
  String _getDescription(int index) {
    switch (index) {
      case 0:
        return 'Welcome To Heal Thether.';
      case 1:
        return 'Access all emails and usernames at your finger tip';
      default:
        return '';
    }
  }

}

class AnimatedOnboardingContent extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final bool isVisible;

  const AnimatedOnboardingContent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isVisible ? 1 : 0,
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              alignment: isVisible ? Alignment.center : Alignment.topCenter,
              child: Image.asset(
                imagePath,
                height: 250,
              ),
            ),
          ),
          SizedBox(height: 30.h),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isVisible ? 1 : 0,
            child: Text(
              title,
              style: AppTextStyles.headerStyle
                  .copyWith(fontSize: 25.sp, color: const Color(0xff043582)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isVisible ? 1 : 0,
            child: Text(
              description,
              style: AppTextStyles.headerStyle
                  .copyWith(fontSize: 16.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
