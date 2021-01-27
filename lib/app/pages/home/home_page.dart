import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterando_mobx_observable_list/app/models/item_model.dart';
import 'package:mobx/mobx.dart';

import 'components/item_widget.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  _dialog() {
    var model = ItemModel();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Adicionar item'),
          content: TextField(
            onChanged: model.setTitle,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Novo Item',
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                controller.addItem(model);
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: controller.setFilter,
          decoration: InputDecoration(hintText: 'Pesquisa...'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Observer(
              builder: (_) {
                return Text('${controller.totalChecked}');
              },
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (controller.output.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: controller.output.data.length,
            itemBuilder: (_, index) {
              var item = controller.output.data[index];
              return ItemWidget(
                item: item,
                removeCliecked: () {
                  controller.removeItem(item);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _dialog();
        },
      ),
    );
  }
}
