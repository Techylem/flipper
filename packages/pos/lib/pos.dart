library pos;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos/payable/payable_view.dart';
import 'pos_viewmodel.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({Key key, this.model}) : super(key: key);
  final PosViewModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).copyWith(canvasColor: Colors.white).canvasColor,
      body: SafeArea(
        child: Column(
          children: [
            Display(
              model: model,
            ),
            Keyboard(model: model)
          ],
        ),
      ),
    );
  }
}

class Display extends StatelessWidget {
  Display({Key key, this.model}) : super(key: key);
  final PosViewModel model;
  TextEditingController etAmount;
  String userAmt = "";

  @override
  Widget build(BuildContext context) {
    etAmount = TextEditingController(text: userAmt);
    print("dddddddddddddd" + model.expression);
    final views = <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: PayableView(model: model),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                'Add a note',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFeatures: [
                    FontFeature.enable('sups'),
                  ],
                  fontSize: 15.0,
                  color: const Color(0xffc2c7cc),
                ),
              ),
            ),
            Expanded(
              child: callText(model),
              // child:TextField(
              //   controller: etAmount,
              //   onChanged: (value) => userAmt = value,
              //   decoration: new InputDecoration(
              //       border: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //       contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              //       hintText:'FRw0.00'
              //   ),
              //   style: const TextStyle(
              //     fontFeatures: [
              //       FontFeature.enable('sups'),
              //     ],
              //     fontSize: 28.0,
              //     color: const Color(0xffc2c7cc),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    ];

    return Container(
      // width: double.infinity,
      color: Theme.of(context)
          .copyWith(canvasColor: Colors.white)
          .canvasColor, //this can be set to a visible color, when designing
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: views,
      ),
    );
  }

  callText(PosViewModel model) {
    if (model.expression == "0.0" || model.expression == "") {
     return Text(
        'FRw0.0',
        textAlign: TextAlign.right,
        //  maxLines: 2,
        softWrap: true,
        style: const TextStyle(
          fontFeatures: [
            FontFeature.enable('sups'),
          ],
          fontSize: 28.0,
          color: const Color(0xffc2c7cc),
        ),
      );
    } else {
     return Text(
        'FRw' + model.expression,
        textAlign: TextAlign.right,
        //  maxLines: 2,
        softWrap: true,
        style: const TextStyle(
          fontFeatures: [
            FontFeature.enable('sups'),
          ],
          fontSize: 28.0,
          color: const Color(0xff3d454c),
        ),
      );
    }
  }
}

class Keyboard extends StatelessWidget {
  Keyboard({Key key, this.model}) : super(key: key);
  final PosViewModel model;
  var myDynamicAspectRatio = 1000 / 1;
  OverlayEntry sticky;
  List<PosViewModel> myGridList = new List();
  double maxHeight = 0;
  double maxWidth = 0;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.3;
    final double height = (MediaQuery.of(context).size.height - 168) * 0.3;
    print(MediaQuery.of(context).size.height);
    return GridView.count(
      primary: true,
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      childAspectRatio: height / width,
      physics: const NeverScrollableScrollPhysics(),
      children: <String>[
        // @formatter:off
        '1', '2', '3',
        '4', '5', '6',
        '7', '8', '9',
        'C', '0', '+',
        // @formatter:on
      ].map((key) {
        return GridTile(
          child: KeyboardKey(key, model),
        );
      }).toList(),
    );
  }
}

// class Keyboard extends StatelessWidget {
//   Keyboard({Key key, this.model}) : super(key: key);
//   final PosViewModel model;
//   var myDynamicAspectRatio = 1000 / 1;
//   OverlayEntry sticky;
//   List<PosViewModel> myGridList = new List();
//   double maxHeight = 0;
//   double maxWidth = 0;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     maxHeight = MediaQuery.of(context).size.height;
//     maxWidth = MediaQuery.of(context).size.width;
//     var myDynamicAspectRatio =  maxWidth / maxHeight;
//     // if(sticky != null) {
//     //   sticky.remove();
//     // }
//     // sticky = OverlayEntry(
//     //   builder: (context) => stickyBuilder(context),
//     // );
//     return GridView.count(
//       crossAxisCount: 3,
//       //childAspectRatio: 1.0,
//       childAspectRatio: myDynamicAspectRatio,
//       shrinkWrap: true,
//       //padding: const EdgeInsets.all(2.0),
//       physics: NeverScrollableScrollPhysics(),
//       // crossAxisSpacing: 4.0,
//       // padding: const EdgeInsets.all(2.0),
//       // crossAxisSpacing: 1.0,
//       children: <String>[
//         // @formatter:off
//         '1', '2', '3',
//         '4', '5', '6',
//         '7', '8', '9',
//         'C', '0', '+',
//         // @formatter:on
//       ].map((key) {
//         return GridTile(
//           child: KeyboardKey(key, model),
//         );
//       }).toList(),
//     );
//
//     // return Expanded(
//     //     child: Column(children: <Widget>[
//     //   Container(
//     //     margin: EdgeInsets.all(10),
//     //     child: Table(
//     //       border: TableBorder.all(),
//     //       children: [
//     //         TableRow(children: [
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('1')},
//     //               child:Container(
//     //                   child: Text('1'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('2')},
//     //               child:Container(
//     //                   child: Text('2'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('3')},
//     //               child:Container(
//     //                   child: Text('3'))),]),
//     //         ]),
//     //         TableRow(children: [
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('4')},
//     //               child:Container(
//     //                   child: Text('4'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('5')},
//     //               child:Container(
//     //                   child: Text('5'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('6')},
//     //               child:Container(
//     //                   child: Text('6'))),]),
//     //         ]),
//     //         TableRow(children: [
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('7')},
//     //               child:Container(
//     //                   child: Text('7'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('8')},
//     //               child:Container(
//     //                   child: Text('8'))),]),
//     //           Column(children: [  GestureDetector(
//     //               onTap: () => {model.addKey('9')},
//     //               child:Container(
//     //                   child: Text('9'))),]),
//     //         ]),
//     //         TableRow(children: [
//     //           Column(children: [
//     //             GestureDetector(
//     //                 onTap: () => {model.addKey('C')},
//     //                 child:Container(
//     //                     child: Text('C'))),
//     //           ]),
//     //           Column(children: [
//     //             GestureDetector(
//     //                 onTap: () => {model.addKey('0')},
//     //                 child:Container(
//     //                     child: Text('0'))),
//     //           ]),
//     //           Column(children: [
//     //             GestureDetector(
//     //                 onTap: () => {model.addKey('+')},
//     //                 child:Container(
//     //                 child: Text('+'))),
//     //           ]),
//     //         ]),
//     //       ],
//     //     ),
//     //   ),
//     // ]));
//   }
//
//   // shouldUpdateGridList() {
//   //   bool isChanged = false;
//   //   for (PosViewModel gi in myGridList) {
//   //     gi
//   //     if (gi.width != null) {
//   //       if (gi.height > maxHeight) {
//   //         maxHeight = gi.height;
//   //         maxWidth = gi.width;
//   //         isChanged = true;
//   //       }
//   //     }
//   //   }
//   //   if (isChanged) {
//   //     myDynamicAspectRatio = maxWidth / maxHeight;
//   //     print("AspectRatio" + myDynamicAspectRatio.toString());
//   //   }
//   // }
//   //
//   // Widget stickyBuilder(BuildContext context) {
//   //   for(PosViewModel gi in myGridList) {
//   //     if(gi.width == null) {
//   //       final keyContext = gi.itemKey.currentContext;
//   //       if (keyContext != null) {
//   //         final box = keyContext.findRenderObject() as RenderBox;
//   //         print(box.size.height);
//   //         print(box.size.width);
//   //         gi.width = box.size.width;
//   //         gi.height = box.size.height;
//   //       }
//   //     }
//   //   }
//   //   shouldUpdateGridList();
//   //   return Container();
//   // }
//   //
//
// }

class KeyboardKey extends StatelessWidget {
  const KeyboardKey(this._keyValue, this.model);

  final PosViewModel model;
  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      onTap: () => {model.addKey(_keyValue)},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            width: 0.0,
          ),
        ),
        child: Center(
          child: Text(
            _keyValue,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontSize: 40, fontWeight: FontWeight.normal),
          ),
        ),
      ),
      //  ),
    );
  }
}