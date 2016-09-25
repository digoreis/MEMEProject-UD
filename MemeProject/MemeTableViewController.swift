//
//  MemeTableViewController.swift
//  MemeProject
//
//  Created by apple on 24/09/16.
//  Copyright © 2016 Rodrigo Reis. All rights reserved.
//

import UIKit


class MemeTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var memes: [MemeData] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? MemeTableViewCell ?? MemeTableViewCell()
        cell.memeTitle.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        cell.memeImage.image = memes[indexPath.row].memeImage
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}
