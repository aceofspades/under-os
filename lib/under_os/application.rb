class UnderOs::Application

  def self.start(&block)
    @start_block = block
  end

  def initialize(ios_app, options)
    @_      = ios_app
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    instance_exec self, &self.class.instance_variable_get('@start_block')
  end

  def config
    @config ||= UnderOs::Config.new(self)
  end


end
