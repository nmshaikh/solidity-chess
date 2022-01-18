// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Game {
    enum GameStatus {
        Initiated,
        InProgress,
        Completed
    }
    enum PieceType {
        Pawn,
        Knight,
        Bishop,
        Rook,
        Queen,
        King
    }
    enum Colour {
        White,
        Black
    }

    struct Player {
        address plAddr;
        Colour plColour;
    }
    struct Piece {
        PieceType pcType;
        Colour pcColour;
        bool isTaken;
    }
    struct Cell {
        bool hasPiece;
        Piece piece;
        // uint8 row;
        // uint8 column;
    }

    Player _player1;
    Player _player2;
    GameStatus _gameStatus;
    Colour turn;
    Cell[64] board;

    modifier gameStatus(GameStatus status) {
        require(_gameStatus == status);
        _;
    }
    modifier isPlayer() {
        require(msg.sender == _player1.plAddr || msg.sender == _player2.plAddr);
        _;
    }
    modifier isPlayerTurn() {
        if (msg.sender == _player1.plAddr) require(turn == _player1.plColour);
        else require(turn == _player2.plColour);
        _;
    }

    constructor() {}

    function startGame() public {
        _gameStatus = GameStatus.Initiated;
    }

    function acceptGame() public gameStatus(GameStatus.Initiated) {
        _gameStatus = GameStatus.InProgress;
        turn = Colour.White;
    }

    function movePiece() public gameStatus(GameStatus.InProgress) {}

    function forfeitGame() public gameStatus(GameStatus.InProgress) {}

    function cancelGame() public gameStatus(GameStatus.InProgress) {}

    // Update the turn colour at the end of the current player's turn
    function endTurn() internal {
        turn = turn == Colour.White ? Colour.Black : Colour.White;
    }

    function announceWinner() internal {}

    // Allow anyone to check the current status of the game
    function getGameStatus() public view returns (GameStatus) {
        return _gameStatus;
    }

    function checkValidMoves() public {}

    // Set up a new chess board with all 32 pieces placed
    function setUpBoard() internal {
        for (uint8 i = 0; i < 64; ++i) {
            if (i == 0 || i == 7)
                board[i] = createCellWithPiece(PieceType.Rook, Colour.White);
            else if (i == 1 || i == 6)
                board[i] = createCellWithPiece(PieceType.Knight, Colour.White);
            else if (i == 2 || i == 5)
                board[i] = createCellWithPiece(PieceType.Bishop, Colour.White);
            else if (i == 3)
                board[i] = createCellWithPiece(PieceType.Queen, Colour.White);
            else if (i == 4)
                board[i] = createCellWithPiece(PieceType.King, Colour.White);
            else if (i > 7 && i < 16)
                board[i] = createCellWithPiece(PieceType.Pawn, Colour.White);
            else if (i > 46 && i < 56)
                board[i] = createCellWithPiece(PieceType.Pawn, Colour.Black);
            else if (i == 56 || i == 63)
                board[i] = createCellWithPiece(PieceType.Rook, Colour.Black);
            else if (i == 57 || i == 62)
                board[i] = createCellWithPiece(PieceType.Knight, Colour.Black);
            else if (i == 58 || i == 61)
                board[i] = createCellWithPiece(PieceType.Bishop, Colour.Black);
            else if (i == 59)
                board[i] = createCellWithPiece(PieceType.Queen, Colour.Black);
            else if (i == 60)
                board[i] = createCellWithPiece(PieceType.King, Colour.Black);
            else 
                board[i].hasPiece = false;
        }
    }

    // Create an occupied cell with a piece
    function createCellWithPiece(PieceType pType, Colour pColour) internal pure returns (Cell memory) {
        return Cell(true, Piece(pType, pColour, false));
    }
}

/*  The following functionalities should be implemented
- Allow a player to start the game and another to accept it
- Assign a player to white and other to black (must be "random")
- Move a piece
     - Take opponent's piece by performing the move
- Check valid moves for a particular piece on the board
- Allow a pawn to be converted to a queen when it reaches the end of the board

- Check for "check" or "checkmate" condition
- Check for "draw" conditions
- Mechanism to ensure the game does not drag on forever (time limit)
- Implement castling of the king

- Assumptions:
--  Both players will be human and different addresses

*/
