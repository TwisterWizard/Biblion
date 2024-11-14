#$wshell = New-Object -ComObject Wscript.Shell
#$wshell.Popup("Sick", 0, "ok", 0x1)
Add-Type -AssemblyName System.Windows.Forms

#make the popup object using form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Biblion" #This is the title of the window that pops up
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

#make a button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Cancel"
$button.Location = New-Object System.Drawing.Point(275, 175)#these define the top left corner of the button
$button.Size = New-Object System.Drawing.Size(50, 50) #defines the dimensions of the button
$button.DialogResult = 2 #this is the return value on click
$button.Dock = "Bottom"
#https://learn.microsoft.com/en-us/dotnet/desktop/winforms/controls/how-to-dock-and-anchor?view=netdesktop-9.0

#add format select? Work in progress
$mlaB = New-Object System.Windows.Forms.Button
$mlaB.Text = "Go"
$mlaB.Location = New-Object System.Drawing.Point(50, 50)#these define the top left corner of the button
$mlaB.Size = New-Object System.Drawing.Size(50, 50) #defines the dimensions of the button
$mlaB.DialogResult = 1 #this is the return value on click
$mlaB.Dock = "Bottom"


$form.Controls.Add($mlaB)
$form.Controls.Add($button)

#add the form space for the actual info
$title = New-Object System.Windows.Forms.TextBox
$title.Location = New-Object System.Drawing.Point(0, 0)
$title.Size = New-Object System.Drawing.Size(100, 100)
$title.Multiline = $true
$title.ScrollBars = "Vertical"
$title.Anchor = (1 -bor 4) #top left
#for singular can just use string "Top", "Bottom", "Left", "Right"
#having trouble dealing with scope stuff, so just using numeric equivalents
#https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.anchorstyles?view=windowsdesktop-8.0
#anchor ties it to its initially DRAWN location
$title.Font = New-Object System.Drawing.Font("Arial", 10) 

$form.Controls.Add($title)

#dynamically change the box size 
#make an event handler
#can be separate or written within {} as an argument when registering
#let's write it separately
$userWriting = {
    #Write-Host "LETS GO"
    #this displays to the console WHILE the window is open

    #is it at the border of the text box
    #each character is 10px tall
    #get number of lines in the box
    $lCount = $title.Lines.Count
    $availLine = ($title.Height - 10) /10
    $maxLines = ($form.Size.Height - 100) / 10


    #adjust the size
    if ($title.Width -lt $form.Width-10){
        $title.Width += 10
    }
    
    #don't forget to check the case where we adjust window size
    #I don't want the text box to take up more than half the vertical space of the screen
    #a bit redundant, but it's for safety
    if ((($availLine -eq $lCount) -or ($lCount -gt $availLine)) -and ($availLine -lt $maxLines) -and ($title.Height -lt $form.Height/2)){
        $title.Height += 10
        #Write-Host $maxLines
    }
}

$title.add_TextChanged($userWriting) #register the handler

#add handler for resizing of window
$form.add_SizeChanged({
    #enforce minimum size
    if ($form.Height -lt 400 -or $form.Width -lt 600){
        $form.Height = 400
        $form.Width = 600
    }


    #redundant check to make sure that the text box never goes off of the window
    if ($title.Height -ge $form.Height){
        $title.Height = $form.Height
    }
})


#add the custom icon
$iconPath = ".\libMascot.ico"
$icon = New-Object System.Drawing.Icon($iconPath)
$form.Icon = $icon

$result = $form.ShowDialog()#returns the button pressed.
#https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.dialogresult?view=windowsdesktop-8.0
$words = $title.Text
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
Out-File -FilePath .\status.txt -Encoding ascii -InputObject $result #-NoNewline prevents newlines from being written
Out-File -FilePath .\status.txt -Encoding ascii -Append -InputObject $words #append tells the program not to overwrite