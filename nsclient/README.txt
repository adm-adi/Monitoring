
1. V�rifier et copier la derni�re version de NSclient dans \NSC-ONLY_INSTALL\NSclient (le lien pour DL les derni�res versions est dans le dossier)

	=> /!\ Ne laisser qu'un seul ex�cutable dans le dossier /!\


2. V�rifier et copier la derni�re version des fichiers NSclient de (TS23) I:\NSclient vers \NSC-ONLY_INSTALL\NSclient\nsclient

	=> Voir avec CPE dans le doute

	=> Dans \NSC-ONLY_INSTALL\NSclient\nsclient il doit y avoir le fichier nsclient.ini et le sous-dossier (et son contenu of course) "scripts" uniquement


3. Copier le r�pertoire "NSC-ONLY_INSTALL" sur la machine distante (peut importe l'emplacement de destination, le script retrouve le path)

4. /!\ Lancer le script en tant qu'admin /!\

5. L'installation de NSclient se fait en mode silent, il y a un shutdown /a apr�s l'install pour tenter d'�viter le reboot sauvage, mais pas garanti...

	=> La machine risque de red�marrer apr�s l'installation de NSclient
	=> Si c'est le cas, il faut ensuite copier manuellement le contenu de \NSclient\nsclient dans 

6. Supprimer les fichiers d'install de la machine distante

7. Done