on run argv
	
	set wasRunning to application "OmniFocus" is running
	set theFilename to item 1 of argv
	set theName to do shell script "head -n1 " & theFilename
	set theLink to do shell script "tail -n+2 " & theFilename
	
	tell application "OmniFocus"
		try
			tell default document
				tell quick entry
					set newTask to make new inbox task with properties {name:theName}
					tell newTask
						tell note
							make new paragraph at beginning with data theLink
							set paragraph 1 to theName
						end tell
					end tell
					open
					if not wasRunning then
						-- Workaround for problem with OF2 which some times opens a hanging empty Quick Entry window (race condition of some sort).
						-- Apparently also fixable using a delay statement, but this is safer
						activate
					else
						set note expanded of tree (count of trees) to true
						if (count of trees) is 1 then
							tell application "System Events" to keystroke tab
							tell application "System Events" to keystroke tab
						end if
					end if
				end tell
			end tell
		on error errMsg number eNum
			tell application "OmniFocus"
				activate
				display alert eNum message errMsg
			end tell
		end try
	end tell
end run
