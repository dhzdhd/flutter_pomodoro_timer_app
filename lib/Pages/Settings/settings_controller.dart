import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  GetStorage box = GetStorage();

  RxBool blockSite = false.obs;
  RxList<String> sitesToBlock = <String>[].obs;

  RxInt defaultMinutes = 45.obs;

  SettingsController() {
    blockSite.value = box.read("BlockSite") ?? false;
    blockSite.listen((bool val) {
      box.write("BlockSite", val);
    });
  }
}