------------------------------------------------------------------------
-- The Agda standard library
--
-- Automatic solver for equations over product and sum types
--
-- See examples at the bottom of the file for how to use this solver
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

module Function.Related.TypeIsomorphisms.Solver where

open import Algebra using (CommutativeSemiring)
import Algebra.Solver.Ring.NaturalCoefficients.Default
open import Data.Empty.Polymorphic using (⊥)
open import Data.Product.Base using (_×_)
open import Data.Sum.Base using (_⊎_)
open import Data.Unit.Polymorphic using (⊤)
open import Level using (Level)
open import Function.Inverse as Inv using (_↔_)
open import Function.Related as Related
open import Function.Related.TypeIsomorphisms

------------------------------------------------------------------------
-- The solver

module ×-⊎-Solver (k : Symmetric-kind) {ℓ} =
  Algebra.Solver.Ring.NaturalCoefficients.Default
    (×-⊎-commutativeSemiring k ℓ)

------------------------------------------------------------------------
-- Tests

private

  -- A test of the solver above.

  test : {ℓ : Level} (A B C : Set ℓ) →
         (⊤ × A × (B ⊎ C)) ↔ (A × B ⊎ C × (⊥ ⊎ A))
  test = solve 3 (λ A B C → con 1 :* (A :* (B :+ C)) :=
                            A :* B :+ C :* (con 0 :+ A))
                 Inv.id
    where open ×-⊎-Solver bijection
