import os
import platform
import subprocess
import time
from tqdm import tqdm

def run_script_windows(script_path):
    try:
        # PowerShell command to run the script as administrator with execution policy bypass
        command = [
            'powershell',
            '-Command',
            f'Set-ExecutionPolicy Bypass -Scope Process -Force; Start-Process powershell -ArgumentList \'-ExecutionPolicy Bypass -File "{script_path}"\' -Verb RunAs'
        ]
        # Execute the command and capture output and errors
        result = subprocess.run(command, text=True, capture_output=True)
        print("\nWindows script executed successfully.")
        print("Output:\n", result.stdout)
        print("Errors:\n", result.stderr)
    except subprocess.CalledProcessError as e:
        print(f"\nFailed to execute Windows script: {e}")

def run_script_linux(script_path):
    try:
        # Bash command to run the script with sudo
        command = f'sudo bash {script_path}'
        # Execute the command and capture output and errors
        result = subprocess.run(command, shell=True, text=True, capture_output=True)
        print("\nLinux script executed successfully.")
        print("Output:\n", result.stdout)
        print("Errors:\n", result.stderr)
    except subprocess.CalledProcessError as e:
        print(f"\nFailed to execute Linux script: {e}")

def dynamic_loading_screen():
    print("Detecting your OS and preparing to run the script...\n")
    for _ in tqdm(range(100), desc="Loading", ascii=True, ncols=75):
        time.sleep(0.05)  # Adjust the sleep time for different loading speeds

def main():
    os_type = platform.system()
    
    # Paths to the scripts
    windows_script = r"C:\Users\karti\Downloads\Hackathon\3kkr.ps1"  # Replace with your PowerShell script path
    linux_script = 'audit_linux.sh'      # Replace with your Bash script path

    dynamic_loading_screen()
    
    if os_type == 'Windows':
        print("\nDetected Windows OS.")
        run_script_windows(windows_script)
    elif os_type == 'Linux':
        print("\nDetected Linux OS.")
        run_script_linux(linux_script)
    else:
        print("\nUnsupported OS detected.")

if __name__ == "__main__":
 
