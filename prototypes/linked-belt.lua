local mod_name = "__LinkedBelts__"

local name = "linked-belt"
local ingredient = "underground-belt"
local technology = "logistics"

local subgroup = "belt"

local letters = {["linked-belt"]="a", ["fast-linked-belt"]="b", ["express-linked-belt"]="c"}
local letter = letters[name]
local order = "e[linked-belt]-"..letter.."["..name.."]"

local icon = mod_name.."/graphics/icons/"..name..".png"

local filename = mod_name.."/graphics/entity/"..name.."/"..name.."-structure.png"
local hr_filename = mod_name.."/graphics/entity/"..name.."/hr-"..name.."-structure.png"

local speeds = {
	["linked-belt"]=0.03125, 
	["fast-linked-belt"]=2*0.03125, 
	["express-linked-belt"]=3*0.03125
	}

if mods["DoubleSpeedBelts"] then
	speeds["express-linked-belt"]=4*0.03125
end

local speed = speeds[name]

local item = {
  type = "item",
  name = name,
  icon = icon,
  icon_size = 64,
  icon_mipmaps = 4,
  subgroup = subgroup,
  order = order,
  place_result = name,
  stack_size = 10
}

local recipe = {
  type = "recipe",
  name = name,
  enabled = false,
  ingredients = {{type="item", name=ingredient, amount=2}},
  results     = {{type="item", name=name, amount=2}}
}

table.insert (data.raw.technology[technology].effects, 
		{type = "unlock-recipe", recipe = name})
	

local entity = {
  type = "linked-belt",
  name = name,
  icon = icon,
  icon_size = 64,
  icon_mipmaps = 4,
  flags = {
    "placeable-neutral",
    "player-creation"
  },
  minable = {
    mining_time = 0.1,
    result = name
  },
  max_health = 160,
  corpse = "underground-belt-remnants",
  dying_explosion = "underground-belt-explosion",
  open_sound = {
    {
      filename = "__base__/sound/machine-open.ogg",
      volume = 0.5
    }
  },
  close_sound = {
    {
      filename = "__base__/sound/machine-close.ogg",
      volume = 0.5
    }
  },
  working_sound = {
    sound = {
      filename = "__base__/sound/underground-belt.ogg",
      volume = 0.2
    },
    max_sounds_per_type = 2,
    audible_distance_modifier = 0.5,
    persistent = true,
    use_doppler_shift = false
  },
  resistances = {
    {
      type = "fire",
      percent = 60
    },
    {
      type = "impact",
      percent = 30
    }
  },
  collision_box = {
    {
      -0.4,
      -0.4
    },
    {
      0.4,
      0.4
    }
  },
  selection_box = {
    {
      -0.5,
      -0.5
    },
    {
      0.5,
      0.5
    }
  },
  damaged_trigger_effect = {
    type = "create-entity",
    entity_name = "spark-explosion",
    offset_deviation = {
      {
        -0.5,
        -0.5
      },
      {
        0.5,
        0.5
      }
    },
    offsets = {
      {
        0,
        1
      }
    },
    damage_type_filters = "fire"
  },
  animation_speed_coefficient = 32,
  belt_animation_set = {
    animation_set = {
      filename = "__base__/graphics/entity/transport-belt/transport-belt.png",
      priority = "extra-high",
      width = 64,
      height = 64,
      frame_count = 16,
      direction_count = 20,
      hr_version = {
        filename = "__base__/graphics/entity/transport-belt/hr-transport-belt.png",
        priority = "extra-high",
        width = 128,
        height = 128,
        scale = 0.5,
        frame_count = 16,
        direction_count = 20
      }
    }
  },
--  fast_replaceable_group = "linked-belts",
  speed = speed,
  structure_render_layer = "object",
  structure = {
    direction_in = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 96,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          y = 192,
          scale = 0.5
        }
      }
    },
    direction_out = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    direction_in_side_loading = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 288,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          y = 576,
          scale = 0.5
        }
      }
    },
    direction_out_side_loading = {
      sheet = {
        filename = filename,
        priority = "extra-high",
        width = 96,
        height = 96,
        y = 192,
        hr_version = {
          filename = hr_filename,
          priority = "extra-high",
          width = 192,
          height = 192,
          y = 384,
          scale = 0.5
        }
      }
    },
    back_patch = {
      sheet = {
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-back-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-back-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    },
    front_patch = {
      sheet = {
        filename = "__base__/graphics/entity/underground-belt/underground-belt-structure-front-patch.png",
        priority = "extra-high",
        width = 96,
        height = 96,
        hr_version = {
          filename = "__base__/graphics/entity/underground-belt/hr-underground-belt-structure-front-patch.png",
          priority = "extra-high",
          width = 192,
          height = 192,
          scale = 0.5
        }
      }
    }
  },
  allow_clone_connection = true,
  allow_blueprint_connection = true,
  allow_side_loading = false
}

data:extend({item, recipe, entity})