using Dendriform
using Base.Test
import Dendriform: GroveError, TreeInteger, TreeRational, TreeBase, TreeLoday

d = 5
@test promote_rule(PBTree,Array{UInt8,1}) == PBTree && promote_rule(Grove,PBTree) == Grove
@test promote(Grove(3,7),promote(PBTree(2,2),[1,2,3])...) |> typeof <: Tuple
@test convert(Grove,Any[1,2,3]) == convert(Grove,Any[1 2 3])
@test treecheck(3,treeindex([1,2,3])) && grovecheck([1,2,3])
@test sum(GroveError(d)) == 0 == sum(GroveError(Grove(d))) == sum(GroveError(Grove(d).Y))
@test treecheck([1,2,3]) == treecheck(PBTree([1,2,3])) == treecheck(Grove(3)) ==
  treecheck(Grove(3).Y) == PBTree(3,5) |> treecheck
@test treeindexCn(d) == [i//Cn(d) for i ∈ 1:Cn(d)] == treeindex(Grove(d).Y)//Cn(d)
@test σ(σ(Grove(3,7))) == Grove(3,7)
@test ((a,b)=([1:5...],Grove(5,5)); ∪(a,b) == ∪(b,a) == ∪(b.Y,a) == ∪(b.Y) == ∪(b))
@test graft([1,2,3],[2,1]) == graft([1,2],[3,2,1]) |> σ
@test under([1,2,3],[3,2,1]) == σ(over([1,2,3],[3,2,1]))
@test Dendriform.PrimitiveTree([1,2,3]) && Dendriform.PrimitiveTree([3,2,1])
@test leftbranch([1,4,2,1]) == rightbranch([1,2,4,1])
@test Dendriform.LeftInherited([1,2,3]) == Dendriform.RightInherited([3,2,1])
@test [1,2,3] |> grovesort! == [1,2,3] |> Grove
@test Grove(d) |> grovesort! == Grove(d) == Grove(d,2^Cn(d)-1)
@test Grove(d) == d |> TreeBase |> TreeLoday
@test (k = Grove(d) |> TreeBase |> TreeLoday; k == k |> TreeBase |> TreeLoday)
@test [TreeBase([1:d...])] == TreeBase(d,1)
@test Grove(d) |> TreeBase |> TreeInteger == Grove(d) |> TreeInteger
@test (grovesort(false); TreeLoday(d,treeindex(Grove(d))) == Grove(d))
@test (grovesort(false); Grove(d)) == (grovesort(true); Grove(d))
@test Grove(d,groveindex(Grove(d).Y)) == TreeLoday(d)
@test GroveBin([1,4,2,1]) |> Grove |> grovebit |> Grove |> grovecheck
@test TreeLoday(d,grovebit(GroveBin(Grove(d)))) == Grove(d) |> GroveBin |> Grove
@test Grove(d) |> groveindex == 2^Cn(d)-1 == Grove(d) |> grovebit |> groveindex
@test TreeRational(d) == TreeRational(Grove(d))
@test TreeRational(d,BigInt(d)) == Grove(d,d) |> TreeRational
@test (treeshift(false); TreeRational(d,grovebit(Grove(d))) == TreeRational(Grove(d)))
@test (treeshift(true); TreeRational(d,grovebit(Grove(d).Y)) == TreeRational(Grove(d)))
@test TreeInteger(d,d)==TreeInteger(d,grovebit(d,d))==TreeInteger(d,treeindex(Grove(d,d)))
@test (j = ([1,2]⊣[1,2])+[1,2,3]; TreeLoday(7,groveindex(j)) == j)
@test (j = [1,2,3]+([1,2]⊢[1,2]); TreeLoday(7,groveindex(j)) == j)
@test (Grove([1,2,3])⊣PBTree([1,3,1])) == (PBTree([1,2,3])⊣Grove([1,3,1])) ==
  (Grove([1,2,3])⊣Grove([1,3,1])) == ((Grove([1,2,3]).Y)⊣(PBTree([1,3,1]).Y))
@test (Grove([1,2,3])⊢PBTree([1,3,1])) == (PBTree([1,2,3])⊢Grove([1,3,1])) ==
  (Grove([1,2,3])⊢Grove([1,3,1])) == ((Grove([1,2,3]).Y)⊢(PBTree([1,3,1]).Y))
@test (GroveBin(Grove(d))⊣Grove(d)) == (Grove(d)⊣GroveBin(Grove(d)))
@test (GroveBin(Grove(d))⊢Grove(d)) == (Grove(d)⊢GroveBin(Grove(d)))
@test leftsum(Grove(d-1),Grove(d-1)).degr == rightsum(Grove(d-1),Grove(d-1)).degr
@test Grove(8,groveindex(Grove(5,1000)+Grove(3,7)))==Grove(5,1000)+Grove(3,7)
@test (x = PBTree(1,1); GroveBin(x)*x == x*GroveBin(x) == [1]*GroveBin(x) == 1*x
  == 1*GroveBin(x) == GroveBin(x)*Grove(x))
@test grovecomposition(3,groveindex(3)) == 4
@test println(Grove(3,7)) == print(TreeBase([1:d...]))
@test TreeBase(d,1) |> print == println([Grove(d,1)])
@test display(Grove(d,1)) == display(GroveBin(Grove(d,1))); print('\n')
@test ((x,y)=(Grove(3,7),Grove(2,1)); σ(x+y)==σ(y)+σ(x) && σ(x*y)==σ(x)*σ(y))
@test ((x,y)=(PBTree(3,4),PBTree(4,7)); σ(x∨y)==σ(y)∨σ(x)
  && σ(↗(x,y))==↖(σ(y),σ(x)) && σ(↖(x,y))==↗(σ(y),σ(x)))
@test PBTree(d,1)<PBTree(d,d) && PBTree(d,d)>PBTree(d,1)
@test PBTree(d,1)≤PBTree(d,d) && PBTree(d,d)≥PBTree(d,1)
@test Grove(d,1)<Grove(d,d) && Grove(d,d)>Grove(d,1)
@test Grove(d,1)≤Grove(d,d) && Grove(d,d)≥Grove(d,1)
