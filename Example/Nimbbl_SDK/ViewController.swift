//
//  ViewController.swift
//  Nimbbl_SDK
//
//  Created by Bushra on 05/25/2023.
//  Copyright (c) 2023 Bushra. All rights reserved.
//

import UIKit
import Nimbbl_SDK
import MBProgressHUD

typealias JSONObject = Dictionary<String,Any>

class ViewController: UIViewController, NimbblCheckoutDelegate {
    
    @IBOutlet weak var tblProducts: UITableView!
    var arrProducts = [ProductModal]()
    var selected_access_key: String?
    var productID: Int?
    
    fileprivate var nimbblChekout: NimbblCheckout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //By Bushra: for settings icon
        let button  = UIButton(type: .custom)
        if let image = UIImage(named:"settings_icon.png") {
            button.setImage(image, for: .normal)
        }
        button.frame = CGRectMake(0.0, 0.0, 30.0, 30.0)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nimbblChekout = NimbblCheckout(accessKey: selected_access_key ?? "access_key_aQA3j4gmyw4bm72N",
                                       serviceURL: "https://api.nimbbl.tech/api/v2/",
                                       paymentURL: "https://checkout.nimbbl.tech/",
                                       delegate: self)
        nimbblChekout.enableUATEnvironment = false//true
        
        for i in 1...2{
            
            let title = i == 1 ? "Colourful Mandalas" : "Designer Triangles."
            let desc = i == 1 ? "Convert your dreary device into a bright happy place with this wallpaper by Speedy McVroom" : "Bold blue and deep black triangle designer wallpaper to give your device a hypnotic effect by  chenspec from Pixabay"
            let amount = i == 1 ? "2" : "4"
            
            let product = ProductModal(productId: i, title: title, desc: desc, amount: amount)
            arrProducts.append(product)
            
        }
        
        tblProducts.dataSource = self
        tblProducts.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    fileprivate func openPaymentScreen(orderId: String, amount: Double, merchantId: Int) {
        let options: [String : Any] = ["order_id": orderId, "amount" : amount, "merchant_id" : merchantId]
        nimbblChekout.show(options: options, displayController: self)
    }
    
    //By Bushra: to open settings screen
    @objc func addTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createOrderAction(sender: UIButton){
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "Loading ..."
        hud.mode = .indeterminate
        
        let product = arrProducts[sender.tag]
        let parameters = "{ \"product_id\": \(self.productID ?? 1)}"//\(product.productId) }"
        let postData = parameters.data(using: .utf8)
        
        /// UAT :- https://uatshop.nimbbl.tech/api/orders/create
        /// DEV :- https://devshop.nimbbl.tech/api/orders/create
        var request = URLRequest(url: URL(string: "https://shop.nimbbl.tech/api/orders/create")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("API Error:",String(describing: error))
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            do{
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONObject ?? [:]
                guard let result = jsonData["result"] as? JSONObject else { return }
                
                let status = result["success"] as? Bool ?? false
                
                if status {
                    guard let item = result["item"] as? JSONObject else { return }
                    guard let orderId = item["order_id"] as? String else { return }
                    
                    let amount = item["total_amount"] as! Double
                    let merchantId = item["sub_merchant_id"] as! Int
                    
                    DispatchQueue.main.async {
                        hud.hide(animated: true)
                        self.openPaymentScreen(orderId: orderId, amount: amount, merchantId: merchantId)
                    }
                }
            } catch {
                print("Error while parsing")
            }
        }
        
        task.resume()
    }
    
    func onPaymentSuccess(_ response: [AnyHashable : Any]) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ThankYouVC") as! ThankYouVC
        vc.orderid = response["order_id"] as? String ?? ""
        vc.trxId = response["transaction_id"] as? String ?? ""
        debugPrint("Order id: \(response["order_id"]) :: \(response["transaction_id"])")
        UIApplication.shared.keyWindow?.rootViewController = vc
        UIApplication.shared.keyWindow?.makeKeyAndVisible()
    }
    
    func onError(_ error: String) {
        print("Error:- ",error.debugDescription)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product", for: indexPath) as! ProductTVC
        cell.populateData(product: arrProducts[indexPath.row])
        cell.mBtnBuyNow.tag = indexPath.row
        cell.mBtnBuyNow.addTarget(self, action: #selector(createOrderAction(sender:)), for: .touchUpInside)
        return cell
    }
}


class ProductTVC: UITableViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    @IBOutlet weak var mViContent: UIView!
    
    @IBOutlet weak var mBtnBuyNow: UIButton!
    
    override func awakeFromNib() {
        mViContent.layer.cornerRadius = 10.0
        mViContent.layer.masksToBounds = true
    }
    
    func populateData(product: ProductModal){
        imgProduct.image = UIImage(named: "product_\(product.productId)")
        lblTitle.text = product.title
        lblDesc.text = product.desc
        lblAmount.text = "₹ \(product.amount)"
    }
}

struct ProductModal {
    let productId : Int
    let title: String
    let desc: String
    let amount: String
}
