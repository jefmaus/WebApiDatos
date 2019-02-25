using System;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Cors;
using System.Web.Http.Description;
using WebApiDatos.Models;

namespace WebApiDatos.Controllers
{
    //[Route("api/user")]
    public class UsuarioController : ApiController
    {
        private pruebaEntities db = new pruebaEntities();

        // GET: api/Usuario
        /// <summary>
        /// Obtiene la lista de usuarios
        /// </summary>
        /// <returns>Lista de usuarios de tipo ObjectResult</returns>
        public ObjectResult<ConsultarUsuario_Result> GetUsuario()
        {
            return db.SP_Consultar_Usuario("");
        }

        // GET: api/Usuario/5
        /// <summary>
        /// Obtiene un usuario indicando su id
        /// </summary>
        /// <param name="id">id de usuario</param>
        /// <returns>Lista con el usuario de tipo ObjectResult</returns>
        public IHttpActionResult GetUsuario(string id)
        {
            ObjectResult<ConsultarUsuario_Result> result = db.SP_Consultar_Usuario(id);
            if (result == null)
            {
                return NotFound();
            }
            return Ok(result);
        }

        // POST: api/Usuario
        // FromBody: deserializa automaticamente el JSON que enviamos
        /// <summary>
        /// Guarda un usuario en la base de datos
        /// </summary>
        /// <param name="usuario">Objeto de tipo Usuario</param>
        /// <returns>Si guardó, devuelve el id, si el usuario ya existe, devuelve -1 y si hubo un error devuelve 0.</returns>
        public IHttpActionResult PostUsuario([FromBody] usuario usuario)
        {
            if (usuario == null)
            {
                return BadRequest(ModelState);
            }

            try
            {
                ObjectResult<CrearUsuario_Result> result = db.SP_Crear_Usuario(usuario.usuario_red);
                string res = result.ElementAt<CrearUsuario_Result>(0).res.Trim();
                return Ok(res);
            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.WriteLine(e.Message);
                return NotFound();
            }
        }

        // PUT: api/Usuario
        /// <summary>
        /// Actualiza el nombre y el estado de un usuario en la DB.
        /// </summary>
        /// <param name="usuario">Objeto de tipo usuario</param>
        /// <returns>Devuelve 1 si modificó, 2 si no se enviarosn todos los campos y 0 si hubo un error</returns>
        public IHttpActionResult PutUsuario(usuario usuario)
        {
            /*if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }*/

            if (usuario.id_usuario == 0 || usuario.estado == "")
            {
                return BadRequest();
            }

            try
            {
                ObjectResult<ModificarUsuario_Result> result = db.SP_Modificar_Usuario(usuario.id_usuario, usuario.usuario_red, usuario.estado);
                string res = result.ElementAt<ModificarUsuario_Result>(0).res.Trim();
                return Ok(res);
            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.WriteLine(e.Message);
                return NotFound();
            }
            //return StatusCode(HttpStatusCode.NoContent);
        }

        // DELETE: api/Usuario/5
        public IHttpActionResult DeleteUsuario(int id)
        {
            if (id == 0)
            {
                return BadRequest();
            }

            try
            {
                ObjectResult<DesactivarUsuario_Result> result = db.SP_Desactivar_Usuario(id);
                string res = result.ElementAt<DesactivarUsuario_Result>(0).res.Trim();
                return Ok(res);
            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.WriteLine(e.Message);
                return NotFound();
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

    }
}