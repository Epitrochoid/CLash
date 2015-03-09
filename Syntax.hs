module Syntax where

import Data.Text

-- | Convenience type for things that need names
type Name = Text

-- | Top level data type, a kernel has a name,
--   a list of parameters, and a VecExpr tree
--   that says what the kernel does.
data Kernel = Kernel Name [Parameter] VecExpr
            deriving Show

-- | Parameters are the input and output
--   vectors, each has a type.
data Parameter = Parameter Type Name
               deriving Show

-- | Represents the types of parameters and
--   vectors, corresponds to OpenCL types,
--   not Haskell types.
data Type = Float
          | Int

-- | Manual Show instance to avoid double
--   quote marks and fix capitalization.
instance Show Type where
        show Float = "float"
        show Int   = "int"

-- | AST for vector operations, the meat of
--   what an OpenCL kernel does.
data VecExpr = Vec Name Type
             | Add VecExpr VecExpr
             deriving Show
