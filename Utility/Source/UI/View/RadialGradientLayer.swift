import Foundation

public class RadialGradientLayer: CALayer {

  public struct ViewModel {

    // swiftlint:disable:next nesting
    public struct Point {
      let color: UIColor
      let position: CGFloat

      public init(color: UIColor, position: CGFloat) {
        self.color = color
        self.position = position
      }
    }

    let points: [Point]

    public init(points: [Point]) {
      self.points = points
    }
  }

  public var viewModel: ViewModel { didSet { setNeedsDisplay() } }

  public init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
    needsDisplayOnBoundsChange = true
    contentsScale = UIScreen.main.scale
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("This class does not support NSCoding")
  }

  override public func draw(in ctx: CGContext) {
    let colors = viewModel.points.map { $0.color.cgColor }
    let locations = viewModel.points.map { $0.position.clamp(0.0, 1.0) }
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) {
      let center = bounds.size.pointValue * 0.5
      let radius = min(bounds.width / 2.0, bounds.height / 2.0)
      let options = CGGradientDrawingOptions.drawsAfterEndLocation
      ctx.drawRadialGradient(gradient, startCenter: center, startRadius: 0.0,
                             endCenter: center, endRadius: radius, options: options)
    }
  }
}
