
# http://sunlightlabs.github.io/datacommons
global INFLUENCE_EXPLORER_API = URI("http://transparencydata.com/")

# -------

macro sunlight_method__id_limit_cycle(method_name, method_route)
    quote
        function $(esc(symbol(method_name)))(auth::String, entity_id; limit = nothing, cycle = nothing, options...)
            method_route = $method_route

            args = Dict()
            limit != nothing && (args["limit"] = limit)
            cycle != nothing && (args["cycle"] = cycle)

            sunlight_get(auth, INFLUENCE_EXPLORER_API, "/api/1.0/aggregates/pol/$entity_id/$method_route", args; options...)
        end

        $(esc(symbol(method_name)))(entity_id; auth = "", options...) = $(esc(symbol(method_name)))(auth, entity_id; options...)
    end
end

# -------

macro sunlight_method__id_cycle(method_name, method_route)
    quote
        function $(esc(symbol(method_name)))(auth::String, entity_id; cycle = nothing, options...)
            method_route = $method_route

            args = Dict()
            cycle != nothing && (args["cycle"] = cycle)

            sunlight_get(auth, INFLUENCE_EXPLORER_API, "/api/1.0/aggregates/pol/$entity_id/$method_route", args; options...)
        end

        $(esc(symbol(method_name)))(entity_id; auth = "", options...) = $(esc(symbol(method_name)))(auth, entity_id; options...)
    end
end

# -------

macro sunlight_method__id(method_name, method_route)
    quote
        function $(esc(symbol(method_name)))(auth::String, entity_id; options...)
            method_route = $method_route
            sunlight_get(auth, INFLUENCE_EXPLORER_API, "/api/1.0/aggregates/pol/$entity_id/$method_route", Dict(); options...)
        end

        $(esc(symbol(method_name)))(entity_id; auth = "", options...) = $(esc(symbol(method_name)))(auth, entity_id; options...)
    end
end

# -------

@sunlight_method__id_limit_cycle "top_contributors" "contributors.json"

@sunlight_method__id_limit_cycle "top_industries" "contributors/industries.json"

@sunlight_method__id_cycle "unknown_industries" "contributors/industries_unknown.json"

@sunlight_method__id_limit_cycle "top_sectors" "contributors/sectors.json"

@sunlight_method__id_cycle "local_breakdown" "contributors/local_breakdown.json"

@sunlight_method__id_limit_cycle "contributor_breakdown" "contributors/type_breakdown.json"

@sunlight_method__id_limit_cycle "fec_summary" "fec_summary.json"

@sunlight_method__id "fec_independent_expenditures" "fec_indexp.json"



# -------

function entity_search(auth::String, search_str; entity_type = nothing, options...)
    args = {
        "search" => search_str
    }
    entity_type != nothing && (args["type"] = entity_type)

    sunlight_get(auth, INFLUENCE_EXPLORER_API, "/api/1.0/entities.json", args; options...)
end

entity_search(search_str; auth = "", options...) = entity_search(auth, search_str; options...)

# -------

function entity_info(auth::String, entity_id; cycle = nothing, options...)
    args = Dict()
    cycle != nothing && (args["cycle"] = cycle)

    sunlight_get(auth, INFLUENCE_EXPLORER_API, "/api/1.0/entities/$entity_id.json", args; options...)
end

entity_info(entity_id; auth = "", options...) = entity_info(auth, entity_id; options...)

# -------

function top_politicians(auth::String; limit = 16, cycle = nothing, options...)
    args = Dict()
    cycle != nothing && (args["cycle"] = cycle)

    sunlight_get(auth, INFLUENCE_EXPLORER_API, "/api/1.0/aggregates/pols/top_$limit.json", args; options...)
end

top_politicians(; auth = "", options...) = top_politicians(auth; options...)
