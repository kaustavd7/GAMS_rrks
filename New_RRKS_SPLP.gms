set i 'facility'/1*5/;
set k 'slot'/1*5/;

alias(i,j);

alias(k,l);

table
     D(k,l) Distance between slots k and l
                1     2     3     4    5
        1       0     22   43    66    34
        2       21    0    98    32    77
        3       43    98    0    22    22
        4       33    78    66   0     44
        5       11    22    33   44     0
;
table
     F(i,j) flow between facility i and i
                1        2      3        4      5
        1       0       10      4        6      7
        2       5       0      100       8      8
        3       7       2       0        9      9
        4       9       4       6        0      10
        5       13      9       8        12     0
;


positive variable X(i,k) '1 if facility i is on slot k and 0 otherwise' ;
binary variable Y(i,k) 'bin var1' ;
free variable w;

equations
objfn       objective function

condition_1(i)
condition_2(k)
condition_3_upper(i,k)
condition_4_lower(i,k)
;

objfn.. sum((i,j,k,l), X(i,k)*X(j,l)*F(i,j)*D(k,l)) =e= w ;

condition_1(i).. sum((k), X(i,k)) =e= 1 ;
condition_2(k).. sum((i), X(i,k)) =e= 1 ;
condition_3_upper(i,k).. X(i,k) + 20*(1 - Y(i,k)) =g= 1 ;
condition_4_lower(i,k).. X(i,k) - 20*Y(i,k) =l= 0 ;

Model Problem /all/;

problem.nodlim = 1e9;
$onecho > sbb.opt
memnodes 1e6
$offecho
problem.optfile = 1;
option minlp = sbb;

Solve Problem using miqcp minimising w ;

Display w.l ;
