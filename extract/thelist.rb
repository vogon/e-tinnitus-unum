module Extract

module TheList

public
def self.read(path)
	parse(IO.read(path))
end

private
SHOW_DATE = %r{^
				(?<dates_month> jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)
				\s+ (?<dates_day> \d+(/\d+)*)
				(\s+ (?<dates_dayofweek> sun|mon|tue|wed|thr|fri|sat))?
			}x

private
SHOW_FIRST_LINE = /^#{SHOW_DATE}/

private
SHOW_SPLIT = %r{^
				(?<dates>#{SHOW_DATE})
				\s+
				(?<bill>.*)														# the bill
				\s+
				at
				\s+
				(?<venue>.*)													# the venue
			}x

private
def self.parse(str)
	shows = []
	lines = str.split("\n")

	body_start = lines.find_index do |str|
		str.match(SHOW_FIRST_LINE) != nil
	end

	rest = lines[body_start..-1]

	while rest do
		show, rest = parse_one_show(rest)
		shows << show
	end

	shows

end

def self.parse_one_show(lines)
	# assume the first element of lines is the first line of a show.
	# read forward, looking for the beginning of the next show.
	line_idx = 1
	done = false

	loop do
		if lines[line_idx].match(SHOW_FIRST_LINE) then
			# next show begins on this line.
			break
		elsif lines[line_idx].empty? then
			# \n\n -- list of shows is over.
			done = true
			break
		end

		line_idx += 1
	end

	# glue together the lines of the show description.
	show = lines[0...line_idx].reduce(:concat)

	m = show.match(SHOW_SPLIT)

	show =
		{
			:dates => parse_show_date(m[:dates]),
			:bill => nil,
			:venue => nil,
			:raw => m[0]
		}

	if done then
		return show, nil
	else
		return show, lines[line_idx..-1]
	end
end

def self.parse_show_date(str)
	dates = []

	m = str.match(SHOW_DATE)

	# fixme for correct year calculation
	year = Time.now.year
	month = m[:dates_month]

	remaining_days = m[:dates_day]

	while remaining_days =~ /\d+/ do
		day = Regexp.last_match[0]
		remaining_days = Regexp.last_match.post_match

		# fixme for working properly outside of PST/PDT
		dates << Time.local(year, month, day)
	end

	dates
end

end # module TheList

end # module Extract