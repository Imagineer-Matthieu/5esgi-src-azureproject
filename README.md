# Projet Azure avec Terraform

Ce projet utilise Terraform pour déployer une infrastructure Azure qui comprend un groupe de ressources, un compte de stockage avec des conteneurs de blob, ainsi que des applications web Linux configurées pour afficher des fichiers statiques à partir du stockage de blobs.

## Description du Projet

Ce projet vise à déployer une solution cloud sur Microsoft Azure, en utilisant Terraform pour automatiser la configuration et le déploiement des ressources nécessaires. Voici un aperçu des principales composantes :

- **Resource Group (Groupe de ressources)** : Un groupe de ressources Azure dans lequel toutes les ressources sont déployées.
  
- **Azure Storage Account (Compte de stockage Azure)** : Un compte de stockage pour héberger des fichiers statiques, comme des pages HTML et des images.
  
- **Blob Containers (Conteneurs de blobs)** : Des conteneurs de stockage blobs pour organiser et sécuriser les fichiers, avec un conteneur spécifique (`staticfiles`) pour les fichiers statiques à rendre publics.

- **Azure App Service Plan et Web Apps** : Deux applications web Linux configurées pour servir des fichiers statiques à partir du compte de stockage blob.

## Structure du Projet

Le projet est structuré de la manière suivante :

- **main.tf** : Ce fichier contient la définition des ressources Azure à déployer, y compris le groupe de ressources, le compte de stockage, les conteneurs de blob et les applications web.

- **variables.tf** : Ce fichier contient les définitions des variables utilisées dans le projet, comme les noms de ressources et les paramètres de configuration.

- **provider.tf** : Ce fichier spécifie le fournisseur Terraform (Azure) et sa configuration.

- **outputs.tf** : Ce fichier définit les sorties Terraform à afficher après le déploiement, comme les noms des groupes de ressources et les URL des applications web.

## Prérequis

Avant de commencer, assurez-vous que les éléments suivants sont en place :

- **Terraform installé** : Installez Terraform en suivant les instructions officielles [ici](https://learn.hashicorp.com/tutorials/terraform/install-cli).

- **Compte Azure actif** : Assurez-vous d'avoir un compte Azure actif avec les droits nécessaires pour créer des ressources.

## Comment Utiliser

1. **Clonage du Projet**

   ```bash
   git clone https://github.com/votre-utilisateur/projet-azure-terraform.git
   cd projet-azure-terraform
   ```

2. **Initialisation de Terraform**

   Initialisez Terraform pour installer le fournisseur Azure et ses dépendances :
   ```bash
   terraform init
   ```

3. **Configuration des Variables**

   Modifiez si nécessaire les valeurs par défaut des variables dans variables.tf pour correspondre à votre environnement Azure.

4. **Validation du Plan d'Exécution**

   Générez et examinez le plan d'exécution Terraform pour vous assurer que les ressources seront déployées comme prévu :
   ```bash
   terraform plan
   ```

5. **Déploiement des Ressources**

   Appliquez le plan d'exécution pour déployer les ressources sur Azure :
   ```bash
   terraform apply
   ```

6. **Vérification des Sorties**

   Après le déploiement, Terraform affichera les sorties définies dans outputs.tf. Vérifiez ces sorties pour obtenir les informations nécessaires comme les noms des ressources et les URLs des applications web.

7. **Nettoyage des Ressources (Optionnel)**

   Une fois que vous avez terminé avec le projet, vous pouvez supprimer toutes les ressources déployées en utilisant Terraform :
   ```bash
   terraform destroy
   ```

## Contribution

Les contributions sous forme de pull requests sont les bienvenues. Pour des changements majeurs, veuillez ouvrir une issue pour discuter de ce que vous aimeriez modifier.