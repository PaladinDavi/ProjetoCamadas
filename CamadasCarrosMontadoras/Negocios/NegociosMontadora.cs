using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
//Referência das bibliotecas
using AcessaDadosSqlServer;
using ObjetosTranferencia;

namespace Negocios
{
    public class NegociosMontadora
    {
        //Estabelecendo a conexão com o Banco de Dados e acessando os métodos para manipular os dados
        Banco banco = new Banco();

        //Método especifico para inserir dados na tabela Montadoras
        public string InserirMontadora(Montadoras montadora)
        {
            try
            {
                //Limpa os parâmetros antigos
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@nome", montadora.nome);

                string codMontadora = banco.ManipulaDados(CommandType.StoredProcedure, "uspInserirMontadora").ToString();

                return codMontadora;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        //Método especifico para alterar os dados da tabela Montadoras
        public string AlterarMontadora(Montadoras montadora)
        {
            try
            {
                //Limpa os parâmetros antigos
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@codMontadoras", montadora.codMontadora);
                banco.AdicionaParametros("@nome", montadora.nome);

                string codMontadora = banco.ManipulaDados(CommandType.StoredProcedure, "uspAlterarMontadora").ToString();

                return codMontadora;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        //Método especifico para deletar os dados da tabela Montadoras
        public string DeletarMontadora(Montadoras montadora)
        {
            try
            {
                //Limpa os parâmetros antigos
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@codMontadora", montadora.codMontadora);

                string codMontadora = banco.ManipulaDados(CommandType.StoredProcedure, "uspDeletarMontadora").ToString();

                return codMontadora;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        //Método especifico para consultar os dados pelo nome 
        public MontadoraColecao ConsultarMontadoraNome(string nome)
        {
            try
            {
                MontadoraColecao montadoraColecao = new MontadoraColecao();

                //Limpa os parâmetros antigos
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@nome", nome);

                DataTable dataTableMontadoras = banco.ExecutarConsulta(CommandType.StoredProcedure, "uspConsultaMontadoraNome");

                foreach (DataRow linha in dataTableMontadoras.Rows)
                {
                    Montadoras montadora = new Montadoras();

                    montadora.codMontadora = Convert.ToInt32(linha["codMontadora"]);
                    montadora.nome = Convert.ToString(linha["nome"]);

                    montadoraColecao.Add(montadora);
                }

                return montadoraColecao;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
