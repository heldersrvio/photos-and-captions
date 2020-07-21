//
//  ViewController.swift
//  PhotosAndCaptions
//
//  Created by Helder on 20/07/20.
//  Copyright © 2020 Helder de Melo Sérvio Filho. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var pictures: [String] = []
    var captions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takePicture))
        navigationItem.title = "Photo Caption App"
        if let pictures = UserDefaults.standard.stringArray(forKey: "pictures") {
            self.pictures = pictures
        }
        if let captions = UserDefaults.standard.stringArray(forKey: "captions") {
            self.captions = captions
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    @objc func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        let imageName = UUID().uuidString
        let imagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        pictures.append(imageName)
        let ac = UIAlertController(title: "Caption", message: "Add a caption describing the picture.", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default){
            [weak self, ac] _ in
            self?.captions.append(ac.textFields?[0].text ?? "Image \(self?.pictures.count)")
            self?.saveData()
            self?.tableView.reloadData()
        })
        dismiss(animated: true)
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = captions[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImagePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(pictures[indexPath.row]).path
            vc.caption = captions[indexPath.row]
            vc.deletePictureHandler = {
                self.deletePicture(index: indexPath.row)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(pictures, forKey: "pictures")
        UserDefaults.standard.set(captions, forKey: "captions")
    }
    
    func deletePicture(index: Int) {
        pictures.remove(at: index)
        captions.remove(at: index)
        saveData()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }


}

