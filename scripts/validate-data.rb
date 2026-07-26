#!/usr/bin/env ruby
# frozen_string_literal: true

require 'digest'
require 'json'

ROOT = File.expand_path('..', __dir__)
INPUT = ENV.fetch('BC_TW_INPUT', File.join(ROOT, 'data', 'bc-tw.yaml'))
OUTPUT = ENV.fetch('BC_TW_OUTPUT', File.join(ROOT, 'data', 'bc-tw-lite.json'))

payload = JSON.parse(File.read(OUTPUT))
required_keys = %w[source source_sha256 lang cats gacha events]
missing_keys = required_keys - payload.keys
abort "Missing JSON keys: #{missing_keys.join(', ')}" unless missing_keys.empty?

expected_digest = Digest::SHA256.file(INPUT).hexdigest
abort 'Source digest does not match the YAML snapshot' unless payload['source_sha256'] == expected_digest

%w[cats gacha events].each do |section|
  abort "#{section} must be a non-empty object" unless payload[section].is_a?(Hash) && !payload[section].empty?
end

abort 'Unexpected language code' unless payload['lang'] == 'tw'

puts "Validated #{payload['cats'].length} cats, #{payload['gacha'].length} pools, and #{payload['events'].length} events"
