{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Network.HTTP.Simple            ( httpBS, getResponseBody )
import           Control.Lens                   ( preview )
import           Data.Aeson.Lens                ( key, _String )
import qualified Data.ByteString.Char8         as BS
import           Data.Text                      ( Text )
import qualified Data.Text.IO                  as TIO

fetchJSON :: IO BS.ByteString
fetchJSON = do
  res <- httpBS "https://api.coindesk.com/v1/bpi/currentprice.json"
  return (getResponseBody res)

getRate :: BS.ByteString -> Maybe Text
getRate = preview (key "bpi" . key "EUR" . key "rate" . _String)


main :: IO ()
main = do
  json <- fetchJSON

  case getRate json of
    Nothing   -> TIO.putStrLn "No se pudo encontrar la tasa de Bitcoin :("
    Just rate -> TIO.putStrLn $ "La tasa actual de Bitcoin es " <> rate <> " euros"
