module ExamplesADT where

import           Util
import           AST

adt = [Example {name = "match-pattern-hide", program = Program [ADT "int_pair" [("P",[TInt,TInt])]] (ELet ("p",EApply (EApply (EVar "P") (EIntLit 10)) (EIntLit 20)) (ECase (EVar "p") [(PData "P" [PVar "x",PVar "x"],EAdd (EVar "x") (EVar "x"))])), expectedType = Just TInt, expectedResult = RInt 40},Example {name = "list-match-2", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])],ADT "[[int]]" [("[]@[int]",[]),("::@[int]",[TData "[int]",TData "[[int]]"])],ADT "[[[int]]]" [("[]@[[int]]",[]),("::@[[int]]",[TData "[[int]]",TData "[[[int]]]"])]] (ELet ("xs",EApply (EApply (EVar "::@[int]") (EVar "[]@int")) (EApply (EApply (EVar "::@[int]") (EApply (EApply (EVar "::@int") (EIntLit 2)) (EVar "[]@int"))) (EApply (EApply (EVar "::@[int]") (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 1))) (EVar "[]@int"))) (EVar "[]@[int]")))) (ELetRec "sum" ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EIntLit 0),(PData "::@int" [PVar "x",PVar "xs'"],EAdd (EVar "x") (EApply (EVar "sum") (EVar "xs'")))],TInt) (ELetRec "map" ("f",TArrow (TData "[int]") TInt) (ELambda ("xs",TData "[[int]]") (ECase (EVar "xs") [(PData "[]@[int]" [],EVar "[]@int"),(PData "::@[int]" [PVar "x",PVar "xs'"],EApply (EApply (EVar "::@int") (EApply (EVar "f") (EVar "x"))) (EApply (EApply (EVar "map") (EVar "f")) (EVar "xs'")))]),TArrow (TData "[[int]]") (TData "[int]")) (ELet ("sum'",ELambda ("xs",TData "[[int]]") (EApply (EVar "sum") (EApply (EApply (EVar "map") (EVar "sum")) (EVar "xs")))) (ECase (EApply (EApply (EVar "::@[[int]]") (EVar "xs")) (EApply (EApply (EVar "::@[[int]]") (EVar "xs")) (EVar "[]@[[int]]"))) [(PData "[]@[[int]]" [],EBoolLit False),(PData "::@[[int]]" [PVar "_",PData "[]@[[int]]" []],EBoolLit False),(PData "::@[[int]]" [PVar "a",PData "::@[[int]]" [PVar "b",PData "[]@[[int]]" []]],EAnd (EEq (EApply (EVar "sum'") (EVar "a")) (EIntLit 1)) (EEq (EApply (EVar "sum'") (EVar "b")) (EIntLit 1))),(PData "::@[[int]]" [PVar "_",PData "::@[[int]]" [PVar "_",PData "[]@[[int]]" []]],EBoolLit False),(PVar "_",EBoolLit False)]))))), expectedType = Just TBool, expectedResult = RBool True},Example {name = "option-div", program = Program [ADT "option" [("Some",[TInt]),("None",[])]] (ELet ("safe_div",ELambda ("n1",TInt) (ELambda ("n2",TInt) (ECase (EVar "n2") [(PIntLit 0,EVar "None"),(PVar "_",EApply (EVar "Some") (EDiv (EVar "n1") (EVar "n2")))]))) (ELet ("test1",ECase (EApply (EApply (EVar "safe_div") (EIntLit 10)) (EIntLit 5)) [(PData "Some" [PIntLit 2],EBoolLit True),(PVar "_",EBoolLit False)]) (ELet ("test2",ECase (EApply (EApply (EVar "safe_div") (EIntLit 9)) (EIntLit 0)) [(PData "None" [],EBoolLit True),(PVar "_",EBoolLit False)]) (EAnd (EVar "test1") (EVar "test2"))))), expectedType = Just TBool, expectedResult = RBool True},Example {name = "list-length", program = Program [ADT "[char]" [("[]@char",[]),("::@char",[TChar,TData "[char]"])]] (ELetRec "length" ("xs",TData "[char]") (ECase (EVar "xs") [(PData "[]@char" [],EIntLit 0),(PData "::@char" [PVar "_",PVar "xs'"],EAdd (EIntLit 1) (EApply (EVar "length") (EVar "xs'")))],TInt) (EApply (EVar "length") (EApply (EApply (EVar "::@char") (ECharLit 't')) (EApply (EApply (EVar "::@char") (ECharLit 'h')) (EApply (EApply (EVar "::@char") (ECharLit 'i')) (EApply (EApply (EVar "::@char") (ECharLit 's')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EApply (EApply (EVar "::@char") (ECharLit 'i')) (EApply (EApply (EVar "::@char") (ECharLit 's')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EApply (EApply (EVar "::@char") (ECharLit 'a')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EApply (EApply (EVar "::@char") (ECharLit 't')) (EApply (EApply (EVar "::@char") (ECharLit 'e')) (EApply (EApply (EVar "::@char") (ECharLit 's')) (EApply (EApply (EVar "::@char") (ECharLit 't')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EApply (EApply (EVar "::@char") (ECharLit 's')) (EApply (EApply (EVar "::@char") (ECharLit 't')) (EApply (EApply (EVar "::@char") (ECharLit 'r')) (EApply (EApply (EVar "::@char") (ECharLit 'i')) (EApply (EApply (EVar "::@char") (ECharLit 'n')) (EApply (EApply (EVar "::@char") (ECharLit 'g')) (EVar "[]@char")))))))))))))))))))))))), expectedType = Just TInt, expectedResult = RInt 21},Example {name = "option-map", program = Program [ADT "option" [("Some",[TInt]),("None",[])]] (ELetRec "map" ("f",TArrow TInt TInt) (ELambda ("opt",TData "option") (ECase (EVar "opt") [(PData "Some" [PVar "n"],EApply (EVar "Some") (EApply (EVar "f") (EVar "n"))),(PData "None" [],EVar "None")]),TArrow (TData "option") (TData "option")) (ELet ("f",EApply (EVar "map") (ELambda ("x",TInt) (ESub (EVar "x") (EIntLit 10)))) (ELet ("test1",EApply (EVar "f") (EApply (EVar "Some") (EIntLit 233))) (ELet ("test2",EApply (EVar "f") (EVar "None")) (EAnd (ECase (EVar "test1") [(PData "Some" [PIntLit 223],EBoolLit True),(PVar "_",EBoolLit False)]) (ECase (EVar "test2") [(PData "None" [],EBoolLit True),(PVar "_",EBoolLit False)])))))), expectedType = Just TBool, expectedResult = RBool True},Example {name = "list-exists", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])]] (ELet ("empty",ELambda ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EBoolLit True),(PVar "_",EBoolLit False)])) (ELetRec "filter" ("p",TArrow TInt TBool) (ELambda ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EVar "[]@int"),(PData "::@int" [PVar "x",PVar "xs'"],EIf (EApply (EVar "p") (EVar "x")) (EApply (EApply (EVar "::@int") (EVar "x")) (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs'"))) (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs'")))]),TArrow (TData "[int]") (TData "[int]")) (ELet ("exists",ELambda ("p",TArrow TInt TBool) (ELambda ("xs",TData "[int]") (ENot (EApply (EVar "empty") (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs")))))) (EApply (EApply (EVar "exists") (ELambda ("x",TInt) (EGe (EVar "x") (EIntLit 0)))) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 1))) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 2))) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 3))) (EVar "[]@int")))))))), expectedType = Just TBool, expectedResult = RBool False},Example {name = "string", program = Program [ADT "[char]" [("[]@char",[]),("::@char",[TChar,TData "[char]"])]] (ELetRec "eq" ("s1",TData "[char]") (ELambda ("s2",TData "[char]") (ECase (EVar "s1") [(PData "[]@char" [],ECase (EVar "s2") [(PData "[]@char" [],EBoolLit True),(PVar "_",EBoolLit False)]),(PData "::@char" [PVar "x",PVar "xs"],ECase (EVar "s2") [(PData "::@char" [PVar "x'",PVar "xs'"],EIf (EEq (EVar "x") (EVar "x'")) (EApply (EApply (EVar "eq") (EVar "xs")) (EVar "xs'")) (EBoolLit False)),(PVar "_",EBoolLit False)])]),TArrow (TData "[char]") TBool) (ELetRec "concat" ("s1",TData "[char]") (ELambda ("s2",TData "[char]") (ECase (EVar "s1") [(PData "[]@char" [],EVar "s2"),(PData "::@char" [PVar "x",PVar "s1'"],EApply (EApply (EVar "::@char") (EVar "x")) (EApply (EApply (EVar "concat") (EVar "s1'")) (EVar "s2")))]),TArrow (TData "[char]") (TData "[char]")) (EApply (EApply (EVar "eq") (EApply (EApply (EVar "concat") (EApply (EApply (EVar "::@char") (ECharLit 'H')) (EApply (EApply (EVar "::@char") (ECharLit 'e')) (EApply (EApply (EVar "::@char") (ECharLit 'l')) (EApply (EApply (EVar "::@char") (ECharLit 'l')) (EApply (EApply (EVar "::@char") (ECharLit 'o')) (EApply (EApply (EVar "::@char") (ECharLit ',')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EVar "[]@char"))))))))) (EApply (EApply (EVar "::@char") (ECharLit 'H')) (EApply (EApply (EVar "::@char") (ECharLit 'a')) (EApply (EApply (EVar "::@char") (ECharLit 'm')) (EApply (EApply (EVar "::@char") (ECharLit 'l')) (EApply (EApply (EVar "::@char") (ECharLit '!')) (EVar "[]@char")))))))) (EApply (EApply (EVar "::@char") (ECharLit 'H')) (EApply (EApply (EVar "::@char") (ECharLit 'e')) (EApply (EApply (EVar "::@char") (ECharLit 'l')) (EApply (EApply (EVar "::@char") (ECharLit 'l')) (EApply (EApply (EVar "::@char") (ECharLit 'o')) (EApply (EApply (EVar "::@char") (ECharLit ',')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EApply (EApply (EVar "::@char") (ECharLit 'H')) (EApply (EApply (EVar "::@char") (ECharLit 'a')) (EApply (EApply (EVar "::@char") (ECharLit 'm')) (EApply (EApply (EVar "::@char") (ECharLit 'l')) (EApply (EApply (EVar "::@char") (ECharLit '!')) (EVar "[]@char")))))))))))))))), expectedType = Just TBool, expectedResult = RBool True},Example {name = "list-map", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])]] (ELetRec "map" ("f",TArrow TInt TInt) (ELambda ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EVar "[]@int"),(PData "::@int" [PVar "x",PVar "xs'"],EApply (EApply (EVar "::@int") (EApply (EVar "f") (EVar "x"))) (EApply (EApply (EVar "map") (EVar "f")) (EVar "xs'")))]),TArrow (TData "[int]") (TData "[int]")) (ELetRec "sum" ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EIntLit 0),(PData "::@int" [PVar "x",PVar "xs'"],EAdd (EVar "x") (EApply (EVar "sum") (EVar "xs'")))],TInt) (EApply (EVar "sum") (EApply (EApply (EVar "map") (ELambda ("x",TInt) (EAdd (EAdd (EVar "x") (EVar "x")) (EVar "x")))) (EApply (EApply (EVar "::@int") (EIntLit 0)) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 3))) (EApply (EApply (EVar "::@int") (EIntLit 9)) (EVar "[]@int")))))))), expectedType = Just TInt, expectedResult = RInt 18},Example {name = "match-hide", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])]] (ELet ("head",ELambda ("xs",TData "[int]") (ECase (EVar "xs") [(PData "::@int" [PVar "x",PVar "_"],EVar "x")])) (ELet ("xs",EApply (EApply (EVar "::@int") (EIntLit 1)) (EApply (EApply (EVar "::@int") (EIntLit 2)) (EApply (EApply (EVar "::@int") (EIntLit 3)) (EApply (EApply (EVar "::@int") (EIntLit 4)) (EApply (EApply (EVar "::@int") (EIntLit 5)) (EVar "[]@int")))))) (ECase (EVar "xs") [(PData "::@int" [PVar "x",PData "::@int" [PVar "y",PVar "xs"]],EAnd (EAnd (EEq (EVar "x") (EIntLit 1)) (EEq (EVar "y") (EIntLit 2))) (EEq (EApply (EVar "head") (EVar "xs")) (EIntLit 3)))]))), expectedType = Just TBool, expectedResult = RBool True},Example {name = "list-fold", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])]] (ELetRec "fold" ("f",TArrow TInt (TArrow TInt TInt)) (ELambda ("acc",TInt) (ELambda ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EVar "acc"),(PData "::@int" [PVar "x",PVar "xs'"],EApply (EApply (EApply (EVar "fold") (EVar "f")) (EApply (EApply (EVar "f") (EVar "acc")) (EVar "x"))) (EVar "xs'"))])),TArrow TInt (TArrow (TData "[int]") TInt)) (EApply (EApply (EApply (EVar "fold") (ELambda ("x",TInt) (ELambda ("y",TInt) (EMul (EVar "x") (EVar "y"))))) (EIntLit 1)) (EApply (EApply (EVar "::@int") (EIntLit 3)) (EApply (EApply (EVar "::@int") (EIntLit 100)) (EApply (EApply (EVar "::@int") (EIntLit 1)) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 10))) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 5))) (EApply (EApply (EVar "::@int") (EIntLit 9)) (EVar "[]@int"))))))))), expectedType = Just TInt, expectedResult = RInt 135000},Example {name = "list-filter", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])]] (ELetRec "filter" ("p",TArrow TInt TBool) (ELambda ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EVar "[]@int"),(PData "::@int" [PVar "x",PVar "xs'"],EIf (EApply (EVar "p") (EVar "x")) (EApply (EApply (EVar "::@int") (EVar "x")) (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs'"))) (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs'")))]),TArrow (TData "[int]") (TData "[int]")) (ELetRec "sum" ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EIntLit 0),(PData "::@int" [PVar "x",PVar "xs'"],EAdd (EVar "x") (EApply (EVar "sum") (EVar "xs'")))],TInt) (EApply (EVar "sum") (EApply (EApply (EVar "filter") (ELambda ("x",TInt) (EEq (EMod (EVar "x") (EIntLit 2)) (EIntLit 0)))) (EApply (EApply (EVar "::@int") (EIntLit 100)) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 98))) (EApply (EApply (EVar "::@int") (EIntLit 43)) (EApply (EApply (EVar "::@int") (ESub (EIntLit 0) (EIntLit 5))) (EApply (EApply (EVar "::@int") (EIntLit 23)) (EApply (EApply (EVar "::@int") (EIntLit 8)) (EVar "[]@int"))))))))))), expectedType = Just TInt, expectedResult = RInt 10},Example {name = "expr-eval-failure", program = Program [ADT "expr" [("C",[TInt]),("Add",[TData "expr",TData "expr"]),("Sub",[TData "expr",TData "expr"]),("Mul",[TData "expr",TData "expr"]),("Div",[TData "expr",TData "expr"]),("Mod",[TData "expr",TData "expr"])],ADT "result" [("Ok",[TInt]),("Err",[TData "[char]"])],ADT "[char]" [("[]@char",[]),("::@char",[TChar,TData "[char]"])]] (ELet ("add",ELambda ("x",TInt) (ELambda ("y",TInt) (EAdd (EVar "x") (EVar "y")))) (ELet ("sub",ELambda ("x",TInt) (ELambda ("y",TInt) (ESub (EVar "x") (EVar "y")))) (ELet ("mul",ELambda ("x",TInt) (ELambda ("y",TInt) (EMul (EVar "x") (EVar "y")))) (ELet ("mod",ELambda ("x",TInt) (ELambda ("y",TInt) (EMod (EVar "x") (EVar "y")))) (ELet ("helper",ELambda ("r1",TData "result") (ELambda ("r2",TData "result") (ELambda ("op",TArrow TInt (TArrow TInt TInt)) (ECase (EVar "r1") [(PData "Ok" [PVar "n1"],ECase (EVar "r2") [(PData "Ok" [PVar "n2"],EApply (EVar "Ok") (EApply (EApply (EVar "op") (EVar "n1")) (EVar "n2"))),(PData "Err" [PVar "s"],EApply (EVar "Err") (EVar "s"))]),(PData "Err" [PVar "s"],EApply (EVar "Err") (EVar "s"))])))) (ELetRec "eval" ("e",TData "expr") (ECase (EVar "e") [(PData "C" [PVar "n"],EApply (EVar "Ok") (EVar "n")),(PData "Add" [PVar "e1",PVar "e2"],EApply (EApply (EApply (EVar "helper") (EApply (EVar "eval") (EVar "e1"))) (EApply (EVar "eval") (EVar "e2"))) (EVar "add")),(PData "Sub" [PVar "e1",PVar "e2"],EApply (EApply (EApply (EVar "helper") (EApply (EVar "eval") (EVar "e1"))) (EApply (EVar "eval") (EVar "e2"))) (EVar "sub")),(PData "Mul" [PVar "e1",PVar "e2"],EApply (EApply (EApply (EVar "helper") (EApply (EVar "eval") (EVar "e1"))) (EApply (EVar "eval") (EVar "e2"))) (EVar "mul")),(PData "Div" [PVar "e1",PVar "e2"],ECase (EApply (EVar "eval") (EVar "e2")) [(PData "Ok" [PIntLit 0],EApply (EVar "Err") (EApply (EApply (EVar "::@char") (ECharLit 'd')) (EApply (EApply (EVar "::@char") (ECharLit 'i')) (EApply (EApply (EVar "::@char") (ECharLit 'v')) (EApply (EApply (EVar "::@char") (ECharLit 'i')) (EApply (EApply (EVar "::@char") (ECharLit 's')) (EApply (EApply (EVar "::@char") (ECharLit 'i')) (EApply (EApply (EVar "::@char") (ECharLit 'o')) (EApply (EApply (EVar "::@char") (ECharLit 'n')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EApply (EApply (EVar "::@char") (ECharLit 'b')) (EApply (EApply (EVar "::@char") (ECharLit 'y')) (EApply (EApply (EVar "::@char") (ECharLit ' ')) (EApply (EApply (EVar "::@char") (ECharLit 'z')) (EApply (EApply (EVar "::@char") (ECharLit 'e')) (EApply (EApply (EVar "::@char") (ECharLit 'r')) (EApply (EApply (EVar "::@char") (ECharLit 'o')) (EVar "[]@char")))))))))))))))))),(PData "Ok" [PVar "n2"],ECase (EApply (EVar "eval") (EVar "e1")) [(PData "Ok" [PVar "n1"],EApply (EVar "Ok") (EDiv (EVar "n1") (EVar "n2"))),(PData "Err" [PVar "s"],EApply (EVar "Err") (EVar "s"))]),(PData "Err" [PVar "s"],EApply (EVar "Err") (EVar "s"))]),(PData "Mod" [PVar "e1",PVar "e2"],EApply (EApply (EApply (EVar "helper") (EApply (EVar "eval") (EVar "e1"))) (EApply (EVar "eval") (EVar "e2"))) (EVar "mod"))],TData "result") (ELet ("test1",ECase (EApply (EVar "eval") (EApply (EApply (EVar "Add") (EApply (EApply (EVar "Sub") (EApply (EVar "C") (EIntLit 2))) (EApply (EVar "C") (ESub (EIntLit 0) (EIntLit 5))))) (EApply (EApply (EVar "Mul") (EApply (EVar "C") (EIntLit 4))) (EApply (EVar "C") (ESub (EIntLit 0) (EIntLit 9)))))) [(PData "Ok" [PVar "n"],EEq (EVar "n") (ESub (EIntLit 0) (EIntLit 29))),(PVar "_",EBoolLit False)]) (ELet ("test2",ECase (EApply (EVar "eval") (EApply (EApply (EVar "Mod") (EApply (EApply (EVar "Div") (EApply (EVar "C") (EIntLit 100))) (EApply (EVar "C") (EIntLit 3)))) (EApply (EVar "C") (EIntLit 20)))) [(PData "Ok" [PIntLit 13],EBoolLit True),(PVar "_",EBoolLit False)]) (ELet ("test3",ECase (EApply (EVar "eval") (EApply (EApply (EVar "Div") (EApply (EVar "C") (EIntLit 10))) (EApply (EApply (EVar "Sub") (EApply (EVar "C") (EIntLit 4))) (EApply (EVar "C") (EIntLit 4))))) [(PData "Err" [PData "::@char" [PCharLit 'd',PData "::@char" [PCharLit 'i',PData "::@char" [PCharLit 'v',PData "::@char" [PCharLit 'i',PData "::@char" [PCharLit 's',PData "::@char" [PCharLit 'i',PData "::@char" [PCharLit 'o',PData "::@char" [PCharLit 'n',PData "::@char" [PCharLit ' ',PData "::@char" [PCharLit 'b',PData "::@char" [PCharLit 'y',PData "::@char" [PCharLit ' ',PData "::@char" [PCharLit 'z',PData "::@char" [PCharLit 'e',PData "::@char" [PCharLit 'r',PData "::@char" [PCharLit 'o',PData "[]@char" []]]]]]]]]]]]]]]]]],EBoolLit True),(PVar "_",EBoolLit False)]) (EAnd (EAnd (EVar "test1") (EVar "test2")) (EVar "test3"))))))))))), expectedType = Just TBool, expectedResult = RBool True},Example {name = "expr-eval", program = Program [ADT "expr" [("C",[TInt]),("Add",[TData "expr",TData "expr"]),("Sub",[TData "expr",TData "expr"]),("Mul",[TData "expr",TData "expr"]),("Div",[TData "expr",TData "expr"]),("Mod",[TData "expr",TData "expr"])]] (ELetRec "eval" ("e",TData "expr") (ECase (EVar "e") [(PData "C" [PVar "n"],EVar "n"),(PData "Add" [PVar "e1",PVar "e2"],EAdd (EApply (EVar "eval") (EVar "e1")) (EApply (EVar "eval") (EVar "e2"))),(PData "Sub" [PVar "e1",PVar "e2"],ESub (EApply (EVar "eval") (EVar "e1")) (EApply (EVar "eval") (EVar "e2"))),(PData "Mul" [PVar "e1",PVar "e2"],EMul (EApply (EVar "eval") (EVar "e1")) (EApply (EVar "eval") (EVar "e2"))),(PData "Div" [PVar "e1",PVar "e2"],EDiv (EApply (EVar "eval") (EVar "e1")) (EApply (EVar "eval") (EVar "e2"))),(PData "Mod" [PVar "e1",PVar "e2"],EMod (EApply (EVar "eval") (EVar "e1")) (EApply (EVar "eval") (EVar "e2")))],TInt) (ELet ("test1",EEq (EApply (EVar "eval") (EApply (EApply (EVar "Add") (EApply (EApply (EVar "Sub") (EApply (EVar "C") (EIntLit 2))) (EApply (EVar "C") (ESub (EIntLit 0) (EIntLit 5))))) (EApply (EApply (EVar "Mul") (EApply (EVar "C") (EIntLit 4))) (EApply (EVar "C") (ESub (EIntLit 0) (EIntLit 9)))))) (ESub (EIntLit 0) (EIntLit 29))) (ELet ("test2",EEq (EApply (EVar "eval") (EApply (EApply (EVar "Mod") (EApply (EApply (EVar "Div") (EApply (EVar "C") (EIntLit 100))) (EApply (EVar "C") (EIntLit 3)))) (EApply (EVar "C") (EIntLit 20)))) (EIntLit 13)) (EAnd (EVar "test1") (EVar "test2"))))), expectedType = Just TBool, expectedResult = RBool True},Example {name = "list-match-1", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])]] (ELet ("xs",EApply (EApply (EVar "::@int") (EIntLit 1)) (EApply (EApply (EVar "::@int") (EIntLit 2)) (EApply (EApply (EVar "::@int") (EIntLit 3)) (EVar "[]@int")))) (ECase (EVar "xs") [(PData "[]@int" [],EBoolLit False),(PData "::@int" [PIntLit 1,PData "::@int" [PIntLit 2,PData "[]@int" []]],EBoolLit False),(PData "::@int" [PIntLit 1,PData "::@int" [PIntLit 2,PData "::@int" [PIntLit 3,PData "[]@int" []]]],EBoolLit True),(PVar "_",EBoolLit False)])), expectedType = Just TBool, expectedResult = RBool True},Example {name = "list-forall", program = Program [ADT "[int]" [("[]@int",[]),("::@int",[TInt,TData "[int]"])]] (ELetRec "length" ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EIntLit 0),(PData "::@int" [PVar "_",PVar "xs'"],EAdd (EIntLit 1) (EApply (EVar "length") (EVar "xs'")))],TInt) (ELetRec "filter" ("p",TArrow TInt TBool) (ELambda ("xs",TData "[int]") (ECase (EVar "xs") [(PData "[]@int" [],EVar "[]@int"),(PData "::@int" [PVar "x",PVar "xs'"],EIf (EApply (EVar "p") (EVar "x")) (EApply (EApply (EVar "::@int") (EVar "x")) (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs'"))) (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs'")))]),TArrow (TData "[int]") (TData "[int]")) (ELet ("forall",ELambda ("p",TArrow TInt TBool) (ELambda ("xs",TData "[int]") (EEq (EApply (EVar "length") (EApply (EApply (EVar "filter") (EVar "p")) (EVar "xs"))) (EApply (EVar "length") (EVar "xs"))))) (EApply (EApply (EVar "forall") (ELambda ("x",TInt) (EGt (EVar "x") (EIntLit 0)))) (EApply (EApply (EVar "::@int") (EIntLit 1)) (EApply (EApply (EVar "::@int") (EIntLit 2)) (EApply (EApply (EVar "::@int") (EIntLit 3)) (EVar "[]@int")))))))), expectedType = Just TBool, expectedResult = RBool True}] ++ [Example {name = "match-ctor-of-bad-type-1", program = Program [ADT "my_type1" [("A",[TInt,TInt]),("B",[TChar,TChar])],ADT "my_type2" [("C",[TInt])]] (ELet ("x",EApply (EVar "C") (EIntLit 1)) (ECase (EVar "x") [(PData "A" [PVar "n1",PVar "n2"],EEq (EVar "n1") (EVar "n2")),(PData "B" [PVar "c1",PVar "c2"],EEq (EVar "c1") (EVar "c2"))])), expectedType = Nothing, expectedResult = RInvalid},Example {name = "match-ctor-arg-bad-type", program = Program [ADT "my_type1" [("A",[TInt,TInt]),("B",[TChar,TChar])]] (ELet ("x",EApply (EApply (EVar "A") (EIntLit 10)) (EIntLit 10)) (ECase (EVar "x") [(PData "A" [PVar "n1",PVar "n2"],EEq (EVar "n1") (EVar "n2")),(PData "B" [PIntLit 10,PVar "c2"],EEq (EVar "c1") (EVar "c2"))])), expectedType = Nothing, expectedResult = RInvalid},Example {name = "undecl-var-2", program = Program [ADT "my_type1" [("A",[TInt,TInt])]] (ELet ("v1",EApply (EApply (EVar "A") (EIntLit 10)) (EIntLit 20)) (ELet ("v2",EApply (EApply (EVar "A") (EIntLit 30)) (EIntLit 40)) (EAdd (ECase (EVar "v1") [(PData "A" [PVar "x",PIntLit 20],EIntLit 20)]) (ECase (EVar "v1") [(PData "A" [PVar "y",PIntLit 40],EAdd (EVar "x") (EVar "y"))])))), expectedType = Nothing, expectedResult = RInvalid},Example {name = "undecl-type", program = Program [ADT "Hello" [("Hello",[TData "foo"])]] (ELambda ("x",TData "Hello") (EVar "x")), expectedType = Just (TArrow (TData "Hello") (TData "Hello")), expectedResult = RInvalid},Example {name = "undecl-ctor", program = Program [ADT "Hello" [("Hello",[TInt])]] (EApply (EVar "Hello'") (EIntLit 10)), expectedType = Nothing, expectedResult = RInvalid},Example {name = "match-bad-branch", program = Program [ADT "my_type1" [("A",[TInt,TInt]),("B",[TInt,TChar])]] (ELet ("x",EApply (EApply (EVar "A") (EIntLit 10)) (EIntLit 10)) (ECase (EVar "x") [(PData "A" [PVar "n1",PVar "n2"],EAdd (EVar "n1") (EVar "n2")),(PData "B" [PVar "n",PVar "c"],ESub (EVar "n") (EVar "c"))])), expectedType = Nothing, expectedResult = RInvalid},Example {name = "match-bad-type", program = Program [] (ELet ("n",EIntLit 10) (ECase (EVar "n") [(PCharLit 's',EIntLit 1),(PVar "others",ESub (EIntLit 0) (EIntLit 1))])), expectedType = Nothing, expectedResult = RInvalid},Example {name = "undecl-var-1", program = Program [ADT "my_type1" [("A",[TInt,TInt])]] (ELet ("v",EApply (EApply (EVar "A") (EIntLit 10)) (EIntLit 20)) (ECase (EVar "v") [(PData "A" [PIntLit 10,PVar "x"],EVar "x"),(PData "A" [PVar "y",PIntLit 20],EAdd (EVar "x") (EVar "y"))])), expectedType = Nothing, expectedResult = RInvalid},Example {name = "match-ctor-of-bad-type-2", program = Program [ADT "my_type1" [("A",[TInt,TInt]),("B",[TChar,TChar])],ADT "my_type2" [("C",[TInt])]] (ELet ("x",EApply (EApply (EVar "A") (EIntLit 1)) (EIntLit 1)) (ECase (EVar "x") [(PData "A" [PVar "n1",PVar "n2"],EEq (EVar "n1") (EVar "n2")),(PData "C" [PVar "_"],EBoolLit False)])), expectedType = Nothing, expectedResult = RInvalid},Example {name = "match-inconsistent", program = Program [ADT "my_type1" [("A",[TInt,TInt]),("B",[TChar,TChar])]] (ELet ("x",EApply (EApply (EVar "A") (EIntLit 23)) (EIntLit 33)) (ECase (EVar "x") [(PData "A" [PVar "n1",PVar "n2"],EAdd (EVar "n1") (EVar "n2")),(PData "B" [PVar "c1",PVar "c2"],ELe (EVar "c1") (EVar "c2"))])), expectedType = Nothing, expectedResult = RInvalid}]