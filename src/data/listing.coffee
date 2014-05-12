define [], ->

  class Listing
    constructor: (data) ->
      @data = data
      @data.photos ||= []
      @data.floorplans ||= []
    photos: =>
      if @data.floorplans_flag then @data.photos.concat(@data.floorplans) else @data.photos
