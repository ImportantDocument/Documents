USE [ContactDirectory1]
GO
/****** Object:  StoredProcedure [dbo].[GetUserDetails]    Script Date: 7/17/2018 12:46:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC GetUserDetails 1,20,null,null,null,null,null,'India',null,null,null,null,null,null,null,null
ALTER PROCEDURE [dbo].[GetUserDetails]
(             
	@PageNum			INT,              
	@PageSize			INT,
	@OrderColumnName	VARCHAR(50)	 = NULL,                
	@OrderColumnDir		VARCHAR(50)	 = NULL,              
	@FirstName			VARCHAR(200) = NULL,      
	@LastName			VARCHAR(200) = NULL,            
	@MiddleName			VARCHAR(200) = NULL,     
	@Ccountry			VARCHAR(200) = NULL,         
	@Ctaluka			VARCHAR(200) = NULL,      
	@Cdistrict			VARCHAR(200) = NULL,    
	@Cvillage			VARCHAR(200) = NULL,      
	@Czip				VARCHAR(200) = NULL,    
	@Profession			VARCHAR(200) = NULL,      
	@BloodGroup			VARCHAR(200) = NULL,    
	@Gender				VARCHAR(200) = NULL,
	@Degree				VARCHAR(200) = NULL 
)
AS              
BEGIN
	DECLARE @SearchResult TABLE
	(              
		Id								INT,
		UserId							INT,              
		Email							NVARCHAR(100),
		PhoneNo							VARCHAR(100),          
		FirstName						VARCHAR(100),      
		MiddleName						VARCHAR(100),      
		LastName						VARCHAR(100),          
		BloodGroup						VARCHAR(100),          
		Caddress						VARCHAR(100),          
		Ccountry						VARCHAR(100),   
		Cstate							VARCHAR(100),
		Ctaluka							VARCHAR(100),    
		Cdistrict						VARCHAR(100),      
		Cvillage						VARCHAR(100),    
		Czip							VARCHAR(100),          
		DOB								DATE,          
		Department						VARCHAR(100),          
		Gender							VARCHAR(100),          
		Profession						VARCHAR(100),          
		MaritualStatus					VARCHAR(100),        
		CreatedDate						DATETIME,              
		LastActivityDate				DATETIME,
		IsShowCurrentAddressOnSearch	BIT,
		IsShowPermanentAddressOnSearch	BIT,
		IsShowJobDetailsOnSearch		BIT,
		IsShowJobAddressOnSearch		BIT,
		IsShowEducationOnSearch			BIT,
		IsShowUserEmailOnSearch			BIT,
		IsShowUserPhoneNoOnSearch		BIT,
		CLatitude						decimal(12,9),
		CLongitude						decimal(12,9),
		PLatitude						decimal(12,9),
		PLongitude						decimal(12,9),
		OLatitude						decimal(12,9),
		OLongitude						decimal(12,9)
	);      
	        
	DECLARE @TotalCount AS INT              
              
	SET @TotalCount = (SELECT COUNT(DISTINCT U.Id) FROM Users AS U          
			INNER JOIN UserProfiles AS UF ON UF.UserID = U.Id             
			LEFT JOIN UserEducation UE ON UE.UserID = U.Id
			WHERE	(ISNULL(@FirstName,'') = ''OR UF.FirstName LIKE '%' + @FirstName + '%')           
				AND (ISNULL(@MiddleName,'') = '' OR UF.MiddleName LIKE '%' + @MiddleName + '%')           
				AND (ISNULL(@LastName,'') = '' OR UF.LastName LIKE '%' + @LastName + '%')           
				AND (ISNULL(@Ctaluka,'') = '' OR UF.Ctaluka LIKE '%'+ @Ctaluka +'%')      
				AND (ISNULL(@Cvillage,'') = '' OR UF.Cvillage LIKE '%'+ @Cvillage +'%')      
				AND (ISNULL(@BloodGroup,'') = '' OR UF.BloodGroup LIKE '%'+ @BloodGroup +'%')      
				AND (ISNULL(@Profession,'') = '' OR UF.Profession LIKE '%'+ @Profession +'%')    
				AND (ISNULL(@Cdistrict,'') = '' OR UF.Cdistrict LIKE '%'+ @Cdistrict +'%')    
				AND (ISNULL(@Czip,'') = '' OR UF.Czip LIKE '%'+ @Czip +'%')    
				AND (ISNULL(@Gender,'') = '' OR UF.Gender LIKE '%'+ @Gender +'%')  
				AND (ISNULL(@Ccountry,'') = '' OR UF.Ccountry LIKE '%'+ @Ccountry +'%')  
				AND (ISNULL(U.EmailVerified,0) = 1 OR ISNULL(U.PhoneVerified,0) =1)  
				AND (ISNULL(@Degree,'') = '' OR UE.Degree LIKE '%'+ @Degree +'%')  
				AND ISNULL(U.IsActive,0) = 1)              
              
			  select @TotalCount

	INSERT INTO @SearchResult
			(Id,
			 UserId,
			  Email, 
			  PhoneNo,
			   FirstName, MiddleName, LastName, BloodGroup, Caddress, Ccountry, 
			Cstate, Ctaluka, Cdistrict, Cvillage, Czip, DOB, Department, Gender, Profession, MaritualStatus, CreatedDate, 
			LastActivityDate, IsShowCurrentAddressOnSearch, IsShowPermanentAddressOnSearch, IsShowJobDetailsOnSearch, 
			IsShowJobAddressOnSearch, IsShowEducationOnSearch, IsShowUserEmailOnSearch, IsShowUserPhoneNoOnSearch,CLatitude,CLongitude,PLatitude,PLongitude,OLatitude,OLongitude)            
	SELECT	DISTINCT UF.Id,
			U.Id AS UserId,
			U.Email,
			U.PhoneNo,
			UF.FirstName,
			UF.MiddleName,
			UF.LastName,
			UF.BloodGroup,
			UF.Caddress,
			UF.Ccountry,
			UF.Cstate,UF.Ctaluka,UF.Cdistrict,UF.Cvillage,UF.Czip,UF.DOB,UF.Department,UF.Gender,UF.Profession,
			UF.MaritualStatus,U.CreatedDate,U.LastActivityDate,UF.IsShowCurrentAddressOnSearch,UF.IsShowPermanentAddressOnSearch  ,
			UF.IsShowJobDetailsOnSearch, UF.IsShowJobAddressOnSearch, UF.IsShowEducationOnSearch, 
			UF.IsShowUserEmailOnSearch, UF.IsShowUserPhoneNoOnSearch,UF.CLatitude,UF.CLongitude,UF.PLatitude,UF.PLongitude,UF.OLatitude,UF.OLongitude
	FROM Users AS U          
		INNER JOIN UserProfiles as UF on UF.UserID = U.Id       
		LEFT JOIN UserEducation UE ON UE.UserID = U.Id     
	WHERE	(ISNULL(@FirstName,'') = ''OR UF.FirstName LIKE '%' + @FirstName + '%')           
		AND (ISNULL(@MiddleName,'') = '' OR UF.MiddleName LIKE '%' + @MiddleName + '%')           
		AND (ISNULL(@LastName,'') = '' OR UF.LastName LIKE '%' + @LastName + '%')           
		AND (ISNULL(@Ctaluka,'') = '' OR UF.Ctaluka LIKE '%'+ @Ctaluka +'%')      
		AND (ISNULL(@Cvillage,'') = '' OR UF.Cvillage LIKE '%'+ @Cvillage +'%')      
		AND (ISNULL(@BloodGroup,'') = '' OR UF.BloodGroup LIKE '%'+ @BloodGroup +'%')      
		AND (ISNULL(@Profession,'') = '' OR UF.Profession LIKE '%'+ @Profession +'%')    
		AND (ISNULL(@Cdistrict,'') = '' OR UF.Cdistrict LIKE '%'+ @Cdistrict +'%')    
		AND (ISNULL(@Czip,'') = '' OR UF.Czip LIKE '%'+ @Czip +'%')    
		AND (ISNULL(@Gender,'') = '' OR UF.Gender LIKE '%'+ @Gender +'%')  
		AND (ISNULL(@Ccountry,'') = '' OR UF.Ccountry LIKE '%'+ @Ccountry +'%')  
		AND (ISNULL(U.EmailVerified,0) = 1 OR ISNULL(U.PhoneVerified,0) =1)  
		AND (ISNULL(@Degree,'') = '' OR UE.Degree LIKE '%'+ @Degree +'%')  
		AND ISNULL(U.IsActive,0) = 1
          
	SELECT @TotalCount = COUNT(DISTINCT(Id)) FROM @SearchResult              
              
	BEGIN              
		WITH SqlPaging AS 
		(
			SELECT TOP(@PageSize * @PageNum) ROW_NUMBER() OVER (              
				ORDER BY              
				CASE WHEN @OrderColumnName = 'FirstName' and @OrderColumnDir = 'asc'              
				THEN FirstName END ASC,              
				CASE WHEN @OrderColumnName = 'FirstName' and @OrderColumnDir = 'desc'       
				THEN FirstName END DESC,                 
				CASE WHEN @OrderColumnName = 'LastName' and @OrderColumnDir = 'asc'              
				THEN LastName END ASC,              
				CASE WHEN @OrderColumnName = 'LastName' and @OrderColumnDir = 'desc'              
				THEN LastName END DESC,
				CASE WHEN @OrderColumnName = 'MiddleName' and @OrderColumnDir = 'asc'              
				THEN MiddleName END ASC,              
				CASE WHEN @OrderColumnName = 'MiddleName' and @OrderColumnDir = 'desc'              
				THEN MiddleName END DESC,   
				CASE WHEN @OrderColumnName = 'Taluka' and @OrderColumnDir = 'asc'              
				THEN Ctaluka END ASC,              
				CASE WHEN @OrderColumnName = 'Taluka' and @OrderColumnDir = 'desc'              
				THEN Ctaluka END DESC,     
				CASE WHEN @OrderColumnName = 'Country' and @OrderColumnDir = 'asc'              
				THEN Ccountry END ASC,              
				CASE WHEN @OrderColumnName = 'Country' and @OrderColumnDir = 'desc'              
				THEN Ccountry END DESC,  
				CASE WHEN @OrderColumnName = 'BloodGroup' and @OrderColumnDir = 'asc'              
				THEN BloodGroup END ASC,              
				CASE WHEN @OrderColumnName = 'BloodGroup' and @OrderColumnDir = 'desc'              
				THEN BloodGroup END DESC,
				CASE WHEN @OrderColumnName = 'Gender' and @OrderColumnDir = 'asc'              
				THEN Gender END ASC,              
				CASE WHEN @OrderColumnName = 'Gender' and @OrderColumnDir = 'desc'              
				THEN Gender END DESC,
				CASE WHEN @OrderColumnName = 'Village' and @OrderColumnDir = 'asc'              
				THEN Cvillage END ASC,              
				CASE WHEN @OrderColumnName = 'Village' and @OrderColumnDir = 'desc'              
				THEN Cvillage END DESC,
				CASE WHEN @OrderColumnName IS NULL 
				THEN Id END DESC
			) AS ResultNum,              
			Id,   
			UserId,           
			Email,              
			PhoneNo,               
			FirstName,       
			MiddleName,      
			LastName,          
			BloodGroup, 
			Caddress,    
			Ccountry,
			Cstate,      
			Ctaluka,        
			Cdistrict,    
			Cvillage,      
			Czip,      
			DOB,          
			Department,          
			Gender,          
			Profession,          
			MaritualStatus,          
			CreatedDate,          
			LastActivityDate,
			IsShowCurrentAddressOnSearch, 
			IsShowPermanentAddressOnSearch, 
			IsShowJobDetailsOnSearch, 
			IsShowJobAddressOnSearch, 
			IsShowEducationOnSearch,  
			IsShowUserEmailOnSearch,
			IsShowUserPhoneNoOnSearch,  
			CLatitude,
			CLongitude,			
			PLatitude,
			PLongitude,
			OLatitude,
			OLongitude,			          
			@TotalCount AS TotalCount              
			FROM @SearchResult SR              
			WHERE (ISNULL(@FirstName,'') = '' OR FirstName LIKE '%'+ @FirstName +'%')      
				AND (ISNULL(@MiddleName,'') = '' OR MiddleName LIKE '%'+ @MiddleName +'%')      
				AND (ISNULL(@LastName,'') = '' OR LastName LIKE '%'+ @LastName +'%')          
				AND (ISNULL(@Ctaluka,'') = '' OR Ctaluka LIKE '%'+ @Ctaluka +'%')      
				AND (ISNULL(@Cvillage,'') = '' OR Cvillage LIKE '%'+ @Cvillage +'%')      
				AND (ISNULL(@BloodGroup,'') = '' OR BloodGroup LIKE '%'+ @BloodGroup +'%')      
				AND (ISNULL(@Profession,'') = '' OR Profession LIKE '%'+ @Profession +'%')     
				AND (ISNULL(@Cdistrict,'') = '' OR Cdistrict LIKE '%'+ @Cdistrict +'%')      
				AND (ISNULL(@Czip,'') = '' OR Czip LIKE '%'+ @Czip +'%')    
				AND (ISNULL(@Gender,'') = '' OR Gender LIKE '%'+ @Gender +'%')    
				AND (ISNULL(@Ccountry,'') = '' OR Ccountry LIKE '%'+ @Ccountry +'%')  
		)
		                
		SELECT* FROM SqlPaging WITH(NOLOCK) WHERE ResultNum > ((@PageNum - 1) * @PageSize)              

	DELETE FROM @SearchResult 
	END
END