//
//  Created by Stmf on 19/08/2020.
//  Copyright © 2020 Stmf. All rights reserved.
//

import UIKit
import Network

class AlarmViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var connection: NWConnection?
    
    var hostUDP: NWEndpoint.Host = "192.168.42.66"
    var portUDP: NWEndpoint.Port = 8888
    
    var modes = ["Рассвет за 5 минут","Рассвет за 10 минут","Рассвет за 15 минут","Рассвет за 20 минут","Рассвет за 25 минут","Рассвет за 30 минут","Рассвет за 40 минут","Рассвет за 50 минут","Рассвет за 60 минут"]
    
    @IBOutlet weak var modeDAWN: UIPickerView!
    
    
    @IBOutlet weak var TP1: UITextField!
    @IBOutlet weak var TP2: UITextField!
    @IBOutlet weak var TP3: UITextField!
    @IBOutlet weak var TP4: UITextField!
    @IBOutlet weak var TP5: UITextField!
    @IBOutlet weak var TP6: UITextField!
    @IBOutlet weak var TP7: UITextField!
    
    @IBOutlet weak var SW1: UISwitch!
    @IBOutlet weak var SW2: UISwitch!
    @IBOutlet weak var SW3: UISwitch!
    @IBOutlet weak var SW4: UISwitch!
    @IBOutlet weak var SW5: UISwitch!
    @IBOutlet weak var SW6: UISwitch!
    @IBOutlet weak var SW7: UISwitch!
    
    @IBAction func SW1act(_ sender: Any) {
        if(SW1.isOn) {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET1 ON")
        } else {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET1 OFF")
        }
    }
    @IBAction func SW2act(_ sender: Any) {
        if(SW2.isOn) {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET2 ON")
        } else {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET2 OFF")
        }
    }
    @IBAction func SW3act(_ sender: Any) {
        if(SW3.isOn) {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET3 ON")
        } else {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET3 OFF")
        }
    }
    @IBAction func SW4act(_ sender: Any) {
        if(SW4.isOn) {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET4 ON")
        } else {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET4 OFF")
        }
    }
    @IBAction func SW5act(_ sender: Any) {
        if(SW5.isOn) {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET5 ON")
        } else {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET5 OFF")
        }
    }
    @IBAction func SW6act(_ sender: Any) {
        if(SW6.isOn) {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET6 ON")
        } else {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET6 OFF")
        }
    }
    @IBAction func SW7act(_ sender: Any) {
        if(SW7.isOn) {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET7 ON")
        } else {
            ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET7 OFF")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func datePickerChanged1(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TP1.text = formatter.string(from: sender.date)
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET1 "+String(timeToNum(time: formatter.string(from: sender.date))))
    }
    
    @objc func datePickerChanged2(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TP2.text = formatter.string(from: sender.date)
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET2 "+String(timeToNum(time: formatter.string(from: sender.date))))
    }
    
    @objc func datePickerChanged3(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TP3.text = formatter.string(from: sender.date)
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET3 "+String(timeToNum(time: formatter.string(from: sender.date))))
    }
    
    @objc func datePickerChanged4(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TP4.text = formatter.string(from: sender.date)
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET4 "+String(timeToNum(time: formatter.string(from: sender.date))))
    }
    
    @objc func datePickerChanged5(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TP5.text = formatter.string(from: sender.date)
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET5 "+String(timeToNum(time: formatter.string(from: sender.date))))
    }
    
    @objc func datePickerChanged6(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TP6.text = formatter.string(from: sender.date)
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET6 "+String(timeToNum(time: formatter.string(from: sender.date))))
    }
    
    @objc func datePickerChanged7(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        TP7.text = formatter.string(from: sender.date)
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_SET", messageToUDP: "ALM_SET7 "+String(timeToNum(time: formatter.string(from: sender.date))))
    }
    
    func getTime(time:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let ouptputTime = dateFormatter.date(from: time)!
        return ouptputTime
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        textField.inputView = datePicker
        datePicker.datePickerMode = UIDatePicker.Mode.time
        
        if(textField == self.TP1) {
            datePicker.addTarget(self, action: #selector(datePickerChanged1(sender:)), for: .valueChanged)
            datePicker.date = getTime(time: TP1.text ?? "00:00")
        }
    
        if(textField == self.TP2) {
            datePicker.addTarget(self, action: #selector(datePickerChanged2(sender:)), for: .valueChanged)
            datePicker.date = getTime(time: TP2.text ?? "00:00")
        }
        
        if(textField == self.TP3) {
            datePicker.addTarget(self, action: #selector(datePickerChanged3(sender:)), for: .valueChanged)
            datePicker.date = getTime(time: TP3.text ?? "00:00")
        }
        
        if(textField == self.TP4) {
            datePicker.addTarget(self, action: #selector(datePickerChanged4(sender:)), for: .valueChanged)
            datePicker.date = getTime(time: TP4.text ?? "00:00")
        }
        
        if(textField == self.TP5) {
            datePicker.addTarget(self, action: #selector(datePickerChanged5(sender:)), for: .valueChanged)
            datePicker.date = getTime(time: TP5.text ?? "00:00")
        }
        
        if(textField == self.TP6) {
            datePicker.addTarget(self, action: #selector(datePickerChanged6(sender:)), for: .valueChanged)
            datePicker.date = getTime(time: TP6.text ?? "00:00")
        }
        
        if(textField == self.TP7) {
            datePicker.addTarget(self, action: #selector(datePickerChanged7(sender:)), for: .valueChanged)
            datePicker.date = getTime(time: TP7.text ?? "00:00")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TP1.resignFirstResponder()
        TP2.resignFirstResponder()
        TP3.resignFirstResponder()
        TP4.resignFirstResponder()
        TP5.resignFirstResponder()
        TP6.resignFirstResponder()
        TP7.resignFirstResponder()
        return true
    }
    
    // MARK: Helper Methods
    func closekeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        closekeyboard()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(modes[row])
        //print(row)
        self.ConnectUDP(hostUDP,portUDP,Action: "DAWN", messageToUDP: "DAWN"+String(row+1))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modeDAWN.delegate = self
        modeDAWN.dataSource = self
        
        modeDAWN.setValue(UIColor.black, forKeyPath: "textColor")
        
        if((UserDefaults.standard.string(forKey: "hostUDP")) != nil) {
            hostUDP = NWEndpoint.Host(UserDefaults.standard.string(forKey: "hostUDP") ?? "192.168.42.66")
        }
        
        if((UserDefaults.standard.string(forKey: "portUDP")) != nil) {
            let amount:String? = UserDefaults.standard.string(forKey: "portUDP")
            if let amountValue = amount, amountValue.count > 0 {
                portUDP = NWEndpoint.Port(rawValue: UInt16(Int(amountValue)!)) ?? 8888
            }
        }
        
        ConnectUDP(hostUDP,portUDP,Action: "ALARM_GET", messageToUDP: "ALM_GET")
        
        TP1.delegate = self
        TP2.delegate = self
        TP3.delegate = self
        TP4.delegate = self
        TP5.delegate = self
        TP6.delegate = self
        TP7.delegate = self
    }
    

    func receiveHandler(Action: String, String: String) {
        if(Action == "ALARM_GET") {
            let receiveArr = String.components(separatedBy: " ")
            
            if(receiveArr[0] == "ALMS") {
                DispatchQueue.main.async {
                    
                    if(receiveArr[1] == "0") { self.SW1.isOn = false } else { self.SW1.isOn = true }
                    if(receiveArr[2] == "0") { self.SW2.isOn = false } else { self.SW2.isOn = true }
                    if(receiveArr[3] == "0") { self.SW3.isOn = false } else { self.SW3.isOn = true }
                    if(receiveArr[4] == "0") { self.SW4.isOn = false } else { self.SW4.isOn = true }
                    if(receiveArr[5] == "0") { self.SW5.isOn = false } else { self.SW5.isOn = true }
                    if(receiveArr[6] == "0") { self.SW6.isOn = false } else { self.SW6.isOn = true }
                    if(receiveArr[7] == "0") { self.SW7.isOn = false } else { self.SW7.isOn = true }

                    self.TP1.text = self.numToTime(num: receiveArr[8])
                    self.TP2.text = self.numToTime(num: receiveArr[9])
                    self.TP3.text = self.numToTime(num: receiveArr[10])
                    self.TP4.text = self.numToTime(num: receiveArr[11])
                    self.TP5.text = self.numToTime(num: receiveArr[12])
                    self.TP6.text = self.numToTime(num: receiveArr[13])
                    self.TP7.text = self.numToTime(num: receiveArr[14])
                    
                    self.modeDAWN?.selectRow(Int(receiveArr[15])!-1 , inComponent: 0, animated: true)
                }
                
            }
        }
    }
    
    func numToTime(num: String) -> String {
        let timeH = Int(Float(num)! / 60)
        let timeM = Int(num)! - timeH * 60
        
        var timeHresult = String(timeH)
        var timeMresult = String(timeM)
        
        if(timeH == 0) { timeHresult = timeHresult+"0" }
        if(timeM == 0) { timeMresult = timeMresult+"0" }
        
        return timeHresult+":"+timeMresult
    }
    
    func timeToNum(time: String) -> Int {
        
        let timeComps = (time as NSString).components(separatedBy: ":") as [NSString]
        return timeComps.reduce(0) { acc, item in
            acc * 60 + item.integerValue
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
                    
                    
                    if(Action == "ALARM_GET") {
                        self.receiveHandler(Action: "ALARM_GET", String: backToString)
                    }
                    
                    self.connection?.cancel()
                    
                } else {
                    print("Data == nil")
                }
            }
        }
    }

}
