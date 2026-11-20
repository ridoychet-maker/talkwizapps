import 'package:flutter/material.dart';
import 'main.dart'; // হোম পেজে যাওয়ার জন্য

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _sendOTP() {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('সঠিক ১০ ডিজিটের ফোন নম্বর দিন (যেমন: 17XXXXXXXX)')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPScreen(phoneNumber: '+880$phone'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        backgroundColor: const Color(0xFF008069),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'TalkWizApps will need to verify your phone number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('+880', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      hintText: '1XXXXXXXXX',
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008069),
                  foregroundColor: Colors.white,
                ),
                onPressed: _sendOTP,
                child: const Text('NEXT', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPScreen extends StatelessWidget {
  final String phoneNumber;
  const OTPScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifying $phoneNumber'),
        backgroundColor: const Color(0xFF008069),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Enter the 6-digit code sent to your phone'),
            const SizedBox(height: 20),
            const TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(hintText: '------'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008069),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // ভেরিফিকেশন শেষে সরাসরি আপনার মূল হোম পেজে চলে যাবে
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('VERIFY', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
