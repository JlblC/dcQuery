##### dcQuery v0.2.1 https://github.com/JlblC/dcQuery
sub _ {
	local $_=$_;
	my $arg;
	foreach $arg (@_) {
		$_=_1($arg);
	}
	return @{$_} if ref $_ eq "ARRAY";
	return $_;

	sub _1 {		
		return _s($_[0]) if ref \$_[0] eq "SCALAR";
		return &{$_[0]} if ref $_[0] eq "CODE";
		return $_[0] if index(ref $_[0],"Safe::Hole::main")!=-1;
		$Empire->log(3,"dcQuery ERROR type parametr type ". ref $_[0]);		
	}

	sub _s {
		my @result;
		if (index($_[0],',')!=-1){			
			foreach $el (split /,/,$_[0]) {push @result,_s($el)};	
			return \@result;
		}
		if (index($_[0],'$')==0){			
			return $Empire->readVariable(_s(substr $_[0],1)) ;	
		}		
		if (index($_[0],':')!=-1){			
			foreach $el (split /:/,$_[0]) {push @result,_s($el)};	
			return join ":",@result;	
		}
		if (index($_[0],'.')!=-1){			
			foreach $el (split /\./,$_[0]) {push @result,_s($el)};	
			return join "",@result;	
		}
		
		if (index($_[0],'^')!=-1){
			my ($a,$b)=split /\^/,$_[0];
			local $_=_s($a) if $a;
			$b ? / \Q$b\E="([^\"]*)"/ : /<(\S+)\b/;
			return $1;			
		}
				
		return substr($_[0],1) if index($_[0],'`')==0;
		return $_->getProp($_[0]) if defined $_->getProp($_[0]);
		$Empire->log(3,"dcQuery ERROR parametr ".$_[0])
	}
}