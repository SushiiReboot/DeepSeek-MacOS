import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'dart:io';

import 'package:provider/provider.dart';

Future<void> main() async {
  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();
    }
  }

  runApp(DeepSeekUIMacos());
}

class DeepSeekUIMacos extends StatelessWidget {
  const DeepSeekUIMacos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context, _) {
        return MacosApp(
            title: "DeepSeek UI",
            debugShowCheckedModeBanner: false,
            home: MainScreen());
      },
      create: (BuildContext context) {},
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  final items_test =
      List<SidebarItem>.generate(10, (i) => SidebarItem(label: Text("Test")));

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MacosScaffold(
          children: [
            ResizablePane(
              // Sidebar or Resizable Pane
              minSize: 200,
              startSize: 200,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: SidebarItems(
                      items: items_test,
                      currentIndex: pageIndex,
                      onChanged: (i) {
                        setState(() {
                          pageIndex = i;
                        });
                      }),
                );
              },
              resizableSide: ResizableSide.right,
            ),
            ContentArea(
              // Main content
              builder: (context, scrollController) {
                return Center(
                  child: Text(
                    "Welcome to DeepSeek UI",
                    style: MacosTheme.of(context).typography.headline,
                  ),
                );
              },
            ),
          ],
        );
      }
    );
  }
}

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}
