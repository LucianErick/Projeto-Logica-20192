module ComputacaoDeliveries

-- ENCOMENDAS

abstract sig Encomenda{
	cliente: one Cliente,
	entregador: one Entregador
}

sig EncomendaPequena, EncomendaMedia, EncomendaGrande extends Encomenda{
}

-- CLIENTE
abstract sig Cliente {
	pedidos: some Encomenda
}

sig ClienteNormal, ClientePrime extends Cliente{}

-- FATOS

fact ClienteNormalTemAte3Encomendas{
	all c:ClienteNormal | #encomendasDoCliente[c] < 4
}
fact ClientePrimeTemAte6Encomendas {
	all p:ClientePrime | #encomendasDoCliente[p] < 7
}

fact oClienteDaEncomendaEhOQueTemAEncomenda {
	all cli:Cliente, enc:Encomenda | (enc in cli.pedidos) => (enc.cliente = cli)
}

fact todaRelacaoComClienteTemPedido {
	all cli:Cliente,enc:Encomenda | (cli in enc.cliente) => (enc in cli.pedidos)
}

-- FUNÇÕES

fun encomendasDoCliente[c:Cliente]: some Encomenda {
	c.pedidos
}

-- ENTREGADOR

abstract sig Entregador {
	entregas: some Encomenda
}
sig EntregadorNormal, EntregadorEspecial extends Entregador{}

-- FATOS
fact doisEntregadoresNaoTemAMesmaEncomenda{
	all disj ent1,ent2:Entregador | 
	!(some encomenda: Encomenda | 
	encomenda in entregasDoEntregador[ent1] && 
	encomenda in entregasDoEntregador[ent2])
}

fact entregadorNormalNaoEntregaEncomendaGrande {
	all g:EncomendaGrande,e:EntregadorNormal | !(g in entregasDoEntregador[e]) && g.entregador != e
}

-- FUNÇÕES

fun entregasDoEntregador[ent:Entregador]: some Encomenda{
	ent.entregas
}

pred show[]{}
run show for 10
