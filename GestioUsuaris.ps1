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
    Write-Output "A quin usuari li vols canviar la foto?"
    $user = Read-Host "SID > "
    get-aduser -Filter "SID -eq '$user'"
    if ((get-aduser -Filter "SID -eq '$user'" | Format-Wide SID) -eq ($user) ) {
        <# Action to perform if the condition is true #>
        Write-Host " hola"
    }
    else {
        <# Action when all if and elseif conditions are false #>
        $bucle = $False
    }
}


# Write-Output "La foto que m'has de donar no pot excedir de 96x96 píxels"
# foto=Read-Host "Ruta de la foto > "



#Set-ADUser M.Becker -Replace @{thumbnailPhoto=([byte[]](Get-Content "C:scriptsadm.becker.jpg" -Encoding byte))}
