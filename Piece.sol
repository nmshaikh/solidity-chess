// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./Board.sol";
import "./Cell.sol";

abstract contract Piece {
    bool internal _isTaken = false;
    bool internal _isWhite = false;

    function canMove(Board board, Cell start, Cell end) public virtual returns (bool);
    
    function getIsWhite() public view returns (bool) {
        return _isWhite;
    }

    function getIsTaken() public view returns (bool) {
        return _isTaken;
    }
}

contract King is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece.getIsWhite() == _isWhite) return false;
    }
}

contract Queen is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece.getIsWhite() == _isWhite) return false;
    }
}

contract Rook is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece.getIsWhite() == _isWhite) return false;
    }
}

contract Bishop is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece.getIsWhite() == _isWhite) return false;
    }
}

contract Knight is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece.getIsWhite() == _isWhite) return false;
    }
}

contract Pawn is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece.getIsWhite() == _isWhite) return false;
    }
}
