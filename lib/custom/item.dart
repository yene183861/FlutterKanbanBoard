import 'package:boardview/models/dragged_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Provider/provider_list.dart';

class Item extends ConsumerStatefulWidget {
  const Item(
      {super.key,
      required this.itemIndex,
      this.color = Colors.pink,
      required this.listIndex,
      required this.widget});
  final int itemIndex;
  final int listIndex;
  final Widget widget;
  final Color color;
  @override
  ConsumerState<Item> createState() => _ItemState();
}

class _ItemState extends ConsumerState<Item>
    with AutomaticKeepAliveClientMixin {
  Offset location = Offset.zero;
  bool newAdded = false;

  @override
  Widget build(BuildContext context) {
    // if (location == null) {
    var prov = ref.read(ProviderList.reorderProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      prov.board.lists[widget.listIndex].items[widget.itemIndex].context =
          context;
      var box = context.findRenderObject() as RenderBox;
      location = box.localToGlobal(Offset.zero);
      prov.board.lists[widget.listIndex].items[widget.itemIndex].x =
          location.dx;
      prov.board.lists[widget.listIndex].items[widget.itemIndex].y =
          location.dy;
      prov.board.lists[widget.listIndex].items[widget.itemIndex].width =
          box.size.width;
      prov.board.lists[widget.listIndex].items[widget.itemIndex].height =
          box.size.height;
    });
    return GestureDetector(
        onLongPress: () {
          var box = context.findRenderObject() as RenderBox;
          location = box.localToGlobal(Offset.zero);
          prov.updateValue(dx: location.dx, dy: location.dy - 24);
          prov.board.dragItemIndex = widget.itemIndex;
          prov.board.dragItemOfListIndex = widget.listIndex;
          prov.board.isElementDragged = true;

          prov.draggedItemState = DraggedItemState(
              child: Container(
                width: 200,
                // key: ValueKey("xlwq${prov.itemIndex! + 1}"),
                color: Colors.green,
                height: 40,
                margin: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "ITEM ${prov.board.dragItemIndex! + 1}",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              listIndex: widget.listIndex,
              itemIndex: widget.itemIndex,
              height: box.size.height,
              width: box.size.width,
              x: location.dx,
              y: location.dy);
          prov.draggedItemState!.setState =
              prov.board.lists[widget.listIndex].setState;
          // prov.notifyListeners();
        },
        child: AnimatedSwitcher(
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          //  layoutBuilder: (currentChild, previousChildren) => currentChild!,
          duration: const Duration(milliseconds: 300),
          child: prov.board.isElementDragged &&
                  prov.board.dragItemOfListIndex ==
                      prov.board.lists[widget.listIndex].items[widget.itemIndex]
                          .listIndex &&
                  prov.board.dragItemIndex == widget.itemIndex
              ? Container(
                  key: UniqueKey(),
                  width: 250,
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  height: 40,
                  alignment: Alignment.center,
                  color: Colors.green,
                  child: widget.widget)
              : Container(
                  alignment: Alignment.center,
                  color: prov.board.lists[widget.listIndex].items[widget.itemIndex].backgroundColor??
                              widget.color,
                  height: 40,
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  width: 250,
                  child: widget.widget),
        )

        //  widget.index == prov.itemIndex
        //     ? const Opacity(opacity: 1)
        //   :
        );
  }

  @override
  bool get wantKeepAlive => true;
}
