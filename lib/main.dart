import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'landinpage.dart';
import 'auth_page.dart';
import 'dashboard_page.dart';
import 'html_code_page.dart';

// Route name constants
class Routes {
  static const String landing = '/';
  static const String auth = '/auth';
  static const String dashboard = '/dashboard';
  static const String htmlCode = '/html-code';
  static const String notFound = '/404';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBA3sabcnongB2A3hKApsxZkIWtnLFdzhc",
      authDomain: "custoflow-39371.firebaseapp.com",
      projectId: "custoflow-39371",
      storageBucket: "custoflow-39371.firebasestorage.app",
      messagingSenderId: "108003566774",
      appId: "1:108003566774:web:6a37d88786db3700e07217",
    ),
  );
  runApp(const CustoFlowApp());
}

class CustoFlowApp extends StatelessWidget {
  const CustoFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustoFlow - Automated Customer Feedback',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
      ),
      // Define initial route
      initialRoute: Routes.landing,

      // Define named routes
      routes: {
        Routes.landing: (context) => const LandingPage(),
        Routes.auth: (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final isSignUp = args?['isSignUp'] ?? false;
          return AuthPage(isSignUp: isSignUp);
        },
        Routes.dashboard: (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          return DashboardPage(
            companyData: args?['companyData'],
            isFirstTimeSetup: args?['isFirstTimeSetup'] ?? false,
          );
        },
        Routes.htmlCode: (context) {
          final htmlCode =
              ModalRoute.of(context)?.settings.arguments as String? ??
              '<!-- No HTML code provided -->';
          return HtmlCodePage(htmlCode: htmlCode);
        },
      },

      // Handle undefined routes with custom 404 page
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) =>
              NotFoundPage(routeName: settings.name ?? 'Unknown'),
        );
      },

      // Add page transition animations
      onGenerateTitle: (context) => 'CustoFlow',
    );
  }
}

// 404 Error Page
class NotFoundPage extends StatelessWidget {
  final String routeName;

  const NotFoundPage({Key? key, required this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 100, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Page Not Found',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Route: $routeName',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, Routes.landing),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF667eea),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Go Home',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
