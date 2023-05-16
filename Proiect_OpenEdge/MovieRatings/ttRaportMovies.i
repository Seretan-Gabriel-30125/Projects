DEFINE TEMP-TABLE ttRaportMovies BEFORE-TABLE bttRaportMovies
    FIELD MovieId     AS INTEGER
    FIELD MovieTitle  AS CHARACTER FORMAT "x(32)"
    FIELD Genre       AS CHARACTER
    FIELD ReleaseDate AS DATE.
 