
open(FH,"data_ass6.txt");
open(FH1,">output.txt");
@lines = <FH>;
%P = ();
%S = ();

#creating hashes S and P 
foreach $line(@lines)
{
	@data = split(' ', $line);	
	push(@{$P{$data[0]}}, $data[1]);
	push(@{$S{$data[1]}}, $data[0]);	
} 

#to create a S-S graph
sub S_S
{
	@s = keys %S;
	foreach $j(sort(@s))
	{	
		@t = ();
		#stores all papers for which scientist is common
		foreach $k (@{$S{$j}})
		{
			@t = (@t,@{$P{$k}});	
		}
		#creating hash in which keys are the scientist  
		foreach $l(@t)
		{
			$h{$l} = "as";
		}
		#sorting keys
		@tt = sort(@tt = keys %h);
		%h =();
	
		#printing desired results in output file
		foreach $y(@tt)
		{
			if(!($j eq $y))
			{
				print FH1 "$j $y\n";
			}
		}
	}
}

# to create P-P graph
sub P_P
{
	@p = keys %P;
	foreach $j(sort(@p))
	{
		@t = ();
		#stores all scientist for which papers is common
		foreach $k (@{$P{$j}})
		{
			@t = (@t,@{$S{$k}});	
		}
		#creating hash in which keys are the papers
		foreach $l(@t)
		{
			$h{$l} = "as";
		}
		#sorting keys	
		@tt = sort(@tt = keys %h);
		%h =();

		#printing desired results in output file
		foreach $y(@tt)
		{
			if(!($j eq $y))
			{
				print FH1 "$j $y\n";
			}
		}
	}	
}




#calling suroutines
print FH1 "S-S Graph\n\n"; 
&S_S;
print FH1 "\nP-P Graph\n\n"; 
&P_P;

close FH;
close FH1;

