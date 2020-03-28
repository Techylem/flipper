import 'package:flipper/generated/l10n.dart';
import 'package:flipper/theme.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupplyPrice extends StatefulWidget {
  SupplyPrice({Key key}) : super(key: key);
  @override
  _SupplyPriceState createState() => _SupplyPriceState();
}

class _SupplyPriceState extends State<SupplyPrice> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: GoogleFonts.lato(
            fontStyle: FontStyle.normal,
            color: AppTheme.addProduct.accentColor,
            fontSize: AppTheme.addProduct.textTheme.bodyText1
                .copyWith(fontSize: 12)
                .fontSize,
          ),
          onChanged: (supplyPrice) async {
            if (supplyPrice != '' || supplyPrice == null) {
              setState(() {
                DataManager.supplyPrice = double.parse(supplyPrice);
              });
            } else {
              setState(() {
                DataManager.supplyPrice = 0.0;
              });
            }
          },
          decoration: InputDecoration(
              hintText: S.of(context).supplyPrice, focusColor: Colors.blue),
        ),
      ),
    );
  }
}