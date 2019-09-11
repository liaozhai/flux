import sequtils, algorithm, strformat, tables, macros

type User = tuple
    id: int
    name: string
    friends: seq[int]
    interests: seq[string]

proc toUsers(names: seq[string]): seq[User] =
    result = @[]
    for i,n in names:
        result.add (i, n, @[], @[])

proc addFriends(users: var seq[User], links: seq[(int,int)]) =    
    for (i, j) in links:    
        users[i].friends.add j
        users[j].friends.add i

let interests = {
        "Data science": @[0,1,2],
        "Programming": @[3,4],
        "Machine Learning": @[2,3],
        "Nim": @[1,2,3],
        "Astrophysics": @[0,4]
    }.toTable

proc addInterests(users: var seq[User], interests: Table[string, seq[int]]) =
    for k in interests.keys:
        for i in interests[k]:
            users[i].interests.add k

var users = @["Alice", "Dunn", "Spike", "Thor", "Neo"].toUsers
users.addFriends @[(0,1), (2,1), (3,0), (4,0)]
users.addInterests interests

proc withSimilarInterests(user: User): CountTable[int] =
    var t: seq[int] = @[]
    for k in user.interests:
        for i in interests[k]:
            if i != user.id:
                t.add i
    return t.toCountTable

echo "Users:"
echo users

let u = users[0]

echo(fmt"Users with interests like those of {u.name}:")

for (k,v) in u.withSimilarInterests.pairs:
    echo(fmt"{users[k].name}({v})")

macro display(arg: untyped): untyped =
    echo typeof(arg)

display 10