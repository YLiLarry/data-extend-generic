{-# LANGUAGE DeriveGeneric #-}

import Test.Hspec
import Data.Extend
import GHC.Generics


data Test = Test | TestA {
      f1 :: Int,
      f2 :: Maybe Int,
      f3 :: Maybe Int
   } | TestB {
      g1 :: Int,
      g2 :: Maybe Int,
      g3 :: Maybe Int
   } deriving (Show, Generic, Eq)

test1A = TestA 1 (Just 1) Nothing
test2A = TestA 0 Nothing (Just 2)

test1B = TestB 1 (Just 1) Nothing
test2B = TestB 0 Nothing (Just 2)



instance Extend Test

main :: IO ()
main = hspec $
   describe "Data.Extend" $ do
      specify "Int" $
         (2 `extend` 1) `shouldBe` (2 :: Int)
      specify "String" $
         ("b" `extend` "a") `shouldBe` "b"
      specify "data 0" $
         (Test `extend` Test) `shouldBe` Test
      specify "data 1" $
         (test2A `extend` test1A) `shouldBe` TestA 0 (Just 1) (Just 2)
      specify "data 2" $
         (test2B `extend` test1B) `shouldBe` TestB 0 (Just 1) (Just 2)
      specify "data 3" $
         (test2B `extend` test1A) `shouldBe` test2B
      specify "data 4" $
         (test1A `extend` test2B) `shouldBe` test1A
      specify "data 5" $
         (test2A `extend` test1B) `shouldBe` test2A
      specify "data 6" $
         (test1B `extend` test2A) `shouldBe` test1B


