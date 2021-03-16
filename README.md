# GoStyle
![](https://i.imgur.com/dwZXqcW.png)

[TOC]


---

## Technologies utilisées
### PHP 
![](https://i.imgur.com/z4ROYIj.png =100x)
> PHP est un langage serveur qui est fréquemment utilisé en web, il permet de faire la liaison entre notre code et notre BDD afin d'effectuer des requêtes quelconques.
> Nous avons utilisé PHP avec les variables get qui communiquent avec mysql pour le back-end et qui renvoient une information en json, nous l'avons ensuite utilisée en service d'API 

###### tags: backend,server




### MySql

![](https://i.imgur.com/gOnkRcY.png =100x)

> Moteur de BDD très utilisé en web,
> il stocke toutes les données relatives aux QR codes et aux utilisateurs
> voici les modèles de nos tables de données : 

#### scan_user
| id  |    email     |   password   |  admin  |
|:---:|:------------:|:------------:|:-------:|
| int | varchar(255) | varchar(255) | booleen |

#### scan_qr


| id  | value |    promo     |  desc_promo  |
|:---:|:-----:|:------------:|:------------:|
| int | Text  | varchar(255) | varchar(255) |

#### scan_email



| id  |    email     | qr_id |
| --- |:------------:|:-----:|
| int | varchar(255) |  int  |

###### tags: backend,database technologies

### flutter 
![](https://i.imgur.com/hLOGdpc.png =100x)
> Flutter est un Framework qui permet de faire des applications natives sur android, ios, web et desktop 
> il a été lancé par google en 2017 c'est le plus grand concurrent de React native créé par Facebook


### Github
![](https://i.imgur.com/KLA8kRU.png =100x)

>Github est un outil de gestion et de collaboration entre developpeurs
>il est connu pour son aspect open-source.
>Il utilise un outil appelé git pour pouvoir publier son code sur la plateforme.
>Cette plateforme a été rachetée par microsoft en 2018.

[le lien github du projet](https://github.com/polo5922/GoStyle)

###### tags: open-source,code gestion,version gestion,GIT


---

## Les avancements du projet
- [x] Connexion/Inscription
- [x] Liste des codes scannés
- [x] Suppression des codes utilisés
- [x] Ajout de code grâce à un QR code
- [ ] Espace d'admin
- [ ] Gestion des utilisateurs
- [ ] Ajout de QR code


---


## Les fonctionalités
### Connexion/Inscription
#### package utilisé
* [http](https://pub.dev/packages/http)
#### Explication
> Pour notre système de connexion et d'inscription nous avons un formulaire qui sert à nous connecter ou à nous sinscrire
> Nos données sont envoyées à 2 pages ".dart" différentes par rapport au bouton sélectionné par l'utilisateur  
> L'envoi des données permet ma page d'effectuer une requête de connexion ou d'inscription qui vérifie si l'utilisateur existe ou son adresse mail n'a pas déjà été utilisée,
> si jamais l'adresse n'est pas enregistrée dans la BDD l'utilisateur est redirigé à la page d'inscription et de connexion.
#### Code
##### front-end

> Exemple d'entrée de formulaire
``` dart
TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Entrez votre email',
                ),
                validator: (value) { //mon validator me permet de rendre le champs valide si jamais il est vide ou alors il ne contient pas de "@" je retourne false
                  if (value.isEmpty) {
                    return 'Ne pas rentrer de valeur vide';
                  }
                  if (value.contains('@') == false) {
                    return 'Entrez un email valide';
                  }
                  return null;
                },
                controller: myControllerEmail, // mon controller me permet de recupere son contenu
              ),
```
> Chaque TextFormField a son propre controller pour récupérer écrite par l'utilisateur

> Exemple de bouton 
``` dart
ElevatedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {  // si mon formulaire est validée je change de page avec les donnée d'email et de mdp
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(
                                  email: myControllerEmail.text,
                                  password: myControllerPassword.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Connexion'),
                      ),
```
> Ce bouton redirige vers la page de gestion de connexion avec en paramètre l'email et le mot de passe
##### back-end
> login
``` php
if ($type == "login") {
        if (isset($_GET['email'])) {
            $email = $_GET['email'];
            if (isset($_GET['password'])) {
                $password = $_GET['password'];
                $hpass = sha1(md5($password));
                $sql = "SELECT * FROM scan_user WHERE email='$email' AND password='$hpass'";
                $result = $conn->query($sql);
                if ($result->num_rows > 0) {
                    echo "good:login";
                } else {
                    echo "bad:login";
                }
            }
        }
    }
```

>register
``` php
if ($type == "register") {
        if (isset($_GET['email'])) {
            $email = $_GET['email'];
            if (isset($_GET['password'])) {
                $password = $_GET['password'];
                $hpass = sha1(md5($password));
                $sql2 = "SELECT * FROM scan_user WHERE email='$email'";
                $result2 = $conn->query($sql2);
                if ($result2->num_rows == 0) {
                    $sql = "INSERT INTO scan_user (email,password) VALUES ('$email','$hpass')";
                    if ($conn->query($sql)) {
                        echo "good:register";
                    } else {
                        echo "bad:register";
                    }
                } else {
                    echo "bad:register:email_used";
                }
            }
        }
    }
```

#### Screens
> Page de connexion 
![](https://i.imgur.com/l8NrB7W.jpg =300x)

> Si la connexion est mauvaise
![](https://i.imgur.com/wbVFZpK.jpg =300x)

> Si la connexion est bonne
![](https://i.imgur.com/PloaHUZ.jpg =300x)

> Si le mail est déjà utilisé
![](https://i.imgur.com/GYVoC7N.jpg =300x)



### Liste des codes scannés
#### Package utilisé
* [http](https://pub.dev/packages/http)
#### Explication
>Afin de visualiser la liste des promotions scanées par l'utilisateur, une requête de récupération des "ID" liés à l'adresse mail de l'utilisateur a été éffectuée  
>Grâce à l'ID de la promotion qui vient d'être récupéré nous pouvons donc en déterminer les informations telles que la description et le code promo  
#### Code
> Récupération de l'ensemble des ID
``` dart
Future<Ids> fetchIds(email, type) async {
  var queryParameters = {
    'type': type,
    'email': email,
  };
  String url = 'tartapain.bzh';
  // je paramettre l'url de requette avec les variable get 
  var uri = Uri.https(url, '/api/scan/get.php', queryParameters);
  final response = await http.get(uri);

  if (response.statusCode == 200) { // je verifie si ma requete n'a pas eu de probleme
  // alors j'envois dans ma fonction de decodage de json le resultat
    return Ids.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load the post');
  }
}

class Ids {
  final List<dynamic> ids;
  final int lenght;

  //je crée 1 objet qui a 2 variable les IDS et la lenght qui est relative au nombre d'élement
  Ids({
    this.ids,
    this.lenght,
  });

  factory Ids.fromJson(Map<String, dynamic> json) {
    return Ids( // je retourne les differents élement grace au contenu du json
      ids: json['ids'],
      lenght: json['lenght'],
    );
  }
}
```

> Génération des différents éléments de la liste
``` dart
FutureBuilder(
              initialData: [],
              future: futureIds,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading...")); //Affiche un texte "loading" en attente de la recuperation de tout les elements
                }
                if (snapshot.hasData) { // je verifie si ma reponse a du contenus
                  if (snapshot.data.lenght == 0) { // si jamais je n'ai pas d'élement alors j'affiche un texte "pas de QR Code scanée"
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius: new BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Pas de QR Code scanné",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        children: [ // si l'ont recupere des donnée alors je les recupere tous un par un et je genere mon widget custom CardDisplay avec comme parametre l'id de la promotion scannée
                        //ainsi que le mail de la personne connecter pour ne pas perdre son identifiactions
                          for (var i = 0; i < snapshot.data.lenght; i++)
                            CardDisplay(
                              id: snapshot.data.ids[i],
                              email: widget.email,
                            ),
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                // j'affiche les erreur si il y en a
                  return Text('${snapshot.error}');
                } else {
                  return CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black));
                }
              },
            ),
```
#### Screens
![](https://i.imgur.com/0W8cEqO.jpg =300x)

### Suppression des codes utilisés
#### Package utilisé
* [http](https://pub.dev/packages/http)
* [flutter_slidable](https://pub.dev/packages/flutter_slidable)
#### Explication
>Nous avons utilisé le package "flutter_slidable" pour nous permettre de rajouter des boutons d'action par effet de glissement (ce bouton ne peut apparaître que si l'utilisateur glisse la liste vers la droite). 
>Ce bouton est généré en même temps que les éléments de la liste pour pouvoir être lié à l'ID de cet élément.
#### Code

#### Screens
> Bouton de suppression
> ![](https://i.imgur.com/mnYIozp.jpg =300x)

> Confirmation de la suppression
> ![](https://i.imgur.com/JiWr2WN.jpg =300x)


### Ajout de code grâce à un QR code
#### Package utilisée
* [http](https://pub.dev/packages/http)
* [flutter_barcode_scanner](https://pub.dev/packages/flutter_barcode_scanner)

#### Explication
> Nous avons utilisé le package "flutter_barcode_scanner" pour pouvoir simplifier le scan de QR code en quelques fonctions.
> Nous récupérons ensuite la valeur du QR code scanné afin de vérifier si l'utilisateur a déjà lié ce code à son compte, si ce n'est pas le cas, nous pouvons l'enregistrer dans la BDD
> > Si cet utilisateur a déjà scanné ce QR code alors il aura un message d'erreur lui indiquant qu'il l'a déjà scanné.
#### Code
#### Screens

> Ajout du QR code
> ![](https://i.imgur.com/S2E3cZ8.jpg =300x)

> QR code déjà scanné
>![](https://i.imgur.com/XiOWSwc.jpg =300x)



### Espace d'admin 
#### Explication
#### Code
#### Screens
### Gestion des utilisateurs
#### Explication
#### Code
#### Screen
### Ajout de QR code
####
####
####