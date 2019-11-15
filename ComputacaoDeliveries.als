module ComputacaoDeliveries

-- ENCOMENDAS

abstract sig Encomenda{
	cliente: one Cliente
}

sig EncomendaPequena, EncomendaMedia, EncomendaGrande extends Encomenda{
}

-- CLIENTE
abstract sig Cliente {
	pedidos: some Encomenda
}

sig ClienteNormal, ClientePrime extends Cliente{}

fact ClienteNormalTemAte3Encomendas{
	all c:ClienteNormal | #encomendasDoCliente[c] < 4
}
fact ClientePrimeTemAte6Encomendas {
	all p:ClientePrime | #encomendasDoCliente[p] < 7
}

fact EncomendaSoPodeSerDeUmCliente{
	all disj cli1,cli2:Cliente | 
	!(some enc:Encomenda | 
	(enc in encomendasDoCliente[cli1] &&
	 enc in encomendasDoCliente[cli2]))   
}

fact oClienteDaEncomendaEhOQueTemAEncomenda {
	all cli:Cliente, enc:Encomenda | (enc in cli.pedidos) => (enc.cliente = cli)
}

fact todaRelacaoComClienteTemPedido {
	all cli:Cliente,enc:Encomenda | (cli in enc.cliente) => (enc in cli.pedidos)
}


fun encomendasDoCliente[c:Cliente]: set Encomenda {
	c.pedidos
}

pred ehClientePrime {
	
}
pred show[]{}
run show for 10
