{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

module Data.Extend.Internal where

import Control.Applicative
import GHC.Generics


class GExtend a where
   gExtend :: a p -> a p -> a p


instance (GExtend (K1 i (m a)), Alternative m, GExtend b) => GExtend (K1 i (m a) :*: b) where
   gExtend (K1 a1 :*: b1) (K1 a2 :*: b2) = K1 (a1 <|> a2) :*: gExtend b1 b2

instance GExtend U1 where
   gExtend _ _ = U1

instance (Extend a) => GExtend (K1 i a) where
   gExtend (K1 a) (K1 b) = K1 $ extend a b

instance (GExtend a, GExtend b) => GExtend (a :*: b) where
   gExtend (a1 :*: b1) (a2 :*: b2) = gExtend a1 a2 :*: gExtend b1 b2

instance (GExtend a, GExtend b) => GExtend (a :+: b) where
   gExtend (L1 a) (L1 b) = L1 $ gExtend a b
   gExtend (R1 a) (R1 b) = R1 $ gExtend a b
   gExtend a _ = a

instance (GExtend a) => GExtend (M1 i c a) where
   gExtend (M1 a) (M1 b) = M1 $ gExtend a b


class Extend a where
   extend :: a -> a -> a
   default extend :: (Generic a, GExtend (Rep a)) => a -> a -> a
   extend a b = to $ gExtend (from a) (from b)


instance (Extend a) => Extend (Maybe a) where
   extend (Just a) _ = Just a
   extend Nothing  b = b

instance {-# OVERLAPPABLE #-} Extend a where
   extend a _ = a

