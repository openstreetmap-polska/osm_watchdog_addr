import osmapi

# Database
db_conn_params = {
    "db_name": "",
    "db_host": "",
    "db_port": "",
    "db_usr": "",
    "db_pass": ""
}
conn_str = "postgresql://{db_usr}:{db_pass}@{db_host}:{db_port}/{db_name}".format(**db_conn_params)

#OSM Api
osm_user = ""
osm_passwd = ""
osm_api_url = "https://api.openstreetmap.org"

#OSM Test API
# osm_user = ""
# osm_passwd = ""
# osm_api_url = "https://master.apis.dev.openstreetmap.org"



oapi = osmapi.OsmApi(username=osm_user,
                   password=osm_passwd,
                   api=osm_api_url)

# Maile
mail_smtp = "localhost"
mail_from = "watchdog@mail.domain"
mail_to = ["admin1@osm.pl", "admin2@osm.pl"]


mail_subject = "[bot] Dodane niepełne punkty adresowe"

# Notatki
nostreet_note_txt = "--Automatyczny raport--" \
                    "Niepełny adres - brakuje ulicy lub wartości tagu place"

# Komentarze zestau zmian
nostreet_chngeset_comment = "(Wiadomość automatyczna)\n"\
    "Cześć!\n"\
    "Otrzymujesz ten komentarz, ponieważ dodałeś lub zmodyfikowałeś adres, który jest niepełny lub błędny.\n" \
    "Adres powinien zawierać minimum trzy znaczniki: addr:city=[nazwa_miejscowosci] + addr:street=[nazwa_ulicy] + addr:housenumber=[numer_porządkowy].\n" \
    "Wyjątkiem są miejscowości bez nazwanych ulic - wtedy stosujemy znaczniki: addr:place=[nazwa_miejscowosci] + addr:housenumber=[numer_porządkowy].\n" \
    "Bez poprawnego oznaczenia adresów, nie będą one brane pod uwagę przez wyszukiwarki, dlatego warto je dostosować do ww. schematu (w zależności od sytuacji).\n" \
    "Więcej informacji na forum: https://forum.openstreetmap.org/viewtopic.php?id=5632 - a pytania najlepiej zadawać tu: https://forum.openstreetmap.org/viewtopic.php?pid=681873\n"\
    "Pozdrawiamy!"

# Zmienne do testów
rep_test = [('WieKo68', '54898554', -7838163, 50.7659416512691, 18.5855072317376), ('WieKo68', '54897141', -7838030, 50.798371632673, 18.6074352614867), ('saccularius', '54895892', 455389850, 52.6489632548487, 18.930362745817), ('WieKo68', '54898335', -7838057, 50.8329512030009, 18.5930791091407), ('saccularius', '54895892', 456215710, 52.6544234586972, 18.9305657543789), ('TheBobolo', '54897359', 548917082, 50.5464582011951, 16.5453779041417), ('ASCS-Consulting', '54899011', 4408760189, 52.4550053659819, 16.9562467142911), ('WieKo68', '54898642', -7838196, 50.7811868058364, 18.6866053048771)]
notes_test = ['11048', '11049', '11050', '11051', '11052', '11053', '11054', '11055']