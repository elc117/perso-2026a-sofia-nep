module Test where

import Shared

runTest :: IO ()
runTest = do
    print "Testing..."
    wolf <- getInfo "Canis lupus"
    fox <- getInfo "Vulpes vulpes"
    human <- getInfo "Homo sapiens"

    let wolfInfo = parseInfo (Shared.head wolf)
    let foxInfo = parseInfo (Shared.head fox)
    let humanInfo = parseInfo (Shared.head human)

    let wolfLineage = Shared.snd wolfInfo
    let foxLineage = Shared.snd foxInfo
    let humanLineage = Shared.snd humanInfo

    let wolfFoxSimilarity = countMatching (wolfLineage, foxLineage)
    let wolfHumanSimilarity = countMatching (wolfLineage, humanLineage)

    if wolfFoxSimilarity == -1 || wolfHumanSimilarity == -1 then do
        print "Failure: Wolves, foxes, or humans don't exist?"
    else if wolfFoxSimilarity > wolfHumanSimilarity then do
        print "Success: Wolves are closer to foxes than to humans"
    else do
        print "Failure: Wolves are closer to humans than to foxes?"