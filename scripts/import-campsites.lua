-- simple script to import campsites and roads
-- see: https://github.com/openstreetmap/osm2pgsql/blob/master/flex-config/simple.lua
print('osm2pgsql version: ' .. osm2pgsql.version)

local tables = {}
tables.campsites_all = osm2pgsql.define_table{
    name = "campsites_all",
    -- This will generate a column "osm_id INT8" for the id, and a column
    -- "osm_type CHAR(1)" for the type of object: N(ode), W(way), R(relation)
    ids = { type = 'any', id_column = 'osm_id', type_column = 'osm_type' },
    columns = {
        { column = 'type', type = 'text' },
        { column = 'name', type = 'text' },
        { column = 'tags',  type = 'jsonb' },
        { column = 'geom',  type = 'geometry' },
    }
}

for name, dtable in pairs(tables) do
    print("\ntable '" .. name .. "':")
    print("  name='" .. dtable:name() .. "'")
end

-- Returns true if there are no tags left.
function clean_tags(tags)
    tags.odbl = nil
    tags['source:ref'] = nil
    -- tags.created_by = nil
    -- tags.source = nil
    return next(tags) == nil
end


function looks_like_a_campsite(object)
    return object.tags.tourism == 'camp_site' or object.tags.tourism == 'camp_pitch' or object.tags.tourism == 'caravan_site'
end

function process(object, geometry)
    tables.campsites_all:insert({
        type = object.type,
        name = object.tags.name,
        tags = object.tags,
        geom = geometry
    })
end

-- Called for every node in the input
function osm2pgsql.process_node(object)
    if clean_tags(object.tags) then
        return
    end

    if looks_like_a_campsite(object) then
        process(object, object:as_point())
    end
end

-- Called for every way in the input
function osm2pgsql.process_way(object)
    if clean_tags(object.tags) then
        return
    end
    
    -- object.is_closed is a simple, imperfect, way to check if this is a polygon
    if object.is_closed and looks_like_a_campsite(object) then
        process(object, object:as_polygon())
    end
end

function osm2pgsql.process_relation(object)
    if looks_like_a_campsite(object) then
        process(object, object:as_geometrycollection())
    end
end

--  print(inspect(object))