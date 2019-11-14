
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t1](
	[id] [int] NOT NULL,
	[x] [int] NOT NULL,
 CONSTRAINT [PK_t1] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER TRIGGER dbo.idt1 
   ON  dbo.t1 
   INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;
    DECLARE @triggerIsDisabled bit;
    IF (OBJECT_ID('tempdb..#disableTrigger') IS NULL) BEGIN
        CREATE TABLE #disableTrigger ( objectid int, spid int, CONSTRAINT pk_disableTrigger primary key CLUSTERED (spid, objectid) )
        SET @triggerIsDisabled=0;
    END ELSE BEGIN
        SET @triggerIsDisabled= (
            CASE 
                WHEN EXISTS(
                    SELECT dt.* FROM #disableTrigger dt
                    WHERE dt.objectid = OBJECT_ID('dbo.idt1')
                        AND dt.spid = @@SPID
                )
                THEN 0
                ELSE 1
            END
        );        
    END;
    IF (@triggerIsDisabled=0) BEGIN 
        DELETE dbo.t1 
        FROM dbo.t1
        INNER JOIN deleted
            ON dbo.t1.id = deleted.id
        ;
    END ELSE BEGIN
        UPDATE dbo.t1
            SET X=-1
            FROM dbo.T1
            INNER JOIN deleted
                ON dbo.t1.id = deleted.id
            ;
    END;
END
GO

-- repeat this

DECLARE @id int = (SELECT 9+ISNULL(max(id),1) FROM t1);
INSERT INTO [dbo].[t1]
           ([id]
           ,[x])
     VALUES
           (@id
           ,1);
INSERT INTO [dbo].[t1]
           ([id]
           ,[x])
     VALUES
           (@id+1
           ,1);


IF (OBJECT_ID('tempdb..#disableTrigger') IS NULL) BEGIN
    CREATE TABLE #disableTrigger ( objectid int, spid int, CONSTRAINT pk_disableTrigger primary key CLUSTERED (spid, objectid) )
END;
DELETE t1 WHERE id = @id
INSERT INTO #disableTrigger (objectid, spid) VALUES (OBJECT_ID('dbo.idt1'), @@SPID)
DELETE t1 WHERE id = @id+1
DELETE FROM #disableTrigger WHERE spid=@@SPID;
SELECT * FROM t1

