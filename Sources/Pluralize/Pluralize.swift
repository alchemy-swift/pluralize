import Foundation

final class Inflector {
    static let `default` = Inflector()
    
    private var pluralRules: [Rule] = []
    private var singularRules: [Rule] = []
    private var uncountables = Set<String>()
    private var irregularPlurals: [String: String] = [:]
    
    init() {
        setup()
    }
    
    func singularize(_ string: String) -> String {
        if uncountables.contains(string) {
            return string
        }
        
        for (singular, plural) in irregularPlurals {
            if plural == string {
                return singular
            }
        }
        
        for rule in singularRules {
            if let result = rule.replaceMatches(in: string) {
                return result
            }
        }

        return string
    }
    
    func pluralize(_ string: String) -> String {
        if uncountables.contains(string) {
            return string
        }
        
        if let plural = irregularPlurals[string] {
            return plural
        }
        
        for rule in pluralRules {
            if let result = rule.replaceMatches(in: string) {
                return result
            }
        }

        return string
    }
    
    func addSingular(pattern: String, replacement: String) {
        uncountables.remove(pattern)
        Rule(pattern: pattern, replacement: replacement).map { singularRules.insert($0, at: 0) }
    }
    
    func addPlural(pattern: String, replacement: String) {
        uncountables.remove(pattern)
        uncountables.remove(replacement)
        Rule(pattern: pattern, replacement: replacement).map { pluralRules.insert($0, at: 0) }
    }
    
    func addIrregular(singular: String, plural: String) {
        irregularPlurals[singular] = plural
    }
    
    func addUncountable(word: String) {
        uncountables.insert(word)
    }
}

/**
 Inflection rules adapted from Active Support
 Copyright (c) 2005-2020 David Heinemeier Hansson

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
extension Inflector {
    func setup() {
        addPlural(pattern:"$", replacement: "s")
        addPlural(pattern:"s$", replacement: "s")
        addPlural(pattern:"^(ax|test)is$", replacement: "$1es")
        addPlural(pattern:"(octop|vir)us$", replacement: "$1i")
        addPlural(pattern:"(octop|vir)i$", replacement: "$1i")
        addPlural(pattern:"(alias|status)$", replacement: "$1es")
        addPlural(pattern:"(bu)s$", replacement: "$1ses")
        addPlural(pattern:"(buffal|tomat)o$", replacement: "$1oes")
        addPlural(pattern:"([ti])um$", replacement: "$1a")
        addPlural(pattern:"([ti])a$", replacement: "$1a")
        addPlural(pattern:"sis$", replacement: "ses")
        addPlural(pattern:"(?:([^f])fe|([lr])f)$", replacement: "$1$2ves")
        addPlural(pattern:"(hive)$", replacement: "$1s")
        addPlural(pattern:"([^aeiouy]|qu)y$", replacement: "$1ies")
        addPlural(pattern:"(x|ch|ss|sh)$", replacement: "$1es")
        addPlural(pattern:"(matr|vert|ind)(?:ix|ex)$", replacement: "$1ices")
        addPlural(pattern:"^(m|l)ouse$", replacement: "$1ice")
        addPlural(pattern:"^(m|l)ice$", replacement: "$1ice")
        addPlural(pattern:"^(ox)$", replacement: "$1en")
        addPlural(pattern:"^(oxen)$", replacement: "$1")
        addPlural(pattern:"(quiz)$", replacement: "$1zes")

        addSingular(pattern: "s$", replacement: "")
        addSingular(pattern: "(ss)$", replacement: "$1")
        addSingular(pattern: "(n)ews$", replacement: "$1ews")
        addSingular(pattern: "([ti])a$", replacement: "$1um")
        addSingular(pattern: "((a)naly|(b)a|(d)iagno|(p)arenthe|(p)rogno|(s)ynop|(t)he)(sis|ses)$", replacement: "$1sis")
        addSingular(pattern: "(^analy)(sis|ses)$$", replacement: "$1sis")
        addSingular(pattern: "([^f])ves$", replacement: "$1fe")
        addSingular(pattern: "(hive)s$", replacement: "$1")
        addSingular(pattern: "(tive)s$", replacement: "$1")
        addSingular(pattern: "([lr])ves$", replacement: "$1f")
        addSingular(pattern: "([^aeiouy]|qu)ies$", replacement: "$1y")
        addSingular(pattern: "(s)eries$", replacement: "$1eries")
        addSingular(pattern: "(m)ovies$", replacement: "$1ovie")
        addSingular(pattern: "(x|ch|ss|sh)es$", replacement: "$1")
        addSingular(pattern: "^(m|l)ice$", replacement: "$1ouse")
        addSingular(pattern: "(bus)(es)?$", replacement: "$1")
        addSingular(pattern: "(o)es$", replacement: "$1")
        addSingular(pattern: "(shoe)s$", replacement: "$1")
        addSingular(pattern: "(cris|test)(is|es)$", replacement: "$1is")
        addSingular(pattern: "^(a)x[ie]s$", replacement: "$1xis")
        addSingular(pattern: "(octop|vir)(us|i)$", replacement: "$1us")
        addSingular(pattern: "(alias|status)(es)?$", replacement: "$1")
        addSingular(pattern: "^(ox)en", replacement: "$1")
        addSingular(pattern: "(vert|ind)ices$", replacement: "$1ex")
        addSingular(pattern: "(matr)ices$", replacement: "$1ix")
        addSingular(pattern: "(quiz)zes$", replacement: "$1")
        addSingular(pattern: "(database)s$", replacement: "$1")

        addIrregular(singular: "person", plural: "people")
        addIrregular(singular: "man", plural: "men")
        addIrregular(singular: "child", plural: "children")
        addIrregular(singular: "sex", plural: "sexes")
        addIrregular(singular: "move", plural: "moves")
        addIrregular(singular: "zombie", plural: "zombies")

        addUncountable(word: "equipment")
        addUncountable(word: "information")
        addUncountable(word: "rice")
        addUncountable(word: "money")
        addUncountable(word: "species")
        addUncountable(word: "series")
        addUncountable(word: "fish")
        addUncountable(word: "sheep")
        addUncountable(word: "jeans")
        addUncountable(word: "police")
    }
}

struct Rule: Hashable {
    let pattern: String
    let replacement: String
    var options: NSRegularExpression.Options = [.anchorsMatchLines, .caseInsensitive, .useUnicodeWordBoundaries]
    
    private let regex: NSRegularExpression
    
    init?(pattern: String, replacement: String) {
        do {
            self.pattern = pattern
            self.replacement = replacement
            self.regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            print("Encountered error creating NSRegularExpression for pattern \(pattern)!")
            return nil
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(pattern)
    }
    
    func replaceMatches(in string: String) -> String? {
        let mutable = NSMutableString(string: string)
        let matches = regex.replaceMatches(
            in: mutable,
            range: NSRange(location: 0, length: mutable.length),
            withTemplate: replacement
        )
        
        return matches > 0 ? String(mutable) : nil
    }
}
