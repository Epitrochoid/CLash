module Pretty where

import Syntax
import Text.PrettyPrint
import Data.Text hiding (empty)

-- | Takes the parameter list and formats it
--   to OpenCL syntax. Input parameters are
--   declared const, output params are not.
paramList :: [Parameter] -> Doc
paramList [] = empty
paramList ((Output t n):xs) =
        text ("__global " ++ (show t) ++ " *" ++ (unpack n)) <+> (paramList xs)
paramList ((Input t n):xs) =
        text ("__global const " ++ (show t) ++ " *" ++ (unpack n) ++ ",") <+> (paramList xs)

-- | Turns a VecExpr tree into its inline
--   OpenCL representation.
flattenVecExpr :: VecExpr -> Doc
flattenVecExpr (Vec n _) = text $ (unpack n) ++ "[gid]"
flattenVecExpr (Add a b) = (flattenVecExpr a) <+> (text "+") <+> (flattenVecExpr b)
