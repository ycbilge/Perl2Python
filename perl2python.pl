#!/usr/bin/perl -w

$ifClosingParanthesis = 0;
$whileClosingParanthesis = 0;
$ifIndentation = 0;
$whileIndentation = 0;
$forClosingParanthesis = 0;
$forIndentation = 0;
$sysLibFlag = 0;
$fileInputLibFlag = 0;
$regExpLibFlag = 0;
$elsifClosingParanthesis = 0;
$elsifIndentation = 0;
$elseClosingParanthesis = 0;
$elseIndentation = 0;
$eqFlagForReadLine = 0;
$regExpStdinIn = 0;

$stdinClause = "\<STDIN\>";
$argvClause = "\@ARGV";
$joinClause = "join(";
$anyInputClause = "\<\>";
$plusplusClause = "++";
$minusminusClause = "--";


$addPrintfSub = 0;

#TODO stdin e bak basina \ koy cunku argv ye koymadan calismadi
sub createIndentation{
	my $upto;
	my $resultStr;
	my $i;
	$upto = $_[0];
	$resultStr = "";
	$i = 0;
	for($i = 0; $i < $upto; $i++) {
				$resultStr .= "    ";
	}
	return $resultStr;
}
sub handleIndentation() {
	my $str;
	$str = "";
	if($ifIndentation > 0) {
		$str .= createIndentation($ifIndentation);
	}
	if($whileIndentation > 0) {
		$str .= createIndentation($whileIndentation);
	}
	if($forIndentation > 0) {
		$str .= createIndentation($forIndentation);
	}
	if($elsifIndentation > 0) {
		$str .= createIndentation($elsifIndentation);
	}
	if($elseIndentation > 0) {
		$str .= createIndentation($elseIndentation);
	}
	return $str;
}

sub handleLastStatement() {
	my $str;
	$str = handleIndentation();
	$str .= "break\n";
	print $str;
	
}
sub handleNextStatement() {
	my $str;
	$str = handleIndentation();
	$str .= "continue\n";
	print $str;
 }
sub handleChomp() {
	my $param;
	$param = $1;
	$param =~ tr/;//d;
	my $str;
	$str = handleIndentation();
	$str .= "$param = $param\.rstrip()\n";
	print $str;
}
###regular print de \s* yaptim s* $ isaretinden sonra onceki file la check edersin
sub regularPrint() {
	my $str;
	my $parr1;
	my $parr2;
    # print $var = var or print var = $var
    if($1 =~ /^\s*\$\s*(.*)\s+(.*)/) {
		$parr1 = $1;
		$parr2 = $2;
		if(index($parr2, "\$") == -1) {
			$str = handleIndentation();
			$str .= "print $parr1, \"$parr2\"\n";
			print $str;
		}else {
			$str = handleIndentation();
			$str .= "print $parr1 $parr2\n";
			print $str;
		}
	}elsif($1 =~ /^\s*(.*)\s+\$(.*)/) {
		$parr1 = $1;
		$parr2 = $2;
		if(index($parr1, "\$") == -1) {
			$str = handleIndentation();
			$str .= "print \"$parr1\", $parr2\n";
			print $str;
		}else {
			$str = handleIndentation();
			$str .= "print $parr1 $parr2\n";
			print $str;
		}
	}elsif($1 =~ /^\s*\$\s*(.*)\s*/) {
			$par1 = $1;
			$str = handleIndentation();
			$par1 =~ s/(.*?)\./$1+/g;
			$par1 =~ tr/\$//d;
			$str .= "print $par1\n";
			print $str;
    }elsif($1 =~ /^\s*\$\s*(.*)\s*/) {
			$par1 = $1;
			$str = handleIndentation();
			$par1 =~ s/(.*?)\./$1+/g;
			$par1 =~ tr/\$//d;
			$str .= "print $par1\n";
			print $str;
    }else {
			$par1 = $1;
			$str = handleIndentation();
			$par1 =~ s/(.*?)\./$1+/g;
			$par1 =~ tr/\$//d;
			$str .= "print \"$par1\"\n";
			print $str;
     }
}
sub printWithoutNewLine {
		my $str;
		my $par1;
		$par1 = $1;
		$str = handleIndentation();
		$par1 =~ s/(.*?)\./$1+/g;
		
		if(index($par1, "\$") != -1) {
			if(index($par1, ",") != -1) {	  
				$par1 =~ s/"\s*,\s*"/" + "/g;
				$par1 =~ s/"\s*,\s*\$/" + \$/g;
				$par1 =~ s/,\$(.*?)\s*,\s*"\s*/$1 + "/g;
				$par1 =~ s/\$(.*?)\s*,\s*"\s*/$1 + "/g;
				$par1 =~ s/,\s*\$(.*?)\s*,\s*"\s*/+ $1 + "/g;
				$par1 =~ tr/\$//d;
				$str.= "sys.stdout.write($par1)\n";
			}else {
				$par1 =~ s/"\s*,\s*"/" + "/g;
				$par1 =~ s/"\s*,\s*\$/" + \$/g;
				$par1 =~ s/,\$(.*?)\s*,\s*"\s*/$1 + "/g;
				$par1 =~ s/\$(.*?)\s*,\s*"\s*/$1 + "/g;
				$par1 =~ s/,\s*\$(.*?)\s*,\s*"\s*/+ $1 + "/g;
				$par1 =~ tr/\$//d;
				$str.= "sys.stdout.write(str($par1))\n";
				#$str =~ tr/"//d;
			}
		}else {
			if(index($par1, "+") == -1) {
				$str .= "sys.stdout.write($par1)\n";
			}else {
				$str.= "sys.stdout.write($par1)\n";
				$str =~ tr/"//d;
			}
		}
		$str =~ s/(.*?)",/$1"+/g;
		$str =~ tr/\$//d;
		
		print $str;
}
sub printWithComma()  {
		  $param = $1;
		  my $str;
		  if(index($param, "\$") == -1) {
				$str = handleIndentation();
				$str .= "print $param\n";
			  print $str;
		  }else {
			  $param =~ tr/\$//d;
			  $str = handleIndentation();
			  $str .= "print $param\n";
			  $str =~ tr/\$//d;
			  $str =~ tr/"//d;
			  print $str;
		  }
}
sub printWithComma2  {
	my $param = $_[0];
	$param =~ s/\\n//g;
	$param =~ s/"\s*,\s*"/" + "/g;
	$param =~ s/"\s*,\s*\$/" + \$/g;
	$param =~ s/,\$(.*?)\s*,\s*"\s*/$1 + "/g;
	$param =~ s/\$(.*?)\s*,\s*"\s*/$1 + "/g;
	
	$param =~ s/,\s*\$(.*?)\s*,\s*"\s*/+ $1 + "/g;
	$param =~ tr/\$//d;
	my $str;
	$str = handleIndentation();
	$str .= "$param";
	print $str;
		
}
sub variables() {
  $firstElem = $1;
  ### if string has ;
  my $str;
  if($2 =~ /^\s*(.*)\s*;\s*/){
		$secondElem = $1;
		$secondElem =~ tr/\$//d;
		$str = handleIndentation();
		$str .= "$firstElem = $secondElem\n";
		print $str;
  }else { ## if string does not have semicolon
		$2 =~ tr/\$//;
		$str = handleIndentation();
		$str .= "$1 = $2\n";
		print $str;
  }
}
sub handleIf() {
  $booleanStatement = $1;
  $booleanStatement =~ tr/\$//d;
  my $str;
  $str = handleIndentation();
  $str .= "if $booleanStatement:\n";
  $str =~ s/[^\\]eq/ ==/;
  print $str;
}
sub handleelsIf() {
	my $booleanStatement;
	$booleanStatement = $1;
	$booleanStatement =~ tr/\$//d;
	my $str;
	$str = handleIndentation();
	$str .= "elif $booleanStatement:\n";
	$str =~ s/[^\\]eq/ ==/;
    print $str;
}
sub handleelse() {
	my $str;
	$str = handleIndentation();
	$str .= "else:\n";
    print $str;
}

sub handleWhileStatement() {
  $booleanStatement = $1;
  $booleanStatement =~ tr/\$//d;
  my $str;
  $str = handleIndentation();
  $str .= "while $booleanStatement:\n";
  $str =~ s/[^\\]eq/ ==/;
  print $str;
}
sub handleWhileWithStdin {
	my $whileToFor;
	$whileToFor = $_[0];
	$whileToFor =~ /^\s*(.*)=(.*)\s*/;
	my $param1;
	my $param2;
	$param1 = $1;
	$param1 =~ tr/$//d;
	$param2 = $2;
	my $str;
	#print "$param1\n";
	$str = handleIndentation();
	my $lookingFor;
	$lookingFor = "(sys.stdin.readline\(\)";
	$lookingFor2 = "sys.stdin.readline\(\)";
	if(index($param2, $lookingFor) !=-1){
		$str .= "for $param1 in sys.stdin:\n";	
	}elsif(index($param2, $lookingFor2) !=-1) {
		$str .= "for $param1 in sys.stdin:\n";	
	}else{
		$str .= "";
	}
	print $str;
	
}
sub handleWhileWithAnyInput {
	my $whileToFor;
	$whileToFor = $_[0];
	$whileToFor =~ /^\s*(.*)=(.*)\s*/;
	my $param1;
	my $param2;
	$param1 = $1;
	$param1 =~ tr/$//d;
	$param2 = $2;
	my $str;
	#print "$param1\n";
	$str = handleIndentation();
	my $lookingFor;
	$lookingFor = "\<\>";
	if(index($param2, $lookingFor) !=-1){
		$str .= "for $param1 in fileinput.input():\n";	
	}else{
		$str .= "";
	}
	print $str;
}
sub handleRegExpr() {
	my $par1;#line
	my $par2;#s
	my $par3;#[aeiou]
	my $par4;#
	my $par5;#g
	$par1 = $1;
	$par2 = $2;
	$par3 = $3;
	$par4 = $4;
	$par5 = $5;
	my $str;
	$str = "";
	$str = handleIndentation();
	$str .= "$par1 = ";
	if($par2 eq "s") {
		#print "$par1 = re.sub(";
		$str .= "re.sub(r"
	}
	if(index( $par5, "g") == -1 ) {
		$str .= "'$par3', '$par4', $par1,1)\n"
	}else {
		$str .= "'$par3', '$par4', $par1)\n";
	}
	print $str;
}
sub handleForStatement {
	my $varStatement = $1;
	my $from = $2;
	my $until = $_[0];
	my $str;
   $str = handleIndentation();
   if($until eq "\$\#ARGV") {
	   $str .= "for $varStatement in xrange(len(sys.argv)-1):\n";
   }else {
	   $until++;
	   $str .= "for $varStatement in xrange($from, $until):\n";
	}
   print $str;
}

sub handlePlusPlus{
	my $par = $_[0];
	my $str;
	$str = handleIndentation();
	$str .= $par;
	$str .= " += 1";
	$str .= ";\n";
	print $str;
}
sub handleMinusMinus{
	my $par = $_[0];
	my $str;
	$str = handleIndentation();
	$str .= $par;
	$str .= " -= 1";
	$str .= ";\n";
	print $str;
}

sub handleArgvPrint {
	my $par1;
	$par1 = $_[0];
	my $str;
	$str = handleIndentation();
	$str .= "print sys.argv[$par1 + 1]\n";
	print $str;
}
sub handlePrintf{
	my $param = $_[0];
	$param =~ /\s*printf\s*(.*?)\s*;/;
	my $par1 = $1;
	$par1 =~ tr/$//d;

	$sysLibFlag = 1;
	my $str;
	$str = handleIndentation();
	$str .= "printf(";
	$str .= $par1;
	$str .= ")";
	$str .= "\n";
	print $str;
	
}

sub checkLibReq() {
	
	#TODO WHAT IF THERE IS NO ARG
	my $data_file = $ARGV[0];
	open FILE, $data_file;
	my @file_array =<FILE>;
	my @file_array2 = @file_array;
	close FILE;
	$checkVar1 = "\@ARGV";
	$checkVar2 = "\<STDIN\>";
	$checkVar3 = "\<\>";
	$checkVar4 = "=~ s/";
	$checkVar5 = "\$\#ARGV";
	$checkVar6 = "print";
	$eqVar = "eq";
	#TODO boyle sys icin hepsini check1 check2
	#diye yaz ve check et
	$strr = join('', @file_array);
	my $lline;
	if(grep(/$checkVar1/,@file_array) == 1 or grep(/$checkVar2/,@file_array) == 1) {
		$sysLibFlag = 1;
	}elsif(index($strr,$checkVar5) != -1) {
		$sysLibFlag = 1;
	}elsif(index($strr,$checkVar6) != -1) {
		while(@file_array2) {
			$lline = shift @file_array2;
			if(index($lline,$checkVar6) != -1) {
				if(index($lline, "\\n") == -1) {
					$sysLibFlag = 1;
					last;
				}
			}
		}
	}
	#if(grep(/[^\\]$eqVar/,@file_array) == 1) {
	if(index($strr, $eqVar) != -1){
		$eqFlagForReadLine = 1;
	}
	if(grep(/$checkVar3/, @file_array) == 1){
		$fileInputLibFlag = 1;
	}
	#if(grep(/$checkVar4/, @file_array) == 1){
	#	$regExpLibFlag = 1;
	#}
	if(index($strr, $checkVar4) != -1){
		$regExpLibFlag = 1;
	}
	if(index($strr, "printf") != -1) {
		$addPrintfSub = 1;
	}
}
checkLibReq();
while ($line = <>) {
	$line =~ s/\|\|/\|/gi;
	$line =~ s/\&\&/\&/gi;
	if (index($line, $stdinClause) != -1) {
		if($eqFlagForReadLine == 1) {
			$line =~ s/(.*)\<STDIN\>(.*)/$1sys.stdin.readline\(\)$2/;
			$eqFlagForReadLine = 0;
		}elsif($regExpStdinIn == 1) {
			$line =~ s/(.*)\<STDIN\>(.*)/$1sys.stdin.readline\(\)$2/;
			$regExpStdinIn = 0;
		}else {
			$line =~ s/(.*)\<STDIN\>(.*)/$1float\(sys.stdin.readline\(\)\)$2/;
		}
	} 
	if(index($line, $plusplusClause) != -1) {
		$line =~ s/\$(.*)\s*\+\+\s*;\s*/$1 += 1/;
		my $parr = $1;
		handlePlusPlus($parr);
		next;
	}elsif(index($line, $minusminusClause) != -1) {
		$line =~ s/\$(.*)\s*\-\-\s*;\s*/$1 -= 1/;
		my $parr = $1;
		handleMinusMinus($parr);
		next;
	}
	if(index($line, $argvClause) != -1) {
		$line =~ s/(.*)\@ARGV(.*)/$1sys.argv[1:]$2/;
	}
	if(index($line, $joinClause) != -1) {
		$line =~ s/(.*)join\((.*),(.*)\)(.*)/$1$2.join\($3\)$4/;
	}
	if ($line =~ /^#!/ && $. == 1) {
	
		# translate #! line 
		print "#!/usr/bin/python2.7 -u\n";
		if($sysLibFlag == 1) {
			print "import sys\n";
			$sysLibFlag = 0;
		}
		if($fileInputLibFlag == 1) {
			print "import fileinput\n";
			$fileInputLibFlag = 0;
		}
		if($regExpLibFlag == 1) {
			print "import re\n";
			$regExpLibFlag = 0;
			$regExpStdinIn = 1;
		}
		if($addPrintfSub == 1) {
			print "def printf(format, *args):\n    sys.stdout.write(format % args)\n";
			$addPrintfSub = 0;
		}
	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
		# Blank & comment lines can be passed unchanged
		print $line;
	}elsif (index($line, "printf") != -1) {
		chomp $line;
		handlePrintf($line);
	}elsif ($line =~ /\s*print\s*"\s*\$ARGV\[\s*\$(.*?)\s*\]\s*\\n\s*"\s*[\s;]*$/) {
		$pp = $1;
		handleArgvPrint($pp);
	}elsif($line =~ /^\s*print\s*(.*)\s*,\s*"\\n"[\s;]*$/) {
		#printWithComma();
		printWithComma2($line);
	}elsif ($line =~ /^\s*print\s*"(.*)\\n"[\s;]*$/) {
		regularPrint();
	}elsif($line =~ /^\s*print\s*([^;]*)\s*[\s;]*$/) {
		printWithoutNewLine();
	}elsif ($line =~ /^\s*\$(.*)\s*=~\s*(.*)\/(.*)\/(.*)\/(.*?)[\s;]*$/) {
		handleRegExpr();
	}elsif ($line =~ /^\s*\$\s*([^ ]*)\s*=\s*(.*)[\s;]*$/) {
		variables();
	}elsif($line =~ /^\s*\}\s*elsif\s*\(\s*(.*)\s*\)\s*\{\s*/ or $line =~ /^\s*\}\s*elsif\s*\(\s*(.*)\s*\)\s*/) {
		if($ifClosingParanthesis > 0) { # it has to be one
		    #do nothing
		    $ifClosingParanthesis--;
		    $ifIndentation--;
		}elsif($elsifClosingParanthesis > 0) { # it has to be one
		    #do nothing
		    $elsifClosingParanthesis--;
		    $elsifIndentation--;
		}
		$elsifClosingParanthesis++;
		handleelsIf();
		$elsifIndentation++;
	}elsif($line =~ /^\s*elsif\s*\(\s*(.*)\s*\)\s*\{\s*/ or $line =~ /^\s*elsif\s*\(\s*(.*)\s*\)\s*/) {
		$elsifClosingParanthesis++;
		handleelsIf();
		$elsifIndentation++;
	}elsif($line =~ /^\s*\}\s*else\s*\{\s*/ or $line =~ /^\s*\}\s*else\s*/) {
		if($ifClosingParanthesis > 0) { # it has to be one
		    #do nothing
		    $ifClosingParanthesis--;
		    $ifIndentation--;
		}elsif($elsifClosingParanthesis > 0) {
			 $elsifClosingParanthesis--;
			 $elsifIndentation--;
		}
		$elseClosingParanthesis++;
		handleelse();
		$elseIndentation++;
	}elsif($line =~ /^\s*else\s*\{\s*/ or $line =~ /^\s*else\s*/) {
		$elseClosingParanthesis++;
		handleelse();
		$elseIndentation++;
	}elsif($line =~ /^\s*if\s*\(\s*(.*)\s*\)\s*\{\s*/ or $line =~ /^\s*if\s*\(\s*(.*)\s*\)\s*/) {
		$ifClosingParanthesis++;
		handleIf();
		$ifIndentation++;
	}elsif($line =~ /^\s*\{\s*/) {
		#do nothing 
	}elsif($line =~ /^\s*chomp\s*\$\s*(.*)\s*[\s;]*$/) {
		handleChomp();
	}elsif($line =~ /^\s*\}\s*/) {
		if($ifClosingParanthesis > 0) {
		    #do nothing
		    $ifClosingParanthesis--;
		    $ifIndentation--;
		}elsif($whileClosingParanthesis > 0) {
		    #do nothing
		    $whileClosingParanthesis--;
		    $whileIndentation--;
		}elsif($forClosingParanthesis > 0) {
			#do nothing
		    $forClosingParanthesis--;
		    $forIndentation--;
		}elsif($elsifClosingParanthesis > 0) {
			#do nothing
		    $elsifClosingParanthesis--;
		    $elsifIndentation--;
		}elsif($elseClosingParanthesis > 0) {
			#do nothing
		    $elseClosingParanthesis--;
		    $elseIndentation--;
		}		
		else {
		  print "}\n";
		}
	}elsif($line =~ /^\s*while\s*\(\s*(.*)\s*\)\s*\{\s*/ or $line =~ /^\s*while\s*\(\s*(.*)\s*\)\s*/) {
	       $whileClosingParanthesis++;
	       my $p;
	       $p = $1;
	       if (index($p, "(sys.stdin.readline\(\)") != -1 or index($p, "sys.stdin.readline\(\)") != -1) {
			   handleWhileWithStdin($p);
		   }elsif(index($p, $anyInputClause) != -1) {
			   handleWhileWithAnyInput($p);
		   }else {
				handleWhileStatement();
			}
	       $whileIndentation++;
	}elsif($line =~ /^\s*last[\s;]*$/) {
	       handleLastStatement();
	}elsif($line =~ /^\s*next[\s;]*$/) {
	       handleNextStatement();
	}elsif($line =~ /^\s*for\s*/) {
		#foreach
		if($line =~ /^\s*foreach\s*\$\s*(.*)\s*\((.*)\.\.(.*)\)\s*\{\s*/ or $line =~ /^\s*foreach\s*\$\s*(.*)\s*\((.*)\.\.(.*)\)\s*/) {
			$forClosingParanthesis++;
			$parr = $3;
			handleForStatement($parr);
			$forIndentation++;
		}elsif($line =~ /^\s*foreach\s*\$\s*(.*)\s*\((.*)\)\s*\{\s*/ or $line =~ /^\s*foreach\s*\$\s*(.*)\s*\((.*)\)\s*/) {
			$forClosingParanthesis++;
			my $param;
			#if($2 eq "\@ARGV") {
			#	$param = "sys.argv[1:]";
			#}else{#TODO bunu gerektigi sekilde duzelteceksin
				$param = $2;
				$param =~ tr/\$//d;
			#}
			print "for $1 in $param:\n";
			$forIndentation++;
		}
		#TODO implement c like for function and foreach range de variable olabilir($)
		
	}
	else {
		# Lines we can't translate are turned into comments
		print "#$line\n";
	}
}
