USE [prueba]
GO

CREATE TABLE usuario (
    id_usuario int IDENTITY(1,1) PRIMARY KEY,
	usuario_red varchar(30) NOT NULL UNIQUE,
	fecha_registro datetime default CURRENT_TIMESTAMP,
	estado varchar(1) default '1'
);

------------------------------------------------  
-- >>> PROCEDIMIENTO CREAR USUARIO <<<
------------------------------------------------  
DROP PROCEDURE IF EXISTS SP_Crear_Usuario;
GO 

CREATE PROCEDURE SP_Crear_Usuario
@usuario_red as varchar(30)
AS
DECLARE
@res as varchar(20)
BEGIN
	IF EXISTS(SELECT id_usuario FROM USUARIO WHERE usuario_red = @usuario_red)
		BEGIN 
			SET @res = '-1'; -- El usuario ya existe
		END
	ELSE
		BEGIN TRY
			INSERT INTO usuario (usuario_red, fecha_registro, estado) VALUES (@usuario_red, CURRENT_TIMESTAMP, '1');
			SET @res = STR(SCOPE_IDENTITY());	
		END TRY
		BEGIN CATCH  
			SET @res = '0'; -- ERROR
		END CATCH
	END
	SELECT @res AS res;

------------------------------------------------  
-- >>> PROCEDIMIENTO CONSULTAR USUARIOS <<<
------------------------------------------------  
DROP PROCEDURE IF EXISTS SP_Consultar_Usuario;
GO 

CREATE PROCEDURE SP_Consultar_Usuario
@criterio as varchar(30)
AS
BEGIN
	IF ISNUMERIC(@criterio) > 0
	BEGIN 
		SELECT * FROM usuario WHERE id_usuario = cast(@criterio as int)
	END
	ELSE IF @criterio != ''
	BEGIN 
		SELECT * FROM usuario WHERE usuario_red = @criterio
	END
	ELSE 
		BEGIN
			SELECT * FROM usuario
		END
	END
GO

------------------------------------------------  
-- >>> PROCEDIMIENTO MODIFICAR USUARIOS <<<
------------------------------------------------  
DROP PROCEDURE IF EXISTS SP_Modificar_Usuario;
GO 

CREATE PROCEDURE SP_Modificar_Usuario
@id_usuario as int,
@usuario_red as varchar(30),
@estado as varchar(1)
AS
DECLARE
@res as varchar(30)
BEGIN
	IF @id_usuario != 0 AND @usuario_red != '' AND @estado != ''
		BEGIN
			IF EXISTS(SELECT id_usuario FROM usuario WHERE usuario_red = @usuario_red AND id_usuario != @id_usuario)
				BEGIN
					SET @res = '-1'; -- El usuario ya existe
				END
			ELSE
				BEGIN
					UPDATE usuario SET usuario_red = @usuario_red, estado = @estado WHERE id_usuario = @id_usuario
					IF (@@ROWCOUNT > 0)
						SET @res = '1'; -- OK
					ELSE
						SET @res = '0'; -- ERROR
					END
				END
	ELSE
		SET @res = '2'; -- Debe completar todos los campos
	END
	SELECT @res AS res;
GO

SELECT id_usuario FROM usuario WHERE usuario_red = 'd'

------------------------------------------------  
-- >>> PROCEDIMIENTO ELIMINAR USUARIOS <<<
------------------------------------------------  
DROP PROCEDURE IF EXISTS SP_Desactivar_Usuario;
GO 

CREATE PROCEDURE SP_Desactivar_Usuario
@ID as int
AS
DECLARE
@res as varchar(1)
BEGIN
	IF @ID != 0 
		BEGIN
			BEGIN TRY 
				UPDATE usuario SET estado = '0' WHERE id_usuario = @ID
				SET @res = '1'; -- OK
			END TRY
			BEGIN CATCH  
				SET @res = '0'; --ERROR
			END CATCH
		END
	ELSE
		SET @res = '2'; -- Debe completar todos los campos
	END
	SELECT @res AS res;
GO