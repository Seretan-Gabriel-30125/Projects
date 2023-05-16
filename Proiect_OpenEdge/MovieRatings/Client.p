{dsMovies.i}
{dsRatings.i}

/*CURRENT-VALUE(MovieIdSQ)=6.  */
/*CURRENT-VALUE(RatingIdSQ)=12.*/

//RUN testCase1.
//RUN testCase2.
//RUN testCase3.
//RUN verificariValidariMovies.
//RUN verificariValidariRatings.

PROCEDURE testCase1:

    DEFINE VARIABLE hMoviesAndRatings AS HANDLE NO-UNDO.
    RUN BusinessEntity.p PERSISTENT SET hMoviesAndRatings.

    //Create Records Movies
    TEMP-TABLE ttMovies:TRACKING-CHANGES = TRUE.

    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = 7
        ttMovies.MovieTitle  = "Venom"
        ttMovies.Genre       = "Action"
        ttMovies.ReleaseDate = 11/5/2003.

    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = 8
        ttMovies.MovieTitle  = "Anything"
        ttMovies.Genre       = "Comedy"
        ttMovies.ReleaseDate = 5/5/2015.

    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = 9
        ttMovies.MovieTitle  = "Joker"
        ttMovies.Genre       = "Drama"
        ttMovies.ReleaseDate = 7/5/2012.
      
    TEMP-TABLE ttMovies:TRACKING-CHANGES = FALSE.

    DATASET dsMovies:WRITE-JSON("file","MovieRatings\dsMovies.json",TRUE).

    RUN beSaveChangesMovies IN hMoviesAndRatings(INPUT DATASET dsMovies).  
    
   // Create Records Ratings
    TEMP-TABLE ttRatings:TRACKING-CHANGES = TRUE.

    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 13
        ttRatings.MovieId  = 7
        ttRatings.UserName = "Sofia Gonzalez"
        ttRatings.Rating   = 8.

    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 14
        ttRatings.MovieId  = 7
        ttRatings.UserName = "Avery Davis"
        ttRatings.Rating   = 6.

    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 15
        ttRatings.MovieId  = 8
        ttRatings.UserName = "Emily Baker"
        ttRatings.Rating   = 9.

    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 16
        ttRatings.MovieId  = 8
        ttRatings.UserName = "Lily Zhang"
        ttRatings.Rating   = 7.

    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 17
        ttRatings.MovieId  = 9
        ttRatings.UserName = "Chloe Lee"
        ttRatings.Rating   = 5.

    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 18
        ttRatings.MovieId  = 9
        ttRatings.UserName = "Leo Nguyen"
        ttRatings.Rating   = 6.
       
     
    TEMP-TABLE ttRatings:TRACKING-CHANGES = FALSE.

    DATASET dsRatings:WRITE-JSON("file","MovieRatings\dsRatings.json",TRUE).

    RUN beSaveChangesRatings IN hMoviesAndRatings(INPUT DATASET dsRatings).

    FINALLY:
        DELETE PROCEDURE hMoviesAndRatings NO-ERROR.
    END FINALLY.
                                                   
END PROCEDURE.           


PROCEDURE testCase2:
    DEFINE VARIABLE hUpdateDelete AS HANDLE NO-UNDO.
    RUN BusinessEntity.p PERSISTENT SET hUpdateDelete.

    //Update Movies
    RUN beFetchDataMovies IN hUpdateDelete(INPUT 3, OUTPUT DATASET dsMovies).

    DATASET dsMovies:WRITE-JSON("file","MovieRatings\dsMoviesBeforeUpdate.json",TRUE).

    TEMP-TABLE ttMovies:TRACKING-CHANGES = TRUE.

    FOR EACH ttMovies NO-LOCK:
        ttMovies.MovieTitle = "Mockumentary under 18".
    END.

    TEMP-TABLE ttMovies:TRACKING-CHANGES = FALSE.

    RUN beSaveChangesMovies IN hUpdateDelete(INPUT DATASET dsMovies).

    DATASET dsMovies:WRITE-JSON("file","MovieRatings\dsMoviesAfterUpdate.json",TRUE).
    
    
    //Update Ratings
    RUN beFetchDataRatings IN hUpdateDelete(INPUT 5, OUTPUT DATASET dsRatings).

    DATASET dsRatings:WRITE-JSON("file","MovieRatings\dsRatingsBeforeUpdate.json",TRUE).   

    TEMP-TABLE ttRatings:TRACKING-CHANGES = TRUE.

    FOR EACH ttRatings NO-LOCK:
        ttRatings.UserName = "Ionut Cristian".
    END.
    
    TEMP-TABLE ttRatings:TRACKING-CHANGES = FALSE.
        
    RUN beSaveChangesRatings IN hUpdateDelete(INPUT DATASET dsRatings).
    
    DATASET dsRatings:WRITE-JSON("file","MovieRatings\dsRatingsAfterUpdate.json",TRUE).   
    
    
    //Delete Movies
    RUN beFetchDataMovies IN hUpdateDelete(INPUT 7, OUTPUT DATASET dsMovies).

    DATASET dsMovies:WRITE-JSON("file","MovieRatings\dsMoviesBeforeDelete.json",TRUE).

    TEMP-TABLE ttMovies:TRACKING-CHANGES = TRUE.

    FOR EACH ttMovies :
        DELETE ttMovies.
    END.

    TEMP-TABLE ttMovies:TRACKING-CHANGES = FALSE.

    RUN beSaveChangesMovies IN hUpdateDelete(INPUT DATASET dsMovies).

    DATASET dsMovies:WRITE-JSON("file","MovieRatings\dsMoviesAfterDelete.json",TRUE).


    //Delete Ratings
    RUN beFetchDataRatings IN hUpdateDelete(INPUT 17, OUTPUT DATASET dsRatings).

    DATASET dsRatings:WRITE-JSON("file","MovieRatings\dsRatingsBeforeDelete.json",TRUE).

    TEMP-TABLE ttRatings:TRACKING-CHANGES = TRUE.

    FOR EACH ttRatings :
        DELETE ttRatings.
    END.

    TEMP-TABLE ttRatings:TRACKING-CHANGES = FALSE.

    RUN beSaveChangesRatings IN hUpdateDelete(INPUT DATASET dsRatings).

    DATASET dsRatings:WRITE-JSON("file","MovieRatings\dsRatingsAfterDelete.json",TRUE).

    FINALLY:
        DELETE PROCEDURE hUpdateDelete NO-ERROR.
    END FINALLY.

END PROCEDURE.

PROCEDURE testCase3:
    DEFINE VARIABLE hRaport AS HANDLE NO-UNDO.
    RUN BusinessEntity.p PERSISTENT SET hRaport.

    RUN MoviesRatingsRaport IN hRaport(INPUT "MovieRatings\RaportMoviesRatings.txt").
    
END PROCEDURE. 

PROCEDURE verificariValidariMovies:
    
    DEFINE VARIABLE hValidariMovies AS HANDLE NO-UNDO.
    RUN BusinessEntity.p PERSISTENT SET hValidariMovies.
    
    //Testam validarile din tabela movies
    TEMP-TABLE ttMovies:TRACKING-CHANGES = TRUE.  
    
    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = -4
        ttMovies.MovieTitle  = "test3"
        ttMovies.Genre       = ""
        ttMovies.ReleaseDate = 7/5/2001.
        
      //Introducem film cu MovieTitle deja existent in DB 
    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = -2
        ttMovies.MovieTitle  = "Joker"
        ttMovies.Genre       = "Action"
        ttMovies.ReleaseDate = 11/5/2003.    
        
    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = 50
        ttMovies.MovieTitle  = ""
        ttMovies.Genre       = "Action"
        ttMovies.ReleaseDate = 7/5/2001.
       
    //Introducem o data mai mare decat data de astazi
    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = 77
        ttMovies.MovieTitle  = "test2"
        ttMovies.Genre       = "Comedy"
        ttMovies.ReleaseDate = 5/5/2030.
   
    //Introducem un record cu date corecte pentru a demonstra ca nu se adauga in DB (tranzactia)    
    CREATE ttMovies.
    ASSIGN
        ttMovies.MovieId     = 99
        ttMovies.MovieTitle  = "FunctionalTest"
        ttMovies.Genre       = "Drama"
        ttMovies.ReleaseDate = 7/5/2000.
        
    TEMP-TABLE ttMovies:TRACKING-CHANGES = FALSE.

    RUN beSaveChangesMovies IN hValidariMovies(INPUT DATASET dsMovies).
   
    FINALLY:
        DELETE PROCEDURE hValidariMovies NO-ERROR.
    END FINALLY.
END PROCEDURE.
    
      
PROCEDURE verificariValidariRatings:
    
    DEFINE VARIABLE hValidariRatings AS HANDLE NO-UNDO.
    RUN BusinessEntity.p PERSISTENT SET hValidariRatings.
    
    //Testam validarile din tabela Ratings
    TEMP-TABLE ttRatings:TRACKING-CHANGES = TRUE.
    
    //Introducem un film care nu exista in DB.
    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 33
        ttRatings.MovieId  = 100
        ttRatings.UserName = "Emily Baker"
        ttRatings.Rating   = 9.
        
      //Introducem un rating care nu este intre 1 si 10
    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 44
        ttRatings.MovieId  = 4
        ttRatings.UserName = "Avery Davis"
        ttRatings.Rating   = 15.    
        
    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 55
        ttRatings.MovieId  = 5
        ttRatings.UserName = ""
        ttRatings.Rating   = 8.
    
    //Introducem un record cu date corecte pentru a demonstra ca nu se adauga in DB (tranzactia)
    CREATE ttRatings.
    ASSIGN
        ttRatings.RatingId = 99
        ttRatings.MovieId  = 8
        ttRatings.UserName = "Lily Zhang"
        ttRatings.Rating   = 10.
        
    TEMP-TABLE ttRatings:TRACKING-CHANGES = FALSE.
   
    RUN beSaveChangesRatings IN hValidariRatings(INPUT DATASET dsRatings).
    
    FINALLY:
        DELETE PROCEDURE hValidariRatings NO-ERROR.
    END FINALLY.
    
END PROCEDURE.   