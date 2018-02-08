
print "Enter input file name: ";
chomp($file = <STDIN>);
open(FH,$file);
chomp(@lines = <FH>);
print "Enter Element name: ";
chomp($element = <STDIN>);
open(FH1,">output.txt");

foreach $i(@lines)
{	#extracting lines which contains the given user input element
	if($i =~ /\w+\s+\d+\s+$element\s+\w+\s+[A-Z]\s*\d+\s+-?[0-9.]+\s+-?[0-9.]+\s+-?[0-9.]+\s+-?[0-9.]+\s+-?[0-9.]+\s+[A-Z]/)
	{	#extracting 3D coordinates of each atom
		@a = split(/ +/,$i);
		@d =  (@d,$a[6], $a[7], $a[8]);
		print FH1 "$i\n";
	}

}

$l = scalar(@d)/3;
$distance = 0;

#calculating distance between each atoms
for ($i = 1; $i<$l; $i++)
{	
	@A = ($d[$i*3-3], $d[$i*3-2], $d[$i*3-1]);
	for($j = $i+1; $j<=$l; $j++)
		{
			@B = ($d[$j*3-3], $d[$j*3-2], $d[$j*3-1]);
			for ($k = 0; $k<scalar(@B); $k++)
			{
				$distance = $distance + ($B[$k]-$A[$k])**2;
			}
			$distance = $distance**0.5;
			print FH1 "Distance between Molecule $i and Molecule $j : $distance\n";
			$distance = 0;
		
		}
}
print "Results stored in file named output.txt\n";
close FH1; 

