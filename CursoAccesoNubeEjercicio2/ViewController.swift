//
//  ViewController.swift
//  CursoAccesoNubeEjercicio1
//
//  Created by Martin Juarez on 31/12/16.
//  Copyright © 2016 Martin Juarez Acheritobehere. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var isbn: UILabel!
    
    @IBOutlet weak var seachBox: UITextField!
    
    @IBOutlet weak var isbnResult: UITextView!
    
    @IBOutlet weak var cover: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.seachBox.delegate = self
        self.seachBox.tag = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 0:
            recuperaDatosISBN(isbn: textField.text!)
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let currentTextField = textField
        
        currentTextField.becomeFirstResponder()
        
        recuperaDatosISBN(isbn: textField.text!)
        
        return true
        
    }
    
    func recuperaDatosISBN(isbn : String){
        
        
        var texto : String? = nil
        let urlStr = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn //978-84-376-0494-7 - 9780439789493
        let url = NSURL(string: urlStr)
        if (url != nil){
            let datos:NSData? = NSData(contentsOf: url! as URL)
            
            // tratamos el resultado JSON para recuperarel titulo del libro, autores y portada
            do{
                let json = try JSONSerialization.jsonObject(with: datos as! Data, options: JSONSerialization.ReadingOptions.mutableLeaves)
                let diccionarioDatos = json as! NSDictionary
                if ((diccionarioDatos["ISBN:"+isbn]) != nil){
                    let diccionarioDatosISBN = diccionarioDatos["ISBN:"+isbn] as! NSDictionary
                
                // recuperamos el titulo del libro
                let tituloLibro = diccionarioDatosISBN["title"] as! NSString
                
                texto = "Titulo: " + (tituloLibro as String) + "\n\r"
                
                // recupereamos el array de autores
                let arrayDatosAutores : Array<NSDictionary> = diccionarioDatosISBN["authors"] as! Array<NSDictionary>
                for i in 0 ..< arrayDatosAutores.count  {
                    texto = texto! + "Autor: " + (arrayDatosAutores[i]["name"] as! String) + "\n\r"
                }
                    
                // recuperamos la portada en caso que exista
                if ((diccionarioDatosISBN["cover"]) != nil){
                    let diccionarioPortadaLibro = diccionarioDatosISBN["cover"] as! NSDictionary
                    let portadaPequenia = diccionarioPortadaLibro["small"] as! String
                    let url = URL(string: portadaPequenia)
                    let data = try? Data(contentsOf: url!)
                    self.cover.image = UIImage(data: data!)
                } else {
                    self.cover.image = nil
                }
                
                }
            } catch _ {
            }
            
            if (texto == nil){
                texto = "No se ha podido establecer conexión con el servidor. Intentelo mas tarde."
                self.cover.image = nil
            } else if (texto == "{}" || texto == ""){
                texto = "No se han encontrado coincidencias"
                self.cover.image = nil            }
        } else {
            texto = "No se ha podido establecer conexión con el servidor. Intentelo mas tarde."
            self.cover.image = nil
        }
        
        
        
        self.isbnResult.text = texto as String!
    }
    

    
}

