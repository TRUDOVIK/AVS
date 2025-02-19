format PE console
entry start

include 'win32a.inc'

section '.data' data readable writable

        indexOut db '%d',10, 0     ; ����� ������ � �������

        vec_size     dd 50000      ; ������ �������. ������� ��� ������� ����� �� ����� �����
        i            dd ?          ; ���������� ��� ���������� ������� ������
        j            dd 1          ; ���������� ��� ������� for
        k            dd 1          ; ���������� ��� ������� for
        l            dd ?          ; ���������� ��� 3��� for, ������� ������� ������� ����� � �������
        vec          rd 500000

section '.code' code readable executable

start:

getVecLoop:                      ;�������� ������ ������
        cmp ecx, [vec_size]
        jge endInputVector       ; ����� �� �����
        mov [i], ecx
        mov eax, [i]
        mov dword[ebx + eax*4], 0     ;���������� ��������� ������� 0
        mov ecx, [i]
        inc ecx      ;�������������
        jmp getVecLoop
endInputVector:

for1:            ; ������� ��������� ��������� �������� ������� ������ 0
        add [j], 1
        mov ebx, [j]
        mov eax, [j]
        mul eax  ; ��������� eax �� ��������� ��������
        mov [k], eax
        mov ecx, [j]
        mov eax, vec
        mov eax , [eax + ecx*4]
        cmp eax, 0
        je for2
        comeBack1:
 ;-------------------------------- ������� ���������� �����
        mov eax, [j]
        mul eax
        cmp eax, [vec_size]
        jle for1


for3:                 ; ��� ��� ��������� ������ � �������� ����� ������ ������� ����� � �������
        add [l], 1
        mov eax, [l]
        mov ebx,  vec
        mov ebx, dword[ebx + eax*4]
        cmp ebx, 0
        je output
        comeBack2:
 ;-------------------------------- ������� ���������� �����
        mov eax, [l]
        cmp eax, [vec_size]
        jle for3
        call finish

for2:               ; �������� ��� ��������� ������� ������� ������� �� 1
        mov ecx, [k]
        mov eax, vec
        mov dword[eax + ecx*4] , 1
        mov eax, [k]
        mov ecx,  [vec_size]
        sub ecx, 1
        add [k], ebx
        cmp eax, ecx
        jle for2
        jmp comeBack1
 ; ����� ������� ������� ����� � �������
output:
        mov eax, [l]
        push eax
        push indexOut
        call[printf]
        jmp comeBack2
 ; ���������� ���������� ���������
finish:
                call [getch]

                push 0
                call [ExitProcess]


;------------------------------- ����������� ��������� --------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'