# OSM_WATCHDOG_ADDR

Prosty skrypt python-a pilnujący poprawności adresów w changesetach zakończonych w ciągu ostatniej doby

> W aktualnej wersji nie zadziała po uruchomieniu!  
> Do prawidłowego działania potrzebuje bazy danych PostGIS utworzonej przez osm2pgsql, replikującej dane z OSM oraz posiadającej kolumny wyszczególnione w [funkcjach](functions.sql) 
> Jeśli ma działać jako niezależna aplikacja konieczne będzie przerobienie go tak, aby pobierał dane inicjalne z OsmAPI lub OverpassAPI
 
**Absolutnie** i **pod żadnym pozorem**, nawet pod groźbą **śmierci w męczarniach czy trwałego kalectwa** 

**!!! NIE WOLNO !!!** 

testować tego oprogramowania na produkcyjnej bazie OSM. Do testów i developmentu służy środowisko developerskie.

Wytyczne: https://wiki.openstreetmap.org/wiki/API_v0.6#URL_.2B_authentication
Adres API testowego: https://master.apis.dev.openstreetmap.org


## Zasada działania

1. Skrypt uruchamiany jest z cron-a dokładnie co 24h.
2. Pobiera z bazy adresy, które mają `addr:city` a nie mają `addr:street`.
3. Dodaje do listy adresy, które mają równocześnie `addr:street` oraz `addr:place`.
4. (wyłączone) Dla każdego wykrytego błędu tworzy notatkę w OSM.
5. Komentuje każdy changeset, w którym wystąpiły błędne adresy.
6. Z zebranych adresów tworzy maila z raportem i wysyła do zdefiniowanych osób.

## Przed uruchomieniem

1. Utworzyć bazę danych za pomocą osm2pgsql oraz zestawić replikację (sposób opisany na stronie switch2osm.org).
2. Pamiętać, żeby przed importem zmienić plik stylu osm2pgsql, żeby zawierał kolumny zgodne z zapytaniami zawartymi w funkcjach.
3. Utworzyć kopię pliku config_template.py, nazwać config.py i podać niezbędne informacje (parametry połączenia do bazy oraz osmAPI).

## Znane problemy i kierunki rozwoju

1. Skrypt działał w ramach serwera, na którym była baza PostGIS używana do innych zastosowań. Jeśli miałby być uruchamiany samodzielnie to tworzenie bazy tylko dla niego to duży naddatek. Trzeba go przerobić tak, żeby potrafił potrzebne dane pobierać z OverpassAPI.
2. Jeśli zostawiamy ten sposób działania trzeba rozszerzyć dokumentację o instrukcję instalacji, importu bazy, zestawienia replikacji oraz przygotować minimalny plik ze stylem do osm2pgsql.
3. Aktualnie sprawdzana jest tylko obecność obiektu w changesecie, a nie jest sprawdzane, co było w tym obiekcie zmieniane, więc jeśli ktoś w jakikolwiek sposób dotknął obiektu, który miał błędny adres, dostawał komentarz... nawet jeśli to nie on ten adres zepsuł.
4. W przypadku dużych changesetów jest problem z odnalezieniem obiektu, w którym jest błąd, dodatkowo nie wszyscy powstałe błędy poprawiają, dlatego trzeba rozszerzyć aplikację.
- wszystkie odnalezione problemy zapisywać do bazy danych
- dopisać kawałek kodu, który z tych adresów tworzy tabelę i zwraca przez www.
- tabela powinna być filtrowana po dacie i użytkowniku.
- dodać funkcję pozwalającą oznaczyć uszkodzony adres jako naprawiony.
- dodać funkcję sprawdzającą w OSM czy faktycznie błąd został naprawiony.
- zapisać do bazy nick użytkownika, który naprawił błąd.
- dodać ranking użytkowników naprawiających błędy.
