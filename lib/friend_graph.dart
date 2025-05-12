// import 'package:flutter/material.dart';
// import 'package:flutter_force_directed_graph/flutter_force_directed_graph.dart';
// import 'profile_page.dart';

// class FriendGraphPage extends StatelessWidget {
//   const FriendGraphPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = ForceDirectedGraphController<int>();

//     // ノードとその深さを定義
//     final Map<int, int> nodeDepth = {
//       0: 0,  // 自分
//       1: 1, 2: 1, 3: 1,  // 1次
//       4: 2, 5: 2, 6: 2, 7: 2, 8: 2,  // 2次
//       9: 3, 10: 3, 11: 3, 12: 3, 13: 3, // 3次
//       14: 4, 15: 4, 16: 4 // 4次
//     };

//     // ノード追加
//     for (var id in nodeDepth.keys) {
//       controller.addNode(id);
//     }

//     // エッジ追加
//     controller.addEdgeByData(0, 1);
//     controller.addEdgeByData(0, 2);
//     controller.addEdgeByData(0, 3);

//     controller.addEdgeByData(1, 4);
//     controller.addEdgeByData(1, 5);
//     controller.addEdgeByData(2, 6);
//     controller.addEdgeByData(2, 7);
//     controller.addEdgeByData(3, 8);

//     controller.addEdgeByData(4, 9);
//     controller.addEdgeByData(5, 10);
//     controller.addEdgeByData(6, 11);
//     controller.addEdgeByData(7, 12);
//     controller.addEdgeByData(8, 13);

//     controller.addEdgeByData(9, 14);
//     controller.addEdgeByData(10, 15);
//     controller.addEdgeByData(12, 16);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Connections'),
//         backgroundColor: Colors.black,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (_) => const ProfilePage()),
//               );
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Colors.black,
//       body: ForceDirectedGraphWidget<int>(
//         controller: controller,
//         nodesBuilder: (context, data) {
//           final depth = nodeDepth[data] ?? 4;
//           final isMe = depth == 0;

//           final alpha = (1.0 - depth * 0.15).clamp(0.3, 1.0);
//           final color = isMe
//               ? Colors.indigo
//               : Colors.amber.withValues(alpha: alpha); // ✅ 修正

//           return Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: color,
//               boxShadow: [
//                 const BoxShadow(color: Colors.white24, blurRadius: 3),
//               ],
//             ),
//           );
//         },
//         edgesBuilder: (context, a, b, distance) {
//           final alpha = (1.0 - distance * 0.15).clamp(0.3, 1.0);
//           return Container(
//             width: distance,
//             height: 0.5,
//             color: Colors.grey.withValues(alpha: alpha), // ✅ 修正
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_force_directed_graph/flutter_force_directed_graph.dart';
import 'profile_page.dart';

class FriendGraphPage extends StatelessWidget {
  const FriendGraphPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('グラフ画面が表示されました');
    final controller = ForceDirectedGraphController<int>();

    const int maxDepth = 4;
    const int branchPerNode = 2;

    final Map<int, int> nodeDepth = {}; // nodeId -> depth
    int nodeIdCounter = 0;

    void addNodeRecursively(int parentId, int currentDepth) {
      if (currentDepth > maxDepth) return;

      for (int i = 0; i < branchPerNode; i++) {
        nodeIdCounter++;
        int childId = nodeIdCounter;
        nodeDepth[childId] = currentDepth;
        controller.addNode(childId);
        controller.addEdgeByData(parentId, childId);
        addNodeRecursively(childId, currentDepth + 1);
      }
    }

    // 自分ノード（root）
    controller.addNode(0);
    nodeDepth[0] = 0;

    // 再帰的に追加
    addNodeRecursively(0, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ForceDirectedGraphWidget<int>(
        controller: controller,
        nodesBuilder: (context, data) {
          final depth = nodeDepth[data] ?? maxDepth;
          final isMe = depth == 0;

          final opacity = (1.0 - depth * 0.08).clamp(0.2, 1.0);
          final color = isMe
              ? Colors.indigo
              : Colors.amber.withValues(alpha: opacity); // ⚠️ dart 3.3 の場合は .withValues(alpha: opacity)

          return Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: const [
                BoxShadow(color: Colors.white24, blurRadius: 3),
              ],
            ),
          );
        },
        edgesBuilder: (context, a, b, distance) {
          return Container(
            width: distance,
            height: 0.5,
            color: Colors.grey.withValues(alpha: 0.3), // ⚠️ 同上で .withValues(alpha: 0.3) でもOK
          );
        },
      ),
    );
  }
}