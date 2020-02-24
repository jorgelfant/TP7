<%--
  Created by IntelliJ IDEA.
  User: jorge.carrillo
  Date: 2/24/2020
  Time: 10:15 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<%--
************************************************************************************************************************
                                      TP Fil rouge - Étape 5
************************************************************************************************************************

Dans cette cinquième étape du fil rouge qui clôture cette partie du cours, vous allez ajouter un champ au formulaire
de création d'un client, permettant à l'utilisateur d'envoyer une image. Servlets d'upload et de download sont au
programme !

Fonctionnalités
***************


Objectifs
*********

Votre mission cette fois est de permettre à l'utilisateur d'envoyer une image lors de la création d'un client via le
formulaire existant. Votre application devra ensuite vérifier que le fichier envoyé est bien une image, et vous en
profiterez pour vérifier que le poids de l'image ne dépasse pas 1 Mo avant de l'enregistrer dans un dossier externe
au conteneur web.

Bien entendu, l'objectif suivant va être d'afficher un lien vers cette image sur la liste des clients existants.
Au clic sur ce lien, l'utilisateur pourra alors visualiser l'image associée au client.

Enfin, vous devrez veiller à ce que l'utilisateur puisse toujours procéder à la création d'un client depuis le
formulaire de création d'une commande, comme c'était déjà le cas jusqu'à présent.

Voici aux figure suivantes quelques exemples de rendu.

À propos de cette dernière capture d'écran, vous remarquerez que lorsque la taille maximale définie pour un fichier
est dépassée, toutes les informations saisies dans le reste du formulaire disparaissent. Ne vous inquiétez pas, il
s'agit du comportement normal de Tomcat dans ce cas d'utilisation : une IllegalStateException est levée, et les appels
aux méthodes getParameter() renvoient tous null. Ce n'est pas très ergonomique, mais nous nous en contenterons dans le
cadre de ce TP. ^^

**********
Conseils
**********

****************
Envoi du fichier
****************

Première étape, la modification du formulaire existant. Vous allez devoir reprendre le code du fragment de JSP contenant
les champs décrivant un client, et y ajouter un champ de type <input type="file"> pour permettre à l'utilisateur
d'envoyer une image.

En conséquence, vous allez devoir ajouter un attribut enctype aux balises <form> dans les formulaires des deux JSP
responsables de la création d'un client et d'une commande, afin qu'elles gèrent correctement les requêtes contenant
des données sous forme de fichiers.

***************************************
Validation et enregistrement du fichier
***************************************

Côté serveur, vous allez devoir analyser les données reçues dans le nouveau paramètre de requête correspondant au champ
de type fichier. Pour commencer, faites en sorte que ce champ soit optionnel, autrement dit que l'utilisateur puisse le
laisser vide, qu'il ne soit pas obligé d'envoyer un fichier lors de la création d'un client.

Si un fichier est envoyé, alors vous allez devoir :

      * vérifier que le poids du fichier envoyé ne dépasse pas 1 Mo ;

      * vérifier que le fichier envoyé est bien une image ;

      * enregistrer le fichier dans un répertoire du disque local, en dehors du conteneur ;

      * ajouter le chemin vers l'image dans le bean Client, afin de pouvoir retrouver l'image par la suite.

*******************
Le poids du fichier
*******************

Comme je vous l'ai appris, avec l'API servlet 3.0 c'est très simple : les contraintes de taille sont imposées par la
déclaration de la servlet dans le fichier web.xml, par l'intermédiaire de la section <multipart-config>. C'est donc
ici que vous allez devoir limiter à 1 Mo la taille maximale d'un fichier envoyé.

De même, vous savez que Tomcat enverra une IllegalStateException en cas de dépassement des limites définies. Vous savez
donc ce qu'il vous reste à faire pour renvoyer un message d'erreur précis à l'utilisateur, en cas d'envoi d'un fichier
trop volumineux ! ;)

******************
Le type du fichier
******************

Il s'agit de l'étape la plus délicate à réaliser. La solution la plus légère consiste à se baser uniquement sur
l'extension du fichier envoyé par l'utilisateur, mais comme vous vous en doutez, ce n'est pas la solution que je vous
demande d'adopter. Souvenez-vous : ne faites jamais confiance à l'utilisateur ! Qui vous dit qu'un d'entre eux ne va pas
envoyer un prétendu fichier image contenant en réalité un exécutable, une archive, un script ou que sais-je encore ?...

Ainsi, vous allez devoir mettre en place un moyen plus efficace pour déterminer le type réel du fichier transmis.
Pas de panique, il existe des bibliothèques qui se chargent de tout cela pour vous ! Je vous conseille ici l'utilisation
de MimeUtil, car c'est probablement celle qui présente le moins de dépendances externes.

Voici les liens de téléchargement des deux jar nécessaires à son bon fonctionnement :

        * MimeUtil

        * SLF4J

Il vous suffit de les déposer tous deux dans le répertoire /WEB-INF/lib de votre projet.

Je vous donne ci-dessous un exemple d'utilisation de la bibliothèque, vérifiant si un fichier est une image :

          -----------------------------------------------------------------------------------------
          // Extraction du type MIME du fichier depuis l'InputStream nommé "contenu"
          MimeUtil.registerMimeDetector( "eu.medsea.mimeutil.detector.MagicMimeMimeDetector" );
          Collection<?> mimeTypes = MimeUtil.getMimeTypes( contenu );

          // Si le fichier est bien une image, alors son en-tête MIME commence par la chaîne "image"
          if ( mimeTypes.toString().startsWith( "image" ) ) {
              // Appeler ici la méthode d'écriture du fichier sur le disque...
          } else {
              // Envoyer ici une exception précisant que le fichier doit être une image...
          }
          -----------------------------------------------------------------------------------------

L'enregistrement du fichier
***************************

Rien de nouveau ici, cela se passe exactement comme nous l'avons fait dans le cours. Vous allez devoir mettre en
place une méthode dédiée à l'écriture du fichier sur le disque, en manipulant proprement les flux (n'oubliez pas
la traditionnelle structure try/catch/finally) et en gérant les différentes erreurs possibles.

Le chemin du fichier
********************

Vous devez, pour terminer, sauvegarder le chemin de l'image dans le bean Client. Il vous faudra donc le modifier
pour y ajouter une propriété de type String que vous pouvez par exemple nommer image.

********************************
Affichage d'un lien vers l'image
********************************

Depuis votre JSP, vous allez devoir récupérer le chemin vers l'image que vous avez placé dans le bean Client, et en
faire un lien vers la servlet de téléchargement que vous allez par la suite mettre en place.

Pour obtenir le rendu affiché dans le paragraphe précédent, il vous suffit d'ajouter au tableau généré par la page
listerClients.jsp une colonne, qui contiendra un lien HTML vers l'image si une image existe, et rien sinon.

Vous pouvez utiliser pour cela une simple condition <c:if>, testant si la propriété image du bean Client est vide
ou non. Si elle n'est pas vide, alors vous afficherez un lien dont l'URL pourra par exemple prendre la forme
/pro/images/nomDuFichier.ext, que vous générerez bien entendu via la balise <c:url>.

***********************
Ré-affichage de l'image
***********************

La dernière étape du TP consiste à créer la servlet de téléchargement des images, qui va se charger de faire la
correspondance entre l'URL que vous avez créée dans votre JSP - celle de la forme /pro/images/nomDuFichier.ext - et
le répertoire du disque local dans lequel sont stockées les images.

Elle va ressembler très fortement à la servlet de download que vous avez mise en place dans le chapitre précédent, à
ceci près qu'elle va cette fois uniquement traiter des images ; vous allez donc pouvoir modifier l'en-tête
"Content-Disposition" de "attachment" vers "inline". Ainsi, le navigateur du client va afficher directement l'image
après un clic sur le lien "Voir" que vous avez mis en place, et ne va plus ouvrir une fenêtre "Enregistrer sous..."
comme c'était le cas avec la servlet de téléchargement de fichiers.

************************************************************************************************************************
                                                 Correction
************************************************************************************************************************

Faites attention à bien modifier tous les fichiers nécessaires au bon fonctionnement du système, vous pouvez relire les
deux précédents chapitres pour vous assurer de ne rien oublier. Comme toujours, ce n'est pas la seule manière de faire,
le principal est que votre solution respecte les consignes que je vous ai données !

Par ailleurs, vous allez probablement devoir adapter cette correction à la configuration de votre poste, car comme vous
le savez, les déclarations des chemins dans le fichier web.xml dépendent en partie des répertoires externes que vous utilisez.

Prenez le temps de réfléchir, de chercher et coder par vous-mêmes. Si besoin, n'hésitez pas à relire le sujet ou à
retourner lire les précédents chapitres. La pratique est très importante, ne vous ruez pas sur la solution !

Le code des objets métiers


                                           creationClientForm.java

                                           creationCommandeForm.java

*************************************
Le code de l'exception personnalisée
*************************************

Optionnelle, cette exception permet de mieux s'y retrouver dans le code des objets métiers, et d'y reconnaître rapidement
les exceptions gérées. L'intérêt principal est on ne peut plus simple : un throw new FormValidationException(...) est
bien plus explicite qu'un banal throw new Exception(...) ! C'est d'autant plus utile que nous allons bientôt faire
intervenir une base de données, et ainsi être amenés à gérer d'autres types d'exceptions. En prenant l'habitude de
spécialiser vos exceptions, vous rendrez votre code bien plus lisible ! :)




--%>

</body>
</html>
