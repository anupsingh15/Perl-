

##########################################################################

#subroutine to generate the random DNA sequence of given length
sub DNA_sequence
{
print "Enter the length of DNA sequence: ";
chomp($length = <STDIN>);
print "\n";

for($i =1; $i <= $length; $i++)
{
	$c = rand(20);
	if ($c >0 && $c<= 5)
	{
		$dna_seq = $dna_seq.'A';
	}
	elsif ($c >5 && $c<= 10)
	{
		$dna_seq = $dna_seq.'T';
	}
	elsif ($c >10 && $c<= 15)
	{
		$dna_seq = $dna_seq.'G';
	}
	else 
	{
		$dna_seq = $dna_seq.'C';
	}
}

print "Randomly generated DNA sequence: $dna_seq\n";
$dna_seq;
}
##########################################################################
$occurence = 1;
$search_pos = 0;
@gene = ('A', 'T', 'G', 'C');
##########################################################################

#subroutine to calculate the frequencies of patterns in DNA sequence and to calculate their average and standard deviation
sub find_frequency
{
@DNA = @_;
for($i=0; $i<scalar(@gene); $i++)
{
	foreach $dna_seq(@DNA){
	while ($occurence > 0)
	{
		$freq[$occurence-1] = 0;
		while($search_pos <= $length && $search_pos >=0) 
		{		
			$small_string = $gene[$i]x$occurence; #creating patterns
			$pos = index($dna_seq, $small_string, $search_pos); #searching the above given pattern in the DNA sequence
			if($pos != -1)
			{		
				$freq[$occurence-1]++; #if the pattern matches increase counter
				$search_pos = $pos+1;
			}
			else
			{
				$search_pos++; #if pattern not found at the given index search the pattern after that index position
			}
		}
		$k = $occurence-1;
		$occurence++;
		$search_pos = 0;
		if ($freq[$k] == 0) #checking if the given pattern was found or not. if not will try to search the pattern involving different base. 
		{
			$occurence = 0;
		}
		else
		{	
			#print "Frequency of $small_string: $freq[$k]\n"; 
			$a = $freq[$k];
			$data1[$t++] = $a;
			@$small_string = (@$small_string, $a); #storing the frequency of a given pattern across differnt permutations.
			$p1++;
			if ($p1>$p)
				{
					$p = $p1;
				}	
		}	
	}
	$occurence = 1;
	$search_pos = 0;
	$p1 =0;
				}

	@P = (@P, $p);
	$p = 0;
	#print "\n";
}
$l = scalar(@P);
$t = 0;
for ($i = $l - 4; $i<$l; $i++)
{
	$pp[$t++] = $P[$i]; #stores upto what maximum repeation of each base(A,T,G,C) was found across 100 permutations
}	

$std = 0;
$avg = 0;
for($i = 0; $i<scalar(@gene); $i++)
{	
	for($j= 1; $j<=$pp[$i]; $j++)
	{
		$name = $gene[$i]x$j;
		@m = @$name;
		#to calculate avearge of each pattern
		for($k =0; $k<scalar(@m); $k++)
		{
			
			$avg = ($avg + $m[$k]);
	
		}
		$avg = $avg/(scalar(@m));
		#to calculate standard deviation of each pattern
		for($k =0; $k<scalar(@m); $k++)
		{
			$std = (($m[$k]-$avg)*($m[$k]-$avg)) + $std;
		}
		$std = $std/(scalar(@m));
		print "Frequency of $name: @m  Average: $avg  Standard Deviation: $std\n\n\n";
		$avg = 0;
		$std = 0;
	}
	
}

}

###############################################################################

#subroutines to calculate the different permutations of DNA sequence
sub DNA_permutation
{
	srand(time|$$);
	for($i = 0; $i<100; $i++)##################################increase to 100 if you want
	{
		@dna = @_;
		while(scalar(@dna)>0)
		{
			#swapping elements and then popping the last element
			$pos = int(rand(scalar(@dna)));
			$b = $dna[$pos];
			$dna[$pos] = $dna[scalar(@dna)-1];	
			$dna[scalar(@dna)-1] = $b; 
			$t = pop(@dna);
			$dna_seq1 = $dna_seq1.$t;
		}

	@dna_perm[$i] = $dna_seq1;
	$dna_seq1 = "";
	}
@dna_perm;
}
###############################################################################
print "To generate the DNA sequence of given length\n";
print "Output 1\n";
$dna_seq = &DNA_sequence();
&find_frequency($dna_seq);


print "To generate the DNA sequence of given no. of bases\n";
print "Output 2\n";
for($i = 0; $i<scalar(@gene); $i++)
{
	print "Enter frequency of $gene[$i]: ";
	chomp($n[$i] = <STDIN>);
	print "\n";

}

$k = 0;
for($i = 0; $i<scalar(@n); $i++)
{	
	for($j = 0; $j<$n[$i]; $j++)
	{	
		$dna1[$k++] = $gene[$i];
	}	
}


@dna_permutations = &DNA_permutation(@dna1);
@d = &find_frequency(@dna_permutations);

###############################################################################










