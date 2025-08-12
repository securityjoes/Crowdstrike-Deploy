#========================== CONFIGURATION (EDIT THESE) ==========================#
$Operation               = ""        # "Split" or "Deploy"
$Parts                   = 0         # Number of parts for split (e.g., 5)
$OriginalFilePath        = ""        # Full path to original installer to split
$SplittedFilesLocation   = ""        # Folder for file_split_part_* (used by Split & Deploy)
$CrowdstrikeCID          = ""        # Falcon Tenant CID (e.g., 1234567890ABCDEFGHIJKLMN-12)
$TenantName              = ""        # Friendly display name for messages
$RebuiltFileName         = "RebuiltCrowdStrikeSensor.exe"   # Output filename when rebuilding (can rename if wanted)
#===============================================================================#

#---------------------------- Safety & Environment -----------------------------#
$ErrorActionPreference = 'Stop'

function Require-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "Please run this script in an elevated PowerShell (Run as Administrator)."
    }
}
Require-Admin

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not (Test-Path $ScriptDir)) { $ScriptDir = (Get-Location).Path }

#------------------------------ Banner ------------------------------------------#
Write-Output ""
Write-Output "  ██████╗██████╗  ██████╗ ██╗    ██╗██████╗ ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗"
Write-Output " ██╔════╝██╔══██╗██╔═══██╗██║    ██║██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝"
Write-Output " ██║     ██████╔╝██║   ██║██║ █╗ ██║██║  ██║███████╗   ██║   ██████╔╝██║█████╔╝ █████╗"  
Write-Output " ██║     ██╔══██╗██║   ██║██║███╗██║██║  ██║╚════██║   ██║   ██╔══██╗██║██╔═██╗ ██╔══╝"  
Write-Output " ╚██████╗██║  ██║╚██████╔╝╚███╔███╔╝██████╔╝███████║   ██║   ██║  ██║██║██║  ██╗███████╗"
Write-Output "  ╚═════╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝"
Write-Output ""                                                                                       
Write-Output "                     ██████╗ ███████╗██████╗ ██╗      ██████╗ ██╗   ██╗"                 
Write-Output "                     ██╔══██╗██╔════╝██╔══██╗██║     ██╔═══██╗╚██╗ ██╔╝"                 
Write-Output "                     ██║  ██║█████╗  ██████╔╝██║     ██║   ██║ ╚████╔╝"                  
Write-Output "                     ██║  ██║██╔══╝  ██╔═══╝ ██║     ██║   ██║  ╚██╔╝"                   
Write-Output "                     ██████╔╝███████╗██║     ███████╗╚██████╔╝   ██║"                    
Write-Output "                     ╚═════╝ ╚══════╝╚═╝     ╚══════╝ ╚═════╝    ╚═╝"
Write-Output ""
Write-Output "                           Created & Maintained by: Eilay Yosfan"
Write-Output "                                   GitHub.com/YosfanEilay"
Write-Output "                                          Method: 2" 
Write-Output ""

#------------------------------- Split Function --------------------------------#
function Split-File {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][int]$Parts,
        [Parameter(Mandatory=$false)][string]$OutputFolder = $null
    )

    if (-not (Test-Path $Path -PathType Leaf)) {
        throw "Error: File not found: $Path"
    }
    if ($Parts -lt 1) {
        throw "Error: Parts must be a positive integer."
    }

    if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
        if (-not [string]::IsNullOrWhiteSpace($SplittedFilesLocation)) {
            $OutputFolder = $SplittedFilesLocation
        } else {
            $OutputFolder = $ScriptDir
        }
    }

    if (-not (Test-Path $OutputFolder -PathType Container)) {
        Write-Host "Output folder not found, creating: $OutputFolder"
        New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
    }

    $fileInfo = Get-Item $Path
    $fileSize = $fileInfo.Length
    $chunk    = [long][math]::Ceiling($fileSize / [double]$Parts)

    Write-Host "Splitting '$Path' ($fileSize bytes) into $Parts parts in '$OutputFolder'..."
    $in = [System.IO.File]::OpenRead($Path)
    try {
        for ($i = 1; $i -le $Parts; $i++) {
            $outFile = Join-Path $OutputFolder ("file_split_part_{0}" -f $i)
            $remaining = [math]::Min($chunk, $fileSize - $in.Position)
            if ($remaining -le 0) { break }

            $buffer = New-Object byte[] $remaining
            $read   = $in.Read($buffer, 0, $remaining)
            if ($read -gt 0) {
                [System.IO.File]::WriteAllBytes($outFile, $buffer)
                Write-Host "Created: $outFile"
            }
        }
        Write-Host "Split complete."
    } finally {
        $in.Dispose()
    }
}

#------------------------------- Rebuild Function ------------------------------#
function Rebuild-FromParts {
    param(
        [Parameter(Mandatory=$true)][string]$PartsFolder,
        [Parameter(Mandatory=$true)][string]$OutputFile
    )

    if (-not (Test-Path $PartsFolder -PathType Container)) {
        throw "Error: Parts folder not found: $PartsFolder"
    }

    $outputPath = Join-Path $PartsFolder $OutputFile
    if (Test-Path $outputPath) { Remove-Item -Force $outputPath }

    $parts = Get-ChildItem -Path (Join-Path $PartsFolder "file_split_part_*") -File |
             Sort-Object { [int]($_.Name -replace 'file_split_part_','') }

    if (-not $parts) { throw "Error: No parts found in $PartsFolder" }

    Write-Host "Rebuilding original file from parts in: $PartsFolder"
    $out = [System.IO.File]::OpenWrite($outputPath)
    try {
        foreach ($p in $parts) {
            $bytes = [System.IO.File]::ReadAllBytes($p.FullName)
            $out.Write($bytes, 0, $bytes.Length)
            Write-Host "Appended: $($p.FullName)"
        }
    } finally {
        $out.Dispose()
    }

    if (-not (Test-Path $outputPath)) {
        throw "Error: Reconstructed file not found."
    }

    Write-Host "CrowdStrike sensor file reconstructed as: $outputPath"
    return $outputPath
}

#----------------------- Install Function ---------------------------#
function Install-CrowdStrikeSimple {
    param(
        [Parameter(Mandatory=$true)][string]$InstallerPath,
        [Parameter(Mandatory=$true)][string]$CID,
        [Parameter(Mandatory=$true)][string]$TenantName
    )
    $DstPath   = $InstallerPath
    $TenantCID = $CID
    $Hostname  = $env:COMPUTERNAME

    Write-Host "`n[+] Starting CrowdStrike installation..."
    & $DstPath /install /quiet CID=$TenantCID
    Start-Sleep -Seconds 60

    Write-Output "[+] Done. $Hostname will be available on host management under the tenant $TenantName in 5-10 minutes."
    Write-Output ""
}

#---------------------------------- Driver -------------------------------------#
try {
    switch ($Operation) {
        "Split" {
            if ([string]::IsNullOrWhiteSpace($SplittedFilesLocation)) {
                $SplittedFilesLocation = $ScriptDir
            }
            Split-File -Path $OriginalFilePath -Parts $Parts -OutputFolder $SplittedFilesLocation
        }
        "Deploy" {
            if ([string]::IsNullOrWhiteSpace($SplittedFilesLocation)) {
                throw "Please set `$SplittedFilesLocation to the folder containing file_split_part_*."
            }
            $rebuilt = Rebuild-FromParts -PartsFolder $SplittedFilesLocation -OutputFile $RebuiltFileName
            Install-CrowdStrikeSimple -InstallerPath $rebuilt -CID $CrowdstrikeCID -TenantName $TenantName
        }
        Default {
            throw "Error: Unknown Operation: $Operation (use 'Split' or 'Deploy')"
        }
    }
}
catch {
    Write-Error $_.Exception.Message
}
