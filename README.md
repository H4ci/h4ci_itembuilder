# h4ci_itembuilder

Aperçu : https://streamable.com/c7vy3i

[INSTALLATION]

1) Importer sql.sql dans votre base de données

2) Ajouter à votre server.cfg juste après votre esx.basicneeds et esx_status :

```
start h4ci_itembuilder
```

[A SAVOIR]

* Si vos items sont sous le système de poid et non de limite, merci de mettre ``weight`` dans la variable ``itemlimite`` du fichier client (ligne 15)


* Pour changer le groupe ayant le droit d'ouvrir le menu, c'est côté client à la ligne 42


* Après l'ajout d'un item, un reboot est nécessaire **(ne sera plus nécessaire au prochain update du script)**
