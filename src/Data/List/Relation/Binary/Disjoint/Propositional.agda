------------------------------------------------------------------------
-- The Agda standard library
--
-- Pairs of lists that share no common elements (propositional equality)
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

open import Relation.Binary

module Data.List.Relation.Binary.Disjoint.Propositional
  {a} {A : Set a} where

open import Relation.Binary.PropositionalEquality.Properties using (setoid)
open import Data.List.Relation.Binary.Disjoint.Setoid as DisjointUnique

------------------------------------------------------------------------
-- Re-export the contents of setoid uniqueness

open DisjointUnique (setoid A) public
