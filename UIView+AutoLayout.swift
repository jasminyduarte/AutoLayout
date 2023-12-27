import UIKit

extension UIView {

    @discardableResult
    func subviews(_ subViews: UIView...) -> UIView {
        subviews(subViews)
    }

    @discardableResult
    @objc
    func subviews(_ subViews: [UIView]) -> UIView {
        for sv in subViews {
            addSubview(sv)
            sv.translatesAutoresizingMaskIntoConstraints = false
        }
        return self
    }
}

extension UITableViewCell {

    @discardableResult
    override func subviews(_ subViews: [UIView]) -> UIView {
        contentView.subviews(subViews)
    }
}

extension UICollectionViewCell {

    @discardableResult
    override func subviews(_ subViews: [UIView]) -> UIView {
        contentView.subviews(subViews)
    }
}

extension UIStackView {

    @discardableResult
    private func arrangedSubviews(_ subViews: UIView...) -> UIView {
        arrangedSubviews(subViews)
    }

    @discardableResult
    func arrangedSubviews(_ subViews: [UIView]) -> UIView {
        subViews.forEach { addArrangedSubview($0) }
        return self
    }
}

public extension UIView {

    @discardableResult
    func left(_ points: Double = 0.0) -> Self {
        position(.left, points: points)
    }

    @discardableResult
    func left(equalTo anchor: NSLayoutXAxisAnchor, constant: Double = 0.0) -> Self {
        self.leftAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func right(_ points: Double = 0.0) -> Self {
        position(.right, points: -points)
    }

    @discardableResult
    func right(equalTo anchor: NSLayoutXAxisAnchor, constant: Double = 0.0) -> Self {
        self.rightAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
        return self
    }

    @discardableResult
    func top(_ points: Double = 0.0) -> Self {
        position(.top, points: points)
    }

    @discardableResult
    func top(equalTo anchor: NSLayoutYAxisAnchor, constant: Double = 0.0) -> Self {
        self.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func bottom(_ points: Double = 0.0) -> Self {
        position(.bottom, points: -points)
    }

    @discardableResult
    func bottom(equalTo anchor: NSLayoutYAxisAnchor, constant: Double = 0.0) -> Self {
        self.bottomAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
        return self
    }

    @discardableResult
    func leading(_ points: Double = 0.0) -> Self {
        position(.leading, points: points)
    }

    @discardableResult
    func leading(equalTo anchor: NSLayoutXAxisAnchor, constant: Double = 0.0) -> Self {
        self.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func trailing(_ points: Double = 0.0) -> Self {
        position(.trailing, points: -points)
    }

    @discardableResult
    func trailing(equalTo anchor: NSLayoutXAxisAnchor, constant: Double = 0.0) -> Self {
        self.trailingAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
        return self
    }

    fileprivate func position(_ position: NSLayoutConstraint.Attribute,
                              relatedBy: NSLayoutConstraint.Relation = .equal,
                              points: Double) -> Self {
        if let spv = superview {
            let c = constraint(item: self, attribute: position,
                               relatedBy: relatedBy,
                               toItem: spv,
                               constant: points)
            spv.addConstraint(c)
        }
        return self
    }

    fileprivate func constraint(item view1: AnyObject,
                                attribute attr1: NSLayoutConstraint.Attribute,
                                relatedBy: NSLayoutConstraint.Relation = .equal,
                                toItem view2: AnyObject? = nil,
                                attribute attr2: NSLayoutConstraint.Attribute? = nil, // Not an attribute??
                                multiplier: Double = 1,
                                constant: Double = 0) -> NSLayoutConstraint {
        let c =  NSLayoutConstraint(item: view1, attribute: attr1,
                                    relatedBy: relatedBy,
                                    toItem: view2, attribute: ((attr2 == nil) ? attr1 : attr2! ),
                                    multiplier: CGFloat(multiplier), constant: CGFloat(constant))
        c.priority = UILayoutPriority(rawValue: UILayoutPriority.defaultHigh.rawValue + 1)
        return c
    }

    @discardableResult
    func fillContainer(padding: Double = 0.0) -> Self {
        fillHorizontally(padding: padding)
        fillVertically(padding: padding)
        return self
    }

    @discardableResult
    func fillVertically(padding: Double = 0.0) -> Self {
        fill(.vertical, points: padding)
    }

    @discardableResult
    func fillHorizontally(padding: Double = 0.0) -> Self {
        fill(.horizontal, points: padding)
    }

    fileprivate func fill(_ axis: NSLayoutConstraint.Axis, points: Double = 0) -> Self {
        let a: NSLayoutConstraint.Attribute = axis == .vertical ? .top : .leading
        let b: NSLayoutConstraint.Attribute = axis == .vertical ? .bottom : .trailing
        if let spv = superview {
            let c1 = constraint(item: self, attribute: a, toItem: spv, constant: points)
            let c2 = constraint(item: self, attribute: b, toItem: spv, constant: -points)
            spv.addConstraints([c1, c2])
        }
        return self
    }

    @discardableResult
    func size(_ points: Double) -> Self {
        width(points)
        height(points)
        return self
    }

    @discardableResult
    func height(_ points: Double) -> Self {
        size(.height, points: points)
    }

    @discardableResult
    func width(_ points: Double) -> Self {
        size(.width, points: points)
    }

    fileprivate func size(_ attribute: NSLayoutConstraint.Attribute,
                          relatedBy: NSLayoutConstraint.Relation = .equal,
                          points: Double) -> Self {
        let c = constraint(item: self,
                           attribute: attribute,
                           relatedBy: relatedBy,
                           constant: points)
        if let spv = superview {
            spv.addConstraint(c)
        } else {
            addConstraint(c)
        }
        return self
    }

    @discardableResult
    func centerHorizontally(offset: Double = 0.0) -> Self {
        if let spv = superview {
            align(.vertical, v1: self, with: spv, offset: offset)
        }
        return self
    }
    
    @discardableResult
    func centerHorizontally(equalTo anchor: NSLayoutXAxisAnchor, constant: Double = 0.0) -> Self {
        self.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func centerVertically(offset: Double = 0.0) -> Self {
        if let spv = superview {
            align(.horizontal, v1: self, with: spv, offset: offset)
        }
        return self
    }
    
    @discardableResult
    func centerVertically(equalTo anchor: NSLayoutYAxisAnchor, constant: Double = 0.0) -> Self {
        self.centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }

    fileprivate func align(_ axis: NSLayoutConstraint.Axis, v1: UIView, with v2: UIView, offset: Double) {
        if let spv = v1.superview {
            let center: NSLayoutConstraint.Attribute = axis == .horizontal ? .centerY : .centerX
            let c = constraint(item: v1, attribute: center, toItem: v2, constant: offset)
            spv.addConstraint(c)
        }
    }
}
