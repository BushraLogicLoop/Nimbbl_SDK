//
//  SettingsVC.swift
//  Nimbbl_SDK_Example
//
//  Created by Bushra on 25/05/23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//


import Foundation
import UIKit
import DropDown

class SettingsVC: UIViewController {
    
    @IBOutlet weak var environmentVw: UIView!
    @IBOutlet weak var appExperienceVw: UIView!
    @IBOutlet weak var testMerchantVw: UIView!
    
    @IBOutlet weak var environmentLbl: UILabel!
    @IBOutlet weak var appExperienceLbl: UILabel!
    @IBOutlet weak var testMerchantLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    //
    let prodServiceUrl = "https://api.nimbbl.tech"
    let proPaymentUrl = "https://shop.nimbbl.tech"
    
    let preprodServiceUrl = "https://apipp.nimbbl.tech"
    let preprodPaymentUrl = "https://shoppp.nimbbl.tech"
    var accessKey: String?
    var prodID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let environmentDrpTap = UITapGestureRecognizer(target: self, action: #selector(self.environmentDrpTap(_:)))
        self.environmentVw.addGestureRecognizer(environmentDrpTap)
        
        let appExperienceDrpTap = UITapGestureRecognizer(target: self, action: #selector(self.appExperienceDrpTap(_:)))
        self.appExperienceVw.addGestureRecognizer(appExperienceDrpTap)
        
        let testMerchantDrpTap = UITapGestureRecognizer(target: self, action: #selector(self.testMerchantDrpTap(_:)))
        self.testMerchantVw.addGestureRecognizer(testMerchantDrpTap)
        
    }
    
    @objc func environmentDrpTap(_ sender: UITapGestureRecognizer? = nil) {
        dropDownSetting(view: environmentVw)
    }
    
    @objc func appExperienceDrpTap(_ sender: UITapGestureRecognizer? = nil) {
        dropDownSetting(view: appExperienceVw)
    }
    
    @objc func testMerchantDrpTap(_ sender: UITapGestureRecognizer? = nil) {
        dropDownSetting(view: testMerchantVw)
    }
    
    func dropDownSetting(view: UIView) {
        let dropdown = DropDown()
        dropdown.anchorView = view
        if view == environmentVw {
            dropdown.dataSource = ["Prod", "Pre-Prod", "Uat", "Dev"]
        } else if view == appExperienceVw {
            dropdown.dataSource = ["webview"]
        } else {
            dropdown.dataSource = ["Native Config", "Razorpay Config", "PayU Config", "CashFree Config"]
        }
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            if view == environmentVw {
                environmentLbl.text = item
            } else if view == appExperienceVw {
                appExperienceLbl.text = item
            } else {
                testMerchantLbl.text = item
            }
            print("Selected item: \(item) at index: \(index)")
        }
        dropdown.width = 230
        dropdown.show()
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        if environmentLbl.text == "Prod" && testMerchantLbl.text == "Razorpay Config" {
            accessKey = "access_key_1MwvMkKkweorz0ry"
            prodID = 1
        } else if environmentLbl.text == "Prod" && testMerchantLbl.text == "PayU Config" {
            accessKey = "access_key_81x7ByYkREmW205N"
            prodID = 2
        } else if environmentLbl.text == "Prod" && testMerchantLbl.text == "CashFree Config" {
            accessKey = "access_key_aQA3j4gmyw4bm72N"
            prodID = 3
        } else if environmentLbl.text == "Prod" && testMerchantLbl.text == "Native Config" {
            accessKey = "access_key_1MwvMQjywN5zdvry"
            prodID = 5
        } else if environmentLbl.text == "Pre-Prod" && testMerchantLbl.text == "Razorpay Config" {
            accessKey = "access_key_1MwvMkKkweorz0ry"
            prodID = 1
        } else if environmentLbl.text == "Pre-Prod" && testMerchantLbl.text == "PayU Config" {
            accessKey = "access_key_81x7ByYkREmW205N"
            prodID = 2
        } else if environmentLbl.text == "Pre-Prod" && testMerchantLbl.text == "CashFree Config" {
            accessKey = "access_key_aQA3j4gmyw4bm72N"
            prodID = 3
        } else if environmentLbl.text == "Pre-Prod" && testMerchantLbl.text == "Native Config" {
            accessKey = "access_key_1MwvMQjywN5zdvry"
            prodID = 5
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.selected_access_key = accessKey
        vc.productID = prodID
        navigationController?.pushViewController(vc, animated: true)
    }
}

