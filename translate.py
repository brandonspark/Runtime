
s = str(raw_input())

store = ''

lastInstr = None
instrCount = 0

global dirList
dirList = ["R"]

def gen(instr, instrCount):
    global dirList
    print(instr, instrCount, dirList[-1], dirList)
    if instr == None:
        return ''
    suffixString = ''
    ans = ''
    if instrCount > 1:
        suffixString = 's'
    if instr == ">":
        if dirList[-1] == "L":
            ans = 'Turn around\n'
            dirList[-1] = "R"
        return ans + "Lunge forward {} time{}\n".format(instrCount, suffixString)
    elif instr == "<":
        if dirList[-1] == "R" or dirList[-1] == None:
            ans = 'Turn around.\n'
            dirList[-1] = "L"
        return ans + "Lunge forward {} time{}\n".format(instrCount, suffixString)
    elif instr == "+":
        return "Do {} jumping jack{}\n".format(instrCount, suffixString)
    elif instr == "-":
        return "Squat {} time{}\n".format(instrCount, suffixString)
    elif instr == "[":
        for i in range(instrCount):
            dirList.append(dirList[-1])
        return "Touch your toes\n" * instrCount
    elif instr == "]":
        for i in range(instrCount):
            dirList = dirList[:-1]
        return "Stretch your back\n" * instrCount
    elif instr == ",":
        return ''
    elif instr == ".":
        return "Twist right {} time{}\n".format(instrCount, suffixString)
    return ''

final = ''

for c in s:
    if c != lastInstr:
        final += gen(lastInstr, instrCount)
        lastInstr = c
        instrCount = 1
    else:
        instrCount += 1

final += gen(lastInstr, instrCount)

f = open("./workout.txt", 'w')

f.write(final)

f.close()
