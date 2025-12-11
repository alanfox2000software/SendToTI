;@Ahk2Exe-AddResource SendToTI.ico, 159
;@Ahk2Exe-Set FileDescription, SendToTI
;@Ahk2Exe-Set FileVersion, 1.0.0.0
;@Ahk2Exe-Set InternalName, SendToTI.exe
;@Ahk2Exe-Set OriginalFilename, SendToTI.exe
;@Ahk2Exe-Set ProductName, SendToTI
;@Ahk2Exe-Set ProductVersion, 1.0.0.0
;@Ahk2Exe-UpdateManifest 1 

#NoTrayIcon
#SingleInstance Force

full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        args := ""
        for arg in A_Args
            args .= " " . (InStr(arg, " ") ? '"' . arg . '"' : arg)
        
        if A_IsCompiled
            Run "*RunAs `"" A_ScriptFullPath "`" /restart" . args
        else
            Run '*RunAs "' . A_AhkPath . '" /restart "' . A_ScriptFullPath . '"' . args
    }
    ExitApp
}

args := ""
for arg in A_Args
    args .= " " . (InStr(arg, " ") ? '"' . arg . '"' : arg)

if (args = "")
    ExitApp

first := Trim(A_Args[1], "`"")

; run powershell scripts with trustedinstaller
if (first = "/psf" && A_Args.Length >= 2)
{
    psfile := Trim(A_Args[2], "`"")
    if (FileExist(psfile))
    {
        SplitPath psfile, , , &ext
        if (StrLower(ext) = "lnk")
        {
            FileGetShortcut psfile, &realPs
			if (realPs != "" && FileExist(realPs))
                psfile := realPs
        }
        
		Run "wsudo.exe --ti --nui powershell.exe -ExecutionPolicy Bypass -command `"$Host.UI.RawUI.WindowTitle = `'TrustedInstaller`'` `; & `"" psfile "`"`"", , "Hide"
    }
    ExitApp
}

SplitPath first, , &firstdir, &ext


; if target is Shortcut
if (StrLower(ext) = "lnk" && FileExist(first))
{
    FileGetShortcut first, &target, &dir, &lnkArgs, , , , &runState
    if (target != "")
    {
        statePart := ""
        if (runState = 3)
            statePart := "/Max"
        else if (runState = 7)
            statePart := "/Min"

        ; Open folder shortcut with Explorer as Trusted Installer
		if InStr(FileExist(target), "D")
		{
            Run "wsudo.exe --ti --nui explorer.exe /root,`"" first "`"", , "Hide"
            ExitApp
		}

        ; Open cmd.exe shortcut
		if (StrLower(target) = StrLower(A_ComSpec))
		{
			cmd := "wsudo.exe --cwd `""

			if (dir != "")
				cmd .= dir
			else
				cmd .= firstdir

			cmd .= "`" --ti " A_ComSpec
			
			; without --cwd switch
			;
            ;if (dir != "")
            ;    cmd .= " /c cd /d `"" dir "`" &&"
            ;else
            ;    cmd .= " /c cd /d `"" firstdir "`" &&"

			cmd .= " /c start " 

			if (statePart != "")
				cmd .= statePart " "
				
			cmd .= A_ComSpec
				
            if (lnkArgs != "")
				cmd.= " " lnkArgs

			msgbox(cmd)
			Run cmd, , "Hide"
            ExitApp
		}	
  
        ; Launch program shortcut or open file shortcut with default program
		cmd := "wsudo.exe --ti " A_ComSpec " /c start `"`""

        if (statePart != "")
            cmd .= " " statePart
        if (dir != "")
            cmd .= " /d `"" dir "`""

        cmd .= " `"" target "`" " lnkArgs

		Run cmd, , "Hide"
        ExitApp		
    }
}

; Open folder with Explorer as Trusted Installer
if InStr(FileExist(first), "D")
{
	Run "wsudo.exe --ti --nui explorer.exe /root,`"" first "`"", , "Hide"
		ExitApp
}

; Launch cmd.exe
if (StrLower(first) = StrLower(A_ComSpec))
{
	Run "wsudo.exe --ti " A_ComSpec, , "Hide"
	ExitApp
}

; Launch program or open file with default program
Run "wsudo.exe --ti " A_ComSpec " /c start `"`" " args, , "Hide"
ExitApp