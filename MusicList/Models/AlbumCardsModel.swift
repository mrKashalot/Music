//
//  AlbumCardsModel.swift
//  MusicList
//
//  Created by Владислав on 29.06.2021.
//
import UIKit

//MARK: - Структры для получения карточек альбомов (я разделил структуры по разным файлам чтобы не мешать все в кучу) в карточках уже есть необходимая информация по исполнителям/треку/названию/году и т.д. 
struct AlbumData: Decodable {
    
    var collection: CollectionData
    
    enum CodingKeys: String, CodingKey {
        case collection
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        collection = try container.decode(CollectionData.self, forKey: .collection)
    }
}

//MARK: Так как у нас используются динамические ключи - придется создать еще 3 структуры и работать со словарем - в данном случаи из словаря нам нужна обложка/исполнитель/название альбома - обложка и название альбома одинаковы - может работать со словарем.
struct CollectionData: Decodable {
    var album: [String: AlbumId]
    var track: [String: Track]
    var people: [String: People]
    
    enum CodingKeys: String, CodingKey {
        case album, track, people
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        album = try container.decode([String: AlbumId].self, forKey: .album)
        track = try container.decode([String: Track].self, forKey: .track)
        people = try container.decode([String: People].self, forKey: .people)
    }
}

struct AlbumId: Decodable {
    var name: String
    var cover: String
    var coverUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name, cover, coverUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        cover = try container.decode(String.self, forKey: .cover)
        coverUrl = try container.decode(String.self, forKey: .coverUrl)
    }
}

struct Track: Decodable {
    var name: String
    var year: String
    var peopleIds: [String] //?
    
    enum CodingKeys: String, CodingKey {
        case name, year, peopleIds, id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        year = try container.decode(String.self, forKey: .year)
        peopleIds = try container.decode([String].self, forKey: .peopleIds)
    }
}

struct People: Decodable {
    var name: String
    var id: String

    enum CodingKeys: String, CodingKey {
        case name, id
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(String.self, forKey: .id)
    }
}

struct ModelForPlayer {
    var albumNamePlayer: String
    var idPeople: String
    var idTrack: [String]
    var coverAlbumPlayer: UIImage
    var musicianName: String
}
