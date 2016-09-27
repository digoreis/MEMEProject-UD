//
//  MemeGridViewController.swift
//  MemeProject
//
//  Created by apple on 24/09/16.
//  Copyright © 2016 Rodrigo Reis. All rights reserved.
//

import UIKit


class MemeGridViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memes: [MemeData] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = memes[indexPath.row]
        performSegue(withIdentifier: "collectionToDetail", sender: data)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MemeCollectionViewCell ?? MemeCollectionViewCell()
        cell.memeImage.image = memes[indexPath.row].memeImage
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc  = segue.destination as? MemeDetailViewController, let data = sender as? MemeData {
            vc.memeData = data
        }
    }
    
}
