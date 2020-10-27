//
//  AndesTabViewBase.swift
//  AndesUI
//
//  Created by Jose Antonio Guglielminetti on 27/10/2020.
//

import Foundation

// swiftlint:disable implicitly_unwrapped_optional
internal class AndesTabViewBase: UIView, AndesTabView {
    private static var IndicatorViewRadius: CGFloat {
        return 3.0
    }
    private static var IndicatorViewScrollAnimationDuration: Double {
        return 0.2
    }
    private static var IndicatorViewHeight: CGFloat {
        return 3.0
    }
    private static var CellEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    }
    private static var GradienteViewWidth: CGFloat {
        return 80.0
    }
    private static var ScrollViewHeight: CGFloat {
        return 48.0
    }
    private static var SeparatorViewHeight: CGFloat {
        return 1.0
    }
    private static var GradientViewStartColor: UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    }
    private static var GradientViewEndColor: UIColor {
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    private let scrollview: UIScrollView = UIScrollView(frame: .zero)
    private let contentView: UIStackView = UIStackView(frame: .zero)
    private let indicatorView: UIView = UIView(frame: .zero)
    private let separatorView: UIView = UIView(frame: .zero)
    private let gradientView: AndesTabGradientView = AndesTabGradientView()
    private var indicatorLeadingConstraint: NSLayoutConstraint!
    private var indicatorTrailingConstraint: NSLayoutConstraint!
    private var items: [String] = []

    internal weak var delegate: AndesTabViewDelegate?

    internal var selectedIndex: Int? {
        return self.getSelectedIndex()
    }

    internal var count: Int {
        return self.items.count
    }

    override internal init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupUI()
    }

    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }

    internal func addItem(title: String) {
        self.items.append(title)

        let cell = self.getCell(title)
        self.contentView.addArrangedSubview(cell)

        if self.items.count == 1 {
            self.setActive(at: 0)
        }
    }

    internal func removeItem(at index: Int) {
        if self.items.indices.contains(index) == false {
            return
        }

        self.items.remove(at: index)

        let cell = self.contentView.arrangedSubviews[index]
        if let cell = cell as? UIControl, cell.isSelected {
            self.setInactive(at: index)
        }
        self.contentView.removeArrangedSubview(cell)
    }

    internal func setActive(at index: Int) {
        if self.items.indices.contains(index) == false {
            return
        }

        guard let cell = self.contentView.arrangedSubviews[index] as? UIControl else {
            return
        }

        if cell.isSelected {
            return
        }

        if let selectedIndex = self.selectedIndex {
            self.setInactive(at: selectedIndex)
        }

        cell.isSelected = true
        self.scrollToCell(index: index)
        self.moveIndicator(index: index, animated: true)

        self.delegate?.tab(didSelectItemAt: index)
    }

    internal func setInactive(at index: Int) {
        if self.items.indices.contains(index) == false {
            return
        }

        if let cell = self.contentView.arrangedSubviews[index] as? UIControl {
            cell.isSelected = false
        }

        self.delegate?.tab(didDeselectItemAt: index)
    }

    @objc
    internal func touchUpInside(sender: UIControl) {
        if let index = self.contentView.arrangedSubviews.firstIndex(of: sender) {
            self.setActive(at: index)
        }
    }

    @objc
    internal func touchDownInside(sender: UIControl) {
    }

    private func setupUI() {
        self.addSubview(self.scrollview)
        self.scrollview.addSubview(self.contentView)
        self.addSubview(self.gradientView)
        self.addSubview(self.separatorView)
        self.addSubview(self.indicatorView)

        self.setupIndicatorView()
        self.setupSeparatorView()
        self.setupScrollView()
        self.setupContentView()
        self.setupGradientView()
    }

    private func setupIndicatorView() {
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorLeadingConstraint = self.indicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        self.indicatorTrailingConstraint = self.indicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        NSLayoutConstraint.activate(
            [
                self.indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.indicatorLeadingConstraint,
                self.indicatorTrailingConstraint,
                self.indicatorView.heightAnchor.constraint(equalToConstant: AndesTabViewBase.IndicatorViewHeight)
            ]
        )
        self.indicatorView.backgroundColor = AndesStyleSheetManager.styleSheet.accentColor
    }

    private func setupSeparatorView() {
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.separatorView.heightAnchor.constraint(equalToConstant: AndesTabViewBase.SeparatorViewHeight)
            ]
        )
        self.separatorView.backgroundColor = AndesStyleSheetManager.styleSheet.textColorDisabled
    }

    private func setupScrollView() {
        self.scrollview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                self.scrollview.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.scrollview.topAnchor.constraint(equalTo: self.topAnchor),
                self.scrollview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                self.scrollview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.scrollview.heightAnchor.constraint(equalToConstant: AndesTabViewBase.ScrollViewHeight)
            ]
        )
        self.scrollview.showsVerticalScrollIndicator = false
        self.scrollview.showsHorizontalScrollIndicator = false
        self.scrollview.bounces = false
    }

    private func setupContentView() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                self.contentView.bottomAnchor.constraint(equalTo: self.scrollview.bottomAnchor),
                self.contentView.topAnchor.constraint(equalTo: self.scrollview.topAnchor),
                self.contentView.leadingAnchor.constraint(equalTo: self.scrollview.leadingAnchor),
                self.contentView.trailingAnchor.constraint(equalTo: self.scrollview.trailingAnchor),
                self.contentView.heightAnchor.constraint(equalTo: self.scrollview.heightAnchor)
            ]
        )
        self.contentView.distribution = .fillProportionally
        self.contentView.axis = .horizontal
        self.contentView.spacing = 0
    }

    private func setupGradientView() {
        self.gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                self.gradientView.topAnchor.constraint(equalTo: self.topAnchor),
                self.gradientView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                self.gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                self.gradientView.widthAnchor.constraint(equalToConstant: AndesTabViewBase.GradienteViewWidth)
            ]
        )
        self.gradientView.colors = [AndesTabViewBase.GradientViewStartColor, AndesTabViewBase.GradientViewEndColor]
        self.gradientView.backgroundColor = .clear
        self.gradientView.isUserInteractionEnabled = false
    }

    private func getCell(_ title: String) -> UIControl {
        let cell = AndesTabViewCell()

        cell.setTitle(title, for: .normal)
        cell.titleLabel?.font = AndesStyleSheetManager.styleSheet.semiboldSystemFontOfSize(size: AndesFontSize.bodyS)
        cell.contentEdgeInsets = AndesTabViewBase.CellEdgeInsets

        cell.setTitleColor(AndesStyleSheetManager.styleSheet.textColorPrimary, for: .normal)
        cell.setTitleColor(AndesStyleSheetManager.styleSheet.accentColor, for: .selected)
        cell.setTitleColor(AndesStyleSheetManager.styleSheet.accentColor600, for: .highlighted)
        cell.setTitleColor(AndesStyleSheetManager.styleSheet.accentColor600, for: [.selected, .highlighted])

        cell.setBackgroundColor(AndesStyleSheetManager.styleSheet.bgColorWhite, for: .normal)
        cell.setBackgroundColor(AndesStyleSheetManager.styleSheet.bgColorWhite, for: .selected)
        cell.setBackgroundColor(AndesStyleSheetManager.styleSheet.accentColor100, for: .highlighted)
        cell.setBackgroundColor(AndesStyleSheetManager.styleSheet.accentColor100, for: [.selected, .highlighted])

        cell.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        cell.addTarget(self, action: #selector(touchDownInside), for: .touchUpInside)

        return cell
    }

    private func scrollToCenter(cell: UIView) {
        self.scrollview.scrollRectToVisible(cell.frame, animated: true)
    }

    private func scrollToCell(index: Int) {
        if self.contentView.arrangedSubviews.indices.contains(index) == false {
            return
        }

        let cell = self.contentView.arrangedSubviews[index]
        self.scrollToCenter(cell: cell)
    }

    private func moveIndicator(index: Int, animated: Bool) {
        let cell = self.contentView.arrangedSubviews[index]

        self.indicatorLeadingConstraint.isActive = false
        self.indicatorLeadingConstraint = self.indicatorView.leadingAnchor.constraint(equalTo: cell.leadingAnchor)
        self.indicatorLeadingConstraint.isActive = true

        self.indicatorTrailingConstraint.isActive = false
        self.indicatorTrailingConstraint = self.indicatorView.trailingAnchor.constraint(equalTo: cell.trailingAnchor)
        self.indicatorTrailingConstraint.isActive = true

        if animated {
            UIView.animate(
                withDuration: AndesTabViewBase.IndicatorViewScrollAnimationDuration,
                animations: {
                    self.layoutIfNeeded()
                },
                completion: { _ in
                    self.updateIndicatorShape(index)
                }
            )
        }
    }

    private func updateIndicatorShape(_ index: Int) {
        if index == 0 {
            self.indicatorView.roundCorners(radius: AndesTabViewBase.IndicatorViewRadius, corners: [.topRight])
        } else if index == self.items.count - 1 {
            self.indicatorView.roundCorners(radius: AndesTabViewBase.IndicatorViewRadius, corners: [.topLeft])
        } else {
            self.indicatorView.roundCorners(radius: AndesTabViewBase.IndicatorViewRadius, corners: [.topLeft, .topRight])
        }
    }

    private func getSelectedIndex() -> Int? {
        return self.contentView.arrangedSubviews.compactMap({ $0 as? UIControl }).firstIndex(where: { $0.isSelected })
    }
}
