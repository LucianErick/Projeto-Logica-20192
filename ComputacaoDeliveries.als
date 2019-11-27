module ComputacaoDeliveries

------------------------------------------- ENCOMENDAS -------------------------------------------*
abstract sig Encomenda{
	statusEntrega: one StatusEntrega,
	statusPagamento: one StatusPagamento
}

sig EncomendaPequena, EncomendaMedia, EncomendaGrande extends Encomenda{
}

------------------------------------------- CLIENTE ---------------------------------------------------*
abstract sig Cliente {
	pedidos: some Encomenda
}

sig ClienteNormal, ClientePrime extends Cliente{}

------------------------------------------- ENTREGADOR ---------------------------------------------*
abstract sig Entregador {
	entregas: some Encomenda
}
sig EntregadorNormal, EntregadorEspecial extends Entregador{}

------------------------------------------- PAGAMENTO ---------------------------------------------*
abstract sig StatusPagamento {}
one sig PagamentoConfirmado extends StatusPagamento {}
one sig AguardandoPagamento extends StatusPagamento {}

----------------------------------------- ENTREGA ----------------------------------------------------*
abstract sig StatusEntrega {}
one sig Entregue extends StatusEntrega {}
one sig Aguardando extends StatusEntrega {}

----------------------------------------- FATOS --------------------------------------------------------*
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

fact encomendaSoEhEntregueAoPagar {
	all encomenda:Encomenda | clientePagou[encomenda] <=> (encomenda.statusEntrega in Entregue)
}

----------------------------------------- FUNÇÕES --------------------------------------------------*
fun encomendasDoCliente[c:Cliente]: some Encomenda {
	c.pedidos
}

fun entregasDoEntregador[ent:Entregador]: some Encomenda{
	ent.entregas
}

----------------------------------------- PREDICADOS ----------------------------------------------*

pred clientePagou[encomenda:Encomenda] {
	encomenda.statusPagamento in PagamentoConfirmado
}

----------------------------------------- ASSERTS ---------------------------------------------------*

assert assertNumeroDeEncomendasClienteNormal {
	all cliente:ClienteNormal | #encomendasDoCliente[cliente] < 4
}

assert assertNumeroDeEncomendasClientePrime {
	all cliente:ClientePrime | #encomendasDoCliente[cliente] < 7
}

assert assertTodaEncomendaTemCliente {
	all encomenda:Encomenda | one cliente:Cliente |
	 encomenda in encomendasDoCliente[cliente]
}

-------------------------------------- CHECK'S -------------------------------------------------------*

--check assertNumeroDeEncomendasClienteNormal for 10
--check assertNumeroDeEncomendasClientePrime for 10
--check assertTodaEncomendaTemCliente for 10  

-------------------------------------- SHOW -----------------------------------------------------------*

pred show[]{}
run show for 10
