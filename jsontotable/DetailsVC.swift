//
//  DetailsVC.swift
//  jsontotable
//
//  Created by Victor Doshchenko on 12/10/2019.
//  Copyright © 2019 Victor Doshchenko. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {
    var data: Data?
    var request: URLRequest?
    var session: String?

    @IBOutlet weak var txtBody: UITextView!
    @IBOutlet weak var btnSaveButton: UIButton!
    @IBOutlet weak var lblDateCreate: UILabel!
    @IBOutlet weak var lblDateModify: UILabel!

    @IBAction func btnCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSave(_ sender: UIButton) {
        //Add new data
        self.request?.httpBody = ("a=add_entry&session=" + defaults.string(forKey: sName)! + "&body=" + txtBody.text).data(using: String.Encoding.utf8)

        URLSession.shared.dataTask(with: self.request!) { data, response, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else  {
                print("Error while add row!")
            }
        }.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        txtBody.layer.borderWidth = 1
        if data == nil {
            //Add new row
            lblDateCreate.isHidden = true
            lblDateModify.isHidden = true
        } else {
            //View selected row
            btnSaveButton.isHidden = true
            txtBody.text = data?.body
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            lblDateCreate.text = "Дата создания: " + dateFormatter.string(from: Date(timeIntervalSince1970: Double(data!.da)!))
            if data?.da != data?.dm {
                lblDateModify.text = "Дата модификации: " + dateFormatter.string(from: Date(timeIntervalSince1970: Double(data!.dm)!))
            } else {
                lblDateModify.text = ""
            }
        }
    }
}
