
    function print_filter(filter) {
      var f = eval(filter);
      if (typeof(f.length) != "undefined") {}else{}
      if (typeof(f.top) != "undefined") {f=f.top(Infinity);}else{}
      if (typeof(f.dimension) != "undefined") {f=f.dimension(function(d) { return "";}).top(Infinity);}else{}
      console.log(filter+"("+f.length+") = "+JSON.stringify(f).replace("[","[\n\t").replace(/}\,/g,"},\n\t").replace("]","\n]"));
    };

    var bil = dc.barChart("#teste");
    d3.json("ENOIS.json", function(data){

        var dados = crossfilter(data);
        var role = "MIDDLE"
        var roleDim = dados.dimension(function(d){
            return d.championId;
        });

        var damageGroup = roleDim.group().reduceSum(function(d){
            return d.physicalDamageDealt+d.magicDamageDealt+d.trueDamageDealt;
        });
        print_filter(roleDim);
        bil
                  .width(680)
                  .height(480)
                  .margins({ top: 10, right: 50, bottom: 30, left: 40 })
                  .x(d3.scale.ordinal().domain(data.map(function (d) {return d.championId; })))
                  .brushOn(false)
                  .yAxisLabel("Total por Gênero")
                  .dimension(roleDim)
                  .group(damageGroup)
                  .xUnits(dc.units.ordinal)
                bil.render();


    });
