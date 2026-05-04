## 1. Identificação

Nome: Sofia Etchepare Daronco  
Curso: Sistemas de Informação

## 2. Tema/objetivo

O servidor tem 2 endpoints:  
/info/:name, responde com os vários táxons de que a espécie :name faz parte.  
/closer?a=x&b=y&c=z, determina se a espécie y ou z é mais próxima à x. Na verdade isso é uma estimativa, pois uma comparação melhor precisaria de análises genômicas, não apenas comparação de táxons. Mesmo assim, a comparação é geralmente correta.

A programação funcional facilita o reuso de fragmentos de lógica entre o teste e o servidor, além de facilitar o processo de *pattern matching* utilizado em alguns lugares.

## 3. Processo de desenvolvimento

Desde o início achei difícil trabalhar com monads, acabei usando uma mistura de liftIO e outras funções para tentar lidar com problemas, mas não tenho certeza se fiz de modo adequado. Além de monads, precisei entender a differença entre String e Text (eficiência?), pois parece que Scotty utiliza Text.

## 4. Testes

Como o programa é muito simples, acabei apenas criando um teste. Esse teste determina se a análise entre *C. lupus*, *V. vulpes*, e *H. sapiens* está correta. Para executar o teste, é só executar o programa com o parâmetro "test" (i.e., ./Main test).

## 5. Execução

Além de Scotty, o programa também precisa de Aeson (para processamento de JSON), http-conduit (para chamar o API externo), e Split (para manipulação entre Strings e listas).

## 6. Deploy

Link do serviço publicado: https://hs.subby.dev

Como tenho servidores próprios, achei melhor não usar Render. O primeiro servidor utilizado é um VPS (FranTech Solutions) que utiliza SNI proxying (Nginx) + WireGuard para redirecionar a requisição até o meu servidor doméstico sem terminação de TLS. Após isso, o servidor em casa finaliza a conexão através do proxy reverso Caddy. Também uso variações desse processo para vários outros serviços (e.g., Synapse, Sharkey, Forgejo, Vaultwarden, etc), para manter o controle sobre os dados do servidor (o uso de SNI proxying ao invés de terminação de TLS significa que o VPS nunca consegue acessar os dados) e ao mesmo tempo poder utilizar um endereço IP estático sem restrição de portas, que normalmente não seria possível com um servidor doméstico.

## 7. Resultado final

https://bottomservices.club/video.mp4

## 8. Uso de IA 

N/A

## 9. Referências e créditos

https://stackoverflow.com/questions/7691374/io-and-maybe-monad-interaction
https://stackoverflow.com/questions/2395697/what-is-lifting-in-haskell
https://hackage-content.haskell.org/package/scotty-0.30/docs/Web-Scotty.html
https://hackage.haskell.org/package/http-conduit-2.3.9/docs/Network-HTTP-Simple.html
https://ena-docs.readthedocs.io/en/latest/retrieval/programmatic-access/taxon-api.html