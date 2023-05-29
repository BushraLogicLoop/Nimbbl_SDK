//
//  ThankYouVC.swift
//  Nimbbl_SDK_Example
//
//  Created by Bushra on 25/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

import UIKit

class ThankYouVC: UIViewController {
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblTrxId: UILabel!
    
    var orderid = ""
    var trxId = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblOrderId.text = orderid
        lblTrxId.text = trxId
    }
    
    @IBAction func onBtnDoneAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        UIApplication.shared.keyWindow?.rootViewController = vc
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    
}
