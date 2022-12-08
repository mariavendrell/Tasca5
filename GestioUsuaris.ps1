<#  - Fes un script que permeti localitzar tots els SID (identificadors d'usuari) de tots els usuaris existents a un active directory i els mostri en mode taula, 
    amb el format nom - SID
    - A partir del llistat d'usuaris, afegeix el codi necessari per tal que es pugui triar un usuari i modificar-li la foto/imatge d'entrada al sistema.
    - Revisa la data d'entrada al sistema (LastLogonDate) i si es troba fora d'horari laboral de 10 a 14 i de 15 a 18 que aparegui el nom i l'identificador 
    a un fitxer de text de nom alerta.txt. És una acció simulada, per tant si no pots trobar usuaris dintre d'aquest rang d'hores pots canviar-ho.          
    *Cal tenir en compte que les imatges no poden excedir de 96x96 píxels ni ocupar més de 10KB d'espai al disc.        #>



#Mostrar llistat d'usuaris
Get-ADUser -Filter * | Format-Table Name, SID

#Triar usuari per canviar foto
#Comprovo que l'usuari existeix
$bucle=$True
while ($bucle -eq $True) {
    try {
        Write-Output "A quin usuari li vols canviar la foto?"
        $user = Read-Host "Name > "
        if (get-aduser -Filter "Name -eq '$user'") {
            <# Action to perform if the condition is true #>
            $bucle = $False
        }
        else {
            <# Action when all if and elseif conditions are false #>
            {"No m'has donat un usuari correcte"}
            $bucle = $True
        }
        
    }
    catch {
        {"No m'has donat un usuari correcte"}
        $bucle = $True
    } 
}

#Canviar la foto
#Hem dona la ruta de la imatge i comprovo que existeix
#Existeix la canvio
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
#Miro el lastlogon de cada usuari del sistema i comprovo que estigui dins del horari
$usuaris=@(Get-ADUser -Filter * | select -ExpandProperty name)
foreach ($usuari in $usuaris) {
    #Saber l'hora que l'usuari ha sortit de la seva sessió
    $hora = Get-ADUser -Identity $usuari -Properties LastLogon | Select @{Name='LastLogon';Expression={[DateTime]::FromFileTime($_.LastLogon)}} | Select-Object -ExpandProperty LastLogon | Get-Date -Format t
    #Si esta fora de horari(10 a 14 i de 15 a 18) 
    if ((($hora -gt '10:00') -AND ($hora -lt '13:00')) -OR (($now -gt '15:00') -AND ($now -lt '18:00'))) {
        <# Action to perform if the condition is true #>
        #No fa res
    }
    else {
        <# Action when all if and elseif conditions are false #>
        Add-Content -Path .\alerta.txt -Value "L'usuari $usuari va iniciar sessió a les $hora"
    }
}