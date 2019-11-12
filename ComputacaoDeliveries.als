module ComputacaoDeliveries

--Assinaturas
sig Encomenda{
	cliente: one Cliente
}

sig EncomendaPequena, EncomendaMedia extends Encomenda{}
sig EncomendaGrande extends Encomenda {}
 
sig Entregador {
	encomendas: set Encomenda
}
sig EntregadorEspecial extends Entregador{
}

sig Cliente {
	encomendas: set Encomenda
}
sig ClientePrime extends Cliente{}
--Fim das assinaturas

--Checando o numero de encomendas por cliente
fact {
	all c:Cliente | #encomendasDoCliente[c] < 4
	all p:ClientePrime | #encomendasDoClientePrime[p] < 7
	all e:Encomenda | #clienteDaEncomenda[e] = 1

}
--
fun encomendasDoCliente[c:Cliente]: set Encomenda {
	c.encomendas
}

fun encomendasDoClientePrime(p:ClientePrime): set Encomenda {
	p.encomendas
}

fun clienteDaEncomenda[e:Encomenda]: one Cliente {
	e.cliente
}

pred show[]{}
run show for 6
