class UnderOs::HTTP::Request
  include UnderOs::Events

  attr_reader :url, :method, :params

  def initialize(url, options={}, &block)
    @url     = url
    @options = options

    on :complete, &block if block_given?
  end

  def on(*args, &block)
    callback = Proc.new{|event| block.call(event.params[:response]) } if block_given?
    super *args, &(callback || Proc.new{})
  end

  def send
    @request    = build_request
    @receiver   = Receiver.new(self)
    @connection = NSURLConnection.alloc.initWithRequest(@request, delegate:@receiver)
    @connection.start
  end

  def cancel
    @connection.cancel
  end

  def method
    method = @options[:method] || :get
    method = method.to_s.upcase
    method = 'GET' unless %w[GET POST PUT DELETE PATCH HEAD].include?(method)
    method
  end

  def headers
    @options[:headers] || {}
  end

  def cookies
    @options[:cookies] || {}
  end

protected

  def build_request
    url = NSURL.URLWithString(NSString.stringWithFormat(@url))
    NSMutableURLRequest.requestWithURL(url).tap do |request|
      request.setHTTPMethod self.method
      #request.setHTTPBody self.params

      cookies = self.cookies.map do |key, value|
        NSHTTPCookie.cookieWithProperties({
          NSHTTPCookieDomain => url.host,
          NSHTTPCookiePath   => "/",
          NSHTTPCookieName   => key.to_s,
          NSHTTPCookieValue  => value.to_s
        })
      end

      request.setAllHTTPHeaderFields NSHTTPCookie.requestHeaderFieldsWithCookies(cookies) if cookies.size > 0

      headers.each do |key, value|
        request.addValue value, forHTTPHeaderField:key
      end

      # [newRequest addValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
      # [newRequest setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    end
  end
end

