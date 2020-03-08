//
//  ViewControllerlogin.swift
//  SqLite
//
//  Created by Miguel Angel Jimenez Melendez on 3/6/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3
class ViewControllerlogin: UIViewController {
    @IBOutlet weak var txtusuario: UITextField!
    @IBOutlet weak var txtpsw: UITextField!
    
    var db : OpaquePointer?
    var stmt : OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
       let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteIMC.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            alerta(title: "Error", message: "No se puede acceder a la DB")
            return
        }
        let CreateTable = "Create Table If Not Exists Usuario(clave Integer Primary Key, nombre Text, peso Integer, altura Real, imc Real)"
        let tablelogin = "Create Table If Not Exists Login(email Text Primary Key, password Text)"
        if sqlite3_exec(db, CreateTable, nil, nil, nil) != SQLITE_OK{
            alerta(title: "Error", message: "No se creo la Usuario")
            return
        }
        if sqlite3_exec(db, tablelogin, nil, nil, nil) != SQLITE_OK{
            alerta(title: "Error", message: "No se creo login")
            return
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func btnLogin(_ sender: UIButton) {
        if txtusuario.text!.isEmpty || txtpsw.text!.isEmpty {
            alerta(title: "", message: "")
            txtusuario.becomeFirstResponder()
        }else {
            let usuario = txtusuario.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let psw = txtpsw.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let sentencia = "Insert Into Login(email, password) Values(?,?)"
            if sqlite3_prepare(db, sentencia, -1, &stmt, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Error al ligar sentencia")
                return
            }
            if sqlite3_bind_text(stmt, 1, usuario.utf8String, -1, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Usuario")
                return
            }
            if sqlite3_bind_text(stmt, 2, psw.utf8String, -1, nil) != SQLITE_OK {
                alerta(title: "Error", message: "psw")
                return
            }
            if sqlite3_step(stmt) != SQLITE_OK {
                self.performSegue(withIdentifier: "Svcprimary", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Svcprimary" {
            _ = segue.destination as! ViewController
        }
    }
    func alerta (title: String, message: String){
        //Crea una alerta
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Agrega un boton
        alert.addAction(UIAlertAction(title: "Aceptar",style: UIAlertAction.Style.default, handler: nil))
        //Muestra la alerta
        self.present(alert, animated: true, completion: nil)
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
