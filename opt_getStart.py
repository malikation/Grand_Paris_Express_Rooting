import os

home = os.path.expanduser("~")
print(home)

# got to home directory 
os.chdir(home)
print(os.getcwd())
print(os.getcwd())

# create a new directory if not exist
if not os.path.exists("otp"):
    os.makedirs("otp")
else:
    print("The directory already exist")

# go to the new directory
os.chdir("otp")
print(os.getcwd())

# creation function chechinf if the file exist and downlaod it with curl 
def download_file(url, file_name):
    if not os.path.exists(file_name):
        # whaiting for the file to be downloaded
        os.system(f"curl -O {url}")
        while not os.path.exists(file_name):
            sleep(2)
    else:
        print("The file already exist")

shaded_url = "https://repo1.maven.org/maven2/org/opentripplanner/otp/2.2.0/otp-2.2.0-shaded.jar"
shaded_file = "otp-2.2.0-shaded.jar"

osm_url = "https://download.geofabrik.de/europe/france/ile-de-france-latest.osm.pbf"
osm_file = "ile-de-france-latest.osm.pbf"

# I created a link to download the gtfs zip file
gtfs_url = "https://www.dropbox.com/s/pk6gih29psq3nnx/gtfs.zip"
gtfs_file = "gtfs.zip"

java_sdk_19_url_windows = "https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.exe"
java_file_19_windows    = "jdk-19_windows-x64_bin.exe"

java_sdk_19_url_unix = "https://download.oracle.com/java/19/latest/jdk-19_linux-x64_bin.deb"
java_file_19_unix    = "jdk-19_linux-x64_bin.deb"


# download the file
download_file(shaded_url, shaded_file)
download_file(osm_url, osm_file)
download_file(gtfs_url, gtfs_file)

# check java version
os.system("java -version")

# check if java is installe
# get envirement variable
java_home = os.environ.get("JAVA_HOME")

# check if it's jdk 19
if java_home and java_home.split("\\")[-1] == "jdk-19":
    print("Java 19 is installed") 
else:
    print("Java 19 is not installed")

    if os.name == "nt":
        print("Windows")
        download_file(java_sdk_19_url_windows, java_file_19_windows)
        os.system(java_file_19_windows)
        # waiting the end and the installation of java
        while not os.path.exists("C:\\Program Files\\Java\\jdk-19"):
            sleep(2)
        print("Java 19 is installed")
        # set the envirement variable
        os.environ["JAVA_HOME"] = "C:\\Program Files\\Java\\jdk-19"

    else:
        print("Linux")
        download_file(java_sdk_19_url_unix, java_file_19_unix)
        os.system(f"sudo apt-get -qqy install ./{java_file_19_unix}")
        os.system("sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-19/bin/java 1919")
        # export JAVA_HOME=/usr/lib/jvm/jdk-19
        os.system("sudo export JAVA_HOME=/usr/lib/jvm/jdk-19")

# check java version
os.system("java -version")

port_message = ""

# check if port 8080 is free
if os.name == "nt":
    if os.system("netstat -ano | findstr :8080") == 0:
        print("Port 8080 is free")
    else:
        print("Port 8080 is not free")
        port_message = "--port 8081"
else:
    if os.system("netstat -ano | grep :8080") == 0:
        print("Port 8080 is free")
    else:
        print("Port 8080 is not free")
        port_message = "--port 8081"        


# if file graph.obj exist
if os.path.exists("graph.obj"):
    print("The graph.obj file already exist")
    # load it 
    os.system("java -Xmx8G -jar otp-2.2.0-shaded.jar "+port_message+" --load .")
else:
    # build it
    os.system("java -Xmx8G -jar otp-2.2.0-shaded.jar  --build --save .")


                

