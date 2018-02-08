# programme to calculate the frequency of a letter or word.
#! /usr/bin/perl -w

$frequency = 0;
@words = ();
#taking inputs from user
print "Enter Input FIle name: ";
print "\n";
chomp($input_file = <STDIN>);
print "Enter Output FIle name: ";
print "\n"; 
chomp($output_file = <STDIN>);

print "Press 1 to search a particular word in a file\n";
print "Press 2 to search a particular letter in a file\n";
chomp($choice = <STDIN>);

#reading a file
open(FH1,"$input_file");
open(FH2,">$output_file");

#to find the particular word and its frequency in a file
if ($choice == 1)
{	
	#storing each line of a file in an array named 'lines'
	chomp(@lines = <FH1>);
	#storing each words of file in an array 'words'
	foreach $i (@lines)
	{	
		$i =~ tr/A-Z/a-z/;
		@words_in_each_line = split(' ', $i);
		@words = (@words, @words_in_each_line);	#stores words of file
	}

	print "Enter a word to be count in a file: ";
	print "\n";	
	chomp($find_word = <STDIN>);
	$find_word =~ tr/A-Z/a-z/;
	
	#finding the given words and its frequency
	foreach $i(@words)
	{
		if($i eq $find_word || $i eq $find_word.".") 
		{	
			$frequency = $frequency + 1;
		} 
	}
	print "Results entered in Output File\n";
	#printing result to file
	if ($frequency > 0)
	{
		print FH2 "Word \"$find_word\" found\n";
		print FH2 "Frequency: $frequency\n";	
	}
	else
	{
		print FH2 "Word \"$find_word\" not found\n";
		print FH2 "Frequency: $frequency\n";
	}		
} 

#to find the particular letter and its frequency in a file
elsif ($choice == 2)
{
	#storing each line of a file in an array named 'lines'
	chomp(@lines = <FH1>);
	#storing each words of file in an array 'words'
	foreach $i (@lines)
	{	
		$i =~ tr/A-Z/a-z/;
		@words_in_each_line = split('', $i);
		@words = (@words, @words_in_each_line);	#stores words of file
	}
	
	print "Enter a letter to be count in a file: ";
	print "\n";	
	chomp($find_letter = <STDIN>);
	$find_letter =~ tr/A-Z/a-z/;
	
	#finding the given letter and its frequency
	foreach $i(@words)
	{
		if($i eq $find_letter) 
		{	
			$frequency = $frequency + 1;
		} 
	}
	print "Results entered in Output File\n";
	#printing result to file
	if ($frequency > 0)
	{
		print FH2 "Letter \"$find_letter\" found\n";
		print FH2 "Frequency: $frequency\n";	
	}
	else
	{
		print FH2 "Letter \"$find_letter\" not found\n";
		print FH2 "Frequency: $frequency\n";
	}		
}

else
{
	print "Wrong choice entered\n";
}



