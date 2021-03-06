Write-Verbose "Checking for Azure module..."

$AzModule = Get-Module -Name "AzureAD" -ListAvailable

if ($AzModule -eq $null) {

    Write-Verbose "Azure PowerShell module not found"

    #check for Admin Privleges

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

    if(-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))){

        #No Admin, install to current user

        Write-Warning -Message "Can not install AzureAD Module.  You are not running as Administrator"

        Write-Warning -Message "Installing AzureAD Module to Current User Scope"

        Install-Module AzureAD -Scope CurrentUser -Force



    }

    Else{

        #Admin, install to all users

        Install-Module -Name AzureAD -Force

        Import-Module -Name AzureAD -Force


    }

}

#Logging into Azure AD

Connect-AzureAD

$AzureADGuests=Get-AzureADUser -Filter "userType eq 'Guest'"

foreach($AzureADGuest in $AzureADGuests){

    Remove-AzureADUser -ObjectId $AzureADGuest.ObjectId

 }

 Write-Host "Removed all Guest Users"
