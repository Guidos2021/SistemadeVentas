using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;
using System.Runtime.InteropServices;

using CapaEntidad;
using CapaNegocio;

namespace CapaPresentacion
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        [DllImport("user32.DLL", EntryPoint = "ReleaseCapture")]
        private extern static void ReleaseCapture();
        [DllImport("user32.DLL", EntryPoint = "SendMessage")]
        private extern static void SendMessage(System.IntPtr hwnd, int wmsg,
        int wparam, int lparam);

        private void txtUser_Leave(object sender, EventArgs e)
        {
            if (txtUser.Text == "")
            {
                txtUser.Text = "NombreUsuario";
                txtUser.ForeColor = Color.DimGray;
            }
        }

        private void txtUser_Enter(object sender, EventArgs e)
        {
            if (txtUser.Text == "NombreUsuario")
            {
                txtUser.Text = "";
                txtUser.ForeColor = Color.LightGray;
            }
        }
        private void txtPass_Leave(object sender, EventArgs e)
        {
            if (txtPass.Text == "")
            {
                txtPass.Text = "Contraseña";
                txtPass.ForeColor = Color.DimGray;
                txtPass.UseSystemPasswordChar = false;
            }
        }

        private void txtPass_Enter(object sender, EventArgs e)
        {
            if (txtPass.Text == "Contraseña")
            {
                txtPass.Text = "";
                txtPass.ForeColor = Color.LightGray;
                txtPass.UseSystemPasswordChar = true;
            }
        }


        private void btnAccess_Click_1(object sender, EventArgs e)
        {

            List<Usuario> TEST = new CN_Usuario().Listar();

            Usuario ousuario = new CN_Usuario().Listar().Where(u => u.Documento == txtUser.Text && u.Clave == txtPass.Text).FirstOrDefault();

            if (txtUser.Text == "NombreUsuario")
            {
                    lblError.Text = "Ingrese NombreUsuario";
                    lblError.Visible = true;
                    picError.Visible = true;
                    txtUser.Focus();
            }
            else if (txtPass.Text == "Contraseña")
            {
                    lblError.Text = "Ingrese Contraseña";
                    lblError.Visible = true;
                    picError.Visible = true;
                    txtPass.Focus();
            }
            else if (ousuario != null)
            {
                Inicio form = new Inicio(ousuario);
                form.Show();
                this.Hide();
            }
            else
            {
                    lblError.Text = "Datos incorrectos..";
                    lblError.Visible = true;
                    picError.Visible = true;
                    txtUser.Text = "NombreUsuario";
                    txtUser.ForeColor = Color.DimGray;
                    txtPass.Text = "Contraseña";
                    txtPass.ForeColor = Color.DimGray;
                    txtPass.UseSystemPasswordChar = false;
                    txtUser.Focus();
            }
        }

        private void btnCerrar_Click_1(object sender, EventArgs e)
        {
            if (MessageBox.Show("Desea Salir del Sistema.??", "", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
            {
                Application.Exit();
            }
        }

        private void btnMinimizar_Click_1(object sender, EventArgs e)
        {
            this.WindowState = FormWindowState.Minimized;
        }        

        private void panel1_MouseDown(object sender, MouseEventArgs e)
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf012, 0);
        }

        private void pictureBox3_MouseDown(object sender, MouseEventArgs e)
        {
            ReleaseCapture();
            SendMessage(this.Handle, 0x112, 0xf012, 0);
        }

        private void linkPass_LinkClicked_1(object sender, LinkLabelLinkClickedEventArgs e)
        {
            ReestablecerContraseña resPass = new ReestablecerContraseña();
            resPass.Show();
        }

        private void Login_Load(object sender, EventArgs e)
        {

        }
    }
}
