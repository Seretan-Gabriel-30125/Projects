DEFINE TEMP-TABLE ttRatings BEFORE-TABLE bttRatings

    FIELD RatingId AS INTEGER
    FIELD MovieId  AS INTEGER
    FIELD UserName AS CHARACTER FORMAT "x(32)"
    FIELD Rating   AS INTEGER
    INDEX RatingIdIdx IS PRIMARY UNIQUE RatingId
    .