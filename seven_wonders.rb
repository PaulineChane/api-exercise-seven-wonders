# Pauline Chane
# Ada Developers Academy C14
# API Seven Wonders Activity
# 10/06/2020
# frozen_string_literal: true

require 'httparty'
require 'awesome_print'

BASE_URL = 'https://us1.locationiq.com/v1/'
LOCATION_IQ_KEY = 'pk.8a584f92c91c63cfec4b08e5b37557ab' # TOKEN REVOKED

def get_location(search_term)
  # change url
  path = "search.php?key=#{LOCATION_IQ_KEY}&q=#{search_term}&format=json"
  # get response
  response = HTTParty.get(BASE_URL + path)[0]

  { search_term => { lat: response['lat'], lon: response['lon'] } }
end

def find_seven_wonders
  seven_wonders = ['Great Pyramid of Giza', 'Gardens of Babylon', 'Colossus of Rhodes', 'Pharos of Alexandria', 'Statue of Zeus at Olympia', 'Temple of Artemis', 'Mausoleum at Halicarnassus']

  seven_wonders_locations = []

  seven_wonders.each do |wonder|
    sleep(0.5)
    seven_wonders_locations << get_location(wonder)
  end

  seven_wonders_locations
end

# Optional #1:
# given a location and a wonder of the world, return driving directions
def drive_to_wonder(location, wonder)
  # get coordinates for each location
  wonder_coord = get_location(wonder)
  sleep(0.5) # so the API doesn't think we're bad packets
  location_coord = get_location(location)
  # collect coordinates into string
  coordinates = "#{location_coord[location][:lat]},#{location_coord[location][:lon]};#{wonder_coord[wonder][:lat]},#{wonder_coord[wonder][:lon]}"
  # create path to GET info
  path = "directions/driving/#{coordinates}?key=#{LOCATION_IQ_KEY}&alternatives=false&geometries=geojson&overview=full"
  sleep(0.5)
  HTTParty.get(BASE_URL + path)
end

# Optional #2:
# Turn these locations into the names of places: [{ lat: 38.8976998, lon: -77.0365534886228}, {lat: 48.4283182, lon: -123.3649533 }, { lat: 41.8902614, lon: 12.493087103595503}]
# make a helper function
def reverse_location(lat, lon)
  path = "reverse.php?key=#{LOCATION_IQ_KEY}&lat=#{lat}&lon=#{lon}&format=json"
  response = HTTParty.get(BASE_URL + path)

  response.parsed_response["display_name"]
end

# make another function to find coords
def coords_to_names
  search_coords = [{ lat: 38.8976998, lon: -77.0365534886228},
                   {lat: 48.4283182, lon: -123.3649533 },
                   { lat: 41.8902614, lon: 12.493087103595503}]

  search_coords_names= []

  search_coords.each do |coord|
    sleep(0.5)
    search_coords_names << reverse_location(coord[:lat], coord[:lon])
  end

  search_coords_names
end
# Use awesome_print because it can format the output nicely
ap find_seven_wonders
# Expecting something like:
# [{"Great Pyramid of Giza"=>{:lat=>"29.9791264", :lon=>"31.1342383751015"}}, {"Gardens of Babylon"=>{:lat=>"50.8241215", :lon=>"-0.1506162"}}, {"Colossus of Rhodes"=>{:lat=>"36.3397076", :lon=>"28.2003164"}}, {"Pharos of Alexandria"=>{:lat=>"30.94795585", :lon=>"29.5235626430011"}}, {"Statue of Zeus at Olympia"=>{:lat=>"37.6379088", :lon=>"21.6300063"}}, {"Temple of Artemis"=>{:lat=>"32.2818952", :lon=>"35.8908989553238"}}, {"Mausoleum at Halicarnassus"=>{:lat=>"37.03788265", :lon=>"27.4241455276707"}}]
# OPTIONAL
# get driving directions from Cairo, Egypt to the Great Pyramid of Giza
ap drive_to_wonder("Cairo Egypt", "Great Pyramid of Giza")

ap coords_to_names