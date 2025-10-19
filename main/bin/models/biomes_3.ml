open Utils.Types

(** 
  [random_biome_center] génère un centre de biome aléatoire pour chaque zone.

  @param zones La liste des zones distinctes.
  @return Une liste de tuiles représentant les centres de biomes.
*)
let random_biome_center (zones : zone list) : tile list =
  let rec aux (zone : zone list) (acc : tile list) : tile list =
    match zone with
    | [] -> acc
    | zone :: rest ->
      let r = Random.int zone.size in
      let tile = List.nth zone.tiles r in
      let modified_tile = { tile with biome_id = Random.int 9 + 1 } in
      aux rest (modified_tile :: acc)
  in
  aux zones []

(** 
  [generate_biomes] génère les biomes de la carte.

  @param tiles La liste des tuiles de la carte.
  @param zones La liste des zones distinctes.
  @return Une nouvelle liste de tuiles avec les biomes attribués.
*)
let generate_biomes (tiles : tile list) (zones : zone list) () : tile list =
  let all_spawn_points = random_biome_center zones in
  let rec aux (tiles : tile list) (spawn_points : tile list) (biomes : tile list) : tile list =
    match tiles with
    | [] -> List.rev biomes
    | tile :: rest ->
      let closest_spawn = List.fold_left (fun acc spawn ->
        let dist = sqrt (float_of_int ((tile.x - spawn.x) * (tile.x - spawn.x) + (tile.y - spawn.y) * (tile.y - spawn.y))) in
        match acc with
        | None -> Some (spawn, dist)
        | Some (_, d) -> if dist < d then Some (spawn, dist) else acc
      ) None spawn_points in
      match closest_spawn with
      | None -> aux rest spawn_points (tile :: biomes)
      | Some (spawn, _) -> aux rest spawn_points ({ tile with biome_id = spawn.biome_id } :: biomes)
  in
  aux tiles all_spawn_points []


