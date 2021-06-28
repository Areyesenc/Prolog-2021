%funciones

fecha(D,M,Y,F):- F = date(D,M,Y).

socialNetwork(Name,Date,Sn2):- Sn2  = [Name,Date,[],0].

socialNetworkRegister(Sn,Date,Username,Password,SnN):- getUsers(Sn,Users), append(Users,[[Date,Username,Password,[]]],New), updateUsers(Sn,New,SnN).   
socialNetworkRegister(Sn,Username,_,Sn):- not(checkUser(Sn,Username)).   

socialNetworkLogin(Sn1,Username,Password,Sn2):- getUsers(Sn1,Users),member([_,Username,Password,_],Users),Sn3 = [_,_,Users,1],updateUsers(Sn1,Sn3,Sn2).
socialNetworkLogin(Sn1,Username,Password,Sn1):- getUsers(Sn1,Users),not(member([Username,Password,_,_],Users)).

socialNetworkFollow(Sn1,Username,Sn2):- Sn1 = [N,D,Users,_],checkUser(Sn1,Username),updateFollowers(Sn1,Username,Users,Final),Sn2 = [N,D,Final,0].
socialNetworkPost(Sn1,Date,Post,List,Sn2):- Sn1 = [Name,_,Users,_],updatePost(Sn1,Post,List,Users,Final),Sn2 = [Name,Date,Final,0].
socialnetworkTostring(Sn1,String):- get_name(Sn1,Name),get_date(Sn1,date(D,M,Y)),getUsers(Sn1,Users),length(Users,TotalUsers), get_usernames(Users,Usernames), string_join(Usernames,'',UsernamesStr),
    string_join(["Nombre red social -",Name,"\n",'Registro -',D,'/',M,'/',Y,"\n",'Total de usuarios registrados -',TotalUsers],'',StringA), string_join([StringA,"\n","Nombre de usuario = ",UsernamesStr],'',String).

comment(Sn1,Date,PostId,CommentId,Comment,Sn2):- Sn1 = [Name,_,Users,L],updateComment(Sn1,Comment,PostId,_,Users,Final),Sn2 = [Name,Date,Final,L], write('This is a comment on the Publication With Id '),write(CommentId).

socialNetworkLike(Sn1,Date,PostId,CommentId,Sn2):- Sn1 = [Name,_,Users,L],updatelike(Sn1,PostId,Users,Final),Sn2 = [Name,Date,Final,L], write('This is a like to the Post With Id '),write(CommentId).

%selectores

getUsers(Sn,Users):- Sn = [_,_,Users,_].

checkUser(Sn,User):- getUsers(Sn,Users),not(member([User,_,_,_],Users)).

loggedin(Sn1,Username):- Sn1 = [_,_,_,Username].

get_name(Sn,X):- Sn = [X,_,_,_].

get_date(Sn,X):- Sn = [_,X,_,_].

get_usernames([],[]).
get_usernames(Users,[Username|ResT]):- Users = [H|T], get_usernames(T,ResT),H = [Username,_,_,_].

%Modificadores

updateUsers(Sn,New,SnN):- Sn = [N,D,_,L], SnN = [N,D,New,L].

updateFollowers(Sn1,Username,Users,Final):- loggedin(Sn1,User).
