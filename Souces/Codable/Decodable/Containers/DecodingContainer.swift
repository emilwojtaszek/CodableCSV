import Foundation

/// A CSV decoding container.
///
/// All CSV decoding container must implement this protocol.
internal protocol DecodingContainer {
    /// The coding key representing the receiving container.
    var codingKey: CSV.Key { get }
    /// The decoder containing the receiving container as its last decoding chain link.
    var decoder: ShadowDecoder! { get }
}

extension DecodingContainer {
    /// The path of coding keys taken to get to this point in decoding.
    ///
    /// This path doesn't include the receiving container.
    var codingPath: [CodingKey] {
        var result = self.decoder.codingPath
        if !result.isEmpty {
            result.removeLast()
        }
        return result
    }
    
    func superDecoder() throws -> Decoder {
        return self.decoder.superDecoder()
    }
}

/// A decoding container holding an overview of the whole CSV file.
///
/// This container is usually in charge of giving the user rows (one at a time) through unkeyed or keyed decoding containers.
internal protocol FileDecodingContainer: DecodingContainer {
    /// The newly created file decoding container will duplicate the receiving decoder and attach itself to it.
    /// - parameter decoder: The `superDecoder` calling the `unkeyedDecodingContainer()` function.
    init(decoder: ShadowDecoder)
}

/// A decoding container holding a CSV record/row.
///
/// This container is usually in charge of giving the user fields (one at a time) through unkeyed or keyed decoding containers.
internal protocol RecordDecodingContainer: DecodingContainer {
    /// The newly created record decoding container will duplicate the receiving decoder and attach itself to it.
    /// - parameter decoder: The `superDecoder` calling the `unkeyedDecodingContainer()` function.
    init(decoder: ShadowDecoder) throws
}