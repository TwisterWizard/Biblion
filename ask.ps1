#$wshell = New-Object -ComObject Wscript.Shell
#$wshell.Popup("Sick", 0, "ok", 0x1)
Add-Type -AssemblyName System.Windows.Forms

#make the popup object using form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Nice" #This is the title of the window that pops up
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

#make a button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Start"
$button.Location = New-Object System.Drawing.Point(125, 50)#these define the top left corner of the button
$button.Size = New-Object System.Drawing.Size(50, 50) #defines the dimensions of the button
$button.DialogResult = 1 #this is the return value on click
$button.Dock = "Right"

#add format select?
$mlaB = New-Object System.Windows.Forms.Button
$mlaB.Text = "OK"
$mlaB.Location = New-Object System.Drawing.Point(50, 50)#these define the top left corner of the button
$mlaB.Size = New-Object System.Drawing.Size(50, 50) #defines the dimensions of the button
$mlaB.DialogResult = 1 #this is the return value on click
$mlaB.Dock = "Right"


$form.Controls.Add($mlaB)
$form.Controls.Add($button)

#add the form spaces for the actual info
$title = New-Object System.Windows.Forms.TextBox
$title.Location = New-Object System.Drawing.Point(0, 0)
$title.Size = New-Object System.Drawing.Size(40, 20)
$title.Multiline = $true
$title.AutoSize = $true
$title.Dock = "Top"


$form.Controls.Add($title)


$result = $form.ShowDialog()#returns the button pressed.
#https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.dialogresult?view=windowsdesktop-8.0

#will print the associated name. check link for exact definitions/available values
#Write-Output $result
#create an environment variable. It will not be persistent - it disappears after the shell session ends


#it actually must persist as otherwise the shell closes before the value is passed?
#i'd rateher not clutter user computers with an extra env variable
#pass values to the c code
#$env:CHOSEN = $result
#Write-Output $env:CHOSEN

#pull the info from the form and then store it into the text file

#that is not working. Maybe let's try piping it to a random file to then read?
Out-File -FilePath .\status.txt -Encoding ascii -InputObject $result