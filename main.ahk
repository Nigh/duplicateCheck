
libName:="lib.csv"

FileRead, csvFile, % libName

lib:=Array()

Loop, Parse, csvFile, `n,
{
	line:=A_Index
	Loop, Parse, A_LoopField, CSV,
	{
		if(A_Index=1)
		{
			if A_LoopField is Number
			{
				lib.Insert(Object())
				lib[lib.MaxIndex()].num:=A_LoopField
				lib[lib.MaxIndex()].notes:=""
			}
			Else
			{
				Continue
			}
		}
		Else
		{
			lib[lib.MaxIndex()].notes.=A_LoopField "`n"
		}
	}
}

gui, font, S18
gui, add, Edit, w400 R16 Multi vinputs
gui, add, Button, w150 Default ginsert, 插入
gui, add, Button, w100 x+150 gGuiClose, 退出
gui, Show
Return

GuiClose:
ExitApp

insert:
gui, Submit, NoHide
inputList:=Array()
dupList:=Array()
newList:=Array()
lists:=inputs "`n"
Loop, Parse, lists, `n
{
	if(RegExMatch(A_LoopField, "([0-9]{4,})(?:\s|,|，)*(.*)", matchs))
	{
		inputList.Insert(Object())
		inputList[inputList.MaxIndex()].num:=matchs1
		inputList[inputList.MaxIndex()].notes:=matchs2
	}
}
loop, % inputList.MaxIndex()
{
	if(index:=inList(inputList[A_Index].num,lib))
	{
		dupList.Insert(Object())
		dupList[dupList.MaxIndex()].num:=lib[index].num
		dupList[dupList.MaxIndex()].notes:=lib[index].notes
	}
	Else
	{
		newList.Insert(Object())
		newList[newList.MaxIndex()].num:=inputList[A_Index].num
		newList[newList.MaxIndex()].notes:=inputList[A_Index].notes
	}
}

if(dupList.MaxIndex()>0){
	test:="重复项：`n`n"
	loop, % dupList.MaxIndex()
	{
		test.=dupList[A_Index].num "`n"
		test.=dupList[A_Index].notes "`n`n"
	}
	MsgBox, % test
}

if(newList.MaxIndex()>0)
{
	test:="新增：`n`n"
	loop, % newList.MaxIndex()
	{
		test.=newList[A_Index].num "`n"
		test.=newList[A_Index].notes "`n`n"
	}
	MsgBox, % test
	adds:=""
	loop, % newList.MaxIndex()
	{
		adds.=newList[A_Index].num "," newList[A_Index].notes "`n"
	}
	FileAppend, % adds, % libName
}

if(ErrorLevel)
{
	MsgBox, 0x1010, Error, 更新文件失败，可能文件已经被打开。
}
Else
{
	GuiControl, , inputs,
}
Return

inList(num,byref lists)
{
	loop, % lists.MaxIndex()
	{
		if(lists[A_Index].num=num)
		{
			Return A_Index
		}
	}
	return 0
}


