#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'digest'
require 'json'
require 'yaml'

ROOT = File.expand_path('..', __dir__)
INPUT = ENV.fetch('BC_TW_INPUT', File.join(ROOT, 'data', 'bc-tw.yaml'))
OUTPUT = ENV.fetch('BC_TW_OUTPUT', File.join(ROOT, 'data', 'bc-tw-lite.json'))
SOURCE_URL = 'https://gitlab.com/godfat/battle-cats-rolls/-/raw/master/build/bc-tw.yaml'

raw = YAML.safe_load(
  File.read(INPUT),
  permitted_classes: [Date],
  aliases: true
)

cats = raw.fetch('cats').each_with_object({}) do |(id, info), result|
  names = Array(info['name'])
  result[id.to_s] = {
    id: id,
    name: names[0] || id.to_s,
    names: names,
    rarity: info['rarity']
  }
end

gacha = raw.fetch('gacha').each_with_object({}) do |(id, info), result|
  result[id.to_s] = {
    cats: Array(info['cats'])
  }
end

events = raw.fetch('events').each_with_object({}) do |(event_id, event), result|
  result[event_id] = {
    id: event_id,
    name: event['name'],
    gacha_id: event['id'],
    start_on: event['start_on'].to_s,
    end_on: event['end_on'].to_s,
    rare: event['rare'],
    supa: event['supa'],
    uber: event['uber'],
    guaranteed: !!event['guaranteed'],
    step_up: !!event['step_up'],
    version: event['version']
  }
end

payload = {
  source: SOURCE_URL,
  source_sha256: Digest::SHA256.file(INPUT).hexdigest,
  lang: 'tw',
  cats: cats,
  gacha: gacha,
  events: events
}

File.write(OUTPUT, JSON.pretty_generate(payload))
puts "Wrote #{OUTPUT}"
