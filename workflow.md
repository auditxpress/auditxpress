# Workflow Documentation

## Overview

This project performs audits on Linux and Windows systems based on the CIS Benchmark. The auditing process is modular and includes different scripts for various components of the audit.

## Project Structure
```
.
├── benchmark_linux
│   ├── helper_functions.sh
│   └── modules
│       ├── demo_mod1.sh
│       ├── demo_mod2.sh
│       ├── fs_module.sh
│       └── fs_partition.sh
├── init.py
├── LICENSE
├── linux_audit.sh
├── windows_audit.ps1
└── workflow.md
```

### Description of Files and Directories

- **`windows_audit.ps1`**: PowerShell script for performing Windows system audits based on the CIS Benchmark.

- **`benchmark_linux/`**: Directory containing Linux-specific audit scripts.
  - **`helper_functions.sh`**: Contains utility functions for logging and reporting used in the Linux audit scripts.
  - **`modules/`**: Directory containing modular benchmark scripts for different audit tasks.
    - **`demo_mod1.sh`**: Example module script for a specific benchmark check.
    - **`demo_mod2.sh`**: Another example module script for a different benchmark check.
    - **`fs_module.sh`**: Script for auditing filesystem-related settings.
    - **`fs_partition.sh`**: Script for auditing filesystem partitions.

- **`init.py`**: Python script that detects the operating system and executes the appropriate audit script (`linux_audit.sh` or `windows_audit.ps1`).

- **`linux_audit.sh`**: Driver script for executing the Linux benchmark modules from the `benchmark_linux/modules` directory.

- **`LICENSE`**: GPL3 License file for the project.

## Workflow

### 1. Initialization

- **`init.py`**: This script is the entry point. It detects the operating system of the host system and executes the corresponding audit script:
  - If a Linux system is detected, it executes `linux_audit.sh`.
  - If a Windows system is detected, it executes `windows_audit.ps1`.

### 2. Linux Auditing

- **`linux_audit.sh`**: This driver script manages the execution of various Linux benchmark modules. It calls the benchmark scripts located in the `benchmark_linux/modules` directory.

### 3. Benchmark Modules

- **`benchmark_linux/modules/`**: This directory contains individual scripts for different benchmark checks. Each script performs a specific set of checks or configurations based on the CIS Benchmark. For example:
  - **`fs_module.sh`**: Checks and reports on filesystem configurations.
  - **`fs_partition.sh`**: Checks and reports on filesystem partitions.

### 4. Helper Functions

- **`benchmark_linux/helper_functions.sh`**: This file contains helper functions used across the Linux benchmark scripts. Functions include:
  - `Log()`: For logging messages.
  - `Report()`: For reporting the audit results.
  - `Suggestion()`: For providing suggestions based on the audit findings.

## Contributing

If you would like to contribute to this project, please follow these guidelines:
- Fork the repository and create a new branch for your changes.
- Add or modify scripts in the `benchmark_linux/modules/` directory or update `helper_functions.sh` as needed.
- Ensure that all changes are well-documented and tested.
- Submit a pull request with a description of your changes.

