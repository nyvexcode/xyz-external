@echo off
setlocal
cd /d "%~dp0"

if not exist imgui\imgui.h (
    where git >nul 2>&1 || (echo [x] git nao encontrado. Instale o Git ou baixe o ImGui v1.91.9 em .\imgui & exit /b 1)
    git clone --depth 1 --branch v1.91.9 https://github.com/ocornut/imgui.git imgui || exit /b 1
)

set "VSW=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSW%" (echo [x] Visual Studio Build Tools nao encontrado & exit /b 1)
for /f "usebackq delims=" %%i in (`"%VSW%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VS=%%i"
if not defined VS (echo [x] Componente C++ do Visual Studio nao encontrado & exit /b 1)
call "%VS%\VC\Auxiliary\Build\vcvars64.bat" >nul

if not exist build mkdir build
cl /nologo /std:c++17 /O2 /EHsc /MT /DNDEBUG /utf-8 ^
   /I imgui /I imgui\backends ^
   main.cpp ^
   imgui\imgui.cpp imgui\imgui_draw.cpp imgui\imgui_tables.cpp imgui\imgui_widgets.cpp ^
   imgui\backends\imgui_impl_win32.cpp imgui\backends\imgui_impl_dx11.cpp ^
   /Fobuild\ /Febuild\XYZExternal.exe ^
   /link /SUBSYSTEM:WINDOWS user32.lib gdi32.lib d3d11.lib dxgi.lib dwmapi.lib || exit /b 1

copy /y offsets.ini build\offsets.ini >nul
echo.
echo [ok] build\XYZExternal.exe
