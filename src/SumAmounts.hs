module SumAmounts
  ( Obligation (..)
  , Line (..)
  , Settlement (..)
  , SettleError (..)
  , settle
  ) where

-- Obligation id, amount due, priority.
data Obligation = Obligation Integer Integer Integer
  deriving (Eq, Show)

-- Line id, applied amount.
data Line = Line Integer Integer
  deriving (Eq, Show)

-- Settlement lines, in input order, and the unapplied remainder.
data Settlement = Settlement [Line] Integer
  deriving (Eq, Show)

data SettleError = DuplicateId
  deriving (Eq, Show)

settle :: Integer -> [Obligation] -> Either SettleError Settlement
settle _ _ = error "not implemented"
