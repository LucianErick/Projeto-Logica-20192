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

fact relacaoEntreClienteEEncomendaEhDupla{
	all cliente:Cliente, pedido:Encomenda | 
	(pedido in encomendasDoCliente[cliente]) => (oCliente[pedido] = cliente)
}

fact todaRelacaoComClienteTemPedido{
	all cliente:Cliente, pedido:Encomenda | 
	(cliente in oCliente[pedido]) => (pedido in encomendasDoCliente[cliente])
}

fact doisEntregadoresNaoTemAMesmaEncomenda{
	all disj ent1,ent2:Entregador | 
	!(some pedido: Encomenda | 
	pedido in entregasDoEntregador[ent1] && 
	pedido in entregasDoEntregador[ent2])
}

fact relacaoEntreEncomendaEEntregadorEhDupla {
	all pedido:Encomenda, entregador:Entregador |
	 (oEntregador[pedido] = entregador) => (pedido in entregasDoEntregador[entregador])
}

fact entregadorNormalNaoEntregaEncomendaGrande {
	all pedido:EncomendaGrande, entregador:EntregadorNormal |
 	!(pedido in entregasDoEntregador[entregador]) && oEntregador[pedido] != entregador
}

-- FUNÇÕES

fun encomendasDoCliente[c:Cliente]: some Encomenda {
	c.pedidos
}
fun entregasDoEntregador[ent:Entregador]: some Encomenda{
	ent.entregas
}
fun oCliente[pedido:Encomenda] : one Cliente {
	pedido.cliente
}

fun oEntregador[pedido:Encomenda] : one Entregador {
	pedido.entregador
}

pred show[]{}
run show for 10
