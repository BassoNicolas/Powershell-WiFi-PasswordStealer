[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

class WifiProfile {
    [string]$Name
    [string]$Password

    WifiProfile([string]$name, [string]$password) {
        $this.Name = $name
        $this.Password = $password
    }
}

class WifiCredentialsExtractor {
    [string]$WifiName
    [string]$WifiPassword

    WifiCredentialsExtractor() {
        $systemCulture = [System.Globalization.CultureInfo]::CurrentCulture.Name
        if ($systemCulture -eq 'fr-FR') {
            $this.WifiName = "Profil Tous les utilisateurs"
            $this.WifiPassword = "Contenu de la clé"
        } else {
            $this.WifiName = "All User Profile"
            $this.WifiPassword = "Key Content"
        }
    }

    [System.Collections.Generic.List[WifiProfile]] ExtractWifiCredentials() {
        $profilesInfo = New-Object System.Collections.Generic.List[WifiProfile]

        foreach ($line in (netsh wlan show profiles).Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)) {
            if ($line.Contains($this.WifiName)) {
                $profileName = ($line -Split ": ")[-1].Trim()
                $profileInfo = netsh wlan show profile "$profileName" key=clear
                $password = ""

                foreach ($profileLine in $profileInfo.Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)) {

                    if ($profileLine.Contains($this.WifiPassword)) {
                        $password = ($profileLine -Split ": ")[-1].Trim()
                        break
                    }
                }

                $profilesInfo.Add((New-Object WifiProfile -ArgumentList $profileName, $password))
            }
        }

        return $profilesInfo
    }
}

Write-Output (New-Object WifiCredentialsExtractor).ExtractWifiCredentials() | ConvertTo-Json -Depth 100 | ConvertFrom-Json
