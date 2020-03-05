//
//  ViewController.swift
//  SqLite
//
//  Created by Miguel Angel Jimenez Melendez on 3/4/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
//Libreria SQLite
import SQLite3

class ViewController: UIViewController {
    @IBOutlet weak var txtpeso: UITextField!
    @IBOutlet weak var txtaltura: UITextField!
    @IBOutlet weak var txtcve: UITextField!
    @IBOutlet weak var txtnom: UITextField!
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    var registro = [Registro]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteIMC.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            alerta(title: "Error", message: "No se puede acceder a la DB")
            return
        }
        let CreateTable = "Create Table If Not Exists Usuario(clave Integer Primary Key, nombre Text, peso Integer, altura Real, imc Real)"
        if sqlite3_exec(db, CreateTable, nil, nil, nil) != SQLITE_OK{
            alerta(title: "Error", message: "No se creo la Tabla")
            return
        }
        alerta(title: "Exito", message: "Se creo DB")
        // Do any additional setup after loading the view.
    }
    @IBAction func btnguardar(_ sender: UIButton) {
        if txtcve.text!.isEmpty || txtnom.text!.isEmpty || txtpeso.text!.isEmpty || txtaltura.text!.isEmpty {
            alerta(title: "Falta informaciòn", message: "Complete el formulario")
            txtcve.becomeFirstResponder()
        }else{
            var kg = Double(txtpeso.text!)!
            var h = Double(txtaltura.text!)!
            var i = kg / (h * h)
            let clave = txtcve.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let nombre = txtnom.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let peso = String(kg).trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let altura = String(h).trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let imc = String(i).trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let sentencia = "Insert Into Usuario(clave, nombre, peso, altura, imc) Values(?,?,?,?,?)"
            if sqlite3_prepare(db, sentencia, -1, &stmt, nil) != SQLITE_OK{
                alerta(title: "Error", message: "Error al ligar sentencia")
                return
            }
            if sqlite3_bind_int(stmt, 1, (clave as NSString).intValue) != SQLITE_OK {
                alerta(title: "Error", message: "Error Clave")
                return
            }
            if sqlite3_bind_text(stmt, 2, nombre.utf8String, -1, nil) != SQLITE_OK {
                alerta(title: "Error", message: "Error Nombre")
                return
            }
            if sqlite3_bind_double(stmt, 3, (peso as NSString).doubleValue) != SQLITE_OK {
                alerta(title: "Error", message: "Error Peso")
                return
            }
            if sqlite3_bind_double(stmt, 4, (altura as NSString).doubleValue) != SQLITE_OK {
                alerta(title: "Error", message: "Error Altura")
                return
            }
            if sqlite3_bind_double(stmt, 5, (imc as NSString).doubleValue) != SQLITE_OK{
                alerta(title: "Error", message: "Error IMC")
                return
            }
            if sqlite3_step(stmt) != SQLITE_OK {
                alerta(title: "Guardando", message: "Se guardo con exito")
                txtnom.text = ""
                txtpeso.text = ""
                txtaltura.text = ""
                txtcve.text = ""
            }else{
                alerta(title: "Error", message: "Problemas al guardar")
            }
        }
    }
    @IBAction func btnconsultar(_ sender: UIButton) {
        registro.removeAll()
        //alerta(title: "hola", message: "")
        let query = "Select * From Usuario Order By nombre"
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db))
            alerta(title: "error", message: "Error en la DB \(error)")
            return
        }
        while sqlite3_step(stmt) == SQLITE_ROW {
            let clave = String(cString: sqlite3_column_text(stmt, 0))
            let nombre = sqlite3_column_text(stmt, 1)
            let peso = String(cString: sqlite3_column_text(stmt, 2))
            let altura = String(cString: sqlite3_column_text(stmt, 3))
            let imc = String(cString: sqlite3_column_text(stmt, 4))
            registro.append(Registro(clave: Int(clave)!, nombre: String(describing: nombre), peso: Double(peso)!, altura: Double(altura)!, imc: Double(imc)!))
        }
        self.performSegue(withIdentifier: "SLista", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SLista" {
            let lista = segue.destination as! TableViewController
            lista.registro = registro
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

}

