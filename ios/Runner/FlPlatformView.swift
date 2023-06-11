import UIKit
import Flutter

class FlPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FlPlatformView(
            frame: frame,
            viewIndentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }
}

class FlPlatformView: NSObject, FlutterPlatformView, FlutterStreamHandler {
    private var _view: UIView
    private var _eventSink: FlutterEventSink!
    
    init(
        frame: CGRect,
        viewIndentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        _view = UIView()
        super.init()
        createNativeView(view: _view, binaryMessenger: messenger)
    }
    
    func view() -> UIView {
        return _view
    }
    
    @objc
    func onClick(sender: UIButton!) {
        self._eventSink(Int.random(in: 1..<500))
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }
    
    func createNativeView(view _view: UIView, binaryMessenger messenger: FlutterBinaryMessenger) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 100, y: 100)
        label.textAlignment = .center
        label.text = "I'm a test label"
        _view.addSubview(label)
        
        let channel = FlutterMethodChannel(name: "CALL_METHOD", binaryMessenger: messenger)
        let eventChannel = FlutterEventChannel(name: "CALL_EVENTS", binaryMessenger: messenger)
        
        eventChannel.setStreamHandler(self)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "sendText" else {
                result(FlutterMethodNotImplemented)
                return
            }
            guard let args = call.arguments as? [String : Any] else {return}
            let labelText = args["text"] as! String
            label.text = labelText
            result(Int.random(in: 1..<500))
        })
    }
}
