//
//  ViewController.swift
//  BIPtheguy
//
//  Created by Kaylee Mei Chao on 7/11/22.
//

import UIKit
import AVFoundation //for sound

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var audioPlayer : AVAudioPlayer!
    var imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
    
    func playSound(name: String) {
        if let sound = NSDataAsset(name: name) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("ERROR: \(error.localizedDescription). Could not initialize")
            }
        } else {
            print ("ERROR: Could not read data from file \(name)")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            //code to open photo library
            self.accessPhotoLibrary()        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            //add code to bring up camera
            self.accessCamera()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        
        let originalFrame = imageView.frame
        let widthShrink: CGFloat = 30
        let heightShrink: CGFloat = 30
        let smallerFrame = CGRect(x: imageView.frame.origin.x + widthShrink,
                                  y: imageView.frame.origin.y + heightShrink,
                                  width: imageView.frame.width - (2*widthShrink),
                                  height: imageView.frame.height - (2*heightShrink))
        
        imageView.frame = smallerFrame
        
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10.0) {
            self.imageView.frame = originalFrame
        }
        
        playSound(name: "punchSound")
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //code goes here
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //code goes here
        dismiss(animated: true, completion: nil)
    }
    
    func accessPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            showAlert(title: "Camera Not Available", message: "There is no camera on this device")
        }
    }
}
