// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Piece.sol";

contract Cell {
    bool private _hasPiece = false;
    Piece private _piece;

    constructor(bool hasPiece, Piece piece) {
        _hasPiece = hasPiece;
        if (hasPiece) _piece = piece;
    }

    function getHasPiece() public view returns (bool) {
        return _hasPiece;
    }

    function getPiece() public view returns (Piece) {
        return _piece;
    }
}
