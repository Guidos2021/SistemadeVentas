using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CapaPresentacion
{
    public partial class ReestablecerContraseña : Form
    {
        public ReestablecerContraseña()
        {
            InitializeComponent();
        }

        private void btnEnviar_Click(object sender, EventArgs e)
        {
            if (txtCorreo.Text == "")
            {
                lblMessage.Visible = true;
                lblMessage.Text = "Error, Ingresa un correo electronico valido...!";
                picError.Visible = true;
                picCorrecto.Visible = false;
                txtCorreo.Text = "";
                txtCorreo.Focus();
            }
            else
            {
                lblMessage.Visible = true;
                lblMessage.Text = "Correo electronico enviado con Exito..!";
                picError.Visible = false;
                picCorrecto.Visible = true;
                txtCorreo.Text = "";
                txtCorreo.Focus();
            }
        }

        private void btnMinimizar_Click_1(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
