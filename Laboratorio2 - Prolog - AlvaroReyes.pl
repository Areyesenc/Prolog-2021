% Main.

% fecha(D,M,Y,F):- Fecha en el formato D/M/Y volviendo a F.
fecha(D,M,Y,F):- F = date(D,M,Y).

% Creacion de la  red social (socialNetwork).
socialNetwork(Name,Date,Sn2):- Sn2  = [Name,Date,[],0].

% registrando a la red Social Network... mediante la obtencion de 1 o mas usuarios.
socialNetworkRegister(Sn,Username,Password,SnN):- getUsers(Sn,Users),checkUser(Sn,Username), append(Users,[[Username,Password,[[],[],0,[],0],[]]],New), updateUsers(Sn,New,SnN).
socialNetworkRegister(Sn,Username,_,Sn):- not(checkUser(Sn,Username)).

% Login a traves de la red social.
socialNetworkLogin(Sn1,Username,Password,Sn2):- getUsers(Sn1,Users),member([Username,Password,_,_],Users),Sn1 = [N,D,_,0] ,Sn2 = [N,D,Users,Username].
socialNetworkLogin(Sn1,Username,Password,Sn1):- getUsers(Sn1,Users),not(member([Username,Password,_,_],Users)).

% Siguiendo un determinado nombre de usuario en el Social Newtork.
socialNetworkFollow(Sn1,Username,Sn2):- Sn1 = [N,D,Users,_],checkUser(Sn1,Username),updateFollowers(Sn1,Username,Users,Final),Sn2 = [N,D,Final,0].

% Publicar cualquier estado, es decir, texto, imagen, video, archivo, etc... a la red social.
socialNetworkPost(Sn1,Date,Post,List,Sn2):- Sn1 = [Name,_,Users,_],updatePost(Sn1,Post,List,Users,Final),Sn2 = [Name,Date,Final,0].

% Convertir los datos en cadena para una mejor comprension y mas conveniente.
socialnetworkTostring(Sn1,String):- get_name(Sn1,Name),get_date(Sn1,date(D,M,Y)),getUsers(Sn1,Users),length(Users,TotalUsers), get_usernames(Users,Usernames), string_join(Usernames,'',UsernamesStr),
    string_join(["Nombre de la red social: -",Name,"\n",'Registro -',D,'/',M,'/',Y,"\n",'Total de usuarios registrados: -',TotalUsers],'',StringA), string_join([StringA,"\n","Nombre de usuario: ",UsernamesStr],'',String).

% Agregar un comentario al post
comment(Sn1,Date,PostId,CommentId,Comment,Sn2):- Sn1 = [Name,_,Users,L],updateComment(Sn1,Comment,PostId,_,Users,Final),Sn2 = [Name,Date,Final,L], write('comentario en la publicacion con Id '),write(CommentId).

% Like por una publicacion o un comentario en la red social (social network)
socialNetworkLike(Sn1,Date,PostId,CommentId,Sn2):- Sn1 = [Name,_,Users,L],updatelike(Sn1,PostId,Users,Final),Sn2 = [Name,Date,Final,L], write('Like al Post con Id '),write(CommentId).

% Compartir un mensaje con un ID de usuario determinado.
socialNetworkShare(Sn1,Date,PostId,List,Sn2):-  Sn1 = [Name,_,Users,L],updateShare(Sn1,PostId,Users,Final),Sn2 = [Name,Date,Final,L],
    length(List,X),X >= 1,write('el post con id '),write(PostId),write(' es compartido con: '),write(List).

socialNetworkShare(Sn1,Date,PostId,[],Sn2):-  loggedin(Sn1,User),Sn1 = [Name,_,Users,L],updateShare(Sn1,PostId,Users,Final),Sn2 = [Name,Date,Final,L],
   write('el post con id '),write(PostId),write(' es compartido con: '),write(User).



% selectores

% getUsers, predicado proporciona el detalle de todos los usuarios de la Red Social
getUsers(Sn,Users):- Sn = [_,_,Users,_].

% Este predicdao comprueba que no hay dos nombres de usuario iguales
checkUser(Sn,User):- getUsers(Sn,Users),not(member([User,_,_,_],Users)).

% Este predicado proporciona el nombre de usuario del usuario que se ha conectado recientemente.
loggedin(Sn1,Username):- Sn1 = [_,_,_,Username].

% Este predicado proporciona el nombre de la red social
get_name(Sn,X):- Sn = [X,_,_,_].

% Este predicado proporciona La fecha de creacion de la Red Social.
get_date(Sn,X):- Sn = [_,X,_,_].

% Este predicado proporciona una lista de todos los nombres de usuario registrados en la red social
get_usernames([],[]).
get_usernames(Users,[Username|ResT]):- Users = [H|T], get_usernames(T,ResT),H = [Username,_,_,_].

% Este predicado proporciona informacion sobre el post del Id entregado.
getPost([],_,[]).
getPost(Users,PostId,Post):- Users = [H|_],H = [_,_,Post1,_],Post1 = [Post,PostId,_,_].
getPost(Users,PostId,Post):- Users = [H|T],getPost(T,PostId,Post),H = [_,_,Post1,_],not(Post1 = [Post,PostId,_,_]).

% Esta es un predicado de ayuda para la funcion getPost(), que proporciona los detalles de la publicacion utilizando el PostId.
getPostbyPostId(Sn1,Post,PostId):- getUsers(Sn1,Users),getPost(Users,PostId,Post).



% Modificadores

% Se utiliza para actualizar los usuarios de la Red Social.
updateUsers(Sn,New,SnN):- Sn = [N,D,_,L], SnN = [N,D,New,L].

% Actualiza la informacion de los seguidores del username dado.
updateFollowers(Sn1,Username,Users,Final):- loggedin(Sn1,User),Users = [H|_],H = [H1,Pass,Post,Exist],User = H1,append([Username],Exist,New),select([User,Pass,Post,Exist],Users,Users3),append([[User,Pass,Post,New]],Users3,New2),Final = New2.
updateFollowers(Sn1,Username,Users,Final):- loggedin(Sn1,User),Users = [H|T],H = [H1,_,_,_],not(User = H1),updateFollowers(Sn1,Username,T,Final).
updateFollowers(Sn1,Username,_,_):- loggedin(Sn1,User),User = Username,fail.

% Este predicado ayuda a enviar una publicacion a los nombres de usuario deseados o a la lista de contactos del usuario.
updatePost(Sn1,Text,Follow,Users,Final):- loggedin(Sn1,User),Users = [H|_],H = [H1,Pass,[Exist,[],0,[],0],Follow],User = H1,append([Text],Exist,New),select([User,Pass,[Exist,[],0,[],0],_],Users,Users3),length(Exist,Len),Len1 is Len+1,string_concat(User,Len1,Nex),append([[User,Pass,[New,Nex,0,[],0],Follow]],Users3,New2),Final = New2.
updatePost(Sn1,Text,Follow,Users,Final):- loggedin(Sn1,User),Users = [H|T],H = [H1,_,_,_],not(User = H1),updatePost(Sn1,Text,Follow,T,Final).

% Predicado que ayuda a a?dir y actualizar los comentarios de un post en particular.
updateComment(Sn1,Comment1,PostId,_,Users,Final):- loggedin(Sn1,User),Users = [H|_],H = [H1,Pass,[Post,PostId,_,Exist,Share],Follow],string_concat(User,' - ',X),string_concat(X,Comment1,Comment),append([Comment],Exist,New),select([H1,Pass,[Post,PostId,0,[],Share],Follow],Users,Users3),append([H1,Pass,[Post,PostId,0,New,Share],Follow],Users3,New2),Final = New2.
updateComment(Sn1,Comment,PostId,_,Users,Final):- loggedin(Sn1,_),Users = [H|T],not(H = [_,_,[_,PostId1,_,_,_],_]),not(PostId = PostId1),updateComment(Sn1,Comment,PostId,_,T,Final).

% Ayuda a que te guste un psot o un comentario.
updatelike(Sn1,PostId,Users,Final):- loggedin(Sn1,_),Users = [H|_],H = [H1,Pass,[Post,PostId,Exist,Comment,Share],Follow],Exist1 is Exist + 1,select([H1,Pass,[Post,PostId,Exist,Comment,Share],Follow],Users,Users3),append([H1,Pass,[Post,PostId,Exist1,Comment,Share],Follow],Users3,New2),Final = New2.
updatelike(Sn1,PostId,Users,Final):- loggedin(Sn1,_),Users = [H|_],not(H = [_,_,[_,PostId,_,_,_],_]),updatelike(Sn1,PostId,Users,Final).

% predicado que ayuda a compartir una publicacion con los usuarios deseados.
updateShare(Sn1,_,Users,Final):- loggedin(Sn1,_),Users = [H|_],H = [H1,Pass,[Post,_,Likes,Comment,Exist],Follow],Exist1 is Exist + 1,select([H1,Pass,[Post,_,Likes,Comment,Exist],Follow],Users,Users3),append([H1,Pass,[Post,_,Likes,Comment,Exist1],Follow],Users3,New2),Final = New2.
updateShare(Sn1,_,Users,Final):- loggedin(Sn1,_),Users = [H|T],not(H = [_,_,[_,_,_,_,_],_]),updateShare(Sn1,_,T,Final).

% Ayuda en base a predicados construidos... 

% Este predicado es una funcion de ayuda para SocialNetworkTostring y ayuda a crear una cadena a partir de una lista.
string_join([],Return,Final):- Final = Return.
string_join(List,X,Final):- List = [H|T], string_concat(X,' ',X1),string_concat(X1,H,X2),string_join(T,X2,Final).