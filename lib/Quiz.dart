import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MiniFormScreen(),
    );
  }
}

class MiniFormScreen extends StatefulWidget {
  const MiniFormScreen({super.key});

  @override
  State<MiniFormScreen> createState() => _MiniFormScreenState();
}

class _MiniFormScreenState extends State<MiniFormScreen> {
  // Step 2: Create TextEditingControllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Step 3: Create GlobalKey for Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Variables to store submitted values
  String? submittedName;
  String? submittedMessage;

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    nameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  // Step 6: Submit handler
  void handleSubmit() {
    if (formKey.currentState!.validate()) {
      setState(() {
        submittedName = nameController.text;
        submittedMessage = messageController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Form'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Step 4: Form with TextFormFields
            Form(
              key: formKey,
              child: Column(
                children: [
                  // Field 1: Full Name (single line)
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your full name',
                    ),
                    // Step 5: Validator
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Field 2: Message (multi-line, 3 lines)
                  TextFormField(
                    controller: messageController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message',
                    ),
                    // Step 5: Validator
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Submit Button
            ElevatedButton(
              onPressed: handleSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            // Step 8: Preview area (only shown after successful submit)
            if (submittedName != null && submittedMessage != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Preview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 20),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              submittedName!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Message: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              submittedMessage!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}