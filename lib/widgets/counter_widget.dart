// widgets/counter_widget.dart
import 'package:flutter/material.dart';

typedef CounterChangedCallback = void Function(int newValue);

class CounterWidget extends StatefulWidget {
  final String label;
  final int initialValue;
  final CounterChangedCallback onChanged;

  const CounterWidget({
    Key? key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    setState(() {
      _currentValue++;
    });
    widget.onChanged(_currentValue);
  }

  void _decrement() {
    setState(() {
      if (_currentValue > 0) {
        _currentValue--;
      }
    });
    widget.onChanged(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                Text(
                  '$_currentValue',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}