module Pretty where

import Syntax
import Text.PrettyPrint
import Data.Text

paramList :: [Parameter] -> Doc
paramList ((Parameter t n):[]) =
        text ("__global " ++ (show t) ++ " *" ++ (unpack n))
paramList ((Parameter t n):xs) =
        text ("__global const " ++ (show t) ++ " *" ++ (unpack n) ++ ",") <+> (paramList xs)
