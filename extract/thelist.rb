module Extract

module TheList

def self.parse(str)
	lines = str.split("\n")

	lines.find_index do |str|
		str.match(/^(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec) /) != nil
	end
end

def self.read(path)
	parse(IO.read(path))
end

end # module TheList

end # module Extract