module Test where

import Text
import Graphics.Element exposing (..)
import ElmTest.Run as Run
import ElmTest.Runner.Element as ElementRunner
import ElmTest.Runner.String  as StringRunner
import ElmTest.Test exposing (..)
import ElmTest.Assertion exposing (..)

import Array
import Matrix
import Matrix.Extra


fromList : Test
fromList = suite "From list"
  [ test "equal size" 
      <| assertEqual (2, 2) 
      <| case Matrix.fromList [[1, 1], [1, 1]] of Just v -> v.size,
    test "inequal size" 
      <| assertEqual (2, 3) 
      <| case Matrix.fromList [[1, 1], [1, 1], [3, 3]] of Just v -> v.size,
    test "inequal size" 
      <| assertEqual (3, 2) 
      <| case Matrix.fromList [[1, 1, 1], [1, 1, 1]] of Just v -> v.size,
    test "Non-consistent size" 
      <| assertEqual False 
      <| case Matrix.fromList [[1, 1, 1], [1, 1, 1, 5]] of 
        Just v -> True
        Nothing -> False
  ]

repeat : Test 
repeat  = suite "Repeat"
  [ test "equal size" 
      <| assertEqual (2, 2) 
      <| (\z -> z.size) <| Matrix.repeat 2 2 1,
    test "inequal size" 
      <| assertEqual (2, 3) 
      <| (\z -> z.size) <| Matrix.repeat 2 3 1,
    test "inequal size matrix fromList 2x3" 
      <| assertEqual (2, 3) 
      <| (\z -> z.size) <| (case Matrix.fromList [[1, 1], [1, 1], [1, 1]] of Just v -> v),
    test "inequal size with 1, 100" 
      <| assertEqual (1, 100) 
      <| (\z -> z.size) <| Matrix.repeat 1 100 1
  ]

get : Test 
get = suite "Get"
  [ test "square get first" 
      <| assertEqual (Just 1) 
      <| Matrix.get 0 0 <| Matrix.repeat 1 1 1,
    test "non-square get middle last row 2x3" 
      <| assertEqual (Just 5) 
      <| Matrix.get 1 1 <| case Matrix.fromList [[1, 2, 3], [4, 5, 6]] of Just v -> v,
    test "non-square get invalid 2x3" 
      <| assertEqual (Nothing) 
      <| Matrix.get 3 1 <| case Matrix.fromList [[1, 2, 3], [4, 5, 6]] of Just v -> v,
    test "non-square get last 3x2" 
      <| assertEqual (Just 6) 
      <| Matrix.get 1 2 <| case Matrix.fromList [[1, 2], [3, 4], [5, 6]] of Just v -> v,
    test "non-square get last 6x2" 
      <| assertEqual (Just 1) 
      <| Matrix.get 0 3 <| case Matrix.fromList [[1, 2], [3, 4], [5, 6], [1, 2], [3, 4], [5, 6]] of Just v -> v,
    test "square get from a bigger matrix (500 x 500)" 
      <| assertEqual (Just 1) 
      <| Matrix.get 24 50 <| Matrix.repeat 500 500 1,
    test "square get from a bigger matrix (500 x 500)" 
      <| assertEqual (Just 1) 
      <| Matrix.get 67 124 <| Matrix.repeat 500 500 1,
    test "square get from a huge matrix (500 x 500)" 
      <| assertEqual (Just 567) 
      <| Matrix.get 24 50 <| Matrix.set 24 50 567 <| Matrix.repeat 500 500 1,
    test "square get from a huge matrix (500 x 500)" 
      <| assertEqual (Just 567) 
      <| Matrix.get 399 432 <| Matrix.set 399 432 567 <| Matrix.repeat 500 500 1,
    test "square get invalid range y too big" 
      <| assertEqual (Nothing) 
      <| Matrix.get 1 2 <| Matrix.repeat 1 1 1,
    test "square get invalid range x too small" 
      <| assertEqual (Nothing) 
      <| Matrix.get -1 2 <| Matrix.repeat 1 1 1,
    test "square get invalid range y too small" 
      <| assertEqual (Nothing) 
      <| Matrix.get 1 -2 <| Matrix.repeat 1 1 1
  ]

getRow : Test 
getRow = suite "GetRow"
  [ test "square get first row" 
      <| assertEqual (Just <| Array.fromList [2, 3]) 
      <| Matrix.getRow 0  <| case Matrix.fromList [[2, 3], [1, 1]] of Just v -> v,
    test "square get last row" 
      <| assertEqual (Just <| Array.fromList [1, 1]) 
      <| Matrix.getRow 1  <| case Matrix.fromList [[2, 3], [1, 1]] of Just v -> v,
    test "non-square get last row 2x3" 
      <| assertEqual (Just <| Array.fromList [4, 5]) 
      <| Matrix.getRow 2  <| case Matrix.fromList [[2, 3], [1, 1], [4, 5]] of Just v -> v,
    test "non-square get last row 3x2" 
      <| assertEqual (Just <| Array.fromList [1, 1, 5]) 
      <| Matrix.getRow 1  <| case Matrix.fromList [[2, 3, 4], [1, 1, 5]] of Just v -> v,
    test "square get invalid range" 
      <| assertEqual (Nothing) 
      <| Matrix.getRow 5 <| Matrix.repeat 1 1 1,
    test "non-square get invalid range" 
      <| assertEqual (Nothing) 
      <| Matrix.getRow 5 <| Matrix.repeat 1 5 1
  ]

getColumn : Test 
getColumn = suite "GetColumn"
  [ test "square get first column 2x2" 
      <| assertEqual (Just <| Array.fromList [2, 1]) 
      <| Matrix.getColumn 0  <| case Matrix.fromList [[2, 3], [1, 6]] of Just v -> v,
    test "square get last column 2x2" 
      <| assertEqual (Just <| Array.fromList [3, 6]) 
      <| Matrix.getColumn 1  <| case Matrix.fromList [[2, 3], [1, 6]] of Just v -> v,
    test "non-square get first column 3x2" 
      <| assertEqual (Just <| Array.fromList [2, 1, 3]) 
      <| Matrix.getColumn 0  <| case Matrix.fromList [[2, 3], [1, 6], [3, 9]] of Just v -> v,
    test "non-square get last column 3x2" 
      <| assertEqual (Just <| Array.fromList [3, 6, 9]) 
      <| Matrix.getColumn 1  <| case Matrix.fromList [[2, 3], [1, 6], [3, 9]] of Just v -> v,
    test "non-square get first column 2x3" 
      <| assertEqual (Just <| Array.fromList [2, 1]) 
      <| Matrix.getColumn 0  <| case Matrix.fromList [[2, 3, 3], [1, 6, 9]] of Just v -> v,
    test "non-square get last column 2x3" 
      <| assertEqual (Just <| Array.fromList [3, 9]) 
      <| Matrix.getColumn 2  <| case Matrix.fromList [[2, 3, 3], [1, 6, 9]] of Just v -> v,
    test "get invalid range" 
      <| assertEqual (Nothing) 
      <| Matrix.getColumn 5 <| Matrix.repeat 1 1 1
  ]

set : Test
set = suite "Set"
  [ test "Set first" 
      <| assertEqual (Just 5) 
      <| Matrix.get 0 0 <| Matrix.set 0 0 5 <| Matrix.repeat 2 2 1,
    test "Set middle 3x3" 
      <| assertEqual (Just 5) 
      <| Matrix.get 1 1 <| Matrix.set 1 1 5 <| Matrix.repeat 3 3 1,
    test "invalid set 3x3" 
      <| assertEqual (Matrix.repeat 2 3 1)
      <| Matrix.set 3 1 5 <| Matrix.repeat 2 3 1,
    test "Set left middle 5x3" 
      <| assertEqual (Just 5) 
      <| Matrix.get 3 1 <| Matrix.set 3 1 5 <| Matrix.repeat 5 3 1,
    test "Set outside of range does nothing"
      <| (\x -> assertEqual (1, 1) x.size)
      <| Matrix.set 5 5 1 <| Matrix.repeat 1 1 1
  ]

update : Test
update = suite "Update"
  [ test "Update first element" 
      <| assertEqual (Just 5) 
      <| Matrix.get 1 1 <| Matrix.update 1 1 (\x -> 5) <| Matrix.repeat 2 2 1
  ]

map : Test
map = suite "Map"
  [ test "increment every value" 
      <| assertEqual (Matrix.repeat 2 2 2) 
      <|  Matrix.map (\x -> x + 1) <| Matrix.repeat 2 2 1,
    test "identity" 
      <| assertEqual (Matrix.repeat 2 2 1) 
      <|  Matrix.map identity <| Matrix.repeat 2 2 1
  ]

map2 : Test
map2 = suite "Map2"
  [ test "x + y" 
      <| assertEqual (Just <| Matrix.repeat 2 2 2) 
      <|  Matrix.map2 (\x y -> x + y) (Matrix.repeat 2 2 1) (Matrix.repeat 2 2 1)
  ]

indexedMap : Test
indexedMap = suite "IndexedMap"
  [ test "basic index map" 
      <| assertEqual (Matrix.repeat 1 1 0) 
      <|  Matrix.indexedMap (\x y _ -> x + y) <| Matrix.repeat 1 1 1,
    test "square (x,y) -> (x, y)" 
      <| assertEqual (case Matrix.fromList [[(0, 0), (1, 0), (2, 0)], [(0,1), (1,1), (2,1)], [(0,2), (1,2), (2,2)]] of Just v -> v) 
      <|  Matrix.indexedMap (\x y _ -> (x, y)) <| Matrix.repeat 3 3 1,
    test "non-square (x,y) -> (x, y)" 
      <| assertEqual (case Matrix.fromList [[(0, 0), (1, 0)], [(0, 1) ,(1,1)], [(0,2), (1,2)]] of Just v -> v) 
      <|  Matrix.indexedMap (\x y _ -> (x, y)) <| Matrix.repeat 2 3 1,
    test "non-square (x,y) -> x + y" 
      <| assertEqual (case Matrix.fromList [[0, 1], [1, 2], [2, 3]] of Just v -> v) 
      <|  Matrix.indexedMap (\x y _ -> x + y) <| Matrix.repeat 2 3 1,
    test "non-square (x,y) -> (x, y)" 
      <| assertEqual (case Matrix.fromList [[(0, 0), (1, 0), (2, 0)], [(0, 1), (1, 1), (2, 1)]] of Just v -> v) 
      <|  Matrix.indexedMap (\x y _ -> (x, y)) <| Matrix.repeat 3 2 1
  ]

toIndexedArray : Test
toIndexedArray = 
  let 
    twoByThreeXAndY : List ( (Int, Int), Int)
    twoByThreeXAndY = 
      [((0, 0), 0), ((1, 0), 1), 
       ((0, 1), 1), ((1, 1), 2), 
       ((0, 2), 2), ((1, 2), 3)] 
    threeByThreeXAndY = [
        ((0, 0), 0), ((1, 0), 1), ((2, 0), 2)
      , ((0, 1), 1), ((1, 1), 2), ((2, 1), 3)
      , ((0, 2), 2), ((1, 2), 3), ((2, 2), 4)
      ] 
    twoByThreeOnes = 
      [((0, 0), 1), ((1, 0), 1), 
       ((0, 1), 1), ((1, 1), 1), 
       ((0, 2), 1), ((1, 2), 1)] 
  in
    suite "toIndexedArray"
      [ test "(x,y) -> ((x, y), x + y) for non-square 2x3" 
          <| assertEqual twoByThreeXAndY
          <|  Array.toList <| Matrix.toIndexedArray <| Matrix.indexedMap (\x y _ -> x + y) <| Matrix.repeat 2 3 1,
        test "(x,y) -> ((x, y), x + y) for non-square 2x3" 
          <| assertEqual twoByThreeOnes
          <|  Array.toList <| Matrix.toIndexedArray <| Matrix.repeat 2 3 1,
        test "(x,y) -> ((x, y), x + y) for square 3x3" 
          <| assertEqual threeByThreeXAndY
          <|  Array.toList <| Matrix.toIndexedArray <| Matrix.indexedMap (\x y _ -> x + y) <| Matrix.repeat 3 3 1
      ]


filter : Test
filter = suite "Filter"
  [ test "Keep ones" 
      <| assertEqual (Array.repeat 2 1) 
      <|  Matrix.filter (\x -> x == 1) <| case Matrix.fromList [[2, 3], [1, 1]] of Just v -> v
  ]

concatRow : Test
concatRow = suite "Append row"
  [ test "add two rows to the end" 
      <| assertEqual (Just <| Matrix.repeat 1 4 2) 
      <|  Matrix.concatRow (Matrix.repeat 1 2 2) (Matrix.repeat 1 2 2)
  ]

concatColumn : Test
concatColumn = suite "Append column"
  [ test "add a column to the end" 
      <| assertEqual (Just <| Matrix.repeat 2 2 2) 
      <|  Matrix.concatColumn (Matrix.repeat 1 2 2) (Matrix.repeat 1 2 2)
  ]

add : Test
add = suite "Add"
  [ test "Add uniform square matricies"
      <| assertEqual (Just <| Matrix.repeat 2 2 3) 
      <|  Matrix.Extra.add (Matrix.repeat 2 2 1) (Matrix.repeat 2 2 2),
    test "Add non-uniform square matricies"
      <| assertEqual (Matrix.fromList [[3, 4], [4, 5]]) 
      <|  Matrix.Extra.add (case Matrix.fromList [[1, 2], [2, 3]] of Just v -> v) (Matrix.repeat 2 2 2),
    test "Can't add two differently sized matricies"
      <| assertEqual Nothing 
      <|  Matrix.Extra.add (Matrix.repeat 2 2 1) (Matrix.repeat 2 3 2)
  ]

subtract : Test
subtract = suite "Subtract"
  [ test "Subtract uniform square matricies"
      <| assertEqual (Just <| Matrix.repeat 2 2 0) 
      <|  Matrix.Extra.subtract (Matrix.repeat 2 2 1) (Matrix.repeat 2 2 1),
    test "Subtract non-uniform square matricies"
      <| assertEqual (Matrix.fromList [[-1, 0], [0, 1]]) 
      <|  Matrix.Extra.subtract (case Matrix.fromList [[1, 2], [2, 3]] of Just v -> v) (Matrix.repeat 2 2 2),
    test "Can't subtract two differently sized matricies"
      <| assertEqual Nothing 
      <|  Matrix.Extra.subtract (Matrix.repeat 2 2 1) (Matrix.repeat 2 3 2)
  ]

hadamard : Test 
hadamard = suite "Hadamard"
  [ test "Hadamard uniform square matricies"
      <| assertEqual (Just <| Matrix.repeat 2 2 1) 
      <|  Matrix.Extra.hadamard (Matrix.repeat 2 2 1) (Matrix.repeat 2 2 1),
    test "Hadamard non-uniform square matricies"
      <| assertEqual (Matrix.fromList [[2, 4], [4, 6]]) 
      <|  Matrix.Extra.hadamard (case Matrix.fromList [[1, 2], [2, 3]] of Just v -> v) (Matrix.repeat 2 2 2),
    test "Can't hadamard two differently sized matricies"
      <| assertEqual Nothing 
      <|  Matrix.Extra.hadamard (Matrix.repeat 2 2 1) (Matrix.repeat 2 3 2)
  ]

power : Test 
power = suite "power"
  [ test "power uniform square matricies"
      <| assertEqual (Just <| Matrix.repeat 2 2 1) 
      <|  Matrix.Extra.power (Matrix.repeat 2 2 1) (Matrix.repeat 2 2 1),
    test "power non-uniform square matricies"
      <| assertEqual (Matrix.fromList [[1, 4], [4, 9]]) 
      <|  Matrix.Extra.power (case Matrix.fromList [[1, 2], [2, 3]] of Just v -> v) (Matrix.repeat 2 2 2),
    test "Can't power two differently sized matricies"
      <| assertEqual Nothing 
      <|  Matrix.Extra.power (Matrix.repeat 2 2 1) (Matrix.repeat 2 3 2)
  ]

neighbours : Test
neighbours = suite "neighbours"
  [ test "neighbours of square matrix"
      <| assertEqual  8
      <|  List.sum <| Matrix.Extra.neighbours 1 1 <| Matrix.repeat 3 3 1,
    test "neighbours of square matrix in the bottom middle"
      <| assertEqual  5
      <|  List.sum <| Matrix.Extra.neighbours 0 1 <| Matrix.repeat 3 3 1,
    test "neighbours of square matrix in the bottom middle"
      <| assertEqual  [1, 1, 1]
      <|  Matrix.Extra.neighbours 0 0 <| Matrix.repeat 3 3 1
  ]

tests : Test
tests = suite "Tests"
  [ get,
    getRow,
    getColumn,


    concatRow,
    concatColumn,
    set,
    update,

    fromList,
    repeat, 
    
    map,
    map2,
    filter,
    indexedMap,
    toIndexedArray,

    add,
    subtract,
    hadamard,
    power,

    neighbours
  ]

results : String
results = StringRunner.runDisplay tests

main : Element
main = ElementRunner.runDisplay tests