//
//  ViewController.swift
//  RequestOpenLibrary
//
//  Created by Jonathan Silva on 25/07/16.
//  Copyright © 2016 Coursera. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var textFieldISBN: UITextField!
    @IBOutlet weak var textViewResponse: UITextView!
    @IBOutlet weak var TextView2: UITextView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var tituloSwitch: UISwitch!
    @IBOutlet weak var autoresSwitch: UISwitch!
    @IBOutlet weak var coverSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func searchBook(sender: AnyObject){
        
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urls+=self.textFieldISBN.text!
        let url = NSURL(string: urls)
        let datos = NSData(contentsOfURL: url!)
        var autores = ""
        
        let num = Int(self.textFieldISBN.text!)
        if num != nil {
            print("Valid Integer")
        }
        else {
            print("Not Valid Integer")
        }
        
        if datos == nil {
            
            let alertController = UIAlertController(title: "Error", message:"Error de comunicación.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else if num == nil {
            
            let alertController = UIAlertController(title: "Error", message:"ISBN Solo acepta numeros.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else if self.textFieldISBN.text?.characters.count < 10 || self.textFieldISBN.text?.characters.count > 12  || self.textFieldISBN.text?.characters.count == 11 {
            
            let alertController = UIAlertController(title: "Error", message:"ISBN Codigo de 10 o 12 numeros.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }else{
        
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                
                let dic1 = json as! NSDictionary
                
                //TITLE
                if(tituloSwitch.on){
                    
                    let title = dic1["ISBN:"+self.textFieldISBN.text!]!["title"]!
                    textViewResponse.text = String(title!)
                    
                }else{
                    textViewResponse.text = ""
                }
                
                //AUTHORS
                if(autoresSwitch.on){
                    
                    let authors = dic1["ISBN:"+self.textFieldISBN.text!]!["authors"] as! NSMutableArray
                    for author in authors {
                        let autor = author as! NSDictionary
                        autores += autor["name"]! as! String
                        autores += "\n"
                        TextView2.text = autores
                    }
                    
                }else{
                    TextView2.text = ""
                }
                
                //COVER
                if(coverSwitch.on){
                    
                    let cover = dic1["ISBN:"+self.textFieldISBN.text!]!["cover"] as! NSDictionary
                    let coverURL = cover["small"]!
                    let url = NSURL(string: coverURL as! String)
                    let imageData = NSData(contentsOfURL: url!)
                    coverImage.alpha = 1
                    coverImage.image = UIImage(data: imageData!)
                    
                }else{
                    coverImage.alpha = 0
                }
                
            }catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                
                let alertController = UIAlertController(title: "Error", message:"Error en lectura.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}

