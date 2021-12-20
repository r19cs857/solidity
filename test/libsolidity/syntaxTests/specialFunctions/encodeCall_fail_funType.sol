interface I {
	function fExternal(uint256 p, string memory t) external;
}

contract Other {
	function fExternal(uint) external pure {}
	function fPublic(uint) public pure {}
	function fInternal(uint) internal pure {}
}

library L {
	function fExternal(uint256 p, string memory t) external {}
	function fInternal(uint256 p, string memory t) internal {}
}

contract Base {
	function baseFunction(uint) internal pure {}
	function baseFunctionPublic(uint) public pure {}
}

contract C is Base {
	using L for uint256;

	function f(int a) public {}
	function f2(int a, string memory b) public {}
	function f3(int a, int b) public {}
	function f4() public {}
	function fInternal(uint256 p, string memory t) internal {}

	function failFunctionPtrMissing() public returns(bytes memory) {
		return abi.encodeCall(1, this.f);
	}
	function failFunctionPtrWrongType() public returns(bytes memory) {
		return abi.encodeCall(abi.encodeCall, (1, 2, 3, "test"));
	}
	function failFunctionInternal() public returns(bytes memory) {
		return abi.encodeCall(fInternal, (1, "123"));
	}
	function failFunctionInternalFromVariable() public returns(bytes memory) {
		function(uint256, string memory) internal localFunctionPointer = fInternal;
		return abi.encodeCall(localFunctionPointer, (1, "123"));
	}
	function failLibraryPointerCall() public {
		abi.encodeCall(L.fInternal, (1, "123"));
		abi.encodeCall(L.fExternal, (1, "123"));
	}
	function failBoundLibraryPointerCall() public returns (bytes memory) {
		uint256 x = 1;
		return abi.encodeCall(x.fExternal, (1, "123"));
	}
	function viaBaseDeclaration() public pure returns (bytes memory) {
		return abi.encodeCall(C.f, (2));
	}
	function viaBaseDeclaration() public pure returns (bytes memory) {
		return bytes.concat(
			abi.encodeCall(Base.baseFunctionPublic, (1)),
			abi.encodeCall(Base.baseFunction, (1))
		);
	}
}
// ----
// DeclarationError 1686: (1556-1660): Function with same name and parameter types defined twice.
// TypeError 5511: (803-804): Expected first argument to be a function pointer, not "int_const 1".
// TypeError 3509: (910-924): Function must be "public" or "external".
// TypeError 3509: (1037-1046): Function must be "public" or "external". Did you forget to prefix "this."?
// TypeError 3509: (1242-1262): Function must be "public" or "external".
// TypeError 3509: (1341-1352): Function must be "public" or "external".
// TypeError 3509: (1384-1395): Function must be "public" or "external".
// TypeError 3509: (1526-1537): Function must be "public" or "external".
// TypeError 3509: (1647-1650): Function must be "public" or "external". Did you forget to prefix "this."?
// TypeError 3509: (1770-1793): Function must be "public" or "external". Functions from base contracts have to be external.
// TypeError 3509: (1819-1836): Function must be "public" or "external". Functions from base contracts have to be external.
