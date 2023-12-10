import "package:flutter/material.dart";
import "package:path_finder_algorithm/path_finder_painter.dart";
import "package:path_finder_algorithm/path_finders/base_path_finder.dart";
import "dart:math";

import "package:path_finder_algorithm/path_finders/node.dart";

const int size = 40;
const int walls = 400;

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Offset startPosition = Offset(
        Random().nextInt(size).toDouble(), Random().nextInt(size).toDouble());

    final Offset endPosition = Offset(
        Random().nextInt(size).toDouble(), Random().nextInt(size).toDouble());

    final List<List<Node>> nodes =
        _generateNodes(size, walls, startPosition, endPosition);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.blueGrey.shade900,
          body: Center(
              child: GridView.count(crossAxisCount: 3, children: <Widget>[]))),
    );
  }
}

Widget _drawMap(
  List<List<Node>> nodes,
  BasePathFinder pathFinder,
  Offset startPosition,
  Offset endPosition,
) {
  final int startX = startPosition.dx.floor();
  final int startY = startPosition.dy.floor();

  final int endX = endPosition.dx.floor();
  final int endY = endPosition.dy.floor();

  final Node start = nodes[startX][startY];
  final Node end = nodes[endX][endY];

  return Column(
    children: <Widget>[
      const SizedBox(height: 8),
      Text(
        '${pathFinder.name}',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      StreamBuilder<List<List<Node>>>(
        stream: pathFinder(nodes, start, end),
        initialData: nodes,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<List<Node>>> finderSnapshot,
        ) =>
            StreamBuilder<List<Node>>(
          stream: pathFinder.getPath(end),
          initialData: const <Node>[],
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Node>> pathSnapshot,
          ) =>
              CustomPaint(
            size: const Size(400, 400),
            painter: PathFinderPainter(
              finderSnapshot.data!,
              pathSnapshot.data!,
              start,
              end,
            ),
          ),
        ),
      ),
    ],
  );
}

List<List<Node>> _generateNodes(
  int size,
  int walls,
  Offset start,
  Offset end,
) {
  final List<List<Node>> nodes = <List<Node>>[];

  for (int i = 0; i < size; i++) {
    final List<Node> row = <Node>[];

    for (int j = 0; j < size; j++) {
      row.add(Node(Offset(j.toDouble(), i.toDouble())));
    }
    nodes.add(row);
  }

  for (int i = 0; i < walls; i++) {
    final int row = Random().nextInt(size);
    final int column = Random().nextInt(size);

    final int startX = start.dx.floor();
    final int startY = start.dy.floor();

    final int endX = end.dx.floor();
    final int endY = end.dy.floor();

    if (nodes[row][column] == nodes[startY][startX] ||
        nodes[row][column] == nodes[endY][endX]) {
      i--;
      continue;
    }

    nodes[row][column].isWall = true;
  }
  return nodes;
}
