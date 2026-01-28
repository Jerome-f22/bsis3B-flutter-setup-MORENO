import 'package:flutter/material.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const QuizScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Quiz state variables
  bool _quizStarted = false;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answerSelected = false;
  int? _selectedAnswerIndex;
  bool _quizEnded = false;

  // Quiz questions and answers
  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          'Which feature would help Jollibee Cubao in Quezon City the most during peak hours?',
      'answers': [
        'Queue number system for walk-in customers',
        'Pre-order and pickup scheduling',
        'Real-time waiting time display',
        'Table reservation system',
      ],
      'correctAnswer': 0, // Index of correct answer (Queue number system)
    },
    {
      'question': 'What is the primary purpose of setState() in Flutter?',
      'answers': [
        'To update the UI when data changes',
        'To create a new widget',
        'To navigate to another screen',
        'To save data permanently',
      ],
      'correctAnswer': 0,
    },
    {
      'question': 'Which widget is used to create a scrollable list in Flutter?',
      'answers': [
        'Container',
        'Column',
        'ListView',
        'Stack',
      ],
      'correctAnswer': 2,
    },
  ];

  // Start the quiz
  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _currentQuestionIndex = 0;
      _score = 0;
      _answerSelected = false;
      _selectedAnswerIndex = null;
      _quizEnded = false;
    });
  }

  // Handle answer selection
  void _selectAnswer(int answerIndex) {
    if (_answerSelected) return; // Prevent multiple selections

    setState(() {
      _selectedAnswerIndex = answerIndex;
      _answerSelected = true;

      // Check if answer is correct
      if (answerIndex == _questions[_currentQuestionIndex]['correctAnswer']) {
        _score++;
      }
    });
  }

  // Move to next question
  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _answerSelected = false;
        _selectedAnswerIndex = null;
      } else {
        _quizEnded = true;
      }
    });
  }

  // Restart the quiz
  void _restartQuiz() {
    setState(() {
      _quizStarted = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _answerSelected = false;
      _selectedAnswerIndex = null;
      _quizEnded = false;
    });
  }

  // Build Start View
  Widget _buildStartView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            const Text(
              'Flutter Quiz',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Test your Flutter knowledge!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _startQuiz,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  // Build Quiz View
  Widget _buildQuizView() {
    final question = _questions[_currentQuestionIndex];
    final answers = question['answers'] as List<String>;
    final correctAnswer = question['correctAnswer'] as int;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Question card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Answer buttons
          Expanded(
            child: ListView.builder(
              itemCount: answers.length,
              itemBuilder: (context, index) {
                final isCorrect = index == correctAnswer;
                final isSelected = _selectedAnswerIndex == index;
                
                Color? buttonColor;
                if (_answerSelected) {
                  if (isSelected) {
                    buttonColor = isCorrect ? Colors.green : Colors.red;
                  } else if (isCorrect) {
                    buttonColor = Colors.green.shade100;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    onPressed: _answerSelected ? null : () => _selectAnswer(index),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: buttonColor,
                      disabledBackgroundColor: buttonColor,
                    ),
                    child: Text(
                      answers[index],
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),

          // Next button (shown after answer selected)
          if (_answerSelected)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build End View
  Widget _buildEndView() {
    final percentage = (_score / _questions.length * 100).toStringAsFixed(0);
    final passed = _score >= (_questions.length / 2);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 100,
              color: passed ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 30),
            Text(
              passed ? 'Congratulations!' : 'Good Try!',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Score',
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$_score / ${_questions.length}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _restartQuiz,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quiz App'),
        centerTitle: true,
      ),
      body: !_quizStarted
          ? _buildStartView()
          : _quizEnded
              ? _buildEndView()
              : _buildQuizView(),
    );
  }
}