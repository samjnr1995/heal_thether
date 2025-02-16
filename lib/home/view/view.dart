import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:health_thether/utils/colors.dart';
import 'package:health_thether/utils/text_styles.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Filter users based on search query
    final filteredUsers = userProvider.users.where((user) {
      return user.name!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Users List",
          style: AppTextStyles.headerStyle.copyWith(fontSize: 20.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await userProvider.fetchUsers();
        },
        child: userProvider.isLoading
            ? const Center(
          child: SpinKitFadingFour(
            color: AppColors.defaultBlue,
            size: 50.0,
          ),
        )
            : userProvider.errorMessage != null
            ? buildErrorWidget(userProvider)
            : buildUserList(filteredUsers),
      ),
    );
  }

  Widget buildUserList(List filteredUsers) {
    return ListView.builder(
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage('assets/place_holder.png'),
            ),
            title: Text(
              user.name.toString(),
              style: AppTextStyles.headerStyle.copyWith(fontSize: 15.sp),
            ),
            subtitle: Text(
              "📧 ${user.email}",
              style: const TextStyle(fontSize: 15),
            ),
          ),
        );
      },
    );
  }

  Widget buildErrorWidget(UserProvider userProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 50),
          SizedBox(height: 15.h),
          Text(
            "Whoops!!!",
            style: AppTextStyles.headerStyle.copyWith(fontSize: 20.sp),
          ),
          Center(child: Text(userProvider.errorMessage!)),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: () {
              userProvider.fetchUsers();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.defaultBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 50.h,
              width: 300.w,
              child: const Center(
                child: Text('Retry', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Search User"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: "Enter name...",
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  searchQuery = searchController.text;
                });
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }
}
