define [
  'jquery'
  'flight/lib/component'
  'image-helper',
  'jquery-smoothdivscroll'
], (
  $,
  defineComponent,
  imageHelper
) ->

  carousel = ->

    _photos = undefined

    @defaultAttrs
      scrollableSelector: '#makeMeScrollable'
      propertyThumbSelector: "#property_thumb_non_carousel"

    @hide = ->
      @$node.hide()
      @select('propertyThumbSelector').show()

    @show = ->
      @$node.show()
      @select('propertyThumbSelector').hide()

      @addPhotosToCarousel()

    @addPhotosToCarousel = () ->
      @pendingImages = _photos.length
      @carousel = []
      @addCarouselPhoto(photo) for photo in _photos

    @addCarouselPhoto = (photo) ->
      path = imageHelper.url(photo.path, null, 250)
      img = new Image()
      @carousel.push(img)
      img.onerror = @onImageError
      img.onload = @onImageLoaded.bind(@)
      img.src = path
      $(img).addClass('carouselPhoto')

    @onImageError = ->
      @src = imageHelper.notFoundURL()

    @onImageLoaded = ->
      @pendingImages -= 1
      return if @pendingImages > 0

      @finalizeCarousel()

    @finalizeCarousel = ->
      scrollable = @select('scrollableSelector')
      scrollable.append(img) for img in @carousel
      scrollable.smoothDivScroll({
        autoScrollingMode: "always",
        autoScrollingDirection: "endlessloopright",
        autoScrollingStep: 1,
        autoScrollingInterval: 15
      })

      scrollable.smoothDivScroll("recalculateScrollableArea")
      scrollable.smoothDivScroll("startAutoScrolling")

    @pauseCarousel = ->
      @select('scrollableSelector').smoothDivScroll("stopAutoScrolling")

    @resumeCarousel = ->
      @select('scrollableSelector').smoothDivScroll("startAutoScrolling")

    @render = (ev, listing) ->
      _photos = listing.photos()
      if listing.data.hide_carousel then @hide() else @show()

    @run = (ev, listing) ->
      @trigger 'uiCarouselRequested', listing

    @after 'initialize', ->
      return unless @select('scrollableSelector').length
      @on document, 'dataCarouselServed', @render
      @on document, 'uiCarouselPause', @pauseCarousel
      @on document, 'uiCarouselResume', @resumeCarousel
      @on 'uiClassicCarouselRun', @run

  defineComponent carousel
