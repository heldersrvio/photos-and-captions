//
//  DetailViewController.swift
//  PhotosAndCaptions
//
//  Created by Helder on 20/07/20.
//  Copyright © 2020 Helder de Melo Sérvio Filho. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    var selectedImagePath: String?
    var caption: String?
    var deletePictureHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = caption
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePicture))
        
        if let imageToLoad = UIImage(contentsOfFile: selectedImagePath ?? "") {
            image?.image = imageToLoad
        }
    }
    
    @objc func deletePicture() {
        if let deletePictureHandler = deletePictureHandler {
            deletePictureHandler()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
