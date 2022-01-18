// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// import "./Cell.sol";
// import "./Piece.sol";

contract Board {
    Cell[64] private board;

    constructor() {
        _resetBoard();
    }

    function _resetBoard() internal {
        Cell emptyCell;
        for (uint8 i = 0; i < 64; ++i) {
            if (i == 0 || i == 7)
                board[i] = new Cell(true, new Rook(true));
            else if (i == 1 || i == 6)
                board[i] = new Cell(true, new Knight(true));
            else if (i == 2 || i == 5)
                board[i] = new Cell(true, new Bishop(true));
            else if (i == 3)
                board[i] = new Cell(true, new Queen(true));
            else if (i == 4)
                board[i] = new Cell(true, new King(true));
            else if (i > 7 && i < 16)
                board[i] = new Cell(true, new Pawn(true));
            else if (i > 46 && i < 56)
                board[i] = new Cell(true, new Pawn(false));
            else if (i == 56 || i == 63)
                board[i] = new Cell(true, new Rook(false));
            else if (i == 57 || i == 62)
                board[i] = new Cell(true, new Knight(false));
            else if (i == 58 || i == 61)
                board[i] = new Cell(true, new Bishop(false));
            else if (i == 59)
                board[i] = new Cell(true, new Queen(false));
            else if (i == 60)
                board[i] = new Cell(true, new King(false));
            else 
                board[i] = emptyCell;
        }
    }
    // i = x + (y * 8)

    function getCell(uint8 index) public view returns (Cell) {
        return board[index];
    }
}

/*******************************************************************************************************/

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

/*******************************************************************************************************/

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
        if (end.getHasPiece() && end.getPiece().getIsWhite() == _isWhite) return false;
    }
}

contract Queen is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece().getIsWhite() == _isWhite) return false;
    }
}

contract Rook is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece().getIsWhite() == _isWhite) return false;
    }
}

contract Bishop is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece().getIsWhite() == _isWhite) return false;
    }
}

contract Knight is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece().getIsWhite() == _isWhite) return false;
    }
}

contract Pawn is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end) public override returns (bool) {
        if (end.getHasPiece() && end.getPiece().getIsWhite() == _isWhite) return false;
    }
}
