# Copyright 2024 DakLod2k3

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$ProgressPreference = 'SilentlyContinue'

$game_path = ""

Write-Output "Attempting to get Roll url!"

$app_data = [Environment]::GetFolderPath('ApplicationData')
$locallow_path = "$app_data\KRLauncher\"

$fileName = "kr_starter_game.json"

$item = Get-Childitem -Path $locallow_path -Include *$fileName* -Recurse
# Write-Output $item
if ($args.Length -eq 0) {
    foreach ($file in $item){
        # Write-Output $file.FullName
        $content = Get-Content -Path $file.FullName
        $content = ConvertFrom-Json $content 
        $game_path = $content.path
        # Write-Output $game_path
        if ($game_path -ne ""){
            break
        }
    }
} else {
    $game_path = $args[0]
}

if ($game_path -eq ""){
    Write-Output "Failed to locate game path! Try another method!"
    exit
}

$payload = ""

$content = Get-Content -Path "$game_path\Client\Saved\Logs\Client.log"
if ($content -eq $null){
    Write-Output "Failed to load log file! Try another method!"
}

$payloads = $content | Where-Object {
    if ($_ -like "*https://aki-gm-resources-oversea.aki-game.net/aki/gacha/index.html#/record?*"){
        # $_.json = ConvertFrom-Json $_
        return $_
    }
}

Write-Output $content
Write-Output $payloads

if ($payloads[0] -match "{.+}"){
    $json = ConvertFrom-Json $matches[0]
    $url = $json.url.Split("?")[1]
    
}

if ($url -eq ""){
    Write-Output "Failed to get url, please ensure that opened the Roll history once before running the script!"
    exit
}
Write-Output "Url Found!"
Write-Output $url
Set-Clipboard -Value $url
Write-Output "Url has been saved to clipboard."
