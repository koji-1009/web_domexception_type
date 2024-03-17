import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DOM Exception issue Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DOM Exception issue Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                try {
                  web.window.navigator.unknownFunction();
                } on web.DOMException catch (e) {
                  print('Caught DOMException: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('DOMException: ${e.name} ${e.message}'),
                    ),
                  );
                } on NoSuchMethodError catch (e) {
                  print('Caught NoSuchMethodError: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('NoSuchMethodError: ${e.runtimeType}'),
                    ),
                  );
                } on Object catch (e) {
                  print('Caught Object: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Object: ${e.runtimeType}'),
                    ),
                  );
                }
              },
              child: const Text('invalid function call'),
            ),
            const SizedBox(
              height: 16,
            ),
            FilledButton(
              onPressed: () async {
                try {
                  await web.window.navigator
                      .setAppBadge(
                        'test'.toJS,
                      )
                      .toDart;
                } on web.DOMException catch (e) {
                  print('Caught DOMException: $e');
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('DOMException: ${e.name} ${e.message}'),
                    ),
                  );
                } on NoSuchMethodError catch (e) {
                  print('Caught NoSuchMethodError: $e');
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('NoSuchMethodError: ${e.runtimeType}'),
                    ),
                  );
                } on Object catch (e) {
                  print('Caught Object: $e');
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Object: ${e.runtimeType}'),
                    ),
                  );
                }
              },
              child: const Text('function call with invalid data'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on web.Navigator {
  external void unknownFunction();

  external JSPromise setAppBadge(JSAny data);
}
