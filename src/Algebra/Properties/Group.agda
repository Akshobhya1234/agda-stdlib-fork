------------------------------------------------------------------------
-- The Agda standard library
--
-- Some derivable properties
------------------------------------------------------------------------

{-# OPTIONS --cubical-compatible --safe #-}

open import Algebra.Bundles

module Algebra.Properties.Group {g₁ g₂} (G : Group g₁ g₂) where

open Group G
open import Algebra.Definitions _≈_
open import Relation.Binary.Reasoning.Setoid setoid
open import Function.Base using (_$_; _⟨_⟩_)
open import Data.Product.Base using (_,_; proj₂)

ε⁻¹≈ε : ε ⁻¹ ≈ ε
ε⁻¹≈ε = begin
  ε ⁻¹      ≈⟨ sym $ identityʳ (ε ⁻¹) ⟩
  ε ⁻¹ ∙ ε  ≈⟨ inverseˡ ε ⟩
  ε         ∎

private

  left-helper : ∀ x y → x ≈ (x ∙ y) ∙ y ⁻¹
  left-helper x y = begin
    x              ≈⟨ sym (identityʳ x) ⟩
    x ∙ ε          ≈⟨ ∙-congˡ $ sym (inverseʳ y) ⟩
    x ∙ (y ∙ y ⁻¹) ≈⟨ sym (assoc x y (y ⁻¹)) ⟩
    (x ∙ y) ∙ y ⁻¹ ∎

  right-helper : ∀ x y → y ≈ x ⁻¹ ∙ (x ∙ y)
  right-helper x y = begin
    y              ≈⟨ sym (identityˡ y) ⟩
    ε          ∙ y ≈⟨ ∙-congʳ $ sym (inverseˡ x) ⟩
    (x ⁻¹ ∙ x) ∙ y ≈⟨ assoc (x ⁻¹) x y ⟩
    x ⁻¹ ∙ (x ∙ y) ∎

∙-cancelˡ : LeftCancellative _∙_
∙-cancelˡ x y z eq = begin
              y  ≈⟨ right-helper x y ⟩
  x ⁻¹ ∙ (x ∙ y) ≈⟨ ∙-congˡ eq ⟩
  x ⁻¹ ∙ (x ∙ z) ≈˘⟨ right-helper x z ⟩
              z  ∎

∙-cancelʳ : RightCancellative _∙_
∙-cancelʳ x y z eq = begin
  y            ≈⟨ left-helper y x ⟩
  y ∙ x ∙ x ⁻¹ ≈⟨ ∙-congʳ eq ⟩
  z ∙ x ∙ x ⁻¹ ≈˘⟨ left-helper z x ⟩
  z            ∎

∙-cancel : Cancellative _∙_
∙-cancel = ∙-cancelˡ , ∙-cancelʳ

⁻¹-involutive : ∀ x → x ⁻¹ ⁻¹ ≈ x
⁻¹-involutive x = begin
  x ⁻¹ ⁻¹              ≈˘⟨ identityʳ _ ⟩
  x ⁻¹ ⁻¹ ∙ ε          ≈˘⟨ ∙-congˡ $ inverseˡ _ ⟩
  x ⁻¹ ⁻¹ ∙ (x ⁻¹ ∙ x) ≈˘⟨ right-helper (x ⁻¹) x ⟩
  x                    ∎

⁻¹-injective : ∀ {x y} → x ⁻¹ ≈ y ⁻¹ → x ≈ y
⁻¹-injective {x} {y} eq = ∙-cancelʳ _ _ _ ( begin
  x ∙ x ⁻¹ ≈⟨ inverseʳ x ⟩
  ε        ≈˘⟨ inverseʳ y ⟩
  y ∙ y ⁻¹ ≈˘⟨ ∙-congˡ eq ⟩
  y ∙ x ⁻¹ ∎ )

⁻¹-anti-homo-∙ : ∀ x y → (x ∙ y) ⁻¹ ≈ y ⁻¹ ∙ x ⁻¹
⁻¹-anti-homo-∙ x y = ∙-cancelˡ _ _ _ ( begin
  x ∙ y ∙ (x ∙ y) ⁻¹    ≈⟨ inverseʳ _ ⟩
  ε                     ≈˘⟨ inverseʳ _ ⟩
  x ∙ x ⁻¹              ≈⟨ ∙-congʳ (left-helper x y) ⟩
  (x ∙ y) ∙ y ⁻¹ ∙ x ⁻¹ ≈⟨ assoc (x ∙ y) (y ⁻¹) (x ⁻¹) ⟩
  x ∙ y ∙ (y ⁻¹ ∙ x ⁻¹) ∎ )

identityˡ-unique : ∀ x y → x ∙ y ≈ y → x ≈ ε
identityˡ-unique x y eq = begin
  x              ≈⟨ left-helper x y ⟩
  (x ∙ y) ∙ y ⁻¹ ≈⟨ ∙-congʳ eq ⟩
       y  ∙ y ⁻¹ ≈⟨ inverseʳ y ⟩
  ε              ∎

identityʳ-unique : ∀ x y → x ∙ y ≈ x → y ≈ ε
identityʳ-unique x y eq = begin
  y              ≈⟨ right-helper x y ⟩
  x ⁻¹ ∙ (x ∙ y) ≈⟨ refl ⟨ ∙-cong ⟩ eq ⟩
  x ⁻¹ ∙  x      ≈⟨ inverseˡ x ⟩
  ε              ∎

identity-unique : ∀ {x} → Identity x _∙_ → x ≈ ε
identity-unique {x} id = identityˡ-unique x x (proj₂ id x)

inverseˡ-unique : ∀ x y → x ∙ y ≈ ε → x ≈ y ⁻¹
inverseˡ-unique x y eq = begin
  x              ≈⟨ left-helper x y ⟩
  (x ∙ y) ∙ y ⁻¹ ≈⟨ ∙-congʳ eq ⟩
       ε  ∙ y ⁻¹ ≈⟨ identityˡ (y ⁻¹) ⟩
            y ⁻¹ ∎

inverseʳ-unique : ∀ x y → x ∙ y ≈ ε → y ≈ x ⁻¹
inverseʳ-unique x y eq = begin
  y       ≈⟨ sym (⁻¹-involutive y) ⟩
  y ⁻¹ ⁻¹ ≈⟨ ⁻¹-cong (sym (inverseˡ-unique x y eq)) ⟩
  x ⁻¹    ∎
