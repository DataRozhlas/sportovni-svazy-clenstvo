container = d3.select ig.containers.base
mapContainer = container.append \div
  ..attr \class \map

map = ig.initMap mapContainer
geojson = topojson.feature ig.data.okresy, ig.data.okresy.objects."data"
console.log geojson.features.0.properties
layerDefs =
  * name: "Muži" headerSport: "Muži", headerSum: "dospeli_muzi"
  * name: "Ženy" headerSport: "Ženy", headerSum: "dospeli_zeny"
  * name: "Dorostenci" headerSport: "Dorostenci", headerSum: "dorost_muzi"
  * name: "Dorostenky" headerSport: "Dorostenky", headerSum: "dorost_zeny"
  * name: "Žáci" headerSport: "Žáci", headerSum: "zaci_muzi"
  * name: "Žačky" headerSport: "Žačky", headerSum: "zaci_zeny"
layersAssoc = {}

for let {name, headerSport, headerSum} in layerDefs
  max = d3.max geojson.features.map ->
    it.properties[headerSport] / it.properties[headerSum]
  scale = d3.scale.linear!
    ..domain [0, max * 0.5, max]
    ..range ['rgb(254,224,210)','rgb(252,146,114)','rgb(222,45,38)']
  layersAssoc[name] = L.geoJson do
    * geojson
    * style: (feature) ->
        fillOpacity: 0.8
        weight: 0
        color: scale feature.properties[headerSport] / feature.properties[headerSum]
      onEachFeature: (feature, layer) ->
        layer.bindPopup "#{feature.properties.NAZOK}, #name:<br>#{ig.utils.formatNumber feature.properties[headerSport]} sportuje z #{ig.utils.formatNumber feature.properties[headerSum]} celkem v kraji<br>(#{ig.utils.formatNumber 100 * feature.properties[headerSport] / feature.properties[headerSum], 2} %)"

L.control.layers layersAssoc, {}, collapsed: no .addTo map
