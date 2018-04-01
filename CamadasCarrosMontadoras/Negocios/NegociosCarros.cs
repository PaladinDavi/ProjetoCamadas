using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
//Referência das Bibliotecas
using AcessaDadosSqlServer;
using ObjetosTranferencia;

namespace Negocios
{
    public class NegociosCarros
    {
        //Estabelecendo a conexão com o banco e acessando os métodos para manipular os dados
        Banco banco = new Banco();

        //Método especifico para inserir dados na tabela Carros
        public string InserirCarro(Carros carro)
        {
            try
            {
                //Limpa os parâmetros antigos
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@modelo", carro.modelo);
                banco.AdicionaParametros("@numPortas", carro.numPortas);
                banco.AdicionaParametros("@cor", carro.cor);
                banco.AdicionaParametros("@codMontadora", carro.codMontadora);

                //Executa a Stored Procedure
                string codCarro = banco.ManipulaDados(CommandType.StoredProcedure, "uspInserirCarro").ToString();

                return codCarro;
            }
            catch (Exception ex)
            {
                 return ex.Message;
            }
        }

        //Método especifico para Alterar dados na tabela Carros
        public string AlteraCarro(Carros carro)
        {
            try
            {
                //Limpa os antigos parâmetros
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@codCarro", carro.codCarro);
                banco.AdicionaParametros("@modelo", carro.modelo);
                banco.AdicionaParametros("@numPortas", carro.numPortas);
                banco.AdicionaParametros("@cor", carro.cor);
                banco.AdicionaParametros("@codMontadora", carro.codMontadora);

                //Executa a Stored Procedure
                string codCarro = banco.ManipulaDados(CommandType.StoredProcedure, "uspAlterarCarros").ToString();

                return codCarro;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        //Método especifico para Deletar dados da tabela carros 
        public string DeletaCarro(Carros carro)
        {
            try
            {
                //Limpa os antigos parâmetros
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@codCarro", carro.codCarro);

                string codCarro = banco.ManipulaDados(CommandType.StoredProcedure, "uspDeletaCarro").ToString();

                return codCarro;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        //Método especifico para Consultar os dados na tabela carros
        public CarrosColecao ConsultaCarroModelo(string nome)
        {
            try
            {
                CarrosColecao carrosColecao = new CarrosColecao();

                //Limpa os parâmetros antigos
                banco.LimpaParametros();

                //Adiciona os novos parâmetros
                banco.AdicionaParametros("@modelo", nome);

                DataTable dataTableCarros = banco.ExecutarConsulta(CommandType.StoredProcedure, "uspConsultaCarroModelo");

                foreach (DataRow linha in dataTableCarros.Rows)
                {
                    Carros carro = new Carros();

                    carro.codCarro = Convert.ToInt32(linha["codCarro"]);
                    carro.modelo = Convert.ToString(linha["modelo"]);
                    carro.numPortas = Convert.ToInt32(linha["numPortas"]);
                    carro.cor = Convert.ToString(linha["cor"]);

                    carrosColecao.Add(carro);
                }

                return carrosColecao;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }
    }
}
