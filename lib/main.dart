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
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(22, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              children: [
                                MacosTextField(
                                  placeholder: "Ask DeepSeek...",
                                  padding: EdgeInsets.only(
                                      top: 15, left: 20, right: 20, bottom: 5),
                                  focusedDecoration: null,
                                  placeholderStyle:
                                      TextStyle(color: Color(0X60FFFFFF)),
                                  decoration: null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        color: Colors.white,
                                        hoverColor: Colors.transparent,
                                        icon: Icon(
                                          Icons.add,
                                          color: Color(0X60FFFFFF),
                                        ),
                                        onPressed: () {},
                                      ),
                                      TextFieldButton(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () {},
                            color: const Color.fromARGB(255, 0, 121, 251),
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    const Color.fromARGB(64, 0, 174, 255))),
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

class TextFieldButton extends StatefulWidget {
  const TextFieldButton({
    super.key,
  });

  @override
  State<TextFieldButton> createState() => _TextFieldButtonState();
}

class _TextFieldButtonState extends State<TextFieldButton>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    _widthAnimation = Tween<double>(begin: 40, end: 110)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _backgroundColorAnimation = ColorTween(
            begin: Colors.transparent, end: Color.fromARGB(50, 0, 174, 255))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Default properties
  double _height = 40;

  static const _buttonSlideTime = Duration(milliseconds: 200);
  static const _textAppearDelay = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: _widthAnimation.value,
      height: 30,
      decoration: BoxDecoration(
        color: _backgroundColorAnimation.value,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      curve: Curves.fastOutSlowIn,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            iconSize: 22,
            color: Color.fromARGB(50, 0, 174, 255),
            hoverColor: Colors.transparent,
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.language,
              color: Color(0X60FFFFFF),
            ),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
                isExpanded ? _controller.forward() : _controller.reverse();
              });
            },
          ),
          Expanded(
              child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: isExpanded
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(bottom: 2, left: 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Search",
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.start,
                        style: MacosTheme.of(context)
                            .typography
                            .headline
                            .copyWith(
                                color: const Color.fromARGB(255, 0, 141, 163)),
                      ),
                    )),
          ))
        ],
      ),
    );
  }
}

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}
