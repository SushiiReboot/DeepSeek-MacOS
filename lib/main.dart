import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
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
    return Builder(builder: (context) {
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
              return Column(
                children: [
                  Expanded(
                      child: Center(
                    child: Text(
                      "Welcome to DeepSeek V3!",
                      style: MacosTheme.of(context).typography.headline,
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: MacosTextField(
                            placeholder: "Ask DeepSeek...",
                            padding: EdgeInsets.all(20),
                            focusedDecoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
                            placeholderStyle:
                                TextStyle(color: Color(0X60FFFFFF)),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(22, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                        ),
                        SizedBox(width: 20,),
                        IconButton(
                            onPressed: () {},
                            color: const Color.fromARGB(255, 0, 121, 251),
                            style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all(const Color.fromARGB(64, 0, 174, 255))),
                            icon: Icon(Icons.arrow_upward_rounded))
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      );
    });
  }
}

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}
