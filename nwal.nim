import nimpy
  
const BASE: array[8, array[3, int]] = [[0,0,0], [255,0,0], [0,255,0], [0,0,255], [255, 255, 0], [255, 0, 255], [0, 255, 255], [255,255,255]]
const MINBRIGHTNESS: int = 500
const MINDARKNESS: int = 35

proc abs(val: int): int =
  if val < 0:
      return val * -1
  return val

proc checkDistance(vec: array[3, int], vec2: array[3, int]): int =
  var distance = 0
  for i in 0..2:
    distance += abs(vec[i] - vec2[i])
  return distance

proc darken(color: array[3, int]): array[3, int] =
  var normalizedColor: array[3, int]
  for i,n in color:
    normalizedColor[i] = color[i]
  while normalizedColor[0] + normalizedColor[1] + normalizedColor[2] > MINDARKNESS:
    for i in 0..2:
        normalizedColor[i] -= 2
  return normalizedColor

proc normalize(color: array[3, int]): array[3, int] =
  var normalizedColor: array[3, int]
  var mainColor = 0
  for i,n in color:
    if color[mainColor] > color[i]:
      mainColor = i
    normalizedColor[i] = color[i]

  while normalizedColor[0] + normalizedColor[1] + normalizedColor[2] > MINBRIGHTNESS:
    for i in 0..2:
      if i == mainColor:
        normalizedColor[i] -= 3
      else:
        normalizedColor[i] -= 1

  while normalizedColor[0] + normalizedColor[1] + normalizedColor[2] < MINBRIGHTNESS:
    for i in 0..2:
      if i == mainColor:
        normalizedColor[i] += 1
      else:
        normalizedColor[i] += 3
  return normalizedColor

proc normalizeBrightness(vec: array[8, array[3, int]]): array[8, array[3, int]] =
  var normalizedVec: array[8, array[3, int]]
  for i,c in vec:
    if i == 0:
      normalizedVec[i] = darken(c)
    elif i == vec.len() - 1:
      normalizedVec[i] = c
    else:
      normalizedVec[i] = normalize(c)
  return normalizedVec

proc getBase(): array[8, array[3, int]] {.exportpy.} =
  return BASE

proc extract(px: seq[array[3, int]]): array[8, array[3, int]] {.exportpy.} =
  var colors: array[8, array[3, int]]
  var i = 0
  while i < px.len():
    for j,c in colors:
      if px[i][0] + px[i][1] + px[i][2] < 255 or px[i][0] + px[i][1] + px[i][2] > 600:
        continue
      elif c[0] == 0 and c[1] == 0 and c[2] == 0:
        colors[j] = px[i]
      elif checkDistance(BASE[j], c) > checkDistance(BASE[j], px[i]):
        colors[j] = px[i]
    i += 10
  return normalizeBrightness(colors)
