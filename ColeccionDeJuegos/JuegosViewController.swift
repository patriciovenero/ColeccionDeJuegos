//
//  JuegosViewController.swift
//  ColeccionDeJuegos
//
//  Created by patricio venero on 29/10/23.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var tituloTextField: UITextField!
    
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    
    @IBOutlet weak var JuegoImageView: UIImageView!
    
    @IBOutlet weak var eliminarBoton: UIButton!
    
    @IBOutlet weak var categoriaPickerView: UIPickerView!

    
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    var categorias = ["Acción", "Aventura", "Deportes", "Estrategia"]
    var categoriaSeleccionada = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        categoriaPickerView.dataSource = self
        categoriaPickerView.delegate = self

        if juego != nil {
            JuegoImageView.image = UIImage(data: (juego!.imagen!)as Data)
            tituloTextField.text = juego!.titulo
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        }else{
            eliminarBoton.isHidden = true
        }
        // Asignar el picker view
          categoriaPickerView.dataSource = self
          categoriaPickerView.delegate = self

          // Seleccionar valor inicial
          if let juego = juego {
            categoriaSeleccionada = juego.categoria ?? ""
            categoriaPickerView.selectRow(categorias.firstIndex(of: categoriaSeleccionada) ?? 0, inComponent: 0, animated: false)
          } else {
            categoriaPickerView.selectRow(0, inComponent: 0, animated: false)
          }
    }

    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
    }
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo = tituloTextField.text
            juego!.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            if !categoriaSeleccionada.isEmpty {
                juego!.categoria = categoriaSeleccionada
            } else {
                // Maneja el caso en el que no se haya seleccionado una categoría (puedes mostrar un mensaje de error o establecer un valor predeterminado).
            }
        } else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context: context)
            juego.titulo = tituloTextField.text
            juego.imagen = JuegoImageView.image?.jpegData(compressionQuality: 0.50)
            if !categoriaSeleccionada.isEmpty {
                juego.categoria = categoriaSeleccionada
            } else {
                // Maneja el caso en el que no se haya seleccionado una categoría (puedes mostrar un mensaje de error o establecer un valor predeterminado).
            }
        }

            
        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        NotificationCenter.default.post(
          name: Notification.Name("UpdateData"),
          object: nil
        )

        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        JuegoImageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
    }
    // Métodos del picker view datasource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return categorias.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return categorias[row]
    }

    // Seleccionar categoría

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      categoriaSeleccionada = categorias[row]
    }

    // Al guardar
    
}
