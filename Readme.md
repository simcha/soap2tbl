##Instalacja

`gem install`

`bundle install`

##Użycie

Pobranie listy obiektów
`01_get_obj_list <usr> <pass>`

Pobranie statusów obiektów dla listy z csv
`02_get_obj_status <usr> <pass>`

I tak samo dla wszystkich skryptów. Przy czym do wykonania skryptów z nazwą większą od 01 potrzebne jest wykonanie skyptu `01_get_obj_list`.

## Puste wyniki

`06_get_most_recent_visited_point_data.rb`
`09_get_obj_total_distance.rb` - liczy bardzo powoli więc pewnie dla jakichś dat wyniki są
`11_get_rec_data_history.rb`
`12_get_tracks.rb`

## Brak skryptów

Niektóre skrypty wydają się niepotrzebne dotyczy to serwisów:

GetTracks2 - robi to samo co GetTracks ale ma więcej opcji wyszukiwania
GetRecHistory - OBSOLETE
GetRecDataHistoryJson - to samo co GetRecDataHistory tylko w jsonie
GetNewEventRec - to co GetEventRecHisory tylko do monitoringu
GetNewAndChangedEventRec - to co GetEventRecHisory tylko do monitoringu



