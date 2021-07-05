//
//  ViewController.swift
//  ImagePicker_GestureApp
//
//  Created by DCS on 03/07/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let imagePicker : UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        return imagePicker
    }()
    
    private let myImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "img1")
        return imageView
    }()
    
    private let myToolBar:UIToolbar = {
        let toolbar = UIToolbar()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(handelSpacer))
        let gallery = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(handleGallery))
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCamera))
        toolbar.items = [spacer, gallery, camera]
        return toolbar
    }()
    
    @objc private func handelSpacer(){
        print("Spacer Called")
    }
    
    @objc private func handleGallery() {
        print("gallery called")
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.async {
            self.present(self.imagePicker, animated: true)
        }
    }
    
    @objc private func handleCamera() {
        print("camera called")
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            DispatchQueue.main.async {
                self.present(self.imagePicker, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Oops!", message: "Camera not found. Try picking an image from your gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.addSubview(myView)
        view.addSubview(myImageView)
        view.addSubview(myToolBar)
        imagePicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchView))
        view.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateView))
        view.addGestureRecognizer(rotationGesture)
        
        let leftSwipe = UIRotationGestureRecognizer(target: self, action: #selector(didSwipeView))
        view.addGestureRecognizer(leftSwipe)
        
        let panGesture = UIRotationGestureRecognizer(target: self, action: #selector(didPanView))
        view.addGestureRecognizer(panGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        myImageView.frame = CGRect(x: 20, y: 100, width: view.width - 40, height: 200)
       
    }
}

extension ViewController {
    @objc private func didTapView(_ gesture:UITapGestureRecognizer) {
        print("Tapped at locatin: \(gesture.location(in: myImageView))")
        let toolBarHeight: CGFloat = view.safeAreaInsets.top + 40
        myToolBar.frame = CGRect(x: 0, y: 30, width: view.width, height: toolBarHeight)
    }
    
    @objc private func didPinchView(_ gesture:UIPinchGestureRecognizer) {
        myImageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
    }
    
    @objc private func didRotateView(_ gesture:UIRotationGestureRecognizer) {
        myImageView.transform = CGAffineTransform(rotationAngle: gesture.rotation)
    }
    
    @objc private func didSwipeView(_ gesture:UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x - 40, y:  self.myImageView.frame.origin.y, width: 200, height: 200)
            }
        } else if gesture.direction == .right {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x + 40, y:  self.myImageView.frame.origin.y, width: 200, height: 200)
            }
        } else if gesture.direction == .up {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x, y:  self.myImageView.frame.origin.y - 40, width: 200, height: 200)
            }
        } else if gesture.direction == .down {
            UIView.animate(withDuration: 0.2) {
                self.myImageView.frame = CGRect(x: self.myImageView.frame.origin.x, y:  self.myImageView.frame.origin.y + 40, width: 200, height: 200)
            }
        } else {
            print("Could not detect direction of swipe")
        }
    }
    
    @objc private func didPanView(_ gesture:UIPanGestureRecognizer) {
        let x = gesture.location(in: myImageView).x
        let y = gesture.location(in: myImageView).y
        myImageView.center = CGPoint(x: x, y: y)
    }
}

extension ViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            myImageView.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

