# Assembly Language (MASM + Irvine) — VS Code Ready

This repository contains my CS118 MASM assignments configured to build & debug from **VS Code** on Windows using the **Irvine32** library.

> ✅ This repo **includes an `irvine/` folder** for convenience so you can build immediately in VS Code.  
> 📎 **Attribution**: The Irvine32 materials included here originate from **Kip R. Irvine**’s site: **https://www.asmirvine.com/**.  
> 🛡️ **Rights**: The Irvine32 materials remain the property of their respective rightsholder(s). See the site for terms and conditions.

---

## Quick Start (Windows)

1) **Install the toolchain**  
   - Install **Visual Studio 2022 Build Tools** with the workload **“Desktop development with C++”** (provides `ml.exe` and `link.exe`).

2) **Open the project in VS Code**  
   - This repo ships with:
     - `.vscode/tasks.json` (build/run tasks)
     - `.vscode/launch.json` (F5 debugging)
     - `.vscode/build_asm.bat` (auto-loads the MSVC x86 environment, then calls `ml`/`link`)
     - `irvine/` (required Irvine files placed for convenience)

3) **Build & run**  
   - Open any `*.asm` file and press **Ctrl+Shift+B** → builds to `build\<name>.exe`.  
   - Press **F5** to build **and** start the debugger (cppvsdbg).  
   - Or run the task **“Run ASM — ACTIVE FILE”** to execute without the debugger.

> No PATH edits needed. The build script calls the Visual Studio **vcvars32.bat** (x86) for you.

---

## If you prefer downloading Irvine yourself
You can obtain the Irvine package directly from the author (recommended for latest updates) and drop the files into `irvine/`:

- Project home: **https://www.asmirvine.com/**  
- Getting Started (MASM + VS2022): **https://www.asmirvine.com/gettingStartedVS2022/index.htm**

Expected files in `irvine/`: `Irvine32.inc`, `Irvine32.lib`, `Kernel32.lib`, `User32.lib`.

---

## How to Build & Run

- **Build (active file):** open a `.asm` file → **Ctrl+Shift+B** → produces `build\<name>.exe`  
- **Run (active file):** use *Run ASM — ACTIVE FILE* task, or just **F5** to debug  
- **Pick a file to build:** run *Build ASM — PICK FILE* (task), then *Run ASM — PICK FILE*

### Debugging tips
- Set a breakpoint on the first instruction inside `main PROC` (not on labels/directives).  
- Step with **F10** (over) / **F11** (into) / **Shift+F11** (out).  
- Use Irvine helpers like `DumpRegs`, `Crlf`, `WriteString` to inspect state.

---

## File Highlights (what each assignment demonstrates)

- **Assignment 2 — Integer arithmetic & registers**  
  Subtracts/combines integer values, moves data between registers/memory, prints results via Irvine routines.

- **Assignment 3 — Reverse copy (strings & addressing)**  
  Copies a string in **reverse order** using a counted loop and indirect addressing (index/pointer usage).

- **Assignment 4 — Console I/O + control flow**  
  Clears screen / positions cursor, prompts for **two integers**, computes their **sum**, repeats a few times.

- **Midterm Assignment 5 — Arrays, validation, modular procs**  
  Reads a fixed number of values with range validation; computes **average**, **min**, **max**, and counts values matching a predicate, split across procedures.

- **Assignment 6 — Greatest Common Divisor**  
  Reads two integers, validates input, computes **GCD** (Euclidean-style), and displays the result.

- **Assignment 7 — Array comparison (near matches)**  
  Compares two arrays with a tolerance rule; demonstrates passing pointers/sizes and returning results in `EAX`.

- **Final Assignment 8 — String analytics**  
  For a user-provided string, counts **words**, **flips case** of all letters, and counts **vowels**, organized into separate procedures.

> The programs use the standard 32-bit MASM pattern:  
> `.386`, `.model flat, stdcall`, `.stack 4096`, `INCLUDE Irvine32.inc`, and `END main`.

---

## Portability

- The build and debug setup is **path-agnostic for this project**. You can move/rename the folder and it will still work.  
- The batch script auto-locates a **VS 2022** C++ toolchain (Build Tools / Community / Pro / Enterprise). On a machine without VS 2022 C++ tools, install that workload first.

---

## Attribution & License

- **Irvine32**: The `irvine/` contents are sourced from **https://www.asmirvine.com/** (Kip R. Irvine). All rights remain with the original author/publisher; see the site for licensing/usage terms.  
- **This repo’s source code**: © 2022–present by Rahim Siddiq (unless otherwise noted).

If you’re a rightsholder and would like the included Irvine files removed from this repository, please reach out and they will be taken down promptly.
