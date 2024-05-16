winget, pid, PID, ahk_class SunAwtFrame
global ProcessHandle := DllCall("OpenProcess","Int",2035711,"Int",0,"UInt",pid)
ReadMemory(MADDRESS)
{
	VarSetCapacity(MVALUE,4,0)
	DllCall("ReadProcessMemory","UInt",ProcessHandle,"UInt",MADDRESS,"Str",MVALUE,"UInt",4,"UInt *",0)
	return *(&MVALUE+3)<<24 | *(&MVALUE+2)<<16 | *(&MVALUE+1)<<8 | *(&MVALUE)
}
WriteMemory(process_handle, address, value)
{
    DllCall("VirtualProtectEx", "UInt", process_handle, "UInt", address, "UInt", 4, "UInt", 0x04, "UInt *", 0) ; PAGE_READWRITE
    DllCall("WriteProcessMemory", "UInt", process_handle, "UInt", address, "UInt *", value, "UInt", 4, "UInt *", 0)
}
writeString(address, string, encoding := "utf-8", aOffsets*)
{
    encodingSize := (encoding = "utf-16" || encoding = "cp1200") ? 2 : 1
    requiredSize := StrPut(string, encoding) * encodingSize - (this.insertNullTerminator ? 0 : encodingSize)
    VarSetCapacity(buffer, requiredSize)
    StrPut(string, &buffer, StrLen(string) + (this.insertNullTerminator ?  1 : 0), encoding)
    return DllCall("WriteProcessMemory", "Ptr", this.hProcess, "Ptr", aOffsets.maxIndex() ? this.getAddressFromOffsets(address, aOffsets*) : address, "Ptr", &buffer, "Ptr", requiredSize, "Ptr", this.pNumberOfBytesWritten)
}
currentItem := 0
WriteMemory(ProcessHandle, 0xE150097C, 874901547) ;set item selected flag
Loop, 4 { ;loop items in inventory
    WriteMemory(ProcessHandle, 0xE3830AF0, currentItem) ;current item
    currentItem += 518436319
    Sleep, 1000
}