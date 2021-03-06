USE [master]
GO
/****** Object:  Database [bdCarros]    Script Date: 31/03/2018 22:05:15 ******/
CREATE DATABASE [bdCarros]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'bdCarros', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\bdCarros.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bdCarros_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\bdCarros_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [bdCarros] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bdCarros].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bdCarros] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bdCarros] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bdCarros] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bdCarros] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bdCarros] SET ARITHABORT OFF 
GO
ALTER DATABASE [bdCarros] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bdCarros] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bdCarros] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bdCarros] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bdCarros] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bdCarros] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bdCarros] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bdCarros] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bdCarros] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bdCarros] SET  DISABLE_BROKER 
GO
ALTER DATABASE [bdCarros] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bdCarros] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bdCarros] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bdCarros] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bdCarros] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bdCarros] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [bdCarros] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [bdCarros] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bdCarros] SET  MULTI_USER 
GO
ALTER DATABASE [bdCarros] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bdCarros] SET DB_CHAINING OFF 
GO
ALTER DATABASE [bdCarros] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [bdCarros] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [bdCarros] SET DELAYED_DURABILITY = DISABLED 
GO
USE [bdCarros]
GO
/****** Object:  Table [dbo].[Carros]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Carros](
	[codCarro] [int] IDENTITY(1,1) NOT NULL,
	[modelo] [varchar](50) NOT NULL,
	[numPortas] [tinyint] NOT NULL,
	[cor] [varchar](20) NOT NULL,
	[codMontadora] [int] NOT NULL,
 CONSTRAINT [PK_Carros] PRIMARY KEY CLUSTERED 
(
	[codCarro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Montadoras]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Montadoras](
	[codMontadora] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](40) NOT NULL,
 CONSTRAINT [PK_Montadoras] PRIMARY KEY CLUSTERED 
(
	[codMontadora] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Carros]  WITH CHECK ADD  CONSTRAINT [FK_Carros_Montadoras] FOREIGN KEY([codMontadora])
REFERENCES [dbo].[Montadoras] ([codMontadora])
GO
ALTER TABLE [dbo].[Carros] CHECK CONSTRAINT [FK_Carros_Montadoras]
GO
/****** Object:  StoredProcedure [dbo].[uspAlterarCarro]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAlterarCarro]
	@codCarro INT,
	@modelo VARCHAR(50),
	@numPortas TINYINT,
	@cor VARCHAR(20),
	@codMontadora INT

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN

			UPDATE Carros SET modelo = @modelo, numPortas = @numPortas, cor = @cor, codMontadora = @codMontadora
				WHERE codCarro = @codCarro

			SELECT @codCarro AS Atualizado

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspAlterarMontadora]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAlterarMontadora]
	@codMontadora INT,
	@nome VARCHAR(40)

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN

			UPDATE Montadoras SET nome = @nome WHERE codMontadora = @codMontadora

			SELECT @codMontadora AS Atualizado

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspConsultaCarroModelo]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspConsultaCarroModelo]
	@modelo VARCHAR(50)

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN

			SELECT * FROM Carros WHERE Carros.modelo LIKE '%' + @modelo + '%'

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspConsultaMontadoraCarro]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspConsultaMontadoraCarro]
	@nome VARCHAR(40)

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN

			SELECT M.nome, C.modelo, C.numPortas, C.cor FROM Montadoras AS M
			INNER JOIN
			Carros AS C ON M.codMontadora = C.codMontadora
			WHERE M.nome LIKE '%' + @nome + '%'

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspConsultaMontadoraNome]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspConsultaMontadoraNome]
	@nome VARCHAR(40)

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN
			
			SELECT * FROM Montadoras WHERE nome LIKE '%' + @nome + '%'

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeletarCarro]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeletarCarro]
	@codCarro INT
AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN

			DELETE FROM Carros WHERE codCarro = @codCarro

			SELECT @codCarro AS Deletado

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspDeletarMontadora]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspDeletarMontadora]
	@codMontadora INT

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN

			DELETE FROM Montadoras WHERE codMontadora = @codMontadora

			SELECT @codMontadora AS Deletado

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspInserirCarro]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspInserirCarro]
	@modelo VARCHAR(50),
	@numPortas TINYINT,
	@cor VARCHAR(20),
	@codMontadora INT 

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN

			INSERT INTO Carros (modelo, numPortas, cor, codMontadora) VALUES (@modelo, @numPortas, @cor, @codMontadora)

			DECLARE @codCarroNovo AS INT = @@IDENTITY

			SELECT @codCarroNovo AS Cadastrado

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[uspInserirMontadora]    Script Date: 31/03/2018 22:05:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspInserirMontadora]
	@nome VARCHAR(40)

AS

BEGIN
	
	BEGIN TRY

		BEGIN TRAN
			
			INSERT INTO Montadoras (nome) values (@nome)

			DECLARE @codMontadoraNova AS INT = @@IDENTITY

			SELECT @codMontadoraNova AS Cadastrado

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		
		ROLLBACK TRAN

		SELECT ERROR_MESSAGE() AS Retorno
	END CATCH
END
GO
USE [master]
GO
ALTER DATABASE [bdCarros] SET  READ_WRITE 
GO
