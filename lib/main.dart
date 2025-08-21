import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const StudentInfoManagerApp());
}

class StudentInfoManagerApp extends StatelessWidget {
  const StudentInfoManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Info Manager",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegisterScreen(),
    );
  }
}

// ---------------- REGISTER SCREEN ----------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _courseController = TextEditingController();
  final _universityController = TextEditingController();

  // Generate random profile image URL
  String _generateProfileImage(String name) {
    // You can use ui-avatars for personalized avatars
    return "https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=random";
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      String profileUrl = _generateProfileImage(_nameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            name: _nameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            course: _courseController.text,
            university: _universityController.text,
            profileUrl: profileUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (value) =>
                value!.isEmpty ? "Enter your full name" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                !value!.contains('@') ? "Enter a valid email" : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? "Password must be at least 6 chars"
                    : null,
              ),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: "Course"),
              ),
              TextFormField(
                controller: _universityController,
                decoration: const InputDecoration(labelText: "University"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- LOGIN SCREEN ----------------
class LoginScreen extends StatefulWidget {
  final String name, email, password, course, university, profileUrl;

  const LoginScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.course,
    required this.university,
    required this.profileUrl,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailInput = TextEditingController();
  final _passwordInput = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_emailInput.text == widget.email &&
          _passwordInput.text == widget.password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              studentName: widget.name,
              course: widget.course,
              university: widget.university,
              email: widget.email,
              profileUrl: widget.profileUrl,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid login credentials")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailInput,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                !value!.contains('@') ? "Enter a valid email" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordInput,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                value!.length < 6 ? "Password too short" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatefulWidget {
  final String studentName;
  final String course;
  final String university;
  final String email;
  final String profileUrl;

  const HomePage({
    super.key,
    required this.studentName,
    required this.course,
    required this.university,
    required this.email,
    required this.profileUrl,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int studentCount = 0;

  @override
  void initState() {
    super.initState();
    studentCount++; // increment each successful registration
  }

  void _showWelcomeAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Hello, ${widget.studentName}! Welcome.")),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          name: widget.studentName,
          course: widget.course,
          university: widget.university,
          email: widget.email,
          profileUrl: widget.profileUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Dashboard"),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(widget.profileUrl),
            ),
            onPressed: _openProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${widget.studentName}",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Course: ${widget.course}",
                style: const TextStyle(fontSize: 16)),
            Text("University: ${widget.university}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _showWelcomeAlert,
              child: const Text("Show Alert"),
            ),
            const SizedBox(height: 30),

            Center(
              child: Column(
                children: [
                  const Text("Registered Students",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    "$studentCount",
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
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

// ---------------- PROFILE PAGE ----------------
class ProfilePage extends StatelessWidget {
  final String name;
  final String course;
  final String university;
  final String email;
  final String profileUrl;

  const ProfilePage({
    super.key,
    required this.name,
    required this.course,
    required this.university,
    required this.email,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipOval(
              child: Image.network(profileUrl,
                  width: 120, height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Text("Name: $name", style: const TextStyle(fontSize: 18)),
            Text("Course: $course", style: const TextStyle(fontSize: 18)),
            Text("University: $university", style: const TextStyle(fontSize: 18)),
            Text("Email: $email", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
