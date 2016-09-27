//
//  MemeDetailViewController.swift
//  MemeProject
//
//  Created by apple on 26/09/16.
//  Copyright © 2016 Rodrigo Reis. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memeData : MemeData?
    @IBOutlet weak var memeImage : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        memeImage.image = memeData?.memeImage
    }

}
