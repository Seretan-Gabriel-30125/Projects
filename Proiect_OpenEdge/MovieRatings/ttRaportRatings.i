DEFINE TEMP-TABLE ttRaportRatings BEFORE-TABLE bttRaportRatings
    FIELD RatingId AS INTEGER
    FIELD MovieId  AS INTEGER
    FIELD UserName AS CHARACTER FORMAT "x(32)"
    FIELD Rating   AS INTEGER
    FIELD AverageOfRatings AS DECIMAL
    .