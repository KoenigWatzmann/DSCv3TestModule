[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Method,

    [Parameter(Mandatory=$true, ValueFromPipeline)]
    [string]$InputJson
)

$ErrorActionPreference = 'Ignore'

Class File{
    [string]$Path = ''
}

Class Model{
    [File]$File = [File]::New()
    [string]$State = $null

    Model(){}

    Model([Hashtable]$InputObj){
        $This.File.Path = $InputObj.FilePath
        $This.State = $InputObj.Ensure
    }

    [Hashtable]ConvertToInputScheme(){
        return @{
            Path = $This.File.Path
            Ensure = $This.State
        }
    }
}

function Get-DSC([Model]$InputObj){
    $Model = [Model]::New()
    $Model.File.Path = (Get-Item -Path $InputObj.File.Path).FullName
    If($InputObj.File.Path -ne $Model.File.Path){
        $Model.State = "Absent"
    }
    Else{
        $Model.State = "Present"
    }
    return $Model
}

function Set-DSC([Model]$InputObj){
    $Model = [Model]::New()
    If($InputObj.State -eq 'Present'){
        If(-not(Test-Path -Path $InputObj.File.Path)){
            $Model.File.Path = (New-Item -ItemType 'File' -Path $InputObj.File.Path).FullName
        }
        Else{
            $Model.File.Path = (Get-Item -Path $InputObj.File.Path).FullName
        }
        $Model.State = 'Present'
    }

    If($InputObj.State -eq 'Absent'){
        If(Test-Path -Path $InputObj.File.Path){
            $Model.File.Path = (Remove-Item -Path $InputObj.File.Path).FullName
        }
        Else{
            $Model.File.Path = ''
        }
        $Model.State = 'Absent'
    }
    return $Model
}

function Test-DSC([Model]$InputObj){
    $Model = [Model]::New()
    If(Test-Path -Path $InputObj.File.Path){
        $Model.File.Path = (Get-Item -Path $InputObj.File.Path).FullName
        $Model.State = 'Present'
    }
    Else{
        $Model.File.Path = $InputObj.File.Path
        $Model.State = 'Absent'
    }
    return $Model.ConvertToInputScheme()
}

$InputObj = [Model]::New(($InputJson | ConvertFrom-Json -Depth 99 -AsHashtable))

Switch($Method)
{
    Get { return Get-DSC -InputObj $InputObj | ConvertTo-Json -Compress }
    Set { return Set-DSC -InputObj $InputObj | ConvertTo-Json -Compress }
    Test{ return Test-DSC -InputObj $InputObj | ConvertTo-Json -Compress }
    Default { [System.NotImplementedException]::New('Currently it seems that there are no further methods implemented.')}
}
