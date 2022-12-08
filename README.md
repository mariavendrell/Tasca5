# Tasca5

## GestioUsuaris.ps1
- Llista els usuaris amb format taula Nom - SID.
- Demana a l'usuari que seleccioni un usuari del AD per canviar-li la foto d'entrada al sistema.

Després li demana la ruta de la nova imatge.

*Perquè funcioni les imatges no poden excedir de 96x96 píxels ni ocupar més de 10KB d'espai al disc.*
- Finalment comprovo el lastlogon de cada usuari del sistema i comprovo que estigui dins de l'horari.

Si no és dins de l'horari afegir a l'arxiu alerta.txt una línia avisant.
