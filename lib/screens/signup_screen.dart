import 'package:flutter/material.dart';

import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Original Activity 10 controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Activity 11 additions
  final _dateController = TextEditingController();

  bool _obscurePassword = true;
  bool _submitting = false;

  DateTime? _birthDate;
  String? _selectedCreatureType;

  final List<String> _creatureTypes = [
    'Ghost',
    'Bat',
    'Black Cat',
    'Pumpkin Spirit',
    'Witch',
  ];

  // Potion 1: Birth date picker
  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _dateController.text = '${picked.month}/${picked.day}/${picked.year}';
      });

      _formKey.currentState?.validate();
    }
  }

  // Potion 2: Loading and navigation
  Future<void> _submit() async {
    if (_submitting) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuccessScreen(
          userName: _nameController.text.trim(),
          creatureType: _selectedCreatureType!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creature Registration Lab'),
        backgroundColor: const Color(0xFF2E1065),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E1065), Color(0xFF14101F)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '🧪',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 64),
                ),
                const SizedBox(height: 12),

                const Text(
                  'Register Your Creature',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // ACTIVITY 10: Name validator unchanged
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Full Name', Icons.person),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ACTIVITY 10: Email validator unchanged
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration('Email Address', Icons.email),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ACTIVITY 10: Password validator unchanged
                // ACTIVITY 11: Visibility toggle added
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Password', Icons.lock).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ACTIVITY 11: Required creature dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCreatureType,
                  dropdownColor: const Color(0xFF2E1065),
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Creature Type', Icons.pets),
                  items: _creatureTypes.map((creature) {
                    return DropdownMenuItem<String>(
                      value: creature,
                      child: Text(creature),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCreatureType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a creature type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ACTIVITY 11: Birth date picker
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _decoration('Birth Date', Icons.cake),
                  validator: (_) {
                    return _birthDate == null ? 'Pick your birth date' : null;
                  },
                  onTap: _pickBirthDate,
                ),
                const SizedBox(height: 24),

                // ACTIVITY 11: Loading button
                ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Register Creature',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Shared input decoration for consistent styling
  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrange),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      errorStyle: const TextStyle(color: Colors.orangeAccent),
    );
  }
}
