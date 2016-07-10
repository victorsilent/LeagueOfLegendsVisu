 var teste;
    //Leitura do CSV
    d3.json("ENOIS.json", function(data) {

        function setProfileData(champ){
            $("#damageTaken").children("span").text(champ.totalDamageTaken);
            $("#winrate").children("span").text(champ.winrate);
            $("#popularity").children("span").text(champ.count/1000);
            $("#damageDealt").children("span").text(champ.totalDamageDealtToChampions);
            $("#levelAverage").children("span").text(champ.champLevel);
            $("#durationAverage").children("span").text(champ.duration);
            $("#kills").children("span").text(champ.kills);
            $("#deaths").children("span").text(champ.deaths);
            $("#assists").children("span").text(champ.assists);
            $("#farm").children("span").text(champ.minionsKilled);
            console.log($("#champImage").attr("src","http://ddragon.leagueoflegends.com/cdn/img/champion/loading/"+champ.championId+"_0.jpg"))
        }
        //Gerar os dados para o scatter plot
        function generateData(eixoX,eixoY,lane=false,champ=false){

            var opt1 = eixoX
            var opt2 = eixoY
            var series=[]
            var seriesJungle=[]
            var seriesAdc=[]
            var seriesTop=[]
            var seriesMid=[]
            var seriesSupport=[]
            if(lane==false){

                for(i=0;i<=data.length-1;i++){
                        if (data[i].role=="TOP"){
                            var champ = {name:data[i].championId,x:data[i][opt1],y:data[i][opt2]}
                            seriesTop.push(champ)
                            champ={}
                        }else if(data[i].role=="JUNGLE"){
                            var champ = {name:data[i].championId,x:data[i][opt1],y:data[i][opt2]}
                            seriesJungle.push(champ)
                            champ={}
                        }else if(data[i].role=="MIDDLE"){
                            var champ = {name:data[i].championId,x:data[i][opt1],y:data[i][opt2]}
                            seriesMid.push(champ)
                            champ={}
                        }else if(data[i].role=="DUO_CARRY"){
                            var champ = {name:data[i].championId,x:data[i][opt1],y:data[i][opt2]}
                            seriesAdc.push(champ)
                            champ={}
                        }else if(data[i].role=="DUO_SUPPORT"){
                            var champ = {name:data[i].championId,x:data[i][opt1],y:data[i][opt2]}
                            seriesSupport.push(champ)
                            champ={}
                        }
                }
                series=[seriesTop,seriesJungle,seriesMid,seriesAdc,seriesSupport]

                return series
            }else{
                var damageTaken = 0,damageDealt = 0,kills = 0,assists = 0,deaths = 0,goldEarned = 0, winrate = 0,count =0
                for(i=0;i<=data.length-1;i++){
                    if (data[i].role==lane){
                        if(data[i].winrate<champ.winrate){
                            winrate     +=  1
                        }
                        if(data[i].totalDamageTaken<champ.totalDamageTaken){
                            damageTaken +=  1
                        }
                        if(data[i].totalDamageDealtToChampions
                            <
                            champ.totalDamageDealtToChampions){

                            damageDealt +=  1

                        }
                        if(data[i].kills<champ.kills){
                            kills       +=  1
                        }
                        if(data[i].assists<champ.assists){
                            assists     +=  1
                        }
                        if(data[i].deaths<champ.deaths){
                            deaths      +=  1
                        }
                        if(data[i].goldEarned<champ.goldEarned){
                            goldEarned  +=  1
                        }
                        count++

                    }
                }
                series = {winrate:winrate,damageTaken:damageTaken,damageDealt:damageDealt,kills:kills,assists:assists,deaths:deaths,goldEarned:goldEarned,count:count}

                return series

            }



        }



        //Scatter Plot
        $(function () {
            $('#container').highcharts({
                chart: {
                    type: 'scatter',
                    zoomType: 'xy'
                },
                title: {
                    text: null
                },
                xAxis: {
                    title: {
                        enabled: true,
                        text: 'Height (cm)'
                    },
                    startOnTick: true,
                    endOnTick: true,
                    showLastLabel: true
                },
                yAxis: {
                    title: {
                        text: 'Weight (kg)'
                    }
                },
                legend: {
                    layout: 'vertical',
                    align: 'left',
                    verticalAlign: 'top',
                    x: 100,
                    y: 70,
                    floating: true,
                    backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColor) || '#FFFFFF',
                    borderWidth: 1
                },
                plotOptions: {
                     series: {
                        cursor: 'pointer',
                        point: {
                            events: {
                                click: function () {
                                    champProfile(this)
                                }
                            }
                        }
                    },
                    scatter: {
                        marker: {
                            radius: 5,
                            states: {
                                hover: {
                                    enabled: true,
                                    lineColor: 'rgb(100,100,100)'
                                }
                            }
                        },
                        states: {
                            hover: {
                                marker: {
                                    enabled: false
                                }
                            }
                        },
                        tooltip: {
                            headerFormat: '',
                            pointFormat: 'Champ: <b>{point.name}</b><br><b>{point.x}</b> damage tanken<br> <b>{point.y}</b> damage dealt<br>'
                        }
                    }
                },
                series: [{
                    name: 'Top',
                    color: 'rgba(27,158,119, .8)',
                    data: []

                },
                {
                    name: 'Jungle',
                    color: 'rgba(217,95,2, .8)',
                    data: []
                },
                {
                    name: 'Mid',
                    color: 'rgba(117,112,179, .8)',
                    data: []
                },
                {
                    name: 'Adc',
                    color: 'rgba(231,41,138, .8)',
                    data: []
                },
                {
                    name: 'Support',
                    color: 'rgba(102,166,30, .8)',
                    data: []
                }]
            });

            //Função para atualizar o grafico do scatter plot
            $('#button').click(function() {
                //1º select
                 var indexX = document.getElementById("eixoX").selectedIndex
                 var valueX = document.getElementById("eixoX").value
                 var nomeCertoX=$("#eixoX option")[indexX].id

                //2º select
                 var indexY = document.getElementById("eixoY").selectedIndex
                 var valueY = document.getElementById("eixoY").value
                 var nomeCertoY=$("#eixoY option")[indexY].id
                 console.log(valueX+' '+valueY)
                series = generateData(valueX,valueY)

                var chart = $('#container').highcharts();
                chart.series[0].setData(series[0], false);
                chart.series[1].setData(series[1], false);
                chart.series[2].setData(series[2], false);
                chart.series[3].setData(series[3], false);
                chart.series[4].setData(series[4], false);
                chart.yAxis[0].axisTitle.attr({
                    text: nomeCertoY
                });
                chart.xAxis[0].axisTitle.attr({
                    text: nomeCertoX
                });
                for(i=0;i<=4;i++){
                    chart.series[i].update({
                        tooltip:{
                            headerFormat: '',
                            pointFormat: 'Champ: <b>{point.name}</b><br><b>{point.x}</b> '+ nomeCertoX+'<br> <b>{point.y}</b> '+ nomeCertoY+'<br>'
                        }
                    })
                }

                $('#container').highcharts().redraw();

            });

            //Gerar os dados para o campeão selecionado no scatter plot
            function champProfile(champObject){
                var average = {}
                var lane = "nothing"

                switch(champObject.series.name){
                    case "Mid":
                        lane = "MIDDLE"
                        break;
                    case "Top":
                        lane = "TOP"
                        break;
                    case "Jungle":
                        lane = "JUNGLE"
                        break;
                    case "Adc":
                        lane = "DUO_CARRY"
                        break;
                    case "Support":
                        lane = "DUO_SUPPORT"
                        break;
                }
                var champ ={}

                for(i=0;i<=data.length-1;i++){

                    if (data[i].championId==champObject.name){
                        champ = data[i]

                    }
                }
                average = generateData(0,0,lane,champ)


                setProfileData(champ);

                //Radar generate
                var radarData
                radarData = [
                    [
                        {axis: "kills", value: average.kills},
                        {axis: "assists", value: average.assists},
                        {axis: "deaths", value: average.deaths},
                        {axis: "gold", value:average.goldEarned},
                        {axis: "taken", value: average.damageTaken},
                        {axis: "dealt", value: average.damageDealt},
                        {axis: "winrate", value: average.winrate}
                    ],
                    [
                        {axis: "kills", value: Math.floor(average.count/2)},
                        {axis: "assists", value: Math.floor(average.count/2)},
                        {axis: "deaths", value: Math.floor(average.count/2)},
                        {axis: "gold", value:Math.floor(average.count/2)},
                        {axis: "taken", value: Math.floor(average.count/2)},
                        {axis: "dealt", value: Math.floor(average.count/2)},
                        {axis: "winrate", value: Math.floor(average.count/2)}
                    ]
                    
                ];  
                        RadarChart.draw("#champProfile", radarData);
            }
        });
});