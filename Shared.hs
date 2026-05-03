{-# LANGUAGE OverloadedStrings #-}
module Shared where

import Data.Aeson
import Data.Aeson.KeyMap (KeyMap)
import Data.Aeson.Types
import Data.ByteString (ByteString)
import Data.Functor
import qualified Data.List.Split
import qualified Data.Strict
import Data.Text.Lazy (pack, replace, unpack)
import Network.HTTP.Simple

getBody :: String -> IO ByteString
getBody url = (parseRequest url >>= httpBS) <&> getResponseBody

urlSafe :: String -> String
urlSafe url =
    unpack $ replace (pack " ") (pack "%20") text
    where text = pack url

getInfo :: String -> IO (Maybe [KeyMap Value])
getInfo name = do
    body <- getBody $ urlSafe ("https://www.ebi.ac.uk/ena/taxonomy/rest/scientific-name/" ++ name)
    return $ decode (Data.Strict.toLazy body)

parseInfo :: Maybe (KeyMap Value) -> Maybe (String, [String])
parseInfo Nothing = Nothing
parseInfo (Just obj) =
    flip parseMaybe obj $ \x -> do
        scientificName <- x .: "scientificName"
        lineage <- x .: "lineage"
        return (scientificName, Data.List.Split.splitOn "; " lineage)

countMatching :: (Maybe [String], Maybe [String]) -> Int
countMatching (Nothing, _) = -1
countMatching (_, Nothing) = -1
countMatching (Just a, Just b) = length $ filter (`elem` b) a

head :: Maybe [a] -> Maybe a
head Nothing = Nothing
head (Just x) = if null x then Nothing else (Just . Prelude.head) x

snd :: Maybe (String, [String]) -> Maybe [String]
snd Nothing = Nothing
snd (Just x) = (Just . Prelude.snd) x