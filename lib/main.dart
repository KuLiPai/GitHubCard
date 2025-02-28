import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:smooth_corner/smooth_corner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double val = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 34, 255, 0))),
      home: GitHubCardPage(),
    );
  }
}

class GitHubCardPage extends StatefulWidget {
  const GitHubCardPage({
    super.key,
  });

  @override
  State<GitHubCardPage> createState() => _GitHubCardPageState();
}

class _GitHubCardPageState extends State<GitHubCardPage> {
  final _controller = TextEditingController();
  var load = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GitHub Card')),
      body: load
          ? Githubcard(name: _controller.text)
          : Column(
              children: [
                SizedBox(
                  height: 64,
                ),
                Center(
                  child: SizedBox(
                    width: 256,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Enter Your GitHub Name',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                FilledButton(
                    onPressed: () {
                      setState(() {
                        load = true;
                      });
                    },
                    child: Text("OK"))
              ],
            ),
    );
  }
}

class Githubcard extends StatelessWidget {
  final String name;
  const Githubcard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: fetchUserData(name), // 调用异步方法
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 加载中状态
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 错误状态
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // 数据加载成功
            String text = snapshot.data!;

            final patternUser = RegExp('p="name">\n +(.+?)\n +?<');

            var user = patternUser
                .allMatches(text)
                .map((match) => match.group(1)!)
                .toList()[0];
            final patternimg = RegExp(r'itemprop="image" href="(.+?)"');
            var img = patternimg
                .allMatches(text)
                .map((match) => match.group(1)!)
                .toList()[0];

            final patternLang =
                RegExp(r'itemprop="programmingLanguage">(.+?)<');

            var chiplen = patternLang.allMatches(text).length;
            var chiptext = patternLang
                .allMatches(text)
                .map((match) => match.group(1)!)
                .toList();

            // 提取名称和描述
            List<String> reposit = [];
            List<String> repositDes = [];

            //final patternProName = RegExp(r'position-absolute">(.+?)<');
            RegExp patternProName = RegExp(
                '<span class="repo" ?>\n? *?(.+?)\n? *?<',
                multiLine: true,
                dotAll: true);

            final patternProDes = RegExp('mt-2 mb-\\d+">\n +?(.+?)\n +?<',
                multiLine: true, dotAll: true);

            // 匹配名称
            for (var match in patternProName.allMatches(text)) {
              if (match.group(1) != null) {
                reposit.add(match.group(1)!.trim());
              }
            }

            // print(reposit);

            // 匹配描述
            for (var match in patternProDes.allMatches(text)) {
              if (match.group(1) != null) {
                repositDes.add(match.group(1)!.trim());
              }
            }
            // print(repositDes);
            int respositlen = (reposit.length >= 4) ? 4 : reposit.length;
            final patternReps = RegExp('Repositories\n +?<span title="(\\d+)"',
                multiLine: true, dotAll: true);

            var reps = patternReps
                .allMatches(text)
                .map((match) => match.group(1)!)
                .toList()[0];

            final patternFollowers =
                RegExp(r'class="text-bold color-fg-default">(.+?)<');
            var follows = patternFollowers
                .allMatches(text)
                .map((match) => match.group(1))
                .toList()[0];

            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 360.0, top: 64, right: 360, bottom: 128),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmoothCard(
                                  smoothness: 1,
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 3.0,
                                  ),
                                  borderRadius: BorderRadius.circular(42),
                                  child: SmoothClipRRect(
                                    smoothness: 1,
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 4.0),
                                    borderRadius: BorderRadius.circular(42),
                                    child: SizedBox(
                                      width: 128,
                                      height: 128,
                                      child: Image.network(
                                        img,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 4),
                                        child: Text(
                                          user,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, top: 16, right: 16),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: List.generate(
                                            ///toolList.length,
                                            chiplen + 1,
                                            (index) => Chip(
                                              label: (index == chiplen)
                                                  ? Wrap(
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text("Follows  "),
                                                            Text(
                                                                follows
                                                                    as String,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary))
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Text(chiptext[index]),
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondaryContainer,
                                              side: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0.0),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Wrap(
                                    spacing: 2,
                                    runSpacing: 1,
                                    children: List.generate(
                                      ///toolList.length,
                                      respositlen,
                                      (index) => Card.filled(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 24.0,
                                              top: 14,
                                              bottom: 14,
                                              right: 16),
                                          child: Row(
                                            children: [
                                              Text(
                                                reposit[index],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              Text(
                                                ": ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  repositDes[index],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card.filled(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: SizedBox(
                                      height: 222,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 24.0,
                                                top: 12,
                                                bottom: 12,
                                                right: 16),
                                            child: Column(
                                              children: [
                                                Text(
                                                  reps,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                Text(
                                                  "Repositories",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onSurface
                                                                  .withOpacity(
                                                                      0.6)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            // 其他情况
            return Center(child: Text('No data'));
          }
        });
  }
}

Future<String> fetchUserData(String name) async {
  try {
    final response = await http.get(
      Uri.parse('https://github.com/$name'),
    );

    if (response.statusCode == 200) {
      // print('Response: ${response.body}');
      return response.body;
    } else {
      // print('Request failed with status: ${response.statusCode}');
      return "";
    }
  } catch (e) {
    // print('Error: $e');
    return "";
  }
}
