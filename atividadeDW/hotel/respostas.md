'''
explicar como cada dimensão será implementada, especialmente aquelas que utilizam
Slowly Changing Dimensions (SCD). Para o SCD Tipo 2, o aluno deve explicar como manter as
versões das dimensões, como Clientes e Quartos.

No modelo de dados proposto, as dimensões são implementadas com o uso de chaves surrogate e Slowly Changing Dimensions (SCD), para garantir a integridade e a manutenção do histórico das informações,
mesmo quando elas mudam ao longo do tempo. A principal vantagem disso é que não se perde o histórico, permitindo gerar relatórios detalhados sobre a evolução dos dados.

dim cliente
SK -> id_cliente_sk, usado como o surrorgate para manter as informações 
id_clinete seria o id do cliente, sendo esse não único para evitar problemas se acabar por gerar outro 
registro na tabela
O interessante dessa tabela o status, ele vek marcado como 'A' (ativo), enquanto as versões antigas terão esse campo marcado como 'I' (inativo).

tabela dim_hotel
id_hotel_sk seria o surrorgate da tabela,
id_hotel seria o id do hotel
o restante se trata de informações de endereço

dim_quarto
id_quarto_sk: Chave surrogate usada para identificar de forma única cada versão do quarto.
id_quarto: Chave natural, o ID real do quarto.
Campos como status de manutenção, tipo de quarto, data da última reforma: Sempre que houver uma mudança significativa,
como uma reforma ou alteração no status de manutenção, uma nova linha será criada para manter o histórico da evolução do quarto.
Da mesma forma que na dimensão cliente, usamos o campo status para indicar se a versão é ativa ou inativa.

A tabela de fatos chama todas as FKs nela.
'''
'''
Identificar e diferenciar as métricas aditivas (como a receita total) das métricas não aditivas
(como a taxa média de ocupação).

Receita Total de Reserva: A receita total gerada por todas as reservas pode ser somada diretamente. Exemplo: se em um período houverem várias reservas, basta somar o valor total de cada reserva para obter o valor total.
Quantidade de Reservas: O número de reservas feitas por clientes ou em um determinado período pode ser somado sem perder o significado.

Número de Noites de Hospedagem: O número total de noites hospedadas em um hotel por todos os clientes ou em um determinado período pode ser somado para calcular o total.

Métricas Não Aditivas
Taxa Média de Ocupação: A soma das taxas de ocupação dos quartos ao longo do tempo não é uma soma simples.
Para calcular a taxa média de ocupação, seria necessário calcular uma média ponderada, levando em consideração o número de quartos disponíveis em cada período.

Taxa de Cancelamento de Reservas: Assim como a taxa de ocupação, a taxa de cancelamento não pode ser somada diretamente.
Para obter a taxa de cancelamento de um período maior, seria necessário calcular a média ponderada de todos os cancelamentos em relação ao total de reservas feitas durante o período.
'''
