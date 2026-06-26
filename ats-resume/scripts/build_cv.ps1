# Build an ATS resume PDF from a RenderCV YAML — PDF only.
#
# Usage:
#   pwsh build_cv.ps1 <input.yaml> [output_basename]
#     output_basename defaults to "resume_<yyyy-MM>"
#
# Renders the YAML, copies the PDF to <output_basename>.pdf, and removes the
# regenerable non-PDF render intermediates.

param(
    [Parameter(Mandatory = $true)][string]$Yaml,
    [string]$Base = "resume_$(Get-Date -Format 'yyyy-MM')"
)

$env:PYTHONIOENCODING = 'utf-8'
python -m rendercv render $Yaml | Out-Null

# RenderCV writes the PDF into .\rendercv_output\<Name>_CV.pdf
$pdf = Get-ChildItem -Path 'rendercv_output\*.pdf' -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if (-not $pdf) {
    Write-Error "No PDF was produced. Check the YAML - and make sure it has no 'render_command:' block (that silently breaks RenderCV)."
    exit 1
}

Copy-Item $pdf.FullName "$Base.pdf" -Force

# PDF only: drop the regenerable non-PDF outputs in the tool's own output dir
Get-ChildItem -Path 'rendercv_output' -File |
    Where-Object { $_.Extension -ne '.pdf' } | Remove-Item -Force

Write-Host "Built: $Base.pdf"
