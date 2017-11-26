CREATE TRIGGER [CheckUniqueSurname]
ON [dbo].[Students]
INSTEAD OF INSERT, UPDATE
AS
BEGIN
   DECLARE @InsertedSurname VARCHAR(50)  = (SELECT Surname  FROM INSERTED );
   DECLARE @InsertedClassId uniqueidentifier = (SELECT ClassId  FROM INSERTED );
   DECLARE @InsertedStudentId uniqueidentifier = (SELECT StudentId  FROM INSERTED );
   DECLARE @IsSurnameExist BIT  = (SELECT 1 
								    FROM [dbo].[Students] 
								   WHERE
								    StudentId <>  @InsertedStudentId
									AND Surname = @InsertedSurname 
									AND ClassId = @InsertedClassId)

   IF (@IsSurnameExist = 1)
     BEGIN
			RAISERROR('Cannot insert student because the surname is already exist at the class',1,1);
			ROLLBACK TRANSACTION;
	 END
   ELSE
   BEGIN	
	    MERGE [dbo].[Students] AS target        
		USING INSERTED  AS source  
		ON (target.StudentId = source.StudentId)                     
        WHEN  MATCHED THEN 		  
		  	  UPDATE SET
			    [Name] = SOURCE.[Name],
				Surname = SOURCE.Surname,
				DOB = SOURCE.DOB,
				GPA = SOURCE.GPA
        WHEN NOT MATCHED  BY TARGET THEN
			   INSERT (StudentId,[Name], Surname, DOB, GPA, ClassId)
			   VALUES(SOURCE.StudentId,SOURCE.[Name], SOURCE.Surname, SOURCE.DOB, SOURCE.GPA, SOURCE.ClassId)	;	   
		  
   END
END
