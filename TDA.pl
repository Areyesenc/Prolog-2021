fecha(D,M,Y,F):- F = date(D,M,Y).

socialNetwork(Name,Date,Sn2):- Sn2  = [Name,Date,[],0].

socialNetworkRegister(Sn,Date,Username,Password,SnN):- getUsers(Sn,Users), append(Users,[[Date,Username,Password,[]]],New), updateUsers(Sn,New,SnN).   
socialNetworkRegister(Sn,Username,_,Sn):- not(checkUser(Sn,Username)).   


getUsers(Sn,Users):- Sn = [_,_,Users,_].

checkUser(Sn,User):- getUsers(Sn,Users),not(member([User,_,_,_],Users)).

updateUsers(Sn,New,SnN):- Sn = [N,D,_,L], SnN = [N,D,New,L].

socialNetworkLogin(Sn1,Username,Password,Sn2):- getUsers(Sn1,Users),member([_,Username,Password,_],Users),Sn3 = [_,_,Users,1],updateUsers(Sn1,Sn3,Sn2).
socialNetworkLogin(Sn1,Username,Password,Sn1):- getUsers(Sn1,Users),not(member([Username,Password,_,_],Users)).

loggedin(Sn1,Username):- Sn1 = [_,_,_,Username].
