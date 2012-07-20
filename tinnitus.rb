require './global_config'
require 'sinatra'
require 'model/show'

class Tinnitus < Sinatra::Base
	get '/' do
		list_body = ""

		Show.each do |show|
			list_body += "<li>#{show.date}: #{show.raw}</li>"
		end

		content = "<html><body>Hello world! <ul>#{list_body}</ul></body></html>"

		content
	end
end