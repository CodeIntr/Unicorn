//
//  ViewController.swift
//  Unicorn
//
//  Created by Nitish on 30/04/20.
//  Copyright © 2020 Unicorn. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var analysisTextView: UITextView!
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func analyzePhoto(_ sender: Any) {
        guard let photo = imageView.image else {
            let alert = UIAlertController(title: "Unicorn", message: "Please take a photo first!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        
        // Define the metadata for the image.
        let imageMetadata = VisionImageMetadata()
        imageMetadata.orientation = UIUtilities.visionImageOrientation(from: photo.imageOrientation)
        
        let visionImage = VisionImage(image: photo)
        visionImage.metadata = imageMetadata
        
        textRecognizer.process(visionImage) { result, error in
          guard error == nil, let result = result else {
            let alert = UIAlertController(title: "Unicorn", message: "Error in analyzing image, try again with another!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
          }
            
          // Recognized text
//            for block in result.blocks {
//                print(block.text)
//            }
            self.analysisTextView.text = result.text
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

