CREATE TABLE [dbo].[Classes] (
    [ClassId]  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Location] VARCHAR (50)     NOT NULL,
    [Teacher]  VARCHAR (50)     NOT NULL,
    [Name] VARCHAR(50) NOT NULL, 
    CONSTRAINT [PK_Classes] PRIMARY KEY CLUSTERED ([ClassId] ASC)
);

