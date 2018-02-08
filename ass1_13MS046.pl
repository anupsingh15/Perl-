#! usr/bin/perl

print "Enter an integer: ";
chomp($n = <STDIN>); #user input 

# creating the upper half of diamond
$a = $n;
$t = (" "x($a-1)).$a;
print "$t\n";

for($i = $n-1; $i>=1; $i--)
{
	$t = " "x($i-1);
	$s = $i.$a.$i; #each time, concatenating the integer at both ends 
	$a = $s;
	print $t.$s."\n"; #prints the string along with the spaces required
}

#creating the lower half of diamond
for($i = 2; $i<=$n; $i++)
{	
	$t = " "x($i-1); #printing spaces required
	print "$t";
	for($j = $i; $j <= $n; $j++)
	{
		print "$j"; #prints integer in ascending order
  	}
	for($k = $n-1; $k>=$i; $k--)
	{
		print "$k"; #prints integer in descending order
	}
	print "\n";
}








