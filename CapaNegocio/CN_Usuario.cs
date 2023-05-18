using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CapaDatos;
using CapaEntidad;

namespace CapaNegocio
{
    public class CN_Usuario
    {
        private CDUsuario objcd_Usuario = new CDUsuario();

        public List<Usuario> Listar()
        {
            return objcd_Usuario.Listar();
        }
        public int Registrar(Usuario obj, out string Mensaje)
        {
            Mensaje = string.Empty;
            if (obj.Documento == "")
            {
                Mensaje += "Ingrese su Documento\n";
            }
            if (obj.NombreCompleto == "")
            {
                Mensaje += "Ingrese su Nombre Completo\n";
            }
            if (obj.Correo == "")
            {
                Mensaje += "Ingrese su Correo\n";
            }
            if (obj.Clave == "")
            {
                Mensaje += "Ingrese su Clave";
            }
            if (Mensaje != string.Empty)
            {
                return 0;
            }
            else
            {
                return objcd_Usuario.Registrar(obj, out Mensaje);
            }

        }
        public bool Editar(Usuario obj, out string Mensaje)
        {
            Mensaje=string.Empty;

            if (obj.Documento == "")
            {
                Mensaje += "Ingrese su Documento\n";
            }
            if (obj.NombreCompleto == "")
            {
                Mensaje += "Ingrese su Nombre Completo\n";
            }
            if (obj.Correo == "")
            {
                Mensaje += "Ingrese su Correo\n";
            }
            if (obj.Clave == "")
            {
                Mensaje += "Ingrese su Clave\n";
            }

            if (Mensaje != string.Empty)
            {
                return false;
            }
            else
            {
                return objcd_Usuario.Editar(obj, out Mensaje);
            }
        }
        public bool Eliminar(Usuario obj, out string Mensaje)
        {
            return objcd_Usuario.Eliminar(obj, out Mensaje);
        }
    }
}
