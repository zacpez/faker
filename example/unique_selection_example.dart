import 'package:faker/faker.dart';
import 'package:test/test.dart';

/// Example demonstrating why distributed selection is useful for testing.
///
/// In real-world applications, tests often use random words to generate
/// test data and verify content. With the traditional random selection
/// (with replacement), word collisions can occur even with small datasets,
/// causing flaky tests.
///
/// This example shows the collision problem and how distributed selection
/// solves it.

void main() {
  group('Distributed Selection Use Case', () {
    test('traditional random selection can cause collisions in small datasets',
        () {
      // Simulate a test that generates 5 random words to verify content
      const testSize = 5;
      final words = List.generate(testSize, (_) => faker.lorem.word());
      final uniqueWords = words.toSet();

      // Even with just 5 items, collisions can occur
      print('Generated words: $words');
      print('Unique words: ${uniqueWords.length} out of $testSize');

      // This assertion may fail intermittently due to collisions
      // NOTE: This may not fail so there is a stress test below
      expect(uniqueWords.length, equals(testSize),
          reason: 'Traditional selection can produce duplicates');
    });

    test(
        'distributed selection guarantees no collisions until corpus exhausted',
        () {
      // Same test scenario using distributed selection
      const testSize = 5;
      final words = List.generate(testSize, (_) => faker.lorem.wordUnique());
      final uniqueWords = words.toSet();

      print('Generated words (distributed): $words');
      print('Unique words: ${uniqueWords.length} out of $testSize');

      // This will always pass as long as testSize <= corpus size
      expect(uniqueWords.length, equals(testSize),
          reason: 'Distributed selection guarantees uniqueness');
    });

    test('real-world scenario: verifying generated content identifiers', () {
      // Example: Test that generates unique identifiers for content items
      // and verifies each identifier maps to the correct content

      final contentItems = [
        'article1',
        'article2',
        'article3',
        'article4',
        'article5'
      ];
      final identifiers = {};

      // Using traditional random selection - collisions possible
      for (final item in contentItems) {
        final id = faker.lorem.word();
        identifiers[id] = item;
      }

      print('Traditional selection identifiers: ${identifiers.keys.toList()}');
      print('Collision occurred: ${identifiers.length < contentItems.length}');

      // If a collision occurred, we lost a content item
      if (identifiers.length < contentItems.length) {
        print('ERROR: Content item lost due to identifier collision!');
      }

      // Using distributed selection - no collisions
      final distributedIdentifiers = {};
      final freshFaker = Faker(); // Fresh instance for clean state
      for (final item in contentItems) {
        final id = freshFaker.lorem.wordUnique();
        distributedIdentifiers[id] = item;
      }

      print(
          'Distributed selection identifiers: ${distributedIdentifiers.keys.toList()}');
      print(
          'Collision occurred: ${distributedIdentifiers.length < contentItems.length}');

      expect(distributedIdentifiers.length, equals(contentItems.length),
          reason: 'All content items have unique identifiers');
    });

    test(
        'stress test: 100 runs with traditional selection shows collision rate',
        () {
      const testSize = 5;
      const runs = 100;
      var collisionCount = 0;

      for (var i = 0; i < runs; i++) {
        final freshFaker = Faker();
        final words = List.generate(testSize, (_) => freshFaker.lorem.word());
        if (words.toSet().length < testSize) {
          collisionCount++;
        }
      }

      final collisionRate = collisionCount / runs * 100;
      print(
          'Traditional selection collision rate over $runs runs: $collisionRate%');

      // With distributed selection, collision rate is 0% (as long as testSize <= corpus)
      var distributedCollisionCount = 0;
      for (var i = 0; i < runs; i++) {
        final freshFaker = Faker();
        final words =
            List.generate(testSize, (_) => freshFaker.lorem.wordUnique());
        if (words.toSet().length < testSize) {
          distributedCollisionCount++;
        }
      }

      final distributedCollisionRate = distributedCollisionCount / runs * 100;
      print(
          'Distributed selection collision rate over $runs runs: $distributedCollisionRate%');

      expect(distributedCollisionCount, equals(0),
          reason: 'Distributed selection has zero collisions');
    });
  });
}
