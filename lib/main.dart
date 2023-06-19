import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio Flutter',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePageContent(),
    AboutPageContent(),
    ProjectsPageContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'My Portfolio',
            style: TextStyle(color: Colors.black), // Set the text color to black
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Projects',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;
  late Animation<Color?> _colorAnimation;
  int _textIndex = 0;
  List<String> _textOptions = [];

  @override
  void initState() {
    super.initState();
    loadTextOptions();
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = ColorTween(begin: Colors.black, end: Colors.green)
        .animate(_animationController);
    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.green)
        .animate(_animationController);

    // Start the timer to change the sentence every 3 seconds
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (_textOptions.isNotEmpty) {
        setState(() {
          _textIndex = (_textIndex + 1) % _textOptions.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadTextOptions() async {
    String jsonString =
        await rootBundle.loadString('assets/text_options.json');
    final jsonMap = json.decode(jsonString);
    setState(() {
      _textOptions = List<String>.from(jsonMap['options']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to My Portfolio',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _textOptions.isNotEmpty
                ? RichText(
                    key: ValueKey<String>(_textOptions[_textIndex]),
                    text: TextSpan(
                      style: TextStyle(fontSize: 24),
                      children: _textOptions[_textIndex]
                          .split("   ")
                          .map((text) {
                        if (text.trim().isEmpty) return TextSpan();
                        return TextSpan(
                          text: text,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.green,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : SizedBox(),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }
}

class AboutPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Me',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage:
                    AssetImage('assets/images/profile_image.jpg'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "I'm a passionate Flutter developer with experience in building mobile applications. I have a strong understanding of the Flutter framework and Dart programming language.",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 16),
          Text(
            'Skills',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SkillChip(label: 'Flutter'),
              SkillChip(label: 'C#'),
              SkillChip(label: 'Laravel'),
              SkillChip(label: 'UI/UX Design'),
              SkillChip(label: 'Responsive Design'),
              SkillChip(label: 'Git'),
            ],
          ),
        ],
      ),
    );
  }
}

class ProjectsPageContent extends StatelessWidget {
  final List<Map<String, String>> projects = [
    {
      'imageUrl': 'assets/images/project1.jpg',
      'title': 'Website Development',
      'description': 'Tugas akhir mas',
    },
    {
      'imageUrl': 'assets/images/project2.jpg',
      'title': 'Application Development',
      'description': 'Tugas akhir applicaiton development',
    },
    {
      'imageUrl': 'assets/images/project3.jpg',
      'title': 'Jual Pisang',
      'description': 'HAHAHAHAHAAHHAHAHAHAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
    },
    {
      'imageUrl': 'assets/images/project4.jpg',
      'title': 'Jual Orang',
      'description': 'Tugas NJ:ASND:OANDSO:jDANSK:JXANWJIDB:KSANXZJNJZKJCNOANDWNASDN',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Projects',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Column(
            children: projects
                .map((project) => ProjectCard(
                      imageUrl: project['imageUrl']!,
                      title: project['title']!,
                      description: project['description']!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailsPage(
                              imageUrl: project['imageUrl']!,
                              title: project['title']!,
                              description: project['description']!,
                            ),
                          ),
                        );
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ProjectCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const ProjectDetailsPage({
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.green,
      labelStyle: TextStyle(color: Colors.white),
    );
  }
}
