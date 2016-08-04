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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        return string.rangeOfCharacterFromSet(invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }

    @IBAction func searchBook(sender: AnyObject){
        
        var urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        urls+=self.textFieldISBN.text!
        let url = NSURL(string: urls)
        let datos = NSData(contentsOfURL: url!)
        var autores = ""
        
        if datos == nil {
            let alertController = UIAlertController(title: "Error", message:"Error de comunicación.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
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
                
            }catch _{
                
                let alertController = UIAlertController(title: "Error", message:"Error en lectura.", preferredStyle: UIAlertControllerStyle.Alert)
                
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
}

