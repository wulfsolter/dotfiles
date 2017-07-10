#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance force

^j::
   Send, My First Script
Return

PgUp::
;  Do nothing
Return

PgDn::
;  Do nothing
Return

^PgUp::
  Send, {PgUp}
Return

^PgDn::
  Send, {PgDn}
Return


