//
//  ViewController.swift
//  jsontotable
//
//  Created by Victor Doshchenko on 12/10/2019.
//  Copyright © 2019 Victor Doshchenko. All rights reserved.
//

import UIKit

let urlString = "https://bnet.i-partner.ru/testAPI/"
let sName = "bnetisession"
let token = "1U9eTJI-WZ-ID9MfZ1"
let url = URL(string: urlString)
let defaults = UserDefaults.standard

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var request = URLRequest(url: url!)
    var dataArray = [Data]()

    func updateUI() {
        //Load data
        request.httpBody = ("a=get_entries&session=" + defaults.string(forKey: sName)!).data(using: String.Encoding.utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let datas = try? JSONDecoder().decode(Datas.self, from: data) {
                    self.dataArray.removeAll()
                    for onedata in datas.data[0] {
                        self.dataArray.append(onedata)
                    }
                    DispatchQueue.main.async {
                        self.tblData.reloadData()
                    }
                } else {
                    print("Can't get data!")
                }
            } else  {
                print("Error load data from http!")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Ошибка", message: "Проверьте соединение с сетью", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Обновить", style: UIAlertAction.Style.default, handler: {action in self.updateUI()}
                    ))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }.resume()
    }

    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "showdetails", sender: self)
    }

    @IBOutlet weak var tblData: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
        
        cell?.detailTextLabel?.text = dataArray[indexPath.row].body
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if dataArray[indexPath.row].da == dataArray[indexPath.row].dm {
            cell?.textLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(dataArray[indexPath.row].da)!))
        } else {
            cell?.textLabel?.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(dataArray[indexPath.row].da)!)) + " - " + dateFormatter.string(from: Date(timeIntervalSince1970: Double(dataArray[indexPath.row].dm)!))
        }
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //tblData.dataSource = self
        //tblData.delegate = self
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "token")

        //Get session
        if defaults.string(forKey: sName) == nil {
            request.httpBody = "a=new_session".data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let datas = try? JSONDecoder().decode(Sessions.self, from: data) {
                        print("New session: ",datas.data.session)
                        defaults.set(datas.data.session, forKey: sName)
                    } else {
                        print("Can't get new session!")
                    }
                } else  {
                    print("Error load session from http!")
                }
            }.resume()
        } else {
            print("Use session: ", defaults.string(forKey: sName) ?? "")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showdetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsVC {
            destination.request = self.request
            if tblData.indexPathForSelectedRow != nil {
                destination.data = dataArray[(tblData.indexPathForSelectedRow?.row)!]
                tblData.deselectRow(at: tblData.indexPathForSelectedRow!, animated: true)
            }
        }
    }
}
