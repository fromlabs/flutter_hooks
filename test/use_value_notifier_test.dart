import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'mock.dart';

void main() {
  testWidgets('useValueNotifier basic', (tester) async {
    ValueNotifier<int> previous;
    ValueNotifier<int> state;
    HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        previous = state;
        element = context as HookElement;
        state = useValueNotifier(42);
        return Container();
      },
    ));

    expect(state.value, 42);
    // ignore: invalid_use_of_protected_member
    expect(state.hasListeners, false);

    await tester.pumpWidget(const SizedBox());

    // ignore: invalid_use_of_protected_member
    expect(() => state.hasListeners, throwsFlutterError);
  });

  testWidgets('no initial data', (tester) async {
    ValueNotifier<int> state;
    HookElement element;

    await tester.pumpWidget(HookBuilder(
      builder: (context) {
        element = context as HookElement;
        state = useValueNotifier();
        return Container();
      },
    ));

    expect(state.value, null);
    expect(element.dirty, false);

    await tester.pump();

    expect(state.value, null);
    expect(element.dirty, false);

    state.value = 43;
    expect(element.dirty, true);
    await tester.pump();

    expect(state.value, 43);
    expect(element.dirty, false);

    // dispose
    await tester.pumpWidget(const SizedBox());

    // ignore: invalid_use_of_protected_member
    expect(() => state.hasListeners, throwsFlutterError);
  });
}
