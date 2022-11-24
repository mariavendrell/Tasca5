<#  - Fes un script que permeti localitzar tots els SID (identificadors d'usuari) de tots els usuaris existents a un active directory i els mostri en mode taula, 
    amb el format nom - SID
    - A partir del llistat d'usuaris, afegeix el codi necessari per tal que es pugui triar un usuari i modificar-li la foto/imatge d'entrada al sistema.
    - Revisa la data d'entrada al sistema (LastLogonDate) i si es troba fora d'horari laboral de 10 a 14 i de 15 a 18 que aparegui el nom i l'identificador 
    a un fitxer de text de nom alerta.txt. És una acció simulada, per tant si no pots trobar usuaris dintre d'aquest rang d'hores pots canviar-ho.          
    *Cal tenir en compte que les imatges no poden excedir de 96x96 píxels ni ocupar més de 10KB d'espai al disc.        #>

#Mostrar llistat d'usuaris
Get-ADUser -Filter * | Format-Table Name, SID

#Triar usuari per canviar foto
$bucle=$True
while ($bucle -eq $True) {
    try {
        Write-Output "A quin usuari li vols canviar la foto?"
        $user = Read-Host "SID > "
        get-aduser -Filter "SID -eq '$user'"
        Write-Host " hola"
        $bucle = $False
    }
    catch {
        {"No m'has donat un usuari correcte"}
        $bucle = $True
    } 
}

#Canviar la foto
$bucle=$True
while ($bucle -eq $True) {
    try {
        Write-Output "La foto que m'has de donar no pot excedir de 96x96 píxels"
        $foto=Read-Host "Ruta de la foto > "
        Set-ADUser $user -Replace @{thumbnailPhoto=([byte[]](Get-Content $foto -Encoding byte))}
        $bucle = $False
    }
    catch {
        {"No m'has donat una ruta correcta correcte"}
        $bucle = $True
    } 
}

#Usuaris treballan fora del seu horari

#Getting users who haven't logged in in over 90 days
#Filtering All enabled users who haven't logged in.
Get-ADUser -Filter {((Enabled -eq $true) -and ((get-date -Format hh LastLogonDate) -lt $date))} -Properties LastLogonDate | select samaccountname, Name, LastLogonDate | Sort-Object LastLogonDate
