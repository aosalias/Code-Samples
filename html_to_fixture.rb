#!/usr/bin/env ruby
#Adam Olsen

require 'iconv'
require 'yaml'

write = File.open('/path/to/rails_app/test/fixtures/sites.yml', 'w')

sites = {}

for id in 1..49
  begin
    read = File.open("/path/to/php_app/sites/showsite.php?siteid=#{ id }", 'r')
    data = Iconv.conv('UTF-8', 'LATIN1', read.read)
  rescue
    nil
  end
  if data
    site = {}
    site['id'] = id

    start = data.index('"load(')+6
    endrange = data.index(',', start)
    real = data[start, endrange-start]
    site['lat'] = real

    start = endrange
    endrange = data.index(',', start+1) + 2
    real = data[start, endrange-start]
    site['lon'] = real

    start = data.index('<h1>') + 4
    endrange = data.index('</h1>')
    real = data[start, endrange-start]
    site['name'] = real

    key = real.downcase
    if key[-1] == 32 then key.slice!(-1) end
    key = key.gsub(' ', '_' ) + ":"

    start = data.index(/(locationid=)/, endrange) + 11
    endrange = data.index('">', start)
    real = data[start, endrange-start]
    site['location_id'] = real

    sites[key] = site
  end
end

write.puts sites.to_yaml
write.close
