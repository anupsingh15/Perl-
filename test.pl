open (FH, "output.txt");

while(<FH>)
{
	print "$_\n"
}
