class UnderOs::UI::Image < UnderOs::UI::View
  wraps UIImageView, tag: 'img'

  def initialize(options)
    options = {srs: options} unless options.is_a?(Hash)

    super(options)

    @_.contentMode = UIViewContentModeScaleAspectFit

    self.src = options.delete(:src) if options.has_key?(:src)
  end

  def src
    @_.image
  end

  def src=(src)
    src = UIImage.imageNamed(src) if src.is_a?(String)
    @_.image = src
  end
end
