import 'package:faker/faker.dart';
import 'package:faker/src/data/lorem/defaults/words.dart';
import 'package:faker/src/data/lorem/defaults/sentences.dart';
import 'package:test/test.dart';

void main() {
  group('Lorem', () {
    group('words', () {
      test('should be able to generate single word', () {
        expect(faker.lorem.word(), matches(RegExp(r'^[\w-^]+$')));
      });

      test('should be able to generate word list', () {
        expect(faker.lorem.words(3), hasLength(3));
      });

      test('should be able to generate word list using distributed selection',
          () {
        final actual = [];
        final corpusSize = words.length;
        for (var i = 0; i < corpusSize + 1; i++) {
          final word = faker.lorem.wordUnique();
          actual.add(word);
        }
        final nextWord = actual.removeLast();

        expect(actual, unorderedMatches(words));
        expect(actual, contains(nextWord));
      });

      test('should not repeat words until corpus is exhausted', () {
        final corpusSize = words.length;
        final generatedWords = faker.lorem.wordsUnique(corpusSize + 1);
        final nextWord = generatedWords.removeLast();
        final uniqueWords = generatedWords.toSet();

        expect(uniqueWords, unorderedMatches(generatedWords));

        // The first word should be the next word to be generated
        expect(uniqueWords.first, nextWord);
      });
    });

    group('sentences', () {
      test('should be able to generate sentence', () {
        expect(faker.lorem.sentence(), matches(RegExp(r'^[\w^ ]+\.$')));
      });

      test('should be able to generate sentence list', () {
        expect(faker.lorem.sentences(3), hasLength(3));
      });

      test(
          'should be able to generate sentence list using distributed selection',
          () {
        final actual = [];
        final corpusSize = sentences.length;
        for (var i = 0; i < corpusSize + 1; i++) {
          final sentence = faker.lorem.sentenceUnique();
          actual.add(sentence);
        }
        final nextSentence = actual.removeLast();

        expect(actual, unorderedMatches(sentences));
        expect(actual, contains(nextSentence));
      });

      test('should not repeat sentences until corpus is exhausted', () {
        final corpusSize = sentences.length;
        final generatedSentences = faker.lorem.sentencesUnique(corpusSize + 1);
        final nextSentence = generatedSentences.removeLast();
        final uniqueSentences = generatedSentences.toSet();

        expect(uniqueSentences, unorderedMatches(generatedSentences));

        // The first sentence should be the next one to be generated
        expect(uniqueSentences.first, nextSentence);
      });
    });
  });
}
