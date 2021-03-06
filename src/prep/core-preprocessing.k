module CORE-PREPROCESSING
    imports CORE-SORTS
    imports CORE-CLASSES

//@ Auxiliary functions related to preprocessing phases only.

//@ \subsection{Auxiliary constructs for retrieving a set of classes}

/*@ Returns a setWrap(Set[ClassType]), containing all top level classes in the program.
    Uses <namesToClasses> to compute the result. Used by the starting rule of several preprocessing phases.
*/
syntax KItem ::= "getTopLevelClasses"
               | getTopLevelClasses ( List, Set )

rule [getTopLevelClasses-start1]:
    <k> getTopLevelClasses => getTopLevelClasses(values(NamesMap), .Set) ...</k>
    <namesToClasses> NamesMap:Map </namesToClasses>

rule [getTopLevelClasses-start2]:
    <k> getTopLevelClasses((ListItem(mapWrap(M:Map)) => values(M)) _, _) ...</k>

rule [getTopLevelClasses-top-level]:
    <k>
      getTopLevelClasses((ListItem(Class:ClassType) => .List) _, (S:Set => S SetItem(Class)))
      ...
    </k>
    <classType> Class </classType>
    <enclosingClass> noClass </enclosingClass>

rule [getTopLevelClasses-not-top-level]:
    <k>
      getTopLevelClasses((ListItem(Class:ClassType) => .List) _, _)
      ...
    </k>
    <classType> Class </classType>
    <enclosingClass> class _ </enclosingClass>

rule getTopLevelClasses(.List, ClassesSet:Set) => setWrap(ClassesSet)

/*@ Returns a setWrap(Set[ClassType]), containing all direct inner classes of the given class.
    Uses <namesToClasses> to compute the result.
*/
syntax KItem ::= getInnerClasses ( ClassType )
               | getInnerClasses ( Map, Set )

rule [getInnerClasses-start-have-inner]:
    <k> getInnerClasses(class Class:Id) => getInnerClasses(InnerClassesMap, .Set) ...</k>
    <namesToClasses>... packageId(Class) |-> mapWrap(InnerClassesMap:Map) ...</namesToClasses>

rule getInnerClasses( (_ |-> Class:ClassType => .Map) _, (S:Set => S SetItem(Class)))
rule getInnerClasses(.Map, ClassesSet:Set) => setWrap(ClassesSet)

rule [getInnerClasses-no-inners]:
    <k> getInnerClasses(Class:ClassType) => setWrap(.Set) ...</k>
    <namesToClasses> TypeNamesMap:Map </namesToClasses>
when
    notBool toPackage(Class) in keys(TypeNamesMap)

//@ Returns the access mode of a method closure given as argument
syntax KItem ::= getMethodAccessMode ( MethodRef )   [strict]
rule [getMethodAccessMode]:
    <k>
      getMethodAccessMode( methodRef(Sig:Signature, Class:ClassType) ) => Acc
      ...
    </k>
    <classType> Class </classType>
    <methodSignature> Sig </methodSignature>
    <methodAccessMode> Acc:AccessMode </methodAccessMode>

//todo repitition
syntax KItem ::=  getContextType (
                AnnoMethodModList       //[...] - the list of method attributes
              )
              [function]

rule getContextType(static _:AnnoMethodModList) => staticCT
rule getContextType(.AnnoMethodModList) => instanceCT
rule getContextType(Hd:AnnoMethodMod Rest:AnnoMethodModList) => getContextType(Rest) when Hd =/=K static

syntax KItem ::=  getContextType (
                AnnoFieldModList       //[...] - the list of method attributes
              )
              [function]

rule getContextType(static _:AnnoFieldModList) => staticCT
rule getContextType(.AnnoFieldModList) => instanceCT
rule getContextType(Hd:AnnoFieldMod Rest:AnnoFieldModList) => getContextType(Rest) when Hd =/=K static

syntax KItem ::=  getContextType (
                AnnoClassModList       //[...] - the list of method attributes
              )
              [function]

rule getContextType(static _:AnnoClassModList) => staticCT
rule getContextType(.AnnoClassModList) => instanceCT
rule getContextType(Hd:AnnoClassMod Rest:AnnoClassModList) => getContextType(Rest) when Hd =/=K static

syntax KItem ::=  getAccessMode (
                AnnoMethodModList //[...] - the list of class/method attributes
              )
              [function]

rule getAccessMode(public _:AnnoMethodModList)    => public
rule getAccessMode(protected _:AnnoMethodModList) => protected
rule getAccessMode(private _:AnnoMethodModList)   => private
rule getAccessMode(.AnnoMethodModList) => package
rule getAccessMode(Hd:AnnoMethodMod Rest:AnnoMethodModList) => getAccessMode(Rest)
when Hd =/=K public andBool Hd =/=K protected andBool Hd =/=K private

syntax KItem ::=  getAccessMode (
                AnnoConstrModList //[...] - the list of class/method attributes
              )
              [function]

rule getAccessMode(public _:AnnoConstrModList)    => public
rule getAccessMode(protected _:AnnoConstrModList) => protected
rule getAccessMode(private _:AnnoConstrModList)   => private
rule getAccessMode(.AnnoConstrModList) => package
rule getAccessMode(Hd:AnnoConstrMod Rest:AnnoConstrModList) => getAccessMode(Rest)
when Hd =/=K public andBool Hd =/=K protected andBool Hd =/=K private

syntax KItem ::=  getAccessMode (
                AnnoClassModList
              )
              [function]

rule getAccessMode(public _:AnnoClassModList)    => public
rule getAccessMode(protected _:AnnoClassModList) => protected
rule getAccessMode(private _:AnnoClassModList)   => private
rule getAccessMode(.AnnoClassModList) => package
rule getAccessMode(Hd:AnnoClassMod Rest:AnnoClassModList) => getAccessMode(Rest)
when Hd =/=K public andBool Hd =/=K protected andBool Hd =/=K private

syntax KItem ::=  getAccessMode (
                AnnoInterfaceModList
              )
              [function]

rule getAccessMode(public _:AnnoInterfaceModList)    => public
rule getAccessMode(protected _:AnnoInterfaceModList) => protected
rule getAccessMode(private _:AnnoInterfaceModList)   => private
rule getAccessMode(.AnnoInterfaceModList) => package
rule getAccessMode(Hd:AnnoInterfaceMod Rest:AnnoInterfaceModList) => getAccessMode(Rest)
when Hd =/=K public andBool Hd =/=K protected andBool Hd =/=K private

endmodule
