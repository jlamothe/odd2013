import Data.String
import System.IO
import Text.CSV

main = do
  hSetBuffering stdout NoBuffering
  inFile   <- prompt "Input file: "
  outFile  <- prompt "Output file: "
  contents <- readFile inFile
  withFile outFile WriteMode $ \h -> processContents h $ lines contents

prompt :: String -> IO String
prompt msg = putStr msg >> getLine

processContents :: Handle -> [String] -> IO ()
processContents handle =
  mapM_ $ \x -> hPutStrLn handle $ processLine x

processLine :: String -> String
processLine x =
  case parseCSV "" x of
    Right (x : _) -> printCSV $ sanitizeCSV [x]
    _             -> "Error!"

sanitizeCSV :: CSV -> CSV
sanitizeCSV =
  foldr (\x acc-> sanitizeRecord x : acc) []

sanitizeRecord :: Record -> Record
sanitizeRecord =
  foldr (\x acc -> sanitizeField x : acc) []

sanitizeField :: Field -> Field
sanitizeField = unwords . words

-- jl
