//Bibliotecas do Banco
using System;
using System.Data;
using System.Data.SqlClient;

namespace AcessaDadosSqlServer
{
    public class Banco
    {
        //Esse método vai criar a conexão com o Banco de Dados
        private SqlConnection CriaConexao()
        {
            //Estou retornando a variável que foi definida no Properties e ela já contém o caminho do Banco de Dados
            return new SqlConnection(AcessaDadosSqlServer.Properties.Settings.Default.conectaBD);
        }

        //Criei uma coleção de parâmetros para as minhas stored procedures
        private SqlParameterCollection sqlParameterCollection = new SqlCommand().Parameters;

        //Limpa os parâmetros que foram adicionado
        public void LimpaParametros()
        {
            sqlParameterCollection.Clear();
        }

        //Adiciona os parâmetros na coleção que foi criada
        public void AdicionaParametros(string nomeParametro, object valorParametro)
        {
            sqlParameterCollection.Add(new SqlParameter(nomeParametro, valorParametro));
        }

        public SqlCommand PreencheSqlCommand(CommandType commandType, string minhaUsp)
        {
            try
            {
                //Cria conexão e abre
                SqlConnection sqlConnection = CriaConexao();
                sqlConnection.Open();

                //Cria e envia o comando para o BD
                SqlCommand sqlCommand = sqlConnection.CreateCommand();
                sqlCommand.CommandType = commandType;
                sqlCommand.CommandText = minhaUsp;

                //Estabelece o tempo de conexão
                sqlCommand.CommandTimeout = 3600;

                foreach (SqlParameter sqlParameter in sqlParameterCollection)
                {
                    sqlCommand.Parameters.Add(new SqlParameter(sqlParameter.ParameterName, sqlParameter.Value));
                }

                return sqlCommand;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        //Métodos genéricos para Inserir, Alterar e Excluir
        public object ManipulaDados(CommandType commandType, string minhaUsp)
        {
            try
            {
                SqlCommand sqlCommand = PreencheSqlCommand(commandType, minhaUsp);
                //Retorna a primeira coluna
                return sqlCommand.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        //Método genérico para Consultar
        public DataTable ExecutarConsulta(CommandType commandType, string minhaUsp)
        {
            try
            {
                SqlCommand sqlCommand = PreencheSqlCommand(commandType, minhaUsp);
                //Esse objeto vai adaptar os dados
                SqlDataAdapter dataAdapter = new SqlDataAdapter();
                DataTable dataTable = new DataTable();
                dataAdapter.Fill(dataTable);
                return dataTable;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

    }
}
