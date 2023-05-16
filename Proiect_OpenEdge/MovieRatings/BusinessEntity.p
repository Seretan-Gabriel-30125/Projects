{dsMovies.i}
{dsRatings.i}
{ttRaportMovies.i}
{ttRaportRatings.i}

//Table Movies
PROCEDURE beFetchDataMovies:
    DEFINE INPUT PARAMETER piMovieId AS INTEGER.
    DEFINE OUTPUT PARAMETER DATASET FOR dsMovies.
    
    DEFINE VARIABLE hMoviePointer AS HANDLE NO-UNDO.
    
    RUN DataAccess.p PERSISTENT SET hMoviePointer.
    RUN FetchDataMovieByMovieId IN hMoviePointer(INPUT piMovieId, OUTPUT DATASET dsMovies).
    
    FINALLY:
        DELETE PROCEDURE hMoviePointer NO-ERROR.
    END FINALLY.
    
END PROCEDURE.
    
    
PROCEDURE beSaveChangesMovies: 
    DEFINE INPUT PARAMETER DATASET FOR dsMovies.
    
    DEFINE VARIABLE hMoviePointer AS HANDLE  NO-UNDO.
    DEFINE VARIABLE lValid        AS LOGICAL NO-UNDO.
    
    RUN DataAccess.p PERSISTENT SET hMoviePointer.
     
     
    DO TRANSACTION:
        RUN ValidateDataMovies(OUTPUT lValid).
    
        IF lValid=TRUE THEN
            RUN saveChangesMovies IN hMoviePointer(INPUT DATASET dsMovies).
     
        CATCH err AS Progress.Lang.Error:
            MESSAGE "Error: "err:GetMessage(1)
            VIEW-AS ALERT-BOX.
        END CATCH.
    END.
    
    FINALLY:
        DELETE PROCEDURE hMoviePointer NO-ERROR.
    END FINALLY.
    
END PROCEDURE.
        
        
PROCEDURE ValidateDataMovies:
    
    DEFINE OUTPUT PARAMETER lValid AS LOGICAL NO-UNDO INITIAL TRUE.

    FOR EACH ttMovies NO-LOCK:
        CASE ROW-STATE(ttMovies): 
            WHEN ROW-CREATED THEN 
                DO:
        //mandatory fields
        
                    IF ttMovies.MovieId = 0 OR ttMovies.MovieId = ? THEN 
                    DO:
                        lValid=FALSE.  
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie id is invalid!",1).
                    END.
                        
                    IF ttMovies.MovieTitle = "" OR ttMovies.MovieTitle = ? THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie Title is empty!",1).
                    END.

                    IF ttMovies.Genre = "" OR ttMovies.Genre = ? THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Genre is empty!",1).
                    END.
                    
                    IF ttMovies.ReleaseDate > TODAY OR ttMovies.ReleaseDate = ? THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Release Date is invalid!",1).
                    END.     
                     
                    IF CAN-FIND(Movies WHERE Movies.MovieTitle = ttMovies.MovieTitle) THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie Title already exists!",1).
                    END.
                END.
        END.
        CASE ROW-STATE(ttMovies): 
            WHEN ROW-MODIFIED THEN 
                DO:
        //mandatory fields
        
                    IF ttMovies.MovieId = 0 OR ttMovies.MovieId = ? THEN 
                    DO:
                        lValid=FALSE.  
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie id is invalid!",1).
                    END.
                        
                    IF ttMovies.MovieTitle = "" OR ttMovies.MovieTitle = ? THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie Title is empty!",1).
                    END.

                    IF ttMovies.Genre = "" OR ttMovies.Genre = ? THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Genre is empty!",1).
                    END.
                    
                    IF ttMovies.ReleaseDate > TODAY OR ttMovies.ReleaseDate = ? THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Release Date is invalid!",1).
                    END.     
                     
                    IF CAN-FIND(Movies WHERE Movies.MovieTitle = ttMovies.MovieTitle) THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie Title already exists!",1).
                    END.
                END.
        END.
    END.
END PROCEDURE.        

//Table Ratings

PROCEDURE beFetchDataRatings:
    DEFINE INPUT PARAMETER piRating AS INTEGER.
    DEFINE OUTPUT PARAMETER DATASET FOR dsRatings.
    
    DEFINE VARIABLE hMoviePointer AS HANDLE NO-UNDO.
    
    RUN DataAccess.p PERSISTENT SET hMoviePointer.
    RUN FetchDataRatingByRatingId IN hMoviePointer(INPUT piRating, OUTPUT DATASET dsRatings).
    
    FINALLY:
        DELETE PROCEDURE hMoviePointer NO-ERROR.
    END FINALLY.
    
END PROCEDURE.

PROCEDURE beSaveChangesRatings: 
    
    DEFINE INPUT PARAMETER DATASET FOR dsRatings.

    DEFINE VARIABLE hMoviePointer AS HANDLE  NO-UNDO.
    DEFINE VARIABLE lValid        AS LOGICAL NO-UNDO.
   
    RUN DataAccess.p PERSISTENT SET hMoviePointer.
    
    DO TRANSACTION:
        
        RUN ValidateDataRatings(OUTPUT lValid).
    
        IF lValid = TRUE THEN
            RUN saveChangesRatings IN hMoviePointer(INPUT DATASET dsRatings).
           
        CATCH err AS Progress.Lang.Error:
            MESSAGE "Error: " err:GetMessage(1)
                VIEW-AS ALERT-BOX.
        END CATCH.
    END.
    
    FINALLY:
        DELETE PROCEDURE hMoviePointer NO-ERROR.
    END FINALLY.
    
END PROCEDURE.
    

PROCEDURE ValidateDataRatings:
    DEFINE OUTPUT PARAMETER lValid AS LOGICAL NO-UNDO INITIAL TRUE.
    
    FOR EACH ttRatings NO-LOCK:
        CASE ROW-STATE(ttRatings): 
            WHEN ROW-CREATED THEN 
                DO:
                    
                    IF NOT CAN-FIND(FIRST Movies WHERE Movies.MovieId = ttRatings.MovieId) THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie id doesn't exist!",1).
                    END.
                    
                    IF ttRatings.RatingId = 0 OR ttRatings.RatingId = ? THEN
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("Rating id is invalid!",1). 
                    END.
               
                    IF ttRatings.UserName = "" OR ttRatings.UserName = ? THEN
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("User name is empty!",1).
                    END.
        
                    IF ttRatings.MovieId = 0 OR ttRatings.MovieId = ? THEN
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie id is invalid!",1).
                    END.
                    
                    IF ttRatings.Rating < 1 OR ttRatings.Rating > 10 THEN 
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("The rating is not between 1 and 10!",1). 
                    END.  
                    
                END.
        END.
        CASE ROW-STATE(ttRatings): 
            WHEN ROW-MODIFIED THEN 
                DO:
                    
                    IF NOT CAN-FIND(FIRST Movies WHERE Movies.MovieId = ttRatings.MovieId) THEN 
                    DO:
                        lValid=FALSE. 
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie id doesn't exist!",1).
                    END.
                    
                    IF ttRatings.RatingId = 0 OR ttRatings.RatingId = ? THEN
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("Rating id is invalid!",1). 
                    END.
               
                    IF ttRatings.UserName = "" OR ttRatings.UserName = ? THEN
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("User name is empty!",1).
                    END.
        
                    IF ttRatings.MovieId = 0 OR ttRatings.MovieId = ? THEN
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("Movie id is invalid!",1).
                    END.
                    
                    IF ttRatings.Rating < 1 OR ttRatings.Rating > 10 THEN 
                    DO:
                        lValid=FALSE.
                        UNDO, THROW NEW  Progress.Lang.AppError("The rating is not between 1 and 10!",1). 
                    END.  
                    
                END.
        END.
    END.
END PROCEDURE.


PROCEDURE MoviesRatingsRaport:
    DEFINE INPUT PARAMETER pcReportName AS CHARACTER.
    DEFINE VARIABLE hMoviePointer      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE pdAverageOfRatings AS DECIMAL.
    
    DEFINE BUFFER buffMovies  FOR ttMovies.
    DEFINE BUFFER buffRatings FOR ttRatings.
    
    RUN DataAccess.p PERSISTENT SET hMoviePointer.
    
    RUN FetchAllDataMovies IN hMoviePointer(OUTPUT DATASET dsMovies).
    RUN FetchAllDataRatings IN hMoviePointer(OUTPUT DATASET dsRatings).
    RUN getAverageOfRatings (OUTPUT pdAverageOfRatings).

    FOR EACH buffMovies NO-LOCK:
        CREATE ttRaportMovies.
        ASSIGN
            ttRaportMovies.MovieId     = buffMovies.MovieId
            ttRaportMovies.MovieTitle  = buffMovies.MovieTitle
            ttRaportMovies.Genre       = buffMovies.Genre
            ttRaportMovies.ReleaseDate = buffMovies.ReleaseDate.
    END. 
    
    FOR EACH buffRatings NO-LOCK: 
        CREATE ttRaportRatings.
        ASSIGN 
            ttRaportRatings.RatingId         = buffRatings.RatingId
            ttRaportRatings.MovieID          = buffRatings.MovieId
            ttRaportRatings.UserName         = buffRatings.UserName
            ttRaportRatings.Rating           = buffRatings.Rating
            ttRaportRatings.AverageOfRatings = pdAverageOfRatings.
    END.
    
    OUTPUT TO Value(pcReportName).
    
    PUT UNFORMATTED 
        "-------------------------------- Cinema Movie ----------------------------------------------" SKIP(2).
    
    FOR EACH ttRaportMovies NO-LOCK:
        PUT UNFORMATTED 
            "--------------------------------------------------------------------------------------------" SKIP.
        PUT UNFORMATTED 
            "Movie Id" "Movie Title" AT 20 "The Genre" AT 50 "Release Date" AT 70 SKIP.
        PUT UNFORMATTED 
            ttRaportMovies.MovieId AT 5
            ttRaportMovies.MovieTitle  AT 20
            ttRaportMovies.Genre AT 50
            ttRaportMovies.ReleaseDate  AT 72 SKIP(1).
            
        FOR EACH ttRaportRatings NO-LOCK WHERE ttRaportMovies.MovieId = ttRaportRatings.MovieId:  
            PUT UNFORMATTED 
                "Rating ID:" ttRaportRatings.RatingId 
                "----------------------------------->"AT 13
                ttRaportRatings.UserName AT 50
                " rated the movie with " 
                ttRaportRatings.Rating " stars." SKIP.
        END.    
    END.
    
    FOR LAST ttRaportRatings NO-LOCK:
        PUT UNFORMATTED 
            "The average ratings of all movies is: " AT 1 ttRaportRatings.AverageOfRatings SKIP.
    END.
     
END PROCEDURE.

PROCEDURE getAverageOfRatings:
    DEFINE OUTPUT PARAMETER  pdAverageOfRatings AS DECIMAL.
    DEFINE VARIABLE iTotalRatings AS INTEGER NO-UNDO.
    DEFINE VARIABLE iNumRatings   AS INTEGER NO-UNDO.

    iTotalRatings=0.
    pdAverageOfRatings=0.

    FOR EACH ttRatings NO-LOCK :

        iTotalRatings = iTotalRatings + ttRatings.Rating.
        iNumRatings = iNumRatings + 1.

        IF iTotalRatings > 0 THEN
            pdAverageOfRatings = iTotalRatings / iNumRatings.
        ELSE
            pdAverageOfRatings=0.
    END.
END PROCEDURE.
