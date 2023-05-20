//Implementare joc de sah

var canvas
var c
var rect
var pieceInHand = 0;
var pieceInHandType = 0;

/*
Cele trei variabile "deleted" memoreaza valorile piesei aflata in prezent in mana jucatorului. 
Am numit-o "deleted piece" deoarece atunci cand jucatorul apuca o piesa,
cea originala dispare si una noua este desenata in mana jucatorului.
*/

var selectedPieceX = null;
var selectedPieceY = null;
var selectedPieceType = null;

var enPassantCaptureX = -1;
var enPassantcaptureY = -1;

var currentMove = 1;

/*
Aceste valori vor astepta pana cand vor fi modificate pentru a obtine pozitia curenta a mouse-ului
*/
var mouse = {
	x: 0,
	y: 0
};

/*
Aceste valori sunt substituenti pentru valorile x si y
*/
var canvasPosition = {
	x: 0,
	y: 0
};

/*
Am setat numarul de coloane si randuri ale tablei de sah si dimesiunile patratelor de pe ea.
*/
var boardDeminsions = {
	rows: 8,
	columns: 8,
	width: 75,
	height: 75
}

/*
Am creat un array 8x8 2d care va reprezenta piesele de pe tabla de sah.
*/
var boardArray = new Array(boardDeminsions.width);
for (var i = 0; i < boardDeminsions.width; i++) {
	boardArray[i] = new Array(boardDeminsions.height);
}

/* Deschiderea jocului */
window.onload = function () {

	/* Crearea contextului pentru joc */
	canvas = document.getElementById("canvas");
	c = canvas.getContext("2d");

	/* 
	Initializam variabilele pe care le stocam in canvas 
	pentru a le folosi mai tarziu pentru a calcula coordonatele mouseului.
	*/
	rect = canvas.getBoundingClientRect();
	canvasPosition.x = rect.left;
	canvasPosition.y = rect.top;

	/* Declaram event handle-urile pentru mouse */
	canvas.onmousedown = handleMouseDown;
	canvas.onmouseup = handleMouseUp;
	canvas.onmousemove = handleMouseMove;

	/* Incarcam interfata.*/
	init();

	/*
	Resetam valorile lui boardArray[] pentru pozitiile de inceput a jocului de sah.
	*/
	resetBoard();

	/*
	drawBoard() deseneaza patrate inchise si deschise la culoare,
	 boardArray[] va desena piesele in aceste patrate dupa ce imaginile sunt incarcate.
	*/
	lightSquare.onload = function () {
		drawBoard();
	}
	blackRook.onload = function () {
		drawPieces();

	}

	//Obtine referinta la butonul de reset
	var resetButton = document.getElementById("resetButton");
	// Adaugă un listener de eveniment pentru click pe butonul de reset
	resetButton.addEventListener("click", function () {
		// Resetează tabla și re-desenează
		resetBoard();
		drawBoard();
		drawPieces();
	});

}

function updateMouseXY(e) {
	/* 
Pentru a updata pozitia lui x si y din canvas.
	*/
	mouse = {
		x: e.pageX - canvasPosition.x,
		y: e.pageY - canvasPosition.y
	}
}

function handleMouseMove(e) {
	updateMouseXY(e);

	/*
	Redeseneaza tabla si piesele in timp ce jucatorul muta piese pe tabla.
	*/
	drawBoard();
	drawPieces();

	/*daca jucatorul tine o piesa, deseneaza piesa sub mouse*/
	if (pieceInHand = 1) {
		drawPieceAtLocation(mouse.x - 37, mouse.y - 37, pieceInHandType);
	}
}

function handleMouseDown(e) {
	updateMouseXY(e)

	/* Folosim coordonatele mouse-ului pentru a gasi pe ce patrat e mouse-ul*/
	var xSquare = Math.floor(mouse.x / 75);
	var ySquare = Math.floor(mouse.y / 75);

	/* 
	daca exista o piesa in patratul in care a fost apasat click-ul
	va rula acest cod
	*/
	if (boardArray[xSquare][ySquare] != 0) {
		/*
		Acum jucatorul va avea o piesa in mana (pieceInHand=1) si vom stoca coordonatele piesei originale
		in variabilele deletedPiece 
		Totodata stocam tipul piesei in variabile pieceInHandType pentru a o putea desena
		*/
		pieceInHand = 1;
		selectedPieceX = xSquare;
		selectedPieceY = ySquare;
		selectedPieceType = boardArray[xSquare][ySquare]
		pieceInHandType = selectedPieceType;

		/* 
		Schimbam variabila boardArray in 0, deci piesa va disparea din locatia originala.
		*/
		boardArray[xSquare][ySquare] = 0;

		/* Desenam tabla si piesele in locatia updatata */
		drawBoard();
		drawPieces();

		/* Desenam piesa care e in mana jucatorului*/
		drawPieceAtLocation(mouse.x - 37, mouse.y - 37, pieceInHandType);
	}
}

/*
Aceasta functie va fi folosita atunci cand mouse-ul este eliberat. 
Verifica daca jucatorul tine o piesa in mana. 
Daca da, va verifica daca patratul pe care a fost eliberata constituie o mutare valida. 
Daca este valida, piesa va fi mutata si starea tablei va fi actualizata.
*/
function handleMouseUp(e) {
	updateMouseXY(e)
	/*
	Din acest cod ne dam seama in care patrat se afla mouse-ul in momentul curent.
	*/
	var xSquare = Math.floor(mouse.x / 75);
	var ySquare = Math.floor(mouse.y / 75);

	if (pieceInHand == 1) {

		/*
		Daca mutarea nu este permisa acest cod va updata tabla de sah.
		*/
		if (isMoveAllowed(xSquare, ySquare) == 0) {
			console.log("move not allowed");
			boardArray[selectedPieceX][selectedPieceY] = selectedPieceType;
			selectedPieceX = null;
			selectedPieceY = null;
			selectedPieceType = null;

			/*
			Daca mutarea este permisa acest cod va updata tabla de sah.

			*/
		} else if (isMoveAllowed(xSquare, ySquare) == 1) {
			console.log("move Allowed");
			boardArray[xSquare][ySquare] = selectedPieceType;
			selectedPieceX = null;
			selectedPieceY = null;
			selectedPieceType = null;
			currentMove += 1;
		}

		/*
		Daca s-a executat blocul de mai sus nu va mai exista piesa in mana jucatorului,
		tabla de sah si piesele vor fi desenate
		*/
		pieceInHand = 0;
		pieceInHandType = 0;
		drawBoard();
		drawPieces();
	}
}
/*
am incarcat imaginile pieselor
*/
function init() {

	darkSquare = new Image();
	darkSquare.src = "Images/DarkSquares.png";

	lightSquare = new Image();
	lightSquare.src = "Images/LightSquares.png";

	blackPawn = new Image();
	blackPawn.src = "Images/BlackPawn.png";

	whitePawn = new Image();
	whitePawn.src = "Images/WhitePawn.png";

	blackRook = new Image();
	blackRook.src = "Images/BlackRook.png";

	whiteRook = new Image();
	whiteRook.src = "Images/WhiteRook.png";

	blackBishop = new Image();
	blackBishop.src = "Images/BlackBishop.png";

	whiteBishop = new Image();
	whiteBishop.src = "Images/WhiteBishop.png";

	blackKnight = new Image();
	blackKnight.src = "Images/BlackKnight.png";

	whiteKnight = new Image();
	whiteKnight.src = "Images/whiteKnight.png";

	whiteQueen = new Image();
	whiteQueen.src = "Images/whiteQueen.png";

	blackQueen = new Image();
	blackQueen.src = "Images/blackQueen.png";

	whiteKing = new Image();
	whiteKing.src = "Images/whiteKing.png";

	blackKing = new Image();
	blackKing.src = "Images/blackKing.png";
}

/* 	
Aceasta functie deseneaza tabla adunand indicii de la array impreuna.
Daca acestia sunt divizibili in mod egal cu 2 (adica se aduna la un numar par),
atunci se deseneaza un patrat inchis in acea locatie. In caz contrar, 
se deseneaza un patrat deschis. 0 este considerat un numar par in cadrul acestui algoritm.
*/


function drawBoard() {
	for (var i = 0; i < boardDeminsions.rows; i++) {
		for (var j = 0; j < boardDeminsions.columns; j++) {
			if ((i + j) % 2 != 0) {
				c.drawImage(darkSquare, i * boardDeminsions.width, j * boardDeminsions.height);
			} else {
				c.drawImage(lightSquare, i * boardDeminsions.width, j * boardDeminsions.height);
			}
		}
	}
}

/*
Aceasta functie deseneaza o piesa la o anumita coordonata x si y. 
Aceasta primeste ca parametri pozitiile x si y si tipul piesei
utilizeaza o instructiune switch cu tipul piesei ca parametru pentru a decide ce imagine sa deseneze.
*/
function drawPieceAtLocation(x, y, piece) {
	switch (piece) {
		case 1:
			c.drawImage(whitePawn, x, y);
			break;
		case 2:
			c.drawImage(whiteKnight, x, y);
			break;
		case 3:
			c.drawImage(whiteBishop, x, y);
			break;
		case 4:
			c.drawImage(whiteRook, x, y);
			break;
		case 5:
			c.drawImage(whiteQueen, x, y);
			break;
		case 6:
			c.drawImage(whiteKing, x, y);
			break;
		case 7:
			c.drawImage(blackPawn, x, y);
			break;
		case 8:
			c.drawImage(blackKnight, x, y);
			break;
		case 9:
			c.drawImage(blackBishop, x, y);
			break;
		case 10:
			c.drawImage(blackRook, x, y);
			break;
		case 11:
			c.drawImage(blackQueen, x, y);
			break;
		case 12:
			c.drawImage(blackKing, x, y);
			break;
	}
}

/*
Deseneaza piesa pe tabla pe baza variabilei boardArray[][]
*/
function drawPieces() {
	for (var i = 0; i < boardDeminsions.rows; i++) {
		for (var j = 0; j < boardDeminsions.columns; j++) {
			if (boardArray[i][j] != 0) {
				drawPieceAtLocation(i * boardDeminsions.width, j * boardDeminsions.height, boardArray[i][j]);
			}
		}
	}
}

/* 
Verificam daca piesa este neagra si returneaza true daca este adevarat. 
Pentru ca o piesa neagra sa nu poata ocupa alta piesa neagra.
*/
function isBlackPiece(x, y) {
	var result = 0;
	for (var i = 7; i < 13; i++) {
		if (boardArray[x][y] == i) {
			result = 1;
		}
	}
	return result;
}

/* 
Verificam daca piesa este alba si returneaza true daca este adevarat. 
Pentru ca o piesa alba sa nu poata ocupa alta piesa alba.
*/
function isWhitePiece(x, y) {
	var result = 0;
	for (var i = 1; i < 7; i++) {
		if (boardArray[x][y] == i) {
			result = 1;
		}
	}
	return result;
}

/* 
Aceasta functie seteaza valoarea in boardArray[][] la standard 
pentru a pune tabla de sah in pozitia de start.
*/
function resetBoard() {
	for (var i = 0; i < 8; i++) {
		for (var j = 0; j < 8; j++) {
			boardArray[i][j] = 0;
		}
	}

	for (var i = 0; i < 8; i++) { /* pionii negrii ocupa aceste patrate */
		boardArray[i][1] = 7;
	}
	for (var i = 0; i < 8; i++) { /* pionii albi ocupa aceste patrate */
		boardArray[i][6] = 1;
	}

	/* black rooks ocupa aceste patrate */
	boardArray[0][0] = 10;
	boardArray[7][0] = 10;

	/* black knights ocupa aceste patrate */
	boardArray[1][0] = 8;
	boardArray[6][0] = 8;

	/* black bishops ocupa aceste patrate */
	boardArray[2][0] = 9;
	boardArray[5][0] = 9;

	/* the black queen ocupa acest patrat */
	boardArray[3][0] = 11;

	/* the black king ocupa acest patrat */
	boardArray[4][0] = 12;

	/* white rooks ocupa aceste patrate */
	boardArray[0][7] = 4;
	boardArray[7][7] = 4;

	/* white knights ocupa aceste patrate */
	boardArray[1][7] = 2;
	boardArray[6][7] = 2;

	/* white bishops ocupa aceste patrate */
	boardArray[2][7] = 3;
	boardArray[5][7] = 3;

	/* white queen ocupa acest patrat */
	boardArray[3][7] = 5;

	/* white king ocupa acest patrat */
	boardArray[4][7] = 6;
}

function isMoveAllowed(x, y) {
	switch (selectedPieceType) {
		case 1: //  gestioneaza logica miscarilor valide pentru pioni albi
			//return 0 daca nu este randul jucatorului cu alb

			if (currentMove % 2 == 0) {
				console.log("not whites turn");
				return 0;
			}

			//ne asiguram ca jucatorul nu isi ia singur piesa
			if (isWhitePiece(x, y) == 1) {
				return 0;
			}

			//Un pion poate inainta cu doua patrate din pozitia initiala
			if (y + 2 == 6 && x == selectedPieceX && boardArray[x][y] == 0 && boardArray[x][y + 1] == 0) {
				enPassantCaptureX = x;		//se stocheaza in variabila in cazul capturarii
				enPassantCaptureY = y + 1;	//se stocheaza in variabila in cazul capturarii
				return 1;
			}
			//Un pion poate inainta un patrat
			else if (y + 1 == selectedPieceY && x == selectedPieceX && boardArray[x][y] == 0) {
				return 1;

				//O piesa este capturata prin fata sau stanga/dreapta
			} else if (y + 1 == selectedPieceY && boardArray[x][y] != 0) {
				if (x == selectedPieceX + 1 || x == selectedPieceX - 1) {
					return 1;
				} else {
					return 0;
				}
			}

			//Capturarea unui en passant
			else if (y + 1 == selectedPieceY && x == enPassantCaptureX && y == enPassantCaptureY) {
				if (x == selectedPieceX + 1 || x == selectedPieceX - 1) {
					boardArray[x][y + 1] = 0;
					return 1;
				} else {
					return 0;
				}
			}

			//return 0 cand mutarea nu e valida
			else {
				return 0;
			}
		case 2: //gestioneaza logica mutarilor valide pentru white knights si ne asiguram ca nu isi poate lua piesa proprie

			//return 0 daca nu e randul jucatorului alb
			if (currentMove % 2 == 0) {
				console.log("not whites turn");
				return 0;
			}

			if (isWhitePiece(x, y) == 1) {
				return 0;
			}

			if (x == selectedPieceX + 2 && y == selectedPieceY + 1) {
				return 1;
			} else if (x == selectedPieceX + 2 && y == selectedPieceY - 1) {
				return 1;
			} else if (x == selectedPieceX - 2 && y == selectedPieceY + 1) {
				return 1;
			} else if (x == selectedPieceX - 2 && y == selectedPieceY - 1) {
				return 1;
			} else if (x == selectedPieceX + 1 && y == selectedPieceY + 2) {
				return 1;
			} else if (x == selectedPieceX + 1 && y == selectedPieceY - 2) {
				return 1;
			} else if (x == selectedPieceX - 1 && y == selectedPieceY + 2) {
				return 1;
			} else if (x == selectedPieceX - 1 && y == selectedPieceY - 2) {
				return 1;
			} else {
				return 0;
			}
		case 3: // gestioneaza logica miscarilor valide pt white bishop
			// ne asiguram ca nu va trece prin alte piese

			//return 0 daca nu este randul jucatorului alb
			if (currentMove % 2 == 0) {
				console.log("not whites turn");
				return 0;
			}

			//ne asiguram ca jucatorul nu isi ia propria piesa
			if (isWhitePiece(x, y) == 1) {
				return 0;
			}

			var changeInX;
			var changeInY;
			var xOnPath = selectedPieceX;
			var yOnPath = selectedPieceY;
			var result;

			if (x > selectedPieceX) {
				changeInX = 1
			} else {
				changeInX = -1
			}
			if (y > selectedPieceY) {
				changeInY = 1
			} else {
				changeInY = -1
			}
			if (Math.abs(x - selectedPieceX) == Math.abs(y - selectedPieceY)) {
				result = 1;
				while (xOnPath != x - changeInX && yOnPath != y - changeInY) {
					xOnPath += changeInX;
					yOnPath += changeInY;
					if (boardArray[xOnPath][yOnPath] != 0) {
						result = 0;
					}
				}
				return result;
			} else {
				return 0;
			}
		case 4:
			//le folosim pentru a ne asigura ca nu avem piese in cale
			var changeInX = 0;
			var changeInY = 0;

			//return 0 daca nu este randul jucatorului alb
			if (currentMove % 2 == 0) {
				console.log("not whites turn");
				return 0;
			}

			//ne asiguram ca jucatorul nu isi ia propria piesa
			if (isWhitePiece(x, y) == 1) {
				return 0;
			}

			//logica atunci cand piesa se misca pe axa y
			if (x == selectedPieceX && y != selectedPieceY) {

				if (selectedPieceY < y) {
					changeInY = 1;
				} else {
					changeInY = -1;
				}

				for (var i = selectedPieceY + changeInY; i != y; i += changeInY) {
					if (boardArray[x][i] != 0) {
						return 0;
					}
				}
			}

			//logica atunci cand piesa se misca pe axa x
			if (x != selectedPieceX && y == selectedPieceY) {

				if (selectedPieceX < x) {
					changeInX = 1;
				} else {
					changeInX = -1;
				}

				for (var i = selectedPieceX + changeInX; i != x; i += changeInX) {
					if (boardArray[i][y] != 0) {
						return 0;
					}
				}
			}

			//daca mutarea este valida atunci returnam 1
			return 1;

		case 7: //gestioneaza logica miscarilor valide pentru pioni negri

			//return 0 daca nu este randul jucatorului cu alb
			if (currentMove % 2 == 1) {
				console.log("not blacks turn");
				return 0;
			}

			//ne asiguram ca jucatorul nu isi ia propria piesa
			if (isBlackPiece(x, y) == 1) {
				return 0;
			}

			//pionul inainteaza doua patrate in fata
			if (y - 2 == 1 && x == selectedPieceX && boardArray[x][y] == 0 && boardArray[x][y - 1] == 0) {
				enPassantCaptureX = x;
				enPassantCaptureY = y - 1;
				return 1;
			}

			//pionul merge un patrat in fata
			else if (y - 1 == selectedPieceY && x == selectedPieceX && boardArray[x][y] == 0) {
				return 1;
			}

			//O piesa este capturata prin fata sau stanga/dreapta
			else if (y - 1 == selectedPieceY && boardArray[x][y] != 0) {
				if (x == selectedPieceX + 1 || x == selectedPieceX - 1) {
					return 1;
				} else {
					return 0;
				}
			}
			//gestioneaza capturarea unei piese
			else if (y - 1 == selectedPieceY && x == enPassantCaptureX && y == enPassantCaptureY) {
				if (x == selectedPieceX + 1 || x == selectedPieceX - 1) {
					boardArray[x][y - 1] = 0;
					return 1;
				} else {
					return 0
				}
			} else {
				return 0;
			}
		case 8: //gestioneaza logica miscarilor valide pentru white knights

			//return 0 daca nu este randul jucatorului negru
			if (currentMove % 2 == 1) {
				console.log("not blacks turn");
				return 0;
			}

			//ne asiguram ca jucatorul nu isi ia propria piesa
			if (isBlackPiece(x, y) == 1) {
				return 0;
			}

			if (x == selectedPieceX + 2 && y == selectedPieceY + 1) {
				return 1;
			} else if (x == selectedPieceX + 2 && y == selectedPieceY - 1) {
				return 1;
			} else if (x == selectedPieceX - 2 && y == selectedPieceY + 1) {
				return 1;
			} else if (x == selectedPieceX - 2 && y == selectedPieceY - 1) {
				return 1;
			} else if (x == selectedPieceX + 1 && y == selectedPieceY + 2) {
				return 1;
			} else if (x == selectedPieceX + 1 && y == selectedPieceY - 2) {
				return 1;
			} else if (x == selectedPieceX - 1 && y == selectedPieceY + 2) {
				return 1;
			} else if (x == selectedPieceX - 1 && y == selectedPieceY - 2) {
				return 1;
			} else {
				return 0;
			}
		case 9: //gestioneaza logica miscarilor valide pentru black bishop
			//ne asiguram ca nu va trece prin piese

			//return 0 daca nu este tura jucatorului negru
			if (currentMove % 2 == 1) {
				console.log("not blacks turn");
				return 0;
			}

			//ne asiguram ca jucatorul nu isi ia propria piesa
			if (isBlackPiece(x, y) == 1) {
				return 0;
			}

			var changeInX;
			var changeInY;
			var xOnPath = selectedPieceX;
			var yOnPath = selectedPieceY;
			var result;

			if (x > selectedPieceX) {
				changeInX = 1
			} else {
				changeInX = -1
			}
			if (y > selectedPieceY) {
				changeInY = 1
			} else {
				changeInY = -1
			}
			if (Math.abs(x - selectedPieceX) == Math.abs(y - selectedPieceY)) {
				result = 1;
				while (xOnPath != x - changeInX && yOnPath != y - changeInY) {
					xOnPath += changeInX;
					yOnPath += changeInY;
					if (boardArray[xOnPath][yOnPath] != 0) {
						result = 0;
					}
				}
				return result;
			} else {
				return 0;
			}
		case 10: //gestioneaza logica miscarilor valide pentru black Rook
			//le folosim pentru a ne asigura ca nu avem piese in cale
			var changeInX = 0;
			var changeInY = 0;

			//return 0 daca nu este randul jucatorului negru
			if (currentMove % 2 == 1) {
				console.log("not blacks turn");
				return 0;
			}

			//ne asiguram ca jucatorul nu isi ia propria piesa
			if (isBlackPiece(x, y) == 1) {
				console.log("tried to take a black piece");
				return 0;
			}

			//logica atunci cand piesa se misca pe axa y
			if (x == selectedPieceX && y != selectedPieceY) {

				if (selectedPieceY < y) {
					changeInY = 1;
				} else {
					changeInY = -1;
				}

				for (var i = selectedPieceY + changeInY; i != y; i += changeInY) {
					if (boardArray[x][i] != 0) {
						return 0;
					}
				}
			}

			//logica atunci cand piesa se misca pe axa x
			if (x != selectedPieceX && y == selectedPieceY) {

				if (selectedPieceX < x) {
					changeInX = 1;
				} else {
					changeInX = -1;
				}

				for (var i = selectedPieceX + changeInX; i != x; i += changeInX) {
					if (boardArray[i][y] != 0) {
						return 0;
					}
				}
			}

			//daca mutarea este permisa, return 1
			return 1;

		default:
			return 0;
	}
}
