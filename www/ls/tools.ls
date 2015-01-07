ig.initMap = (parentElement) ->
  map = L.map do
    * parentElement.node!
    * minZoom: 6,
      maxZoom: 14,
      zoom: 8,
      center: [49.78, 15.5]
      maxBounds: [[48.3,11.6], [51.3,19.1]]

  baseLayer = L.tileLayer do
    * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
    * zIndex: 1
      opacity: 1
      attribution: 'mapová data &copy; přispěvatelé <a target="_blank" href="http://osm.org">OpenStreetMap</a>, obrazový podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

  labelLayer = L.tileLayer do
    * "https://samizdat.cz/tiles/ton_l1/{z}/{x}/{y}.png"
    * zIndex: 3
      opacity: 0.75

  map.addLayer baseLayer
  map.addLayer labelLayer
  map
