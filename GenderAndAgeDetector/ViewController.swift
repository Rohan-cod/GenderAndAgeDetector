//
//  ViewController.swift
//  GenderAndAgeDetector
//
//  Created by pamarori mac on 13/08/20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var gender: UILabel!
    
    @IBOutlet weak var age: UILabel!
    
    
    @IBOutlet weak var image: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let photoLibraryPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
        photoLibraryPicker.delegate = self
        photoLibraryPicker.sourceType = .photoLibrary
        photoLibraryPicker.allowsEditing = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Couldn't Convert to CIImage!")
            }
            
            detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        photoLibraryPicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        guard let model1 = try? VNCoreMLModel(for: age_net().model) else {
            fatalError("Loading CoreML model Failed!")
        }
        
        let request1 = VNCoreMLRequest(model: model1) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image!")
            }
            
            if let firstResult = results.first {
                self.age.text = firstResult.identifier
            }
            
        }
        
        let handler1 = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler1.perform([request1])
        } catch {
            print(error)
        }
        
        guard let model2 = try? VNCoreMLModel(for: gender_net().model) else {
            fatalError("Loading CoreML model Failed!")
        }
        
        let request2 = VNCoreMLRequest(model: model2) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image!")
            }
            
            if let firstResult = results.first {
                self.gender.text = firstResult.identifier
            }
            
        }
        
        let handler2 = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler2.perform([request2])
        } catch {
            print(error)
        }
        
        
        
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        present(photoLibraryPicker, animated: true, completion: nil)
    }
    
    
    
    
}



