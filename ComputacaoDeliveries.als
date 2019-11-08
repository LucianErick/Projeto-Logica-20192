module ComputacaoDeliveries
sig Encomenda{
	cliente: one Cliente
}
sig Pequena, Media extends Encomenda{}
sig Grande extends Encomenda{}
 
sig Entregador {}
sig EntregadorEspecial extends Entregador{}

sig Cliente {}
sig ClientePrime extends Cliente{}
