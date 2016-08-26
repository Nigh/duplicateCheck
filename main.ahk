
libName:="lib.txt"

FileRead, csvFile, % libName

lib:=Array()

Loop, Parse, csvFile, % "`r`n",
{
	line:=A_Index
	RegExMatch(A_LoopField, "([^,， ]+)(?:.(.+))?", match)
	if(match)
	{
		lib.Insert(Object())
		lib[lib.MaxIndex()].num:=match1
		lib[lib.MaxIndex()].notes:=match2
	}
}

gui, font, S18
gui, add, Edit, group w400 R16 Multi vinputs
gui, add, Edit, x+10 w400 R16 Multi ReadOnly vdup_edit
gui, add, Edit, x+10 w400 R16 Multi ReadOnly vnew_edit
gui, add, Button, xs w150 Default ginsert, 插入
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
Loop, Parse, lists, `r`n
{
	startPos:=1
	while(startPos:=RegExMatch(A_LoopField, "O)([^\s,，]+)+", matchs,startPos)+matchs.Len(1))
	{
		loop, % matchs.Count()
		{
			inputList.Insert(Object())
			inputList[inputList.MaxIndex()].num:=matchs.Value(A_Index)
		}
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
	}
}

if(dupList.MaxIndex()>0){
	test:="重复项：`n`n"
	loop, % dupList.MaxIndex()
	{
		test.=dupList[A_Index].num
		if(dupList[A_Index].notes)
		{
			test.=": " dupList[A_Index].notes "`r`n"
		}else{
			test.="`r`n"
		}
	}
	GuiControl,, dup_edit,% test
}else{
	GuiControl,, dup_edit, 无重复项
}

if(newList.MaxIndex()>0)
{
	test:="新增：`n`n"
	loop, % newList.MaxIndex()
	{
		test.=newList[A_Index].num "`r`n"
	}
	GuiControl,, new_edit,% test
	adds:=""
	loop, % newList.MaxIndex()
	{
		adds.=newList[A_Index].num "," newList[A_Index].notes "`r`n"
	}
	FileAppend, % adds, % libName
}else{
	GuiControl,, new_edit, 无新增项
}

if(ErrorLevel)
{
	MsgBox, 0x1010, Error, 更新文件失败，可能文件已经被打开。
}
Else
{
	GuiControl, , inputs,
	FileRead, csvFile, % libName
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


