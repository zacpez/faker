import 'package:faker/src/random_generator.dart';

/// A shuffler that cycles through a shuffled list of elements.
///
/// This is useful for generating random sequences that don't repeat until
/// the entire corpus has been exhausted.
class Shuffler<T> {
  final List<T> _shuffled;
  int _index = 0;

  Shuffler(List<T> elements) : _shuffled = shuffle(elements);

  /// Returns the next element in the shuffled list, cycling back to the
  /// beginning when the end is reached.
  T next() {
    if (_index >= _shuffled.length) {
      _index = 0;
    }
    return _shuffled[_index++];
  }

  /// Shuffles a list of elements using the Fisher-Yates algorithm.
  ///
  /// This is a static method that can be used to shuffle any list of elements.
  static List<T> shuffle<T>(List<T> elements) {
    final list = List<T>.from(elements);

    for (var i = list.length - 1; i > 0; i--) {
      final j = random.integer(i + 1);
      final temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }

    return list;
  }
}
