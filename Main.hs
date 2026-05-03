{-# LANGUAGE OverloadedStrings #-}
import Shared
import Test

import Data.Text.Lazy (pack)
import System.Environment
import Web.Scotty

stringifyInfo :: Maybe (String, [String]) -> String
stringifyInfo Nothing = "Not Found"
stringifyInfo (Just (str, list)) = unlines list ++ str

main :: IO ()
main = do
    args <- getArgs
    if not (null args) && Prelude.head args == "test" then do
        Test.runTest
    else
        scotty 2626 $ do
            get "/info/:name" $ do
                name <- pathParam "name"
                obj <- liftIO $ getInfo name
                let parsed = parseInfo (Shared.head obj)

                text $ pack (stringifyInfo parsed ++ "\n")
            get "/closer" $ do
                a <- queryParam "a"
                b <- queryParam "b"
                c <- queryParam "c"

                arrA <- liftIO $ getInfo a
                let objA = parseInfo (Shared.head arrA)
                let lineageA = Shared.snd objA

                arrB <- liftIO $ getInfo b
                let objB = parseInfo (Shared.head arrB)
                let lineageB = Shared.snd objB

                arrC <- liftIO $ getInfo c
                let objC = parseInfo (Shared.head arrC)
                let lineageC = Shared.snd objC

                let leftComparison = countMatching (lineageA, lineageB)
                let rightComparison = countMatching (lineageA, lineageC)

                let closer = if rightComparison > leftComparison then "C" else "B"
                let msg = if leftComparison == -1 || rightComparison == -1 then "Unknown species\n" else closer ++ " is closer to A\n"
                text $ pack msg
