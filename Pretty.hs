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
