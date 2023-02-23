# Grand Paris Express

- ## Configuration du serveur OpenTripePlaner

  - ### Dependence :

    [lien de téléchargement du serveur otp-2.0.0 ](https://repo1.maven.org/maven2/org/opentripplanner/otp/2.0.0-rc1/otp-2.0.0-rc1-shaded.jar)

    [lien de téléchargement du jdk-11 ](https://adoptium.net/temurin/archive/?version=11)

  - ### Installation et configuration :

    **_mkdir otp_**

    **_cd otp_**

    **_cp c:/Users/your_local_user/Downloads/otp-2.0.0-rc1-shaded.jar ._**

    placer les deux fichier **ile-de-france-latest.osm.pbf**  **IDFM.gtfs.zip** dans le répértoir ./otp

  - ### Création et enregistrement du graph

    dans le fichier ./otp executer la commende suivante

    **_java -Xmx8G -jar otp-2.0.0-shaded.jar --build --save ._**

    vous devrez voir un fichier **graph.obj** dans le répertoire ./opt

  - ### Lancer le serveur

    dans le fichier ./otp executer la commende suivante

    **_java -Xmx8G -jar otp-2.0.0-shaded.jar --load ._**

  - ### Testez le serveur
    sur **127.0.0.1:8080** vous pouvez tester le serveur otp
