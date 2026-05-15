import 'package:faker/src/providers/base_providers.dart';
import 'package:faker/src/shuffler.dart';
import 'random_generator.dart';

class Lorem {
  Lorem(this.random, this._provider)
      : _shuffledWords = null,
        _shuffledSentences = null;

  final RandomGenerator random;
  final LoremDataProvider _provider;

  Shuffler<String>? _shuffledWords;
  Shuffler<String>? _shuffledSentences;

  /// Generates a word.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.word();
  /// ```
  String word() => random.element(_provider.wordsList());

  /// Generates a list of random words. The number of words is determined
  /// by the `numberOfWords` parameter.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.words(3);
  /// ```
  List<String> words(numberOfWords) {
    return Iterable<int>.generate(numberOfWords).map((_) => word()).toList();
  }

  /// Generates a random sentence.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.sentence();
  /// ```
  String sentence() => random.element(_provider.sentencesList());

  /// Generates a list of random sentences. The size of the list of determined
  /// by the `numberOfSentences` parameter.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.sentences(5);
  /// ```
  List<String> sentences(numberOfSentences) {
    return Iterable<int>.generate(numberOfSentences)
        .map((_) => sentence())
        .toList();
  }

  /// Generates a word using unique selection.
  /// Words are returned in a random order without repeats until
  /// the entire corpus has been exhausted.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.wordUnique();
  /// ```
  String wordUnique() {
    _shuffledWords ??= Shuffler(_provider.wordsList());
    return _shuffledWords!.next();
  }

  /// Generates a list of random words using unique selection.
  /// Words are returned without repeats until the corpus is exhausted.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.wordsUnique(3);
  /// ```
  List<String> wordsUnique(numberOfWords) {
    return Iterable<int>.generate(numberOfWords)
        .map((_) => wordUnique())
        .toList();
  }

  /// Generates a sentence using unique selection.
  /// Sentences are returned in a random order without repeats until
  /// the entire corpus has been exhausted.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.sentenceUnique();
  /// ```
  String sentenceUnique() {
    _shuffledSentences ??= Shuffler(_provider.sentencesList());
    return _shuffledSentences!.next();
  }

  /// Generates a list of random sentences using unique selection.
  /// Sentences are returned without repeats until the corpus is exhausted.
  ///
  /// Example:
  /// ```dart
  ///   faker.lorem.sentencesUnique(3);
  /// ```
  List<String> sentencesUnique(numberOfSentences) {
    return Iterable<int>.generate(numberOfSentences)
        .map((_) => sentenceUnique())
        .toList();
  }
}
