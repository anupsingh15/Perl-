sub academics
{

	%grade_marks = ("A+" => 10, "A" => 9, "B+" => 8, "B" => 7, "C" => 6, "D" => 5, "F" => 0);
	$semester = @_[0];
	%student_inf = @_[1 .. (scalar(@_)-1)];

	%roll = ();

	for($i = 1; $i<= 100; $i++)
	{
		$roll{$i} = 1;
	}
	@roll_no = sort {$a <=> $b}(keys %roll); 
	@roll_no1 = @roll_no;
		
	while()
	{	
	
	print "Press 1 for New admission\n";
	print "Press 2 for Registration of existing students\n";
	print "Press 3 for Entering Grades and GPA\n";
	print "Press 4 for Obtaining Degree Certificate\n";
	print "Press 5 for Exit\n";
	chomp($choice = <STDIN>);
	
	
	$l = @roll_no;
	$l1 = @roll_no1;
######################################################################################################################
	if ($choice == 1)
	{	
		open(FH,">>", "MOTHER.txt");
		if ($semester == 0)
		{	
			print "Enter your name: ";
			chomp($name = <STDIN>);
			$id = "13MS".(101 - $roll_no[$l-1]);
			print "Your Registered ID : $id\n";
			pop(@roll_no);
			$GPA = 0;	
			$student_inf{$id} = [$name, $GPA, [&enter_courses(6)], 0];
			print FH "$id	0	0	0	0	0\n";
		}
		elsif ($semester == 4)
		{
			print "Enter your name: ";
			chomp($name = <STDIN>);
			$id = "14MS".(101 - $roll_no1[$l1-1]);
			print "Your Registered ID : $id\n";
			pop(@roll_no1);
			$GPA = 0;	
			$student_inf{$id} = [$name, $GPA, [&enter_courses(6)], 0];
			print FH "$id	0	0	0	0	0\n";
		}
		else
		{
			print "Cannot take admission in between the academic year\n";
		}
		close FH;	 	
	}
######################################################################################################################
	elsif ($choice == 2)
	{	
		print "Enter your ID: ";
		chomp($id = <STDIN>);
		if (exists $student_inf{$id})
		{
			if ($semester == 2)
			{
				@{${$student_inf{$id}}[2]} = &enter_courses(6);	
			}
			elsif ($semester == 6)
			{
				@{${$student_inf{$id}}[2]} = &enter_courses(5);
			}
			else
			{
				print "your current semester is in progress. Cannot register for the next semester right now.\n";	
			}
		}
		else
		{
			print "You are not a registered student of this college\n";				
		}
		
	}
######################################################################################################################
	elsif($choice == 3)
	{
		if ($semester == 2 || $semester == 4 ||$semester == 6 ||$semester == 8)
		{
			print "Enter your ID: ";
			chomp($id = <STDIN>);
			if (exists $student_inf{$id} )
			{	
				$l = @{${$student_inf{$id}}[2]};
				foreach $course (@{${$student_inf{$id}}[2]})
				{
					print "Enter the grades for $course: ";
					chomp($grade_secured = <STDIN>);
					$grade_secured =~ tr/a-z/A-Z/;
					$total = $total + $grade_marks{$grade_secured};
					if ($grade_secured eq "F")
					{
						@failed_course = (@failed_course, $course); ####################
						
					}
				}
				if (scalar(@{${$student_inf{$id}}[3]}) > 0)
				{
					print "Enter the grades for the backlog courses\n";
					foreach $course(@{${$student_inf{$id}}[3]})
					{
						print "Enter the grades for $course: ";
						chomp($grade_secured = <STDIN>);
						$grade_secured =~ tr/a-z/A-Z/;	
						if ($grade_secured eq "F")
						{
							@failed_course = (@failed_course, $course); ####################
						}
					}		
				}
				
				if (scalar(@failed_course) > 0)
				{
					&mark_failed($id);	
				}
				else
				{
					&mark_unfailed($id);	
				}

				${$student_inf{$id}}[3] = [@failed_course];
				@failed_course = ();
				#print "@{${$student_inf{$id}}[3]}\n";
				$gpa = $total/$l;
				print "Your GPA: $gpa\n";
				$total = 0;
			}
	
			else 
			{
				print "You are not a registered student of this college\n";				
			}
		}
		
		else
		{
			print "your current semester is in progress. Cannot enter grades at this time.\n";
		}
			
	 }
######################################################################################################################
	elsif($choice == 4)	
	{
		print "Enter your ID: ";
		chomp($id = <STDIN>);
		if (exists $student_inf{$id})
		{	
			if($semester == 8)		
			{	
				open(FH,"MOTHER.txt");
				@lines = <FH>;
				foreach $s(@lines)
				{	
					@inf = split("	", $s);
					if($inf[0]eq$id){
					if ($inf[2] eq "1")
					{
						print "Congratulations you are being offered Degree Certificate\n";
						delete $student_inf{$id};
					}
					elsif($inf[0]eq$id && $inf[2] eq "2" && $inf[1] eq "8")
					{
						print "Pay your dues and get your Degree Certificate\n";
					}
					else
					{
						print "You can not be offered Degree Certificate\n";
					}
							}
				}	
			}
			else 
			{
				print "You have not completed your 2 years till now\n";
			}	
		}
		else 
		{
			print "You are not a registered student\n";
		}				
	}
######################################################################################################################	
	elsif($choice == 5)
	{
		last;
	}
######################################################################################################################
	else 
	{
		print "Wrong choice\n";
	}
######################################################################################################################
	
	} #end of while loop

	
	open(FH,"MOTHER.txt");
	@lines = <FH>;
	#print "@lines\n";
	for($i = 0; $i< scalar(@lines); $i++)
	{
		@inf = split("	", $lines[$i]);
		if($inf[2] == 1)
		{
			#print "$inf[0]\n";
			delete $student_inf{$inf[0]};
		}	
	}
	
	close FH;

	

	@d = %student_inf;
	#close FH;
	@d;
} #end of subroutine 





######################################################################################################################
sub enter_courses
{
	
	$no_of_courses = @_[0];
	print "Have to enroll ".($no_of_courses*3)." credits($no_of_courses courses) for the semester\n";
	%courses = ();
	print "Enter the course IDs\n";
	for ($i = 1; $i<=$no_of_courses; $i++)
	{
		print "$i. ";
		chomp($course_id = <STDIN>);
		if (exists $courses{$course_id})
		{
			print "Entered the same course\n";
			$i = $i-1;
		}
		else
		{
			$courses{$course_id} = 1;
		}
	}
	@c = (keys %courses);		
	@c;
}
######################################################################################################################

sub delete1 
{	open(FH,"MOTHER.txt");
	@lines = <FH>;
	for($i = 0; $i< scalar(@lines); $i++)
	{
		@inf = split("	", $lines[$i]);
		if($inf[2] == 0 || $inf[2] == 2)
		{
		@retain = (@retain, $i);
		}	
	}

	close FH;
	
	open(FH1, ">","MOTHER.txt");
	foreach $k(@retain)
	{
		print FH1 "$lines[$k]";
	}
	close FH1;
	@retain = ();		
}
######################################################################################################################

sub mark_failed
{
	open(FH, "MOTHER.txt");
	@lines = <FH>;
	close FH;
	open(FH, ">", "MOTHER.txt");
	close FH;
	foreach $l(@lines)
	{
		open(FH, ">>", "MOTHER.txt");
		@t = split("	", $l);
		if ($t[0] eq @_[0])
		{	
			$t[5] = 1;
			@a = join("	", @t);
			print FH "@a\n";
		}
		else
		{
			print FH $l;
		}
	}
	close FH;	
}
######################################################################################################################

sub mark_unfailed
{
	open(FH, "MOTHER.txt");
	@lines = <FH>;
	close FH;
	open(FH, ">", "MOTHER.txt");
	close FH;
	foreach $l(@lines)
	{
		open(FH, ">>", "MOTHER.txt");
		@t = split("	", $l);
		if ($t[0] eq @_[0])
		{	
			$t[5] = 0;
			@a = join("	", @t);
			print FH "@a\n";
		}
		else
		{
			print FH $l;
		}
	}
	close FH;	
}
######################################################################################################################


open(FH, ">", "MOTHER.txt");
close FH;
@x = ();
$t = 0;
while($t <= 8)
{

print "update $t\n";
&delete1();
@stud = &academics($t, @x);

@x = @stud;
$t = $t+1;
}



