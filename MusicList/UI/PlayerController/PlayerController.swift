//
//  PlayerController.swift
//  MusicList
//
//  Created by Владислав on 28.06.2021.
//

import UIKit
import MediaPlayer

//MARK: - класс для плеера AVP (по заданию такой фреймворк использовать можно)
class PlayerController: UIViewController {
    
    var player: AVPlayer!
    
    //MARK: вспомогательные переменные
    var albumPlayerImage = UIImage()
    var albumPlayerName = String()
    var trackForPlay = String()
    var musicianForPalyer = String()
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var executorName: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var sliderTrackTime: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: присваиваем значение переменной в которую передадим изображение
        albumImage.image = albumPlayerImage
        
        //MARK: присваиваем значение переменной в которую передадим название альбома
        albumName.text = albumPlayerName
        
        //MARK: присваиваем значение переменной в которую передадим имя исполнителя
        executorName.text = musicianForPalyer
        
        //MARK: извлекаем трек - из переданного элемента в массиве (передача по нажатию на ячейку)
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: trackForPlay, ofType: "mp3")!))
        
        //MARK: настройка слайдера на продолжительность
        sliderTrackTime.maximumValue = Float(player.currentItem?.asset.duration.seconds ?? 0)
        
        //MARK: берем метод из коробки и устанавляиваем интервал времени. Поскольку мы меняем элемент интерфейса - выполнять будем в основной очереди
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1000), queue: DispatchQueue.main) {
            (time) in
            self.sliderTrackTime.value = Float(time.seconds)
        }
    }
    
    //MARK: взаимодействие с слайдером времени
    @IBAction func sliderTrackTimeAction(_ sender: Any) {
        
        //MARK: В фреймворке доступен метод перемотки seek используем его для перемотки в экшене слайдера
        player.seek(to: CMTime(seconds: Double(sliderTrackTime.value), preferredTimescale: 1000))
    }
    
    //MARK: воспроизведение трека/пауза
    @IBAction func buttonPlayPausePressed(_ sender: Any) {
        
        //MARK: Отслеживаем состояние кнопки и запускаем или останавливаем произведение из коробки + если играет  - то кнопка меняет изображение на паузу и наоборот
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for:. normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for:. normal)
        }
    }
}
