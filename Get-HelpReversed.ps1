function Get-HelpReversed (){
<#
.SYNOPSIS
    Generate a powershell comment boilerplate.

.DESCRIPTION
    create a function newfunction, than call Get-HelpReversed "<newfunction>" to get the comment boilerplate.
    
.PARAMETER name
    the function name
  
.EXAMPLE
  Get-HelpReversed Get-HelpReversed

#>
    param(
        [string] $name,
        [Switch] $valueOnly

    )
    if ($valueOnly.ToBool()){
        $h=Get-Help $name -Full
    
        "<#"
        ".SYNOPSIS"
        "    "+$h.Synopsis.Trim()
        ""
        ".DESCRIPTION"
            try {
            $h.description | %{
                if ($null -eq $_.Text){
                    "    TODO"
                } else {
                    $_.Text.Split("`n`r".ToCharArray(), [System.StringSplitOptions]::RemoveEmptyEntries) | %{
                        "    "+$_
                    }
                }
            }
        } catch {
            "    TODO"
        }
        ""

        $h.parameters.parameter | %{
            $p = $_
    
            ".PARAMETER $($p.name)"    
                try {
                if (($null -eq $p.description) -or ($p.description.Count -eq 0)) {
                    "    TODO $($p.name)"
                } else {
                    $p.description | %{
				        if ($null -eq $_.Text){
					        "    TODO"
				        } else {
					        $_.Text.Split("`n`r".ToCharArray(), [System.StringSplitOptions]::RemoveEmptyEntries) | %{
						        "    "+$_
					        }
				        }
                    }
                }
            } catch {
                "    TODO"
            }
            ""
        }

        if ($null -eq $h.examples){
            "  "
            ".EXAMPLE"
            "  TODO"
        } else {
            $h.examples | %{
                "  "
                ".EXAMPLE"
                $_.example.introduction | %{ $_.Text } | ?{ $_ -ne "" }
                $_.example.code
                $_.example.remarks | %{ $_.Text } | ?{ $_ -ne "" }
            }
        }
        "#>"
    } else {
        $h = Get-HelpReversed -name $name -valueOnly
        Set-Clipboard -Value $h
        $h
    }
}

<#
$cs = Get-Command -CommandType Function | ? {$_.ModuleName -eq "Your module"} | ? {-not $_.Definition.Contains("Set-Location") } | ?{ -not @("Clear-Host", "Get-HelpReversed", "Get-Verb", "help", "ImportSystemModules", "mkdir", "oss", "Pause", "prompt", "psEdit", "TabExpansion2").Contains($_.Name)}
$cs | %{ "Get-HelpReversed '$($_.Name)'" } 

$cs = Get-Command -CommandType Function | ? {$_.ModuleName -eq ""} | ? {-not $_.Definition.Contains("Set-Location") } | ?{ -not @("Clear-Host", "Get-HelpReversed", "Get-Verb", "help", "ImportSystemModules", "mkdir", "oss", "Pause", "prompt", "psEdit", "TabExpansion2").Contains($_.Name)}
$cs | %{ "Get-HelpReversed '$($_.Name)'" } 

#>