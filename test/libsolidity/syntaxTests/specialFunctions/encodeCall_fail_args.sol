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
	function baseFunctionExternal(uint) external pure {}
}

contract C is Base {
	using L for uint256;

	function f(int a) public {}
	function f2(int a, string memory b) public {}
	function f3(int a, int b) public {}
	function f4() public {}
	function fInternal(uint256 p, string memory t) internal {}

	function failFunctionArgsWrongType() public returns(bytes memory) {
		return abi.encodeCall(this.f, ("test"));
	}
	function failFunctionArgsTooMany() public returns(bytes memory) {
		return abi.encodeCall(this.f, (1, 2));
	}
	function failFunctionArgsTooFew0() public returns(bytes memory) {
		return abi.encodeCall(this.f, ());
	}
	function failFunctionArgsTooFew1() public returns(bytes memory) {
		return abi.encodeCall(this.f);
	}
	function failFunctionArgsArrayLiteral() public returns(bytes memory) {
		return abi.encodeCall(this.f3, [1, 2]);
	}
}
// ----
// TypeError 5407: (818-826): Cannot implicitly convert component at position 0 from "literal_string "test"" to "int256".
// TypeError 7788: (908-938): Expected 1 instead of 2 components for the tuple parameter.
// TypeError 7788: (1019-1045): Expected 1 instead of 0 components for the tuple parameter.
// TypeError 6219: (1126-1148): Expected two arguments: a function pointer followed by a tuple.
// TypeError 7515: (1234-1265): Expected a tuple with 2 components instead of a single non-tuple parameter.
// TypeError 5407: (1258-1264): Cannot implicitly convert component at position 0 from "uint8[2]" to "int256".
