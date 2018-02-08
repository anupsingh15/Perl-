#! /usr/bin/perl -w

=pod
roll
update(f) delete(f) fine(f) lost(f) backlog(f) fine canteen account fee
=cut

sub delete_stu{
	my $roll = $_[0];
	open(FH1,"ACCOUNTS.txt");
	my @cont = <FH1>;
	close(FH1);
	my $k;
	open(FH2,">ACCOUNTS.txt");
	foreach $k (@cont){
		if($k =~ /^($roll)/){}
		else{
			print FH2 $k;
		}
	}
}

open(FH1,"MOTHER.txt");
@cont1 = <FH1>;
close(FH1);

open(FH1,"ACCOUNTS.txt");
@cont2 = <FH1>;
close(FH1);

foreach $stu (@cont1){
	if($stu =~ /(\w+)\s+(\d+)\s+(\d+)\s+(\d+)\s+([0-9.]+)\s+(\d+)/){
		${$student_acc{$1}}[0] = $2;
		${$student_acc{$1}}[1] = $3;
		${$student_acc{$1}}[2] = $4;
		${$student_acc{$1}}[3] = $5;
		${$student_acc{$1}}[4] = $6;
		${$student_acc{$1}}[5] = 0.0;
		${$student_acc{$1}}[6] = 0.0;
		${$student_acc{$1}}[7] = 0.0;
		${$student_acc{$1}}[8] = 1;
	}
}

foreach $stu (@cont2){
	if($stu =~ /(\w+)\s+(-?[0-9.]+)\s+(-?[0-9.]+)\s+([0-9.]+)\s+(\d+)/){
		${$student_acc{$1}}[5] = $2;
		${$student_acc{$1}}[6] = $3;
		${$student_acc{$1}}[7] = $4;
		${$student_acc{$1}}[8] = $5;
	}
}

=pod
foreach $stu (keys %student_acc){
	@a = @{$student_acc{$stu}};
	print "@a\n";
}
=cut

$fee_upd = 1;                        #whether to update fee or not. 0 means do.
foreach $k (keys %student_acc){
	#print ${$student_acc{$k}}[0]."\n";
	if( ${$student_acc{$k}}[0] < 8 && ${$student_acc{$k}}[0]%2 == 0 ){    #if student has faced less than 8 updates and even update
		$fee_upd = 0;
		if( ${$student_acc{$k}}[8] == 0 ){
			${$student_acc{$k}}[8] = 1;
		}
	}
}

$fine_upd = 0;
$canteen_upd = 0;
$time_upd = 0;

sub fileupdate{
	open(FH2,">MOTHER.txt");
	open(FH3,">ACCOUNTS.txt");
	foreach $k (keys %student_acc){
		print FH2 $k."	".${$student_acc{$k}}[0]."	".${$student_acc{$k}}[1]."	".${$student_acc{$k}}[2]."	".${$student_acc{$k}}[3]."	".${$student_acc{$k}}[4]."\n";
		print FH3 $k."	".${$student_acc{$k}}[5]."	".${$student_acc{$k}}[6]."	".${$student_acc{$k}}[7]."	".${$student_acc{$k}}[8]."\n";
	}
	close(FH2);
	close(FH3);
}

sub validfraction{
	my $num = $_[0];
	if($num =~ /^[0-9.]+$/){
		return 1;
	}
	else{
		return 0;
	}
}


$opt = 0;
while($opt != 6){
	print "\nAccounts Section\n";
	print "Enter corresponding number:\n";
	print "1. Tution fee payment\n";
	print "2. Book fine\n";
	print "3. Canteen\n";
	print "4. Students' accounts\n";
	print "5. Update time\n";
	print "6. Exit\n";
	
	chomp($opt = <STDIN>);
#tution fee------------------------------------------------------------------------------------	
	if($opt == 1){
		$opt1 = 0;
		while($opt1 != 4){
			print "\nTution fee payment\n";
			print "Enter corresponding number:\n";
			print "1. Enquiry\n";
			print "2. Update\n";
			print "3. Pay fee(exceptional case)\n";
			print "4. Exit section\n";
			
			chomp($opt1 = <STDIN>);
#enquiry-----------------------------------------------------------------------		
			if($opt1 == 1){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					if( ${$student_acc{$roll}}[8] == 0 ){
						print "Tution fee paid.\n";
					}
					elsif( ${$student_acc{$roll}}[8] == 1 ){
						print "Tution fee not paid.\n";
					}
					elsif( ${$student_acc{$roll}}[8] == 2 ){
						print "Tution fee not paid. Student is under warning.\n";
					}
					else{
						print "You are under the process of expulsion for not paying tution fee.\n";
					}
				}
				else{
					print "ID does not exist.\n";
				}
			}
#enquiry-------------------------------------------------------------------------------
#Update--------------------------------------------------------------------------------
			if($opt1 == 2){
				if($fee_upd == 0){
					print "Enter student IDs who have paid tution fee:\n";
					$roll = 0;
					while($roll ne ""){
						chomp($roll = <STDIN>);
						if( exists $student_acc{$roll} ){
							if( ${$student_acc{$roll}}[8] == 1 ){
								${$student_acc{$roll}}[8] = 0;
							}
							elsif( ${$student_acc{$roll}}[8] == 0 ){
								print "Fees already paid. Amount added to account.\n";
								${$student_acc{$roll}}[7] = ${$student_acc{$roll}}[7] + 10000.00;
							}
						}
						elsif($roll eq ""){}
						else{
							print "ID does not exist.\n";
						}
					}
					
					foreach $k (keys %student_acc){
						if( ${$student_acc{$k}}[8] == 1 ){
							${$student_acc{$k}}[8] = 2;
							print "$k is under warning of expulsion for not paying fee.\n";
						}
						elsif( ${$student_acc{$k}}[8] == 3 ){
							print "$k is under process of expulsion for not paying fee.\n";
						}
					}
					fileupdate();
					$fee_upd = 1;
					print "Update complete.\n";
				}
				else{
					print "Not time to update tution fee.\n";
				}
			}
#Update--------------------------------------------------------------------------------
#Exceptional case-------------------------------------------------------------------------
			if($opt1 == 3){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					if( ${$student_acc{$roll}}[8] == 3 ){
						print "You are no more under process of expulsion.\n";
						${$student_acc{$roll}}[8] = 0;
						print "Payment complete.\n";
					}
					elsif( ${$student_acc{$roll}}[8] == 2 ){
						print "You are no more under warning of expulsion.\n";
						${$student_acc{$roll}}[8] = 0;
						print "Payment complete.\n";
					}
					elsif( ${$student_acc{$roll}}[8] == 0 ){
						print "You have already paid.\n";
					}
					if( ${$student_acc{$roll}}[1] == 1 ){
						${$student_acc{$roll}}[1] = 0;
					}
					fileupdate();
				}
				else{
					print "You are not in the database.\n";
				}
			}
#Exceptional case-------------------------------------------------------------------------
		}
	}
#tution fee--------------------------------------------------------------------------
#Book fine--------------------------------------------------------------------------
	if($opt == 2){
		$opt1 = 0;
		while($opt1 != 5){
			print "\nBook fine\n";
			print "Enter corresponding number:\n";
			print "1. Enquiry\n";
			print "2. Update\n";
			print "3. Clear book fine\n";
			print "4. Pay for lost book\n";
			print "5. Exit section\n";
			
			chomp($opt1 = <STDIN>);
#enquiry----------------------------------------------------------------------------
			if($opt1 == 1){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					print "Book fine = Rs.".abs(${$student_acc{$roll}}[5])."\n";
					print "Fine for lost book = Rs.".${$student_acc{$roll}}[3]."\n";
				}
				else{
					print "ID does not exist.\n";
				}
			}
#enquiry----------------------------------------------------------------------------
#Update-----------------------------------------------------------------------------
			if($opt1 == 2){
				if($fine_upd == 0){
					foreach $k (keys %student_acc){
						${$student_acc{$k}}[5] = ${$student_acc{$k}}[5] - ${$student_acc{$k}}[2]*100.00;
					}
				fileupdate();
				$fine_upd = 1;
				print "Update complete.\n";
				}
				else{
					print "Not time to update book fine.\n";
				}
			}
#Update-----------------------------------------------------------------------------
#Clear fine-------------------------------------------------------------------------------
			if($opt1 == 3){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					print "Book fine = Rs.".abs(${$student_acc{$roll}}[5])."\n";
					print "Enter amount = Rs.";
					chomp($add = <STDIN>);
					while(validfraction($add) != 1){
						print "Enter amount = Rs.";
						chomp($add = <STDIN>);
					}
					if($add+${$student_acc{$roll}}[5] >= 0){
						${$student_acc{$roll}}[5] = 0;
						${$student_acc{$roll}}[7] = ${$student_acc{$roll}}[7] + $add + ${$student_acc{$roll}}[5];
						print "Fine paid.\n";
					}
					else{
						${$student_acc{$roll}}[5] = $add + ${$student_acc{$roll}}[5];
						print "Fine reduced.\n";
					}
					fileupdate();
				}
				else{
					print "ID does not exist.\n";
				}
			}
#Clear fine-------------------------------------------------------------------------------
#lost book--------------------------------------------------------------------------------
			if($opt1 == 4){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					print "Lost book price = Rs.".abs(${$student_acc{$roll}}[3])."\n";
					print "Enter amount = Rs.";
					chomp($add = <STDIN>);
					while(validfraction($add) != 1){
						print "Enter amount = Rs.";
						chomp($add = <STDIN>);
					}
					if($add - ${$student_acc{$roll}}[3] >= 0){
						${$student_acc{$roll}}[3] = 0.0;
						${$student_acc{$roll}}[7] = ${$student_acc{$roll}}[7] + $add - ${$student_acc{$roll}}[3];
						print "Amount paid.\n";
					}
					else{
						${$student_acc{$roll}}[3] = ${$student_acc{$roll}}[3] - $add;
						print "Amount not completely paid.\n";
					}
					fileupdate();
				}
				else{
					print "ID does not exist.\n";
				}
			}
#lost book--------------------------------------------------------------------------------
		}
	}
#Book fine--------------------------------------------------------------------------
#Canteen-------------------------------------------------------------------------------
	if($opt == 3){
		$opt1 = 0;
		while($opt1 != 4){
			print "\nCanteen\n";
			print "Enter corresponding number:\n";
			print "1. Enquiry\n";
			print "2. Update\n";
			print "3. Pay canteen fine\n";
			print "4. Exit section\n";
			
			chomp($opt1 = <STDIN>);
#enquiry----------------------------------------------------------------------------
			if($opt1 == 1){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					print "Canteen balance = Rs.".${$student_acc{$roll}}[6]."\n";
				}
				else{
					print "ID does not exist.\n";
				}
			}
#enquiry----------------------------------------------------------------------------
#Update-----------------------------------------------------------------------------
			if($opt1 == 2){
				if($canteen_upd == 0){
					foreach $k (keys %student_acc){
						print "$k\n";
						print "Enter payment = Rs.";
						chomp($paid = <STDIN>);
						while(validfraction($paid) != 1){
							print "Enter payment: Rs.\n";
							chomp($paid = <STDIN>);
						}
						print "Enter consumption = Rs.";
						chomp($take = <STDIN>);
						while(validfraction($paid) != 1){
							print "Enter consumption: Rs.\n";
							chomp($take = <STDIN>);
						}
						${$student_acc{$k}}[6] = ${$student_acc{$k}}[6] + $paid - $take;
					}
					fileupdate();
					$canteen_upd = 1;
					print "Update complete.\n";
				}
				else{
					print "Not time to update canteen.\n";
				}
			}
#Update-----------------------------------------------------------------------------
#Increase balance------------------------------------------------------------------------------
			if($opt1 == 3){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					print "Canteen balance = Rs.".${$student_acc{$roll}}[6]."\n";
					print "Enter amount = Rs.";
					chomp($add = <STDIN>);
					while(validfraction($add) != 1){
						print "Enter amount = Rs.";
						chomp($add = <STDIN>);
					}
					${$student_acc{$roll}}[6] = $add+${$student_acc{$roll}}[6];
					print "Canteen balance increased.\n";
					fileupdate();
				}
				else{
					print "ID does not exist.\n";
				}
			}
#Increase balance------------------------------------------------------------------------------
		}
	}
#Canteen-------------------------------------------------------------------------------
#Students' accounts----------------------------------------------------------------------
	if($opt == 4){
		$opt1 = 0;
		while($opt1 != 4){
			print "\nStudents' Accounts\n";
			print "Enter corresponding number:\n";
			print "1. Enquiry\n";
			print "2. Add balance\n";
			print "3. Clear all debts\n";
			print "4. Exit section\n";
			
			chomp($opt1 = <STDIN>);
#enquiry----------------------------------------------------------------------------
			if($opt1 == 1){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					print "Account balance = Rs.".${$student_acc{$roll}}[7]."\n";
				}
				else{
					print "ID does not exist.\n";
				}
			}
#enquiry----------------------------------------------------------------------------
#Add balance-------------------------------------------------------------------------
			if($opt1 == 2){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					print "Account balance = Rs.".${$student_acc{$roll}}[7]."\n";
					print "Enter amount = Rs.";
					chomp($add = <STDIN>);
					while(validfraction($add) != 1){
						print "Enter amount = Rs.";
						chomp($add = <STDIN>);
					}
					${$student_acc{$roll}}[7] = ${$student_acc{$roll}}[7] + $add;
					print "Balance added.\n";
					fileupdate();
				}
				else{
					print "ID does not exist.\n";
				}
			}
#Add balance-------------------------------------------------------------------------
#Clear all debts---------------------------------------------------------------------
			if($opt1 == 3){
				print "Enter student ID: ";
				chomp($roll = <STDIN>);
				
				if( exists $student_acc{$roll} ){
					if( ${$student_acc{$roll}}[6] >= 0 ){
						$debt = ${$student_acc{$roll}}[5];
					}
					else{
						$debt = ${$student_acc{$roll}}[5] + ${$student_acc{$roll}}[6];
					}
					print "Total debt = Rs.".abs($debt)."\n";
					print "Enter amount = Rs.";
					chomp($add = <STDIN>);
					while(validfraction($add) != 1){
						print "Enter amount = Rs.";
						chomp($add = <STDIN>);
					}
					if( $add + $debt >= 0 ){
						${$student_acc{$roll}}[7] = ${$student_acc{$roll}}[7] + $add + $debt;
						${$student_acc{$roll}}[5] = 0.0;
						${$student_acc{$roll}}[6] = 0.0;
						print "All debts cleared.\n";
					}
					else{
						print "Insufficient amount.\n";
					}
					fileupdate();
				}
				else{
					print "ID does not exist.\n";
				}
			}
#Clear all debts---------------------------------------------------------------------
		}
	}
#Students' accounts----------------------------------------------------------------------
#Update time----------------------------------------------------------------------------
	if($opt == 5){
		if($time_upd == 0){
			if($fee_upd == 1 && $fine_upd == 1 && $canteen_upd == 1){
				for $k (keys %student_acc){
					if( ${$student_acc{$k}}[4] == 0 && ${$student_acc{$k}}[0] < 8 ){
						${$student_acc{$k}}[7] = ${$student_acc{$k}}[7] + 15000.00;	#if not failed or passed out enter stipend
					}
					if( ${$student_acc{$k}}[7] + ${$student_acc{$k}}[5] >= 0 ){
						${$student_acc{$k}}[7] = ${$student_acc{$k}}[7] + ${$student_acc{$k}}[5];	#if possible deduct book fine from account
						${$student_acc{$k}}[5] = 0.0;
					}
					if( ${$student_acc{$k}}[7] + ${$student_acc{$k}}[6] >= 0 && ${$student_acc{$k}}[6] < 0 ){
						${$student_acc{$k}}[7] = ${$student_acc{$k}}[7] + ${$student_acc{$k}}[6];	#if possible deduct canteen fine from account
						${$student_acc{$k}}[6] = 0.0;
					}
					if( ${$student_acc{$k}}[7] - ${$student_acc{$k}}[3] >= 0 ){
						${$student_acc{$k}}[7] = ${$student_acc{$k}}[7] - ${$student_acc{$k}}[3];	#if possible deduct price of lost book from account
						${$student_acc{$k}}[3] = 0.0;	#set lost book marker to 0
					}
					else{
						${$student_acc{$k}}[5] = ${$student_acc{$k}}[5] - ${$student_acc{$k}}[3]; #add lost book price to fine
						${$student_acc{$k}}[3] = 0.0;  #set lost book marker to 0
					}
					if( ${$student_acc{$k}}[5] < 0 || ${$student_acc{$k}}[6] < 0 ){
						if( ${$student_acc{$k}}[1] == 0 ){
							${$student_acc{$k}}[1] = 2;	#if book fine or canteen fine remains then set delete(f) = 2
						}
					}
					else{
						if( ${$student_acc{$k}}[1] == 2 ){
							${$student_acc{$k}}[1] = 0;	#if no fine is there but delete(f) = 2 reset it to 0
						}
					}
					if( ${$student_acc{$k}}[8] == 2 && ${$student_acc{$k}}[0]%2 == 1 ){  #if fees still not paid at odd month expel
						${$student_acc{$k}}[8] = 3;
						${$student_acc{$k}}[1] = 1;
					}
					if( ${$student_acc{$k}}[0] < 8 ){
						${$student_acc{$k}}[0] = ${$student_acc{$k}}[0] + 1;	#if not passed out update time
					}
				}
				fileupdate();
				$time_upd = 1;
				print "Time update completed.\n";
			}
			else{
				print "First complete all updates (tution fee, book fine, canteen).\n";
			}
		}
		else{
			print "Already updated time.\n";
		}
	}
#Update time----------------------------------------------------------------------------
#Exit------------------------------------------------------------------------------------------
	if($opt == 6){
		if($time_upd != 1){
			print "You cannot exit without completing time update.\n";
			$opt = 0;
		}
	}
#Exit------------------------------------------------------------------------------------------
}

=pod
update(f) = 0; delete(f) = 1; fine(f) = 2; lost(f) = 3; backlog(f) = 4; fine = 5; canteen = 6; account = 7; fee = 8
=cut