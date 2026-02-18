"""
Python script to check python packages specified in requirements are successfully installed
"""

import pathlib
import importlib.util
import pkg_resources

# Open requirements file
with pathlib.Path("/requirements.txt").open() as requirements_txt:
    INSTALLED_FLAG = True
    EXCEPTION_LIST = ["ipython"]
    PACKAGES = pkg_resources.parse_requirements(requirements_txt)

    # Iterate through packages on list and check if installed (unless on exception list)
    for package in PACKAGES:
        # Parse package name
        if "==" in str(package):
            package_name = str(package).split("==")[0].split("@")[0].replace("-", "_")
        else:
            package_name = str(package).split(">=")[0].split("@")[0].replace("-", "_")

        if package_name not in EXCEPTION_LIST:
            spec = importlib.util.find_spec(package_name)
            if spec is None:
                print(package_name + " is not installed")
                INSTALLED_FLAG = False

    STATUS = (
        "SUCCESS: All Packages Installed"
        if INSTALLED_FLAG
        else "FAILED: Missing Package(s)"
    )
    print(STATUS)
