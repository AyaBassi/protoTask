//
//  MovieInfos.swift
//  ProtoTask
//
//  Created by Aya Bassi on 14/09/2022.
//

import Foundation

// MARK: - MovieInfos
struct MovieInfos: Codable {
    let id: Int
    let title, movieDescription, duration, releaseDate: String
    let images: [Image]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case movieDescription = "description"
        case duration, releaseDate, images
    }
}

// MARK: - Image
struct Image: Codable {
    let url: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case channelBadge = "channel-badge"
    case heroMobile = "hero-mobile"
    case heroWeb = "hero-web"
    case packshot = "packshot"
    case thumbnail = "thumbnail"
}

typealias Welcome = [MovieInfos]
