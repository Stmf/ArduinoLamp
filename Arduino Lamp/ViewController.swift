//
//  Created by Stmf on 19/08/2020.
//  Copyright © 2020 Stmf. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var IPADDR: UITextField!
    @IBOutlet weak var PORT: UITextField!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBAction func settingsBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowSettings", sender: self)
        
    }
    
    @IBAction func alarmBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowAlarm", sender: self)
        
    }
    
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBAction func checkButton(_ sender: Any) {
        
        if(IPADDR.text != "" && PORT.text != "") {
            if(isValidIP(s: IPADDR.text!) && isValidPORT(s: PORT.text!)) {
                UserDefaults.standard.set(IPADDR.text, forKey: "hostUDP")
                UserDefaults.standard.set(PORT.text, forKey: "portUDP")
                
                if((UserDefaults.standard.string(forKey: "hostUDP")) != nil) {
                    hostUDP = NWEndpoint.Host(UserDefaults.standard.string(forKey: "hostUDP") ?? "192.168.42.66")
                }
                
                if((UserDefaults.standard.string(forKey: "portUDP")) != nil) {
                    let amount:String? = UserDefaults.standard.string(forKey: "portUDP")
                    if let amountValue = amount, amountValue.count > 0 {
                        portUDP = NWEndpoint.Port(rawValue: UInt16(Int(amountValue)!)) ?? 8888
                    }
                }
                
                self.ConnectUDP(hostUDP,portUDP,Action: "DEB", messageToUDP: "DEB")
            } else {
                self.statusLbl.text = "Данные не корректны"
                self.statusLbl.textColor = UIColor(hexString: "#ff053f")
                self.buttonView.isHidden = true
            }
        }
        
    }
    
    
    var connection: NWConnection?
    
    var hostUDP: NWEndpoint.Host = "192.168.42.66"
    var portUDP: NWEndpoint.Port = 8888
    
    var isConnected = false
    var CheckConnect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        
        IPADDR.delegate = self
        PORT.delegate = self
        
        if((UserDefaults.standard.string(forKey: "hostUDP")) != nil) {
            IPADDR.text = UserDefaults.standard.string(forKey: "hostUDP")
        }
        
        if((UserDefaults.standard.string(forKey: "portUDP")) != nil) {
            PORT.text = UserDefaults.standard.string(forKey: "portUDP")
        }
        
        //Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
        //    if(self.isConnected) {
        //        self.checkConnect()
        //    }
        //}
        
        
    }
    
    func receiveHandler(Action: String, String: String) {
        if(Action == "DEB") {
            let receiveArr = String.components(separatedBy: " ")
            
            if(receiveArr[0] == "OK") {
                DispatchQueue.main.async {
                    self.isConnected = true
                    self.statusLbl.text = "Связь установлена"
                    self.statusLbl.textColor = UIColor(hexString: "#00e600")
                    self.buttonView.isHidden = false
                    self.CheckConnect = false
                }
                
            }
            
            if(String == "ERROR") {
                DispatchQueue.main.async {
                    self.isConnected = false
                    self.statusLbl.text = "Не удалось подключиться"
                    self.statusLbl.textColor = UIColor(hexString: "#ff9900")
                    self.buttonView.isHidden = true
                    
                }
            }
            
        }
    }
    
    func checkConnect() {
        
        if((UserDefaults.standard.string(forKey: "hostUDP")) != nil) {
            hostUDP = NWEndpoint.Host(UserDefaults.standard.string(forKey: "hostUDP") ?? "192.168.42.66")
        }
        
        if((UserDefaults.standard.string(forKey: "portUDP")) != nil) {
            let amount:String? = UserDefaults.standard.string(forKey: "portUDP")
            if let amountValue = amount, amountValue.count > 0 {
                portUDP = NWEndpoint.Port(rawValue: UInt16(Int(amountValue)!)) ?? 8888
            }
        }
        
        
        if(hostUDP != "") {
            self.ConnectUDP(hostUDP,portUDP,Action: "DEB", messageToUDP: "DEB")
        }
    }
    
    func ConnectUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port, Action: String, messageToUDP: String) {
        // Transmited message:
        
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        
        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
            case .ready:
                print("State: Ready\n")
                self.sendUDP(messageToUDP)
                self.receiveConnectUDP(Action: Action)
            case .setup:
                print("State: Setup\n")
            case .cancelled:
                print("State: Cancelled\n")
            case .preparing:
                print("State: Preparing\n")
            default:
                print("ERROR! State not defined!\n")
            }
        }
        
        self.connection?.start(queue: .global())
    }
    
    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    
    func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    
    func receiveConnectUDP(Action: String) {
        
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                    
                    if(Action == "DEB" && backToString != "") {
                        self.receiveHandler(Action: "DEB", String: backToString)
                        self.CheckConnect = true
                    }
                    
                    self.connection?.cancel()
                    
                } else {
                    print("Data == nil")
                }
            }
            
        };
        
        if(!CheckConnect) {
            if(Action == "DEB") {
                self.receiveHandler(Action: "DEB", String: "ERROR")
            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //For mobile numer validation
        if textField == IPADDR {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        if textField == PORT {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func isValidIP(s: String) -> Bool {
        let parts = s.components(separatedBy: ".")
        let nums = parts.compactMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256}.count == 4
    }
    
    func isValidPORT(s: String) -> Bool {
        
        let port = Int(s)
        
        if(port! >= 1 && port! <= 65535) {
            return true
        } else {
            return false
        }
    }
    
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
