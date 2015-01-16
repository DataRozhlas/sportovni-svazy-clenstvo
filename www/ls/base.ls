container = d3.select ig.containers.base
mapContainer = container.append \div
  ..attr \class \map

map = ig.initMap mapContainer
geojson = topojson.feature ig.data.okresy, ig.data.okresy.objects."data"
for feature in geojson.features
  feature.properties.all_all = feature.properties.dospeli_muzi + feature.properties.dospeli_zeny + feature.properties.dorost_muzi + feature.properties.dorost_zeny + feature.properties.zaci_muzi + feature.properties.zaci_zeny

layerDefs =
  * name: "celkem" headerSport: "Celkem", headerSum: "all_all"
  * name: "muži" headerSport: "Muži", headerSum: "dospeli_muzi"
  * name: "ženy" headerSport: "Ženy", headerSum: "dospeli_zeny"
  * name: "dorostenci" headerSport: "Dorostenci", headerSum: "dorost_muzi"
  * name: "dorostenky" headerSport: "Dorostenky", headerSum: "dorost_zeny"
  * name: "žáci" headerSport: "Žáci", headerSum: "zaci_muzi"
  * name: "žačky" headerSport: "Žačky", headerSum: "zaci_zeny"
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

layersAssoc['celkem'].addTo map
L.control.layers layersAssoc, {}, collapsed: no .addTo map
