
#reading contents of file
open(FH1,"lib_database.txt");
chomp(@t = <FH1>);

foreach $x(@t)
{	
	
	@c = (@c,split(' ', $x));

}

%records = @c;
close FH1;
$t = 0;

while ($t == 0)
{
print "Enter 1: New Entry\n";
print "Enter 2: Delete Entry\n";
print "Enter 3: Issue book\n";
print "Enter 4: Return book\n";
print "Enter 5: Exit\n";

chomp($choice = <STDIN>);

print "Enter the roll no.: ";
print "\n";
chomp($roll_no = <STDIN>);

#to create an entry
if($choice == 1)
{
	if(exists $records{$roll_no})
	{
		print "Entry already exists\n";
	}
	else
	{
		$records{$roll_no} = 0;
		print "Entry created\n";
	}
}
#to delete a account	
elsif($choice == 2)
{
	if(exists $records{$roll_no})
	{
		delete $records{$roll_no};
		print "Account Deleted\n";
	}
	else
	{	
		print "Given Roll no does not exist\n";
	}
}

#to issue a book
elsif($choice == 3)
{
	if(exists $records{$roll_no})
	{
		if ($records{$roll_no} <5)
		{
			$records{$roll_no} = $records{$roll_no} + 1;
			print "Book Issued\n";
			print "Total books issued: $records{$roll_no}\n";
		}
		else
		{
			print "You have already issued 5 books. Can not issue furthe more\n";
		}
			
	}
	else
	{
		print "Given Roll no does not exist\n";
	}
}

#to return a book
elsif($choice == 4)
{
	if(exists $records{$roll_no})
	{
		$records{$roll_no} = $records{$roll_no} - 1;
		print "Book Returned\n";
		print "Total books issued: $records{$roll_no}\n";
	}
	else
	{
		print "Given Roll no does not exist\n";
	}
}

#to exit the loop
elsif($choice == 5)
{	
	$t = 1;
}

}#end of while loop

#to overwrite the file
open (FH1,">","lib_database.txt");
@key = keys %records;
foreach $x( @key )
{
	print FH1 "$x $records{$x}\n";
}









