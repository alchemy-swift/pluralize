extension String {
    public var pluralized: String {
        Inflector.default.pluralize(self)
    }
    
    public var singularized: String {
        Inflector.default.singularize(self)
    }
}
