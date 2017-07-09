//
//  SerialViewController.swift
//  HM10 Serial
//
//  Created by Alex on 10-08-15.
//  Copyright (c) 2015 Balancing Rock. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore




/// The option to add a \n or \r or \r\n to the end of the send message
enum MessageOption: Int {
    case noLineEnding,
         newline,
         carriageReturn,
         carriageReturnAndNewline
}

/// The option to add a \n to the end of the received message (to make it more readable)
enum ReceivedMessageOption: Int {
    case none,
         newline
}

final class SerialViewController: UIViewController, UITextFieldDelegate, BluetoothSerialDelegate {

//MARK: IBOutlets
    
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint! // used to move the textField up when the keyboard is present
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!

    @IBOutlet var logTextfield: UITextField!

    @IBOutlet var logSwitch: UISwitch!
    
    @IBOutlet var top: UIButton!
    @IBOutlet var left: UIButton!
    @IBOutlet var right: UIButton!
    @IBOutlet var down: UIButton!
    
    @IBOutlet var B: UIButton!
    @IBOutlet var A: UIButton!
    @IBOutlet var X: UIButton!
    @IBOutlet var Y: UIButton!
    @IBOutlet weak var grab: UIButton!
    
    @IBOutlet weak var rel: UIButton!
    @IBOutlet var ModeSwitch: UISwitch!

    @IBOutlet weak var leftslider: UISlider!{
        didSet{
            leftslider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        }
    }

    @IBOutlet weak var rightslider: UISlider!{
        didSet{
            rightslider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
        }
    }

    
    func initborder(button: UIButton)
    {
        
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1

        let rgbValue = 0x007AFF
        let r = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let g = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let b = CGFloat((rgbValue & 0xFF))/255.0
        button.layer.borderColor = UIColor(red:r, green: g, blue: b, alpha: 1.0).cgColor

    }
    
    func disableButton(button: UIButton)
    {

        button.layer.borderWidth = 0
        button.isEnabled = false
        button.tintColor = UIColor.clear
       
    }
    
    func enableButton(button: UIButton)
    {
        
        
        button.layer.borderWidth = 1
        button.isEnabled = true
        button.tintColor = nil
        
        
    }
    
    
    
    func buttoninit()
    {
        top.tag = 0
        left.tag = 1
        down.tag = 2
        right.tag = 3
        B.tag = 4
        grab.tag = 4
        A.tag = 5
        X.tag = 6
        Y.tag = 7
        rel.tag = 7
    
        initborder(button: top)
        initborder(button: left)
        initborder(button: down)
        initborder(button: right)
        initborder(button: B)
        initborder(button: A)
        initborder(button: X)
        initborder(button: Y)
        initborder(button: grab)
        initborder(button: rel)

    }
    

    
    func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            logTextfield.text = "Log is On"
        } else {
            logTextfield.text = "Log is Off"
        }
    }

  
    
    func buttonClicked(button: UIButton) {
        
        
        var msg = ""
        let pref = UserDefaults.standard.integer(forKey: MessageOptionKey)
        
        switch(button.tag)
        {
            case 0:
                print("top sending")
                msg = upOptionKey
            break
        
            case 1:
                print("left sending")
                msg = leftOptionKey
            break
        
            case 2:
                print("down sending")
                msg = downOptionKey
            break
        
            case 3:
                print("right sending")
                msg = rightOptionKey
            break
            
        case 4:
            print("B sending")
            msg = grabOptionKey
            break
            
        case 5:
            print("A sending")
            msg = rlOptionKey
            break
            
        case 6:
            print("X sending")
            msg = rrOptionKey
            break
            
        case 7:
            print("Y sending")
            msg = releaseOptionKey
            break
            
        default:
            break
        }
        

        switch pref {
        case MessageOption.newline.rawValue:
            msg += "\n"
        case MessageOption.carriageReturn.rawValue:
            msg += "\r"
        case MessageOption.carriageReturnAndNewline.rawValue:
            msg += "\r\n"
        default:
            msg += ""
        }
        
               serial.sendMessageToDevice(msg)
        
        
    }
    
    func buttonR()
    {
        var msg = stopOptionKey
        let pref = UserDefaults.standard.integer(forKey: MessageOptionKey)
        print("stop sending")
        switch pref {
        case MessageOption.newline.rawValue:
            msg += "\n"
        case MessageOption.carriageReturn.rawValue:
            msg += "\r"
        case MessageOption.carriageReturnAndNewline.rawValue:
            msg += "\r\n"
        default:
            msg += ""
        }
          serial.sendMessageToDevice(msg)
    
    }
    
    func slidersendL(slider: UISlider)
    {
        print(slider.value)
        var msg = stopOptionKey
        
        if slider.value > 0.8 {
            slider.tintColor = UIColor.red
            msg = l5
            
        }else if slider.value > 0.6 {
            slider.tintColor = UIColor.orange
            msg = l4
        }else if slider.value > 0.4 {
            slider.tintColor = UIColor.yellow
            msg = l3
        }
        else if slider.value > 0.2 {
            slider.tintColor = UIColor.green
            msg = l2
        }
        else if slider.value < 0.21 {
            slider.tintColor = UIColor.blue
            msg = l1
        }

        let pref = UserDefaults.standard.integer(forKey: MessageOptionKey)
        switch pref {
        case MessageOption.newline.rawValue:
            msg += "\n"
        case MessageOption.carriageReturn.rawValue:
            msg += "\r"
        case MessageOption.carriageReturnAndNewline.rawValue:
            msg += "\r\n"
        default:
            msg += ""
        }
        serial.sendMessageToDevice(msg)
        
    }
    
    func slidersendR(slider: UISlider)
    {
        print(slider.value)
        var msg = stopOptionKey
        
        if slider.value > 0.8 {
            slider.tintColor = UIColor.red
            msg = r5
        }else if slider.value > 0.6 {
            slider.tintColor = UIColor.orange
            msg = r4
        }else if slider.value > 0.4 {
            slider.tintColor = UIColor.yellow
            msg = r3
        }
        else if slider.value > 0.2 {
            slider.tintColor = UIColor.green
            msg = r2
        }
        else if slider.value < 0.21 {
            slider.tintColor = UIColor.blue
            msg = r1
        }
        
        let pref = UserDefaults.standard.integer(forKey: MessageOptionKey)
        switch pref {
        case MessageOption.newline.rawValue:
            msg += "\n"
        case MessageOption.carriageReturn.rawValue:
            msg += "\r"
        case MessageOption.carriageReturnAndNewline.rawValue:
            msg += "\r\n"
        default:
            msg += ""
        }
        serial.sendMessageToDevice(msg)
        
    }
    
    
    func switchValueDidChange(sender:UISwitch!)
    {
        if (sender.isOn == true){
            print("on")
            enableButton(button: top)
            enableButton(button: down)
            enableButton(button: left)
            enableButton(button: right)
            enableButton(button: A)
            enableButton(button: B)
            enableButton(button: X)
            enableButton(button: Y)
            disableButton(button: grab)
            disableButton(button: rel)
            leftslider.isEnabled = false
            leftslider.isHidden = true
            
            rightslider.isEnabled = false
            rightslider.isHidden = true

        }
        else{
            print("off")
            disableButton(button: top)
            disableButton(button: down)
            disableButton(button: left)
            disableButton(button: right)
            disableButton(button: A)
            disableButton(button: B)
            disableButton(button: X)
            disableButton(button: Y)
            enableButton(button: grab)
            enableButton(button: rel)
            leftslider.isEnabled = true
            leftslider.isHidden = false
            
            rightslider.isEnabled = true
            rightslider.isHidden = false
        }
    }

    
    

//MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        leftslider.isEnabled = false
        leftslider.isHidden = true
        leftslider.addTarget(self, action:#selector(self.slidersendL), for: .allTouchEvents)
        
        rightslider.isEnabled = false
        rightslider.isHidden = true
        rightslider.addTarget(self, action:#selector(self.slidersendR), for: .allTouchEvents)
        
        buttoninit()
        
        disableButton(button: grab)
        disableButton(button: rel)
        
        
        top.addTarget(self, action:#selector(self.buttonR), for: .touchUpInside)
        
        left.addTarget(self, action:#selector(self.buttonR), for: .touchUpInside)
        
        right.addTarget(self, action:#selector(self.buttonR), for: .touchUpInside)
        
        down.addTarget(self, action:#selector(self.buttonR), for: .touchUpInside)
        

        
        X.addTarget(self, action:#selector(self.buttonR), for: .touchUpInside)
        
        A.addTarget(self, action:#selector(self.buttonR), for: .touchUpInside)
        
        top.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        left.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        right.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        down.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        B.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        A.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        X.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        Y.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        rel.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        grab.addTarget(self, action:#selector(self.buttonClicked), for: .touchDown)
        
        
        ModeSwitch.addTarget(self, action: #selector(self.switchValueDidChange), for: .valueChanged)
        
        logSwitch.addTarget(self, action: #selector(stateChanged(switchState:)), for: UIControlEvents.valueChanged)
        // init serial
        serial = BluetoothSerial(delegate: self)
        
        // UI
        mainTextView.text = ""
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(SerialViewController.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
        // we want to be notified when the keyboard is shown (so we can move the textField up)
        NotificationCenter.default.addObserver(self, selector: #selector(SerialViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SerialViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // to dismiss the keyboard if the user taps outside the textField while editing
        let tap = UITapGestureRecognizer(target: self, action: #selector(SerialViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // style the bottom UIView
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -1)
        bottomView.layer.shadowRadius = 0
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowColor = UIColor.gray.cgColor
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // animate the text field to stay above the keyboard
        var info = (notification as NSNotification).userInfo!
        let value = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardFrame = value.cgRectValue
        
        //TODO: Not animating properly
//        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
//            self.bottomConstraint.constant = keyboardFrame.size.height
//            }, completion: { Bool -> Void in
//            self.textViewScrollToBottom()
//        })
    }
    
    func keyboardWillHide(_ notification: Notification) {
        // bring the text field back down..
//        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
//            self.bottomConstraint.constant = 0
//        }, completion: nil)

    }
    
    func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        
        if serial.isReady {
            navItem.title = serial.connectedPeripheral!.name! + " Bluetooth Controller"
            barButton.title = "Disconnect"
            barButton.tintColor = UIColor.red
            barButton.isEnabled = true
        } else if serial.centralManager.state == .poweredOn {
            navItem.title = "Bluetooth Controller"
            barButton.title = "Connect"
            barButton.tintColor = view.tintColor
            barButton.isEnabled = true
        } else {
            navItem.title = "Bluetooth Controller"
            barButton.title = "Connect"
            barButton.tintColor = view.tintColor
            barButton.isEnabled = false
        }
    }
    
    func textViewScrollToBottom() {
        let range = NSMakeRange(NSString(string: mainTextView.text).length - 1, 1)
        mainTextView.scrollRangeToVisible(range)
    }
    

//MARK: BluetoothSerialDelegate
    
    func serialDidReceiveString(_ message: String) {
        // add the received text to the textView, optionally with a line break at the end
        if logSwitch.isOn {
                mainTextView.text! += message
        }

        textViewScrollToBottom()
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        dismissKeyboard()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = "Disconnected"
        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            dismissKeyboard()
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.mode = MBProgressHUDMode.text
            hud?.labelText = "Bluetooth turned off"
            hud?.hide(true, afterDelay: 1.0)
        }
    }
    
    
//MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !serial.isReady {
            let alert = UIAlertController(title: "Not connected", message: "What am I supposed to send this to?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: { action -> Void in self.dismiss(animated: true, completion: nil) }))
            present(alert, animated: true, completion: nil)
            messageField.resignFirstResponder()
            return true
        }
        
        // send the message to the bluetooth device
        // but fist, add optionally a line break or carriage return (or both) to the message
        let pref = UserDefaults.standard.integer(forKey: MessageOptionKey)
        var msg = messageField.text!
        switch pref {
        case MessageOption.newline.rawValue:
            msg += "\n"
        case MessageOption.carriageReturn.rawValue:
            msg += "\r"
        case MessageOption.carriageReturnAndNewline.rawValue:
            msg += "\r\n"
        default:
            msg += ""
        }
        
        // send the message and clear the textfield
        serial.sendMessageToDevice(msg)
        messageField.text = ""
        return true
    }
    
    func dismissKeyboard() {
        messageField.resignFirstResponder()
    }
    
    
//MARK: IBActions

    @IBAction func barButtonPressed(_ sender: AnyObject) {
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "ShowScanner", sender: self)
        } else {
            serial.disconnect()
            reloadView()
        }
    }
}
