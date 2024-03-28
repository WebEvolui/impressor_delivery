import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart'
as usb_esc_printer_windows;

class PrintService {
  late final String _printerName;

  PrintService(this._printerName);

  Future<String> print(dynamic pedido) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load(name: 'TM-T88V');
    final generator = Generator(PaperSize.mm80, profile);
    generator.setGlobalCodeTable('CP1252');

    bytes += [27, 97, 1];
    bytes += generator.text('Pedido #${pedido['id']}',
        styles: const PosStyles(bold: true, height: PosTextSize.size2, align: PosAlign.left));

    bytes += [27, 97, 1];
    bytes += generator.text('Cliente : ${pedido['customer']['user']['name']}');
    bytes += generator.text('Email : ${pedido['customer']['user']['email']}');

    bytes += [27, 97, 1];
    bytes += generator.feed(1);

    bytes += generator.row([
      PosColumn(
        text: 'Quant',
        width: 2,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'Item',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'Preço',
        width: 2,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    for (var item in pedido['products']) {
      bytes += generator.row([
        PosColumn(
          text: item['pivot']['quantity'].toString(),
          width: 2,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${item['name']} (${item['description']})',
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: ' ${item['pivot']['subtotal'].toString()}',
          width: 2,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.feed(1);
    bytes += [27, 97, 1];
    bytes += generator.text('Total  R\$ ${pedido['total_price']}',
        styles: PosStyles(align: PosAlign.right));
    bytes += generator.feed(1);

    bytes += [27, 97, 1];
    bytes += generator.text('Data : ${pedido['created_at']}');
    bytes += generator.feed(1);
    bytes += generator.text('*** Obrigado por sua preferência ***',
        styles: const PosStyles(
            bold: true, height: PosTextSize.size2));
    bytes += generator.feed(2);

    bytes += generator.feed(1);
    bytes += generator.cut();

    final res =
    await usb_esc_printer_windows.sendPrintRequest(bytes, _printerName);
    String msg = "";

    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg =
      "Failed to generate a print please make sure to use the correct printer name";
    }

    return msg;
  }
}