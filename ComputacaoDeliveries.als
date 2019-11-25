module ComputacaoDeliveries

-- ENCOMENDAS
abstract sig Encomenda{

	statusEntrega: one StatusEntrega,
	statusPagamento: one StatusPagamento

}

sig EncomendaPequena, EncomendaMedia, EncomendaGrande extends Encomenda{
}

-- CLIENTE
abstract sig Cliente {
	pedidos: some Encomenda
}

sig ClienteNormal, ClientePrime extends Cliente{}

-- ENTREGADOR

abstract sig Entregador {
	entregas: some Encomenda
}
sig EntregadorNormal, EntregadorEspecial extends Entregador{}


-- FATOS

fact clienteNormalTemAte3Encomendas {
	all cliente:ClienteNormal | #encomendasDoCliente[cliente] < 4
}
fact clientePrimeTemAte6Encomendas {
	all pedido:ClientePrime | #encomendasDoCliente[pedido] < 7
}

fact todaEncomendaTemCliente {
	all encomenda:Encomenda | one cliente:Cliente |
	 encomenda in encomendasDoCliente[cliente]
}

fact encomendaSoTemUmCliente{
	all disj cli1, cli2: Cliente |
	!(some encomenda:Encomenda 
	| encomenda in encomendasDoCliente[cli1] && encomenda in encomendasDoCliente[cli2])
}

fact doisEntregadoresNaoTemAMesmaEncomenda{
	all disj ent1,ent2:Entregador | 
	!(some pedido: Encomenda | 
	pedido in entregasDoEntregador[ent1] && 
	pedido in entregasDoEntregador[ent2])
}

fact entregadorNormalNaoEntregaEncomendaGrande {
	all pedido:EncomendaGrande, entregador:EntregadorNormal |
 	!(pedido in entregasDoEntregador[entregador])
}

fact todaEncomendaTemEntregador {

	all encomenda:Encomenda | one entregador:Entregador | encomenda in entregasDoEntregador[entregador]
}

fact entregueAoPagar {
	all encomenda:Encomenda | (encomenda.statusPagamento in Confirmado) <=> (encomenda.statusEntrega in Entregue)
}

fact clientePagando {
	all cliente:Cliente, encomenda:Encomenda | (encomenda.statusPagamento in AguardandoPagamento) => pagamentoDoCliente[encomenda]
}

-- FUNÇÕES

fun encomendasDoCliente[c:Cliente]: some Encomenda {
	c.pedidos
}
fun entregasDoEntregador[ent:Entregador]: some Encomenda{
	ent.entregas
}

fun pagamentoDoCliente[encomenda:Encomenda] {
	encomenda.statusPagamento in Confirmado
}



-- PAGAMENTO

abstract sig StatusPagamento {}
one sig Confirmado extends StatusPagamento {}
one sig AguardandoPagamento extends StatusPagamento {}


-- ENTREGA

abstract sig StatusEntrega {}
one sig Entregue extends StatusEntrega {}
one sig Aguardando extends StatusEntrega {}


pred show[]{}
run show for 10
