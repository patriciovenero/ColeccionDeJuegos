//
//  ViewController.swift
//  ColeccionDeJuegos
//
//  Created by patricio venero on 29/10/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = true
    }
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
        } catch {
            
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]

        var textToShow = ""
        
        if let titulo = juego.titulo {
            textToShow = titulo
        } else {
            textToShow = "Sin título"
        }

        if let categoria = juego.categoria {
            textToShow += " (\(categoria))"
        } else {
            textToShow += " (Sin categoría)"
        }
        
        cell.textLabel?.text = textToShow

        if let imageData = juego.imagen, let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(named: "defaultImage") // Coloca una imagen predeterminada si no hay imagen disponible.
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "juegoSegue" {

            let vc = segue.destination as! JuegosViewController
            vc.juego = sender as? Juego

          }

    }
    //funcion eliminar un elemento usando el deslizar
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let eliminarAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = self.juegos[indexPath.row]
            context.delete(juego)

            do {
                try context.save()
                self.juegos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Error al eliminar el juego: \(error)")
            }
        }
        eliminarAction.backgroundColor = .red

        let editarAction = UITableViewRowAction(style: .normal, title: "Editar") { action, indexPath in
            let juego = self.juegos[indexPath.row]
            self.performSegue(withIdentifier: "juegoSegue", sender: juego)
        }
        editarAction.backgroundColor = .blue

        return [eliminarAction, editarAction]
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let juegoMovido = juegos[sourceIndexPath.row]
        juegos.remove(at: sourceIndexPath.row)
        juegos.insert(juegoMovido, at: destinationIndexPath.row)

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error al mover el juego: \(error)")
        }
    }


}
    


