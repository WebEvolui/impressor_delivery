import 'dart:async';
import 'dart:convert';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';

import '../helpers/dio.dart';
import '../secrets.dart';
import 'print_service.dart';

class RealTimeService {
  String token;
  String channelName;
  late final dio;
  late PusherChannelsClient client;
  late StreamSubscription<void> connectionSubs;
  late StreamSubscription<ChannelReadEvent> pedidosPrivateChannelEventSubs;

  RealTimeService(this.token, this.channelName) {
    dio = createDio(token);
    connect();
  }

  connect() async {
    PusherChannelsPackageLogger.disableLogs();

    const pusherOptions = PusherChannelsOptions.fromCluster(
      scheme: 'wss',
      cluster: 'us2',
      key: keyPusherOptions,
      port: 443,
    );

    // Create an instance of PusherChannelsClient
    client = PusherChannelsClient.websocket(
      options: pusherOptions,
      // Connection exceptions are handled here
      connectionErrorHandler: (exception, trace, refresh) async {
        // This method allows you to reconnect if any error is occurred.
        refresh();
      },
    );

    PrivateChannel pedidosPrivateChannel = client.privateChannel(
      channelName,
      authorizationDelegate:
      EndpointAuthorizableChannelTokenAuthorizationDelegate
          .forPrivateChannel(
        authorizationEndpoint:
        Uri.parse('${dio.options.baseUrl}/broadcasting/auth'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    pedidosPrivateChannelEventSubs =
        pedidosPrivateChannel.bind('App\\Events\\OrderAdded').listen((event) {
          final data = jsonDecode(event.data);
          String idPedido = data['id'].toString();

          sendPrint(idPedido);
        });

    // Organizing all channels for readibility
    final allChannels = <Channel>[
      pedidosPrivateChannel,
    ];

    connectionSubs = client.onConnectionEstablished.listen((_) {
      for (final channel in allChannels) {
        // Subscribes to the channel if didn't unsubscribe from it intentionally
        channel.subscribeIfNotUnsubscribed();
      }
    });

    // Connect with the client
    unawaited(client.connect());

  }

  void sendPrint(String idPedido) async {
    final pedido = await dio.get('/orders/$idPedido');

    final printService = PrintService("TM T20X");
    final respostaPrint = await printService.print(pedido.data);
    print(respostaPrint);
  }

  disconnect() async {
    connectionSubs.cancel();
    pedidosPrivateChannelEventSubs.cancel();
    await client.disconnect();
  }
}