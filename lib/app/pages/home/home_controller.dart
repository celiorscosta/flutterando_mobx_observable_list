import 'package:flutterando_mobx_observable_list/app/models/item_model.dart';
import 'package:mobx/mobx.dart';
import 'package:rxdart/rxdart.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final listItems = BehaviorSubject<List<ItemModel>>.seeded([]);
  final filter = BehaviorSubject<String>.seeded('');

  ObservableStream<List<ItemModel>> output;
  _HomeControllerBase() {
    output = Rx.combineLatest2<List<ItemModel>, String, List<ItemModel>>(
        listItems.stream, filter.stream, (list, filter) {
      if (filter.isEmpty) {
        return list;
      } else {
        return list
            .where((element) =>
                element.title.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      }
    }).asObservable(initialValue: []);
  }

  @action
  addItem(ItemModel itemModel) {
    listItems.add(List<ItemModel>.from(listItems.value)..add(itemModel));
  }

  @action
  removeItem(ItemModel itemModel) {
    var list = List<ItemModel>.from(listItems.value);
    list.removeWhere((item) => item.title == itemModel.title);
    listItems.add(list);
  }

  @computed
  int get totalChecked => output.value.where((item) => item.check).length;

  @action
  setFilter(String value) => filter.add(value);
}

// // Sem RXDART
// abstract class _HomeControllerBase with Store {
//   @observable
//   ObservableList<ItemModel> listItems = [
//     ItemModel(title: 'Item 1', check: true),
//     ItemModel(title: 'Item 2', check: true),
//     ItemModel(title: 'Item 3', check: true),
//     ItemModel(title: 'Item 4', check: false),
//     ItemModel(title: 'Item 5', check: false),
//   ].asObservable();

//   @action
//   addItem(ItemModel itemModel) {
//     listItems.add(itemModel);
//   }

//   @computed
//   int get totalChecked => listItems.where((item) => item.check).length;

//   @computed
//   List<ItemModel> get listFiltered {
//     if (filter.isEmpty) {
//       return listItems;
//     } else {
//       return listItems
//           .where((element) =>
//               element.title.toLowerCase().contains(filter.toLowerCase()))
//           .toList();
//     }
//   }

//   @observable
//   String filter = '';

//   @action
//   setFilter(String value) => filter = value;

//   @action
//   removeItem(ItemModel itemModel) {
//     listItems.removeWhere((element) => element.title == itemModel.title);
//   }
// }
