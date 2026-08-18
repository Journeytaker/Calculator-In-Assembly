# ARM Assembly Calculator

A command-line calculator written in **ARM Assembly**. This project was developed as a learning exercise in low-level programming, input parsing, register management, memory operations, subroutines, ASCII conversion, and arithmetic operations.

The calculator accepts algebraic expressions in the following format:

```text
Operand1 Operator Operand2
```

For example:

```text
12 + 100
```

## Features

* Addition
* Subtraction
* Multiplication
* Integer division
* Positive and negative operands
* Operand validation
* Operator validation
* Input-length validation
* Detection of missing or excessive spaces
* Detection of missing or excessive newlines
* Division-by-zero detection
* ASCII-to-integer conversion
* Integer-to-ASCII conversion
* Error messages for invalid input
* Support for operands from `-128` to `127`

## Supported Operators

| Operator | Operation        |
| -------- | ---------------- |
| `+`      | Addition         |
| `-`      | Subtraction      |
| `*`      | Multiplication   |
| `/`      | Integer division |

## Input Format

The calculator expects an expression containing two operands and one operator, with spaces separating each part.

### Valid examples

```text
12 + 100
-25 * 4
100 - 50
64 / 8
-100 / 5
```

### Division by zero

Division by zero is detected and produces an error message instead of attempting the calculation.

```text
12 / 0
```

## Operand Range

Both operands are limited to the signed 8-bit range:

```text
-128 through 127
```

Values outside this range are rejected.

## Division Behavior

Division is currently implemented as **integer division**. Fractional results are not displayed.

For example:

```text
12 / 5 = 2
```

rather than:

```text
12 / 5 = 2.4
```

This is a current limitation of the calculator. Floating-point or fixed-point decimal output has not been implemented.

## How It Works

The program is divided into several subroutines, with each subroutine responsible for a specific part of the calculator's operation.

### Input Processing

The program first reads the user's command into the `Input` buffer.

`SUB1` searches the input for spaces and the newline character. The locations of the two spaces and newline are saved so that the operands and operator can be located later.

### Negative Number Detection

`SUB4` determines whether either operand begins with a negative sign (`-`). This information is stored in:

```text
Operand1C
Operand2C
```

A value of `1` indicates a negative operand, while `0` indicates a positive operand.

### Operand Length Detection

`SUB5` determines the number of digits in each operand and stores the lengths in:

```text
Operand1B
Operand2B
```

The calculator supports operands containing up to three digits, in addition to an optional negative sign.

### Operand and Operator Extraction

`SUB6` extracts the operands and operator from the original input string and stores them separately:

```text
Operand1_A
Operand2_A
Operator
```

### Input Validation

The calculator checks that:

* Operand characters are valid decimal digits.
* The operator is one of `+`, `-`, `*`, or `/`.
* The input contains the correct number of spaces.
* The input contains exactly one newline.
* Both operands contain valid numbers.
* Neither operand exceeds the supported length.
* The operands are within the `-128` to `127` range.
* The divisor is not zero.

### ASCII Conversion

`SUB9` converts the ASCII representation of each operand into a numeric value that can be used by the arithmetic routines.

For example:

```text
ASCII "123"
       ↓
numeric 123
```

### Arithmetic

`SUB10` determines which operation the user selected and performs the appropriate calculation.

The division routine uses repeated subtraction to determine the integer quotient.

For example:

```text
12 / 3

12 - 3 = 9
 9 - 3 = 6
 6 - 3 = 3
 3 - 3 = 0

Result = 4
```

Division by zero is detected before the division routine is executed.

### Result Conversion

After the calculation, `hex_to_ascii` converts the numeric result back into ASCII characters so that it can be displayed to the user.

For example:

```text
numeric 123
     ↓
ASCII "123"
```

## Error Handling

The program uses error codes to communicate problems between subroutines.

Some of the errors handled include:

* Too many spaces
* Too few spaces
* Too many newlines
* Missing newline
* Missing operand
* Operand too long
* Invalid operand characters
* Invalid operator
* Operand outside the supported range
* Division by zero

The error code is passed to `SUB3`, which displays the appropriate message to the user.

## Memory Organization

Several variables are reserved in the `.data` section for storing input and intermediate information.

Some of the important variables include:

```text
Input       Original user input
Operand1_A  ASCII representation of operand 1
Operand1B   Length of operand 1
Operand1C   Negative flag for operand 1
Operand1_H  Numeric value of operand 1

Operand2_A  ASCII representation of operand 2
Operand2B   Length of operand 2
Operand2C   Negative flag for operand 2
Operand2_H  Numeric value of operand 2

Operator    Selected arithmetic operator
Result_H    Numeric calculation result
Result_A    ASCII representation of the result
Result_N    Negative flag for the result
```

## Example

A typical calculation looks like:

```text
Hello and welcome to the Calculator Program.

Input Format: Operand1 Operator Operand2
Operators: + - * /

Input Algebraic Command Line Here:
12 * -4

Operand 1:12
Operand 2:-4
Operator:*
Result:-48
```

## Current Limitations

This project is primarily intended as an ARM Assembly learning project. Some limitations remain:

* Division produces integer results only.
* Decimal/fractional output is not currently supported.
* Operands are limited to `-128` through `127`.
* The input format is intentionally strict.
* The program is designed around the ARM/Linux environment used during development.

These limitations may be addressed in future versions depending on the requirements of the project.

## Learning Objectives

This project provided practical experience with:

* ARM Assembly syntax
* Registers and register management
* Memory addressing
* Load/store operations
* Branching and conditional execution
* Subroutines
* Macros
* The stack
* Two's-complement signed values
* ASCII encoding
* Integer arithmetic
* Input validation
* Error handling
* System calls

## Project Status

**Complete / Functional**

The calculator currently supports the four basic arithmetic operations, signed operands, input validation, result conversion, and division-by-zero handling.

Further improvements may be made as additional ARM Assembly concepts are learned.

## Author
Dillon Parrack
Developed as an ARM Assembly programming project.


## Setup on Raspberry Pi 3B+ using Raspberry Pi OS Desktop 64 Bit

### Command to install resources to run 32-bit programs:
```text
sudo apt install gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf
```
This will install the nessary resources to run 32 bit programs since the calculator was built for a 32 bit system.

### Commands to compile and run the program
```text
arm-linux-gnueabihf-as -g -o calculator.o calculator.s
```
```text
arm-linux-gnueabihf-gcc -o calculator calculator.o
```
```text
./calculator
```
These commands will test the program for any errors, compile the program, and then the final command will run the program.
