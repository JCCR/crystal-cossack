module Cossack
  # A connection to perform a real HTTP request using the standard library.
  class HTTPConnection < Connection
    def call(request : Request) : Response
      client = HTTP::Client.new(request.uri)
      client.connect_timeout = request.options.connect_timeout
      client.read_timeout = request.options.read_timeout

      http_response = client.exec(request.method, request.uri.to_s, request.headers, request.body)
      puts http_response.body_io
      Response.new(http_response.status_code, http_response.headers, http_response.body, http_response.body_io)
    rescue err # : IO::Timeout
      puts err.message
      raise err
    end
  end
end
