import 'package:source_gen_test/src/init_library_reader.dart';
import 'package:test/test.dart';

import 'src/generators/add_names_generator.dart';
import 'src/generators/add_numbers_generator.dart';
import 'src/mock_builders/mock_merging_builder.dart';

/// Tests if the generators [AddNumbersGenerator]
/// and [AddNamesGenerator] produce the expected output.
///
/// To run this program navigate to the top directory the package
/// [merging_builder] and use the command:
/// # pub run test -r expanded --test-randomize-ordering-seed=random
///
/// Note: The path to the input files is specified relative to the main
/// directory of [merging_builder].
Future<void> main() async {
  /// Read libraries.
  final libResearcherA = await initializeLibraryReaderForDirectory(
      'test/src/input', 'researcher_a.dart');

  final libResearcherB = await initializeLibraryReaderForDirectory(
      'test/src/input', 'researcher_b.dart');

  final numBuilder = MockMergingBuilder<num>(
    generator: AddNumbersGenerator(),
    libraries: [libResearcherA, libResearcherB],
    header: AddNumbersGenerator.header,
    footer: AddNumbersGenerator.footer,
    //formatOutput: (input) => (input),
  );

  final namesBuilder = MockMergingBuilder<List<String>>(
    generator: AddNamesGenerator(),
    libraries: [libResearcherA, libResearcherB],
    header: AddNamesGenerator.header,
    footer: AddNamesGenerator.footer,
    //formatOutput: (input) => (input),
  );

  final String numMergedContent = await numBuilder.mergedContent;
  final String numExpected =
      '// GENERATED CODE. DO NOT MODIFY. Generated by AddNumbersGenerator.\n'
      '\n'
      '/// Added numbers\n'
      'final num number0 = 19;\n'
      'final num number0 = 119;\n'
      'final num sum = 138;\n'
      '\n'
      '/// This is the footer.\n'
      '';

  /// This is the footer.
  final String namesMergedContent = await namesBuilder.mergedContent;
  final String namesExpected =
      '// GENERATED CODE. DO NOT MODIFY. Generated by AddNamesGenerator.\n'
      '\n'
      '/// Added names.\n'
      'final name0 = [\'Thomas\', \'Mayor\'];\n'
      'final name1 = [\'Philip\', \'Martens\'];\n'
      '\n'
      'final List<List<String>> names = [\n'
      '  [\'Thomas\', \'Mayor\'],\n'
      '  [\'Philip\', \'Martens\'],\n'
      '];\n'
      '\n'
      '/// This is the footer.\n'
      '';

  group('MergingGenerator:', () {
    test('Stream<List<String>>', () {
      expect(namesMergedContent, namesExpected);
    });
    test('Stream<num>', () {
      expect(numMergedContent, numExpected);
    });
  });
}
