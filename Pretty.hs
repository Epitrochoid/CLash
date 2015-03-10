{-# LANGUAGE OverloadedStrings #-}
module Pretty where

import Syntax
import Text.PrettyPrint
import Data.Text hiding (empty, reverse, head)

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

-- | Toy implementation of the final printer.
kernelPrinter :: Kernel -> Doc
kernelPrinter (Kernel name params vecexpr) =
        let
            signature = "__kernel void" <+> txt name <> "(" <> (paramList params) <> ") {"
            gid = "int gid = get_global_id(0);"
            getname (Output _ n) = n
            outputname = getname . head . reverse
            vecops = (txt $ outputname params) <+> "=" <+> (flattenVecExpr vecexpr) <> ";"
        in
            signature $+$ (nest 4 gid) $+$ (nest 4 vecops) $+$ "}"

-- | Helper function for going directly from
--   Text to Doc
txt :: Text -> Doc
txt = text . unpack
