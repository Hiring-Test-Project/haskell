module Main where

import SumAmounts (Line (..), Obligation (..), SettleError (..), Settlement (..), settle)
import System.Exit (exitFailure, exitSuccess)

expect :: (Eq a, Show a) => String -> a -> a -> IO Bool
expect name got want
  | got == want = pure True
  | otherwise = do
      putStrLn $ "FAIL " ++ name
      putStrLn $ "  got  " ++ show got
      putStrLn $ "  want " ++ show want
      pure False

main :: IO ()
main = do
  results <- sequence
    [ expect "empty" (settle 100 []) (Right (Settlement [] 100))
    , expect "pays in full" (settle 500 [Obligation 1 100 1, Obligation 2 40 3, Obligation 3 60 2]) (Right (Settlement [Line 1 100, Line 2 40, Line 3 60] 300))
    , expect "higher priority first" (settle 60 [Obligation 1 80 1, Obligation 2 50 9, Obligation 3 25 9]) (Right (Settlement [Line 1 0, Line 2 50, Line 3 10] 0))
    , expect "same priority" (settle 10 [Obligation 1 50 1, Obligation 2 30 1, Obligation 3 20 1]) (Right (Settlement [Line 1 10, Line 2 0, Line 3 0] 0))
    , expect "spills to next priority" (settle 120 [Obligation 1 100 1, Obligation 2 40 5, Obligation 3 60 5]) (Right (Settlement [Line 1 20, Line 2 40, Line 3 60] 0))
    , expect "duplicate id" (settle 5 [Obligation 1 10 1, Obligation 1 4 2]) (Left DuplicateId)
    ]
  if and results then exitSuccess else exitFailure
