//
//  Created by Stmf on 19/08/2020.
//  Copyright © 2020 Stmf. All rights reserved.
//

import UIKit
import Network

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var modePV: UIPickerView!
    @IBOutlet weak var swEffects: UISwitch!
    
    var modes1 = ["Конфети", "Огонь", "Белый огонь", "Радуга верт.", "Радуга гориз.", "Радуга диаг.", "Смена цвета", "Безумие 3D", "Облака 3D", "Лава 3D","Плазма 3D","Радуга 3D","Павлин 3D","Зебра 3D","Лес 3D","Океан 3D","Цвет","Снегопад","Метель","Звездопад", "Матрица", "Светлячки", "Светлячки со шлейфом", "Пейнтбол", "Блуждающий кубик", "Белый свет"]
    var modes2 = ["Эффект 01", "Эффект 02", "Эффект 03", "Эффект 04", "Эффект 05", "Эффект 06", "Эффект 07", "Эффект 08", "Эффект 09", "ЛЭффект 10","Эффект 11","Эффект 12","Эффект 13","Эффект 14","Эффект 15","Эффект 16","Эффект 17","Эффект 18","Эффект 19","Эффект 20", "Эффект 21", "Эффект 22", "Эффект 23", "Эффект 24", "Эффект 25", "Эффект 26", "Эффект 27", "Эффект 28", "Эффект 29", "Эффект 30", "Эффект 31", "Эффект 32", "Эффект 33", "Эффект 34", "Эффект 35", "Эффект 36", "Эффект 37", "Эффект 38", "Эффект 39", "Эффект 40", "Эффект 41", "Эффект 42", "Эффект 43", "Эффект 44", "Эффект 45", "Эффект 46", "Эффект 47", "Эффект 48", "Эффект 49", "Эффект 50"]
    
    @IBAction func ActEffects(_ sender: Any) {
        if(swEffects.isOn) {
            UserDefaults.standard.set("2", forKey: "swEffects")
            self.modePV.reloadAllComponents()
        } else {
            UserDefaults.standard.set("1", forKey: "swEffects")
            self.modePV.reloadAllComponents()
        }
    }
    
    
    
    
    @IBOutlet weak var brightnessCountLbl: UILabel!
    @IBOutlet weak var BRIvalue: UISlider!
    @IBAction func brightnessValueChanget(_ sender: UISlider) {
        brightnessCountLbl.text = String(Int(sender.value))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.ConnectUDP(self.hostUDP,self.portUDP,Action: "BRI", messageToUDP: "BRI"+String(Int(sender.value)))
        }
    }
    
    
    @IBOutlet weak var speedCountLbl: UILabel!
    @IBOutlet weak var SPDvalue: UISlider!
    @IBAction func speedValueChanged(_ sender: UISlider) {
        speedCountLbl.text = String(Int(sender.value))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.ConnectUDP(self.hostUDP,self.portUDP,Action: "SPD", messageToUDP: "SPD"+String(Int(sender.value)))
        }
    }
    
    
    @IBOutlet weak var scaleCountLbl: UILabel!
    @IBOutlet weak var SCAvalue: UISlider!
    @IBAction func scaleValueChanged(_ sender: UISlider) {
        scaleCountLbl.text = String(Int(sender.value))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.ConnectUDP(self.hostUDP,self.portUDP,Action: "SCA", messageToUDP: "SCA"+String(Int(sender.value)))
        }
    }
    
    var connection: NWConnection?
    
    var hostUDP: NWEndpoint.Host = "192.168.42.66"
    var portUDP: NWEndpoint.Port = 8888
    
    @IBOutlet weak var powerImg: UIImageView!
    
    var powerStatus: Int = 0
    
    
    @IBAction func powerBtn(_ sender: Any) {
        if(powerStatus == 0) {
            self.ConnectUDP(self.hostUDP,self.portUDP,Action: "POWER", messageToUDP: "P_ON")
        } else {
            self.ConnectUDP(self.hostUDP,self.portUDP,Action: "POWER", messageToUDP: "P_OFF")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        modePV.delegate = self
        modePV.dataSource = self
        
        modePV.setValue(UIColor.black, forKeyPath: "textColor")
        
        if((UserDefaults.standard.string(forKey: "hostUDP")) != nil) {
            hostUDP = NWEndpoint.Host(UserDefaults.standard.string(forKey: "hostUDP") ?? "192.168.42.66")
        }
        
        if((UserDefaults.standard.string(forKey: "portUDP")) != nil) {
            let amount:String? = UserDefaults.standard.string(forKey: "portUDP")
            if let amountValue = amount, amountValue.count > 0 {
                portUDP = NWEndpoint.Port(rawValue: UInt16(Int(amountValue)!)) ?? 8888
            }
        }
        
        ConnectUDP(hostUDP,portUDP,Action: "GET", messageToUDP: "GET")
        
        if((UserDefaults.standard.string(forKey: "swEffects")) != nil) {
            if((UserDefaults.standard.string(forKey: "swEffects")) == "1") {
                self.swEffects.isOn = false
            }
            
            if((UserDefaults.standard.string(forKey: "swEffects")) == "2") {
                self.swEffects.isOn = true
            }
        }
        
    }
    
    func receiveHandler(Action: String, String: String) {
        if(Action == "GET") {
            let receiveArr = String.components(separatedBy: " ")
            
            if(receiveArr[0] == "CURR") {
                DispatchQueue.main.async {
                    self.modePV?.selectRow(Int(receiveArr[1]) ?? 0, inComponent: 0, animated: true)
                    self.brightnessCountLbl.text = receiveArr[2]
                    self.BRIvalue.setValue(Float(receiveArr[2]) ?? 0.0, animated: true)
                    self.speedCountLbl.text = receiveArr[3]
                    self.SPDvalue.setValue(Float(receiveArr[3]) ?? 0.0, animated: true)
                    self.scaleCountLbl.text = receiveArr[4]
                    self.SCAvalue.setValue(Float(receiveArr[4]) ?? 0.0, animated: true)
                    
                    if(receiveArr[5] == "0") {
                        let Image: UIImage = UIImage(named: "Logo_dark")!
                        self.powerImg.image = Image
                        self.powerStatus = 0
                    } else {
                        let Image: UIImage = UIImage(named: "Logo")!
                        self.powerImg.image = Image
                        self.powerStatus = 1
                    }
                }
                
            }
        }
        
        if(Action == "POWER") {
            let receiveArr = String.components(separatedBy: " ")
            
            if(receiveArr[0] == "CURR") {
                DispatchQueue.main.async {
                    
                    if(receiveArr[5] == "0") {
                        let Image: UIImage = UIImage(named: "Logo_dark")!
                        self.powerImg.image = Image
                        self.powerStatus = 0
                    } else {
                        let Image: UIImage = UIImage(named: "Logo")!
                        self.powerImg.image = Image
                        self.powerStatus = 1
                    }
                }
                
            }
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
                    
                    if(Action == "GET") {
                        self.receiveHandler(Action: "GET", String: backToString)
                    }
                    
                    if(Action == "POWER") {
                        self.receiveHandler(Action: "POWER", String: backToString)
                    }
                    
                    self.connection?.cancel()
                    
                } else {
                    print("Data == nil")
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(swEffects.isOn) {
            return modes2.count
        } else {
            return modes1.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(swEffects.isOn) {
            return modes2[row]
        } else {
            return modes1[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(modes[row])
        //print(row)
        self.ConnectUDP(hostUDP,portUDP,Action: "EFF", messageToUDP: "EFF"+String(row))
    }

}
