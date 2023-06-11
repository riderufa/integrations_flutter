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
//        let button = UIButton()
        // button.setTitle("iOs native button", for: .normal)
        // button.addTarget(self, action: #selector(onClick(sender:)), for: .touchUpInside)
        // button.backgroundColor = UIColor.blue
        // button.frame = CGRect(x: 0, y: 0, width: 180, height: 48)
        var correctOrIncorrect: String = "text"
        let text = Text(correctOrIncorrect)
        // _view.addSubview(button)
        _view.addSubview(text)
        
        let channel = FlutterMethodChannel(name: "CALL_METHOD", binaryMessenger: messenger)
        let eventChannel = FlutterEventChannel(name: "CALL_EVENTS", binaryMessenger: messenger)
        
        eventChannel.setStreamHandler(self)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "sendText" else {
                result(FlutterMethodNotImplemented)
                return
            }
//            button.setTitle("button", for: .normal)
//            let text = Text("Hamlet").font(.title)
//            _view.addSubview(text)
            result(Int.random(in: 1..<500))
        })
    }
}
