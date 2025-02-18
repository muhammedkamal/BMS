import 'package:bms/helpers/bluetooth_helper.dart';
import 'package:bms/providers/auth.dart';
import 'package:bms/providers/cells.dart';
import 'package:bms/widgets/cell_history_tile.dart';
import 'package:bms/widgets/cell_meters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CellDetailsScreen extends StatefulWidget {
  static const routeName = "/cellDetails";
  @override
  _CellDetailsScreenState createState() => _CellDetailsScreenState();
}

class _CellDetailsScreenState extends State<CellDetailsScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final int cellIndex = ModalRoute.of(context).settings.arguments as int;
    Provider.of<BTHelper>(context);
    var providerData = Provider.of<Cells>(context);
    Cell cellData = providerData.getCellCurrentData(cellIndex);
    bool isAuth = Provider.of<Auth>(context).isAuth();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cell ${cellData.id.toInt()}'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await providerData.getHistoryData();
          //await Provider.of<BTHelper>(context, listen: false).getData();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              if (!isAuth)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Current Data',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(cellData.sOC.toString()),
                      ),
                      title: Text(
                          '${DateFormat("yy/MM/dd - HH:mm").format(DateTime.now()).toString()}'),
                      trailing: IconButton(
                        icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                      ),
                    ),
                    if (_expanded)
                      CellMeters(
                        current: cellData.current,
                        temp: cellData.temp.toDouble(),
                        volt: cellData.volt,
                      ),
                    Divider(),
                  ],
                ),
              //if (isAuth)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Historical Data',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Divider(),
                  Container(
                    height: 500,
                    child: Builder(builder: (ctx) {
                      return ListView.builder(
                        itemCount:
                            providerData.getCellHistoryData(cellIndex).length,
                        itemBuilder: (ctx, i) => CellHistoryTile(
                          dateTime: providerData
                              .getCellHistoryData(cellIndex)[providerData
                                      .getCellHistoryData(cellIndex)
                                      .length -
                                  i -
                                  1]
                              .dateTime,
                          temp: providerData
                              .getCellHistoryData(cellIndex)[providerData
                                      .getCellHistoryData(cellIndex)
                                      .length -
                                  i -
                                  1]
                              .temp
                              .toString(),
                          current: providerData
                              .getCellHistoryData(cellIndex)[providerData
                                      .getCellHistoryData(cellIndex)
                                      .length -
                                  i -
                                  1]
                              .current
                              .toString(),
                          volt: providerData
                              .getCellHistoryData(cellIndex)[providerData
                                      .getCellHistoryData(cellIndex)
                                      .length -
                                  i -
                                  1]
                              .volt
                              .toString(),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
