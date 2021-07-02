//
//  ViewController.swift
//  MusicList
//
//  Created by Владислав on 28.06.2021.
//

import UIKit

//MARK: - класс контроллера для вывода айдишников альбомов в таблицу
class ViewController: UIViewController {
    
    //MARK: Вспомогательная переменная для того чтобы вывести с помощью массива данные в таблицу
    var albumIdArray = [String]()
    
    //MARK: Вспомогательные переменные для подстановки в ссылку
    var pageNumber = String()
    var albumCount = String()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: начальное состояние индикатора - прячем его
        activityIndicator.isHidden = true
        
        //MARK: настроки навигейшен контроллера
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - добавил кнопку верхнего бара для регулировки вывода номера страницы и количества альбомов (экшен вызывает алерт контроллер с двумя полями)
    @IBAction func alertControllerSort(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Страница и количество альбомов?", message: "", preferredStyle: .alert)
        
        //MARK: добавляем поля ввода на номер страницы и количесвто альбомов
        alertController.addTextField { textField in
            textField.placeholder = "Страница?"
            textField.textAlignment = .center
        }
        
        alertController.addTextField{ textField in
            textField.placeholder = "Сколько альбомов вывести?"
            textField.textAlignment = .center
        }
        
        //MARK: подключаем функционал - кнопку отмены
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Canelled")
        }
        
        //MARK: кнопка подтверждения - проверяем захват значений из полей ввода
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            //MARK: присваиваем значения нашим переменным
            self.pageNumber = (alertController.textFields?.first?.text)!
            self.albumCount = (alertController.textFields?.last?.text)!
            
            //MARK: запускаем метод получения данных (получаем айди альбомов и выводим их в табличку)
            self.fetchMusicData()
            
            print("Страница номер: \(alertController.textFields?.first?.text ?? "None")")
            print("Вывести альбомов: \(alertController.textFields?.last?.text ?? "None")")
            self.tableView.reloadData()
        }
        
        //MARK: добвляем экшены на кнопки
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        //MARK: Выводим алерт контроллер
        present(alertController, animated: true, completion: nil)
        self.tableView.reloadData()
    }
}

//MARK:- Расширения для использования tableView (тут мы формируем таблицу с айдшиниками альбомов которые получили по ссылке согласно модели)
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumIdArray.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell") as! CustomAlbumCell
        
        cell.albumID.text = albumIdArray[indexPath.row]
        
        return cell
    }
    
    //MARK: передаем id альбома по нажатию на определенную ячейку в следующий контроллер треков
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let trackView = storyboard.instantiateViewController(withIdentifier: "TrackList") as! TrackListController
        
        //MARK: присваиваем переменной albumIdForTrack значение полученной из данных массива (подставляем и получаем необходимый айди для подстановки в ссылку
        trackView.albumIdForTrack = albumIdArray[indexPath.row]
        
        navigationController?.pushViewController(trackView, animated: true)
    }
}

