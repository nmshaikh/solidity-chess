// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

struct Player {
    address pAddress;
    bool isWhite;
}

enum GameStatus {
    Initiated,
    InProgress,
    Completed
}

contract Game {
    Board private _board;
    Player private _player1;
    Player private _player2;
    Player private _currentPlayer;
    GameStatus private _gameStatus;
    uint8 immutable cellsPerRow = 8;

    modifier gameStatus(GameStatus status) {
        require(_gameStatus == status);
        _;
    }
    modifier isPlayer() {
        require(msg.sender == _player1.pAddress || msg.sender == _player2.pAddress);
        _;
    }
    modifier isPlayerTurn() {
        require(_currentPlayer.pAddress == msg.sender);
        _;
    }
    modifier validCoords(uint8[2] memory coords) {
        require(coords[0] < cellsPerRow || coords[1] < cellsPerRow);
        _;
    }

    function initGame() public {
        _player1 = Player({pAddress: msg.sender, isWhite: true}); // TODO: implement randomness
        _gameStatus = GameStatus.Initiated;
    }

    function acceptGame() public {
        Player memory player2;
        player2.pAddress = msg.sender;
        if (_player1.isWhite) {
            player2.isWhite = false;
            _currentPlayer = _player1;
        }
        else {
            player2.isWhite = true;
            _currentPlayer = player2;
        }

        _player2 = player2;
        _board = new Board();
        _gameStatus = GameStatus.InProgress;
    }

    function movePiece(uint8[2] memory startCoords, uint8[2] memory endCoords) public returns (bool) {
        Cell start = _board.getCell(startCoords);
        if (!start.getHasPiece()) return false;
        Cell end = _board.getCell(endCoords);
        if (!start.getPiece().canMove(_board, start, end, _currentPlayer)) return false;

        _board.setCell(startCoords, new EmptyCell(startCoords));
        _board.setCell(endCoords, new PieceCell(endCoords, start.getPiece()));
        return true;
    }

    function endTurn() internal {
        assert(_gameStatus == GameStatus.InProgress);
        if (_currentPlayer.pAddress == _player1.pAddress)
            _currentPlayer = _player2;
        else 
            _currentPlayer = _player1;
    }

    function getGameStatus() public view returns (GameStatus) {
        return _gameStatus;
    }

    function getCurrentPlayer() public view returns (Player memory) {
        return _currentPlayer;
    }
}

/*******************************************************************************************************/

contract Board {
    uint8 immutable cellsPerRow = 8;
    uint8 immutable totalCells = 64;
    Cell[64] private board;

    constructor() {
        _resetBoard();
    }

    function _resetBoard() internal {
        for (uint8 i = 0; i < totalCells; ++i) {
            uint8 x = i % cellsPerRow;
            uint8 y = (i - x) / cellsPerRow;
            if (i == 0 || i == 7)
                board[i] = new PieceCell([x, y], new Rook(true));
            else if (i == 1 || i == 6)
                board[i] = new PieceCell([x, y], new Knight(true));
            else if (i == 2 || i == 5)
                board[i] = new PieceCell([x, y], new Bishop(true));
            else if (i == 3)
                board[i] = new PieceCell([x, y], new Queen(true));
            else if (i == 4)
                board[i] = new PieceCell([x, y], new King(true));
            else if (i > 7 && i < 16)
                board[i] = new PieceCell([x, y], new Pawn(true));
            else if (i > 47 && i < 56)
                board[i] = new PieceCell([x, y], new Pawn(false));
            else if (i == 56 || i == 63)
                board[i] = new PieceCell([x, y], new Rook(false));
            else if (i == 57 || i == 62)
                board[i] = new PieceCell([x, y], new Knight(false));
            else if (i == 58 || i == 61)
                board[i] = new PieceCell([x, y], new Bishop(false));
            else if (i == 59)
                board[i] = new PieceCell([x, y], new Queen(false));
            else if (i == 60)
                board[i] = new PieceCell([x, y], new King(false));
            else 
                board[i] = new EmptyCell([x, y]);
        }
    }
    // i = x + (y * 8)

    function getCell(uint8[2] memory coords) public view returns (Cell) {
        uint8 index = coords[0] + (coords[1] * cellsPerRow);
        return board[index];
    }

    function setCell(uint8[2] memory coords, Cell cell) public {
        uint8 index = coords[0] + (coords[1] * cellsPerRow);
        board[index] = cell;
    }
}

/*******************************************************************************************************/

abstract contract Cell {
    bool internal _hasPiece;
    Piece internal _piece;
    uint8 internal _row;
    uint8 internal _col;

    function getHasPiece() public view returns (bool) {
        return _hasPiece;
    }

    function getPiece() public view returns (Piece) {
        return _piece;
    }

    function getRow() public view returns (uint8) {
        return _row;
    }

    function getCol() public view returns (uint8) {
        return _col;
    }
}

contract EmptyCell is Cell {
    constructor(uint8[2] memory coords) {
        _hasPiece = false;
        _row = coords[0];
        _col = coords[1];
    }
}

contract PieceCell is Cell {
    constructor(uint8[2] memory coords, Piece piece) {
        _hasPiece = true;
        _row = coords[0];
        _col = coords[1];
        _piece = piece;
    }
}

/*******************************************************************************************************/

abstract contract Piece {
    bool internal _isWhite = false;
    bool internal _isTaken = false;

    function canMove(Board board, Cell start, Cell end, Player memory currentPlayer) public view virtual returns (bool);
    
    function getIsWhite() public view returns (bool) {
        return _isWhite;
    }

    function getIsTaken() public view returns (bool) {
        return _isTaken;
    }

    function _initialChecks(Cell start, Cell end, Player memory currentPlayer) internal view returns (bool) {
        if (_isWhite != currentPlayer.isWhite) return false;
        if (start.getRow() == end.getRow() && start.getCol() == end.getCol()) return false;
        if (end.getHasPiece() && end.getPiece().getIsWhite() == _isWhite) return false;
        return true;
    }

    function abs(int8 num) public pure returns (uint8) {
        return num >= 0 ? uint8(num) : uint8(-num);
    }

    function absDiff(uint8 start, uint8 end) public pure returns (uint8) {
        return abs(int8(end) - int8(start));
    }
}

contract King is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end, Player memory currentPlayer) public view override returns (bool) {
        if(!_initialChecks(start, end, currentPlayer)) return false;

        uint8 xChange = absDiff(start.getRow(), end.getRow());
        uint8 yChange = absDiff(start.getCol(), end.getCol());
        if (xChange + yChange != 1) return false;

        // TODO: implement check for "check"

        return true;
    }
}

contract Queen is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end, Player memory currentPlayer) public view override returns (bool) {
        if(!_initialChecks(start, end, currentPlayer)) return false;

    }
}

contract Rook is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end, Player memory currentPlayer) public view override returns (bool) {
        if(!_initialChecks(start, end, currentPlayer)) return false;
        if (start.getRow() == end.getRow()) {   // Vertical move
            uint8 yChange = absDiff(start.getCol(), end.getCol()) - 1;
            uint8 endY;
            while (yChange > 0) {
                if (end.getCol() > start.getCol())
                    endY = start.getCol() + yChange;
                else
                    endY = start.getCol() - yChange;
                
                if (board.getCell([start.getRow(), endY]).getHasPiece()) return false;
                --yChange;
            }
        } else if (start.getCol() == end.getCol()) {    // Horizontal move
            uint8 xChange = absDiff(start.getRow(), end.getRow()) - 1;
            uint8 endX;
            while (xChange > 0) {
                if (end.getRow() > start.getRow())
                    endX = start.getRow() + xChange;
                else
                    endX = start.getRow() - xChange;
                
                if (board.getCell([endX, start.getCol()]).getHasPiece()) return false;
                --xChange;
            }
        } else return false;

        return true;
    }
}

contract Bishop is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end, Player memory currentPlayer) public view override returns (bool) {
        if(!_initialChecks(start, end, currentPlayer)) return false;
    }
}

contract Knight is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end, Player memory currentPlayer) public view override returns (bool) {
        if(!_initialChecks(start, end, currentPlayer)) return false;
    }
}

contract Pawn is Piece {
    constructor(bool isWhite) {
        _isWhite = isWhite;
    }

    function canMove(Board board, Cell start, Cell end, Player memory currentPlayer) public view override returns (bool) {
        if(!_initialChecks(start, end, currentPlayer)) return false;
    }
}
