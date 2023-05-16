BLOCK-LEVEL ON ERROR UNDO, THROW.
{dsMovies.i}
{dsRatings.i}

//Table Movies

PROCEDURE FetchAllDataMovies:
    
    DEFINE OUTPUT PARAMETER DATASET FOR dsMovies.
    DEFINE BUFFER bufMovies FOR Movie.
   
   //am dat fetch la toate datele din Movies
    FOR EACH bufMovies NO-LOCK: 
        CREATE ttMovies.
        BUFFER-COPY bufMovies TO ttMovies.
    END.
    
END PROCEDURE.

PROCEDURE FetchDataMovieByMovieId:
    
    DEFINE INPUT PARAMETER piMovieId AS INTEGER.
    DEFINE OUTPUT PARAMETER DATASET FOR dsMovies.
    
    DEFINE BUFFER bufMovies FOR Movies.
   
   //am dat fetch la filmul primit ca parametru din Movies
    FOR EACH bufMovies NO-LOCK WHERE bufMovies.MovieId = piMovieId: 
        CREATE ttMovies.
        BUFFER-COPY bufMovies TO ttMovies.
    END.

END PROCEDURE.

PROCEDURE saveChangesMovies:
    
    DEFINE INPUT PARAMETER DATASET FOR dsMovies.
      
//Created
    FOR EACH ttMovies WHERE ROW-STATE(ttMovies) EQ ROW-CREATED:
        CREATE Movies.  
        ASSIGN
            Movies.MovieID = NEXT-VALUE(MovieidSQ).
        BUFFER-COPY ttMovies EXCEPT MovieID TO Movies.
        
    END.


//Modified
    FOR EACH ttMovies WHERE ROW-STATE(ttMovies) EQ ROW-MODIFIED:
        FOR EACH Movie EXCLUSIVE-LOCK WHERE ttMovies.MovieId EQ Movie.MovieId:
            BUFFER-COPY ttMovies TO Movies.
        END.
    END.

//Deleted
    FOR EACH bttMovies WHERE ROW-STATE(bttMovies) EQ ROW-DELETED:
        FOR EACH Movies EXCLUSIVE-LOCK WHERE Movies.MovieId EQ bttMovies.MovieId:
            DELETE Movies.
            //daca stergem un film se vor sterge si rating-urile filmului
            FOR EACH Ratings EXCLUSIVE-LOCK WHERE Ratings.MovieId EQ Movies.MovieId:
                DELETE Ratings.
            END.
        END.
    END.
END PROCEDURE.

    
//Table Ratings

PROCEDURE FetchAllDataRatings:
      
    DEFINE OUTPUT PARAMETER DATASET FOR dsRatings.    
    DEFINE BUFFER bufRatings FOR Ratings.
    
   //am dat fetch la toate datele din Ratings    
    FOR EACH bufRatings NO-LOCK: 
        CREATE ttRatings.
        BUFFER-COPY bufRatings TO ttRatings.
    END.       
END PROCEDURE.


PROCEDURE FetchDataRatingByRatingId:
    
    DEFINE INPUT PARAMETER piRatingId AS INTEGER.   
    DEFINE OUTPUT PARAMETER DATASET FOR dsRatings.    
 
    DEFINE BUFFER bufRatings FOR Ratings.
    
   //am dat fetch la un rating dupa id-ul rating-ului
    FOR EACH bufRatings NO-LOCK WHERE bufRatings.RatingId = piRatingId: 
        CREATE ttRatings.
        BUFFER-COPY bufRatings TO ttRatings.
    END.       
END.

PROCEDURE saveChangesRatings:
    
    DEFINE INPUT PARAMETER DATASET FOR dsRatings.

//Created
    FOR EACH ttRatings WHERE ROW-STATE(ttRatings) EQ ROW-CREATED:
        CREATE Ratings.
        ASSIGN 
            Ratings.RatingId = NEXT-VALUE(RatingIdSQ).
        BUFFER-COPY ttRatings EXCEPT RatingId TO Ratings.    
    END.

//Modified
    FOR EACH ttRatings WHERE ROW-STATE(ttRatings) EQ ROW-MODIFIED:
        FOR EACH Ratings EXCLUSIVE-LOCK WHERE ttRatings.RatingId EQ Ratings.RatingId:
            BUFFER-COPY ttRatings TO Ratings.
        END.
    END.

//Deleted
    FOR EACH bttRatings WHERE ROW-STATE(bttRatings) EQ ROW-DELETED:
        FOR EACH Ratings EXCLUSIVE-LOCK WHERE Ratings.RatingId EQ bttRatings.RatingId:
            DELETE Ratings.
        END.
    END.
END PROCEDURE.