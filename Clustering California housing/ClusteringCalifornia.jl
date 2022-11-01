using DataFrames
using JSON
using CSV
using VegaDatasets
using VegaLite
using Clustering
using FileIO

houses = CSV.File("newhouses.csv") |> DataFrame
names(houses)
vscodedisplay(houses)

cali_shape = JSON.parsefile("california-counties.json")
VV = VegaDatasets.VegaJSONDataset(cali_shape,"california-counties.json")

a = @vlplot(width=500, height=300) +
@vlplot(
    mark = {
        :geoshape,
        fill=:black,
        stroke=:white
    },
    data = {
        values = VV,
        format = {
            type=:topojson,
            feature=:cb_2015_california_county_20m
        }
    },
    projection={type=:albersUsa},
) +
@vlplot(
    :circle,
    data = houses,
    projection = {type=:albersUsa},
    longitude = "longitude:q",
    latitude = "latitude:q",
    size = {value = 12},
    color = "median_house_value:q"
)

bucketprice = Int.(div.(houses[!,:median_house_value], 100000))
extrema(bucketprice)
insertcols!(houses, 3, :cprice => bucketprice)

b = @vlplot(width=500, height=300) +
@vlplot(
    mark = {
        :geoshape,
        fill=:black,
        stroke=:white
    },
    data = {
        values = VV,
        format = {
            type=:topojson,
            feature=:cb_2015_california_county_20m
        }
    },
    projection={type=:albersUsa},
) +
@vlplot(
    :circle,
    data = houses,
    projection = {type=:albersUsa},
    longitude = "longitude:q",
    latitude = "latitude:q",
    size = {value = 12},
    color = "cprice:n"
)


# Clustering with k-MEANS

houses = dropmissing(houses)
X = houses[!, [:median_house_value]];
size(X)
C = kmeans(Matrix(X)', 5)
insertcols!(houses, 3, :Cluster => C.assignments)

c = @vlplot(width=500, height=300) +
@vlplot(
    mark = {
        :geoshape,
        fill=:black,
        stroke=:white
    },
    data = {
        values = VV,
        format = {
            type=:topojson,
            feature=:cb_2015_california_county_20m
        }
    },
    projection={type=:albersUsa},
) +
@vlplot(
    :circle,
    data = houses,
    projection = {type=:albersUsa},
    longitude = "longitude:q",
    latitude = "latitude:q",
    size = {value = 12},
    color = "Cluster:n"
)


save("CaliforniaCluster.svg", c)
save("CaliforniaClusterpng.png", c)