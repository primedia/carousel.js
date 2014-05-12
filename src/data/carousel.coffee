define [
  'jquery',
  'flight/lib/component',
  './listing'
], (
  $,
  defineComponent,
  Listing
) ->

  carousel = ->
    @selector = (listingId) ->
      "[data-listingid=#{listingId}][data-photos]"

    @serveCarouselRequested = (ev, data) ->
      $.extend data, $(@selector(data.listingId)).data()
      listing = new Listing(data)
      @trigger 'dataCarouselServed', listing

    @after 'initialize', ->
      @on 'uiCarouselRequested', @serveCarouselRequested

  defineComponent carousel
