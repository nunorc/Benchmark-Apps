package Benchmark::Apps;
# ABSTRACT: simple interface to benchmark applications.

use warnings;
use strict;

use Time::HiRes qw.gettimeofday tv_interval.;

sub _empty { '' }

my %cfg = ( pretty_print => 1,
            iters        => 5 ,
            args         => \&_empty );
my %command = ();
my %res = ();

sub run {
	my @args = @_;

	@args == 0 and die 'At least one hash reference needs to be passed as argument';
	@args > 2 and die 'A maximum of two arguments (hash refs) should be passed to this function';
	# in case we got the second argument (configuration hash ref)
	if (@args > 1) {
            if (ref $args[1] eq 'HASH') {
   		my @l = keys %{$args[1]};
   		foreach (@l) {
                    if (defined $args[1]{$_}) { # XXX and validate args
         		$cfg{$_} = $args[1]{$_};
                    }
   		}
            }
            else { warn 'Second argument to run should be an hash ref'; }
	}

	%command = %{$args[0]};

	for my $iter (1..$cfg{'iters'}) {
		for my $c (keys %command) {
			$res{$c}{'run'} = $command{$c};
			my $time = time_this($command{$c}.' '.&{$cfg{'args'}}($iter));
			$res{$c}{'result'}{$iter} = $time;
		}
	}

	pretty_print(%res) if $cfg{'pretty_print'};

	return +{%res};
}

sub _validate_option {
	my ($option, $value) = @_;

	# TODO do some validations
	# everything ok for now

	return 1;
}

sub pretty_print {
	my $self = shift;

  	for my $iter (1..$cfg{'iters'}) {
     	_show_iter($iter);

     	for my $c (keys %command) {
        	printf " %8s => %8.4f s\n", $c, $res{$c}{'result'}{$iter};
     	}
	}
}

sub _show_iter {
	my $i = shift;
	printf "%d%s iteration:\n", $i, $i==1?"st":$i==2?"nd":$i==3?"rd":"th";
}

sub time_this {
	my $cmd_line = shift;
	my $start_time = [gettimeofday];
	system("$cmd_line 2>&1 > /dev/null");
	return tv_interval($start_time);
}

1;

__END__

=encoding UTF-8

=head1 SYNOPSIS

This module provides a simple interface to benchmark applications (not
necessarily Perl applications).

  use Benchmark::Apps;

  my $commands = {
       cmd1 => 'run_command_1 with arguments',
       cmd2 => 'run_command_2 with other arguments',
     };

  my $conf = { pretty_print=>1, iters=>5 };

  Benchmark::Apps::run( $commands, $conf );

=head1 DESCRIPTION

This module can be used to perform simple benchmarks on programs. Basically,
it can be used to benchmark any program that can be called with a system
call.

=func run

This function is used to run benchmarks. It runs the commands described in 
the hash passed as argument. It returns an hash of the results each command.
A second hash reference can be passed to this function: a configuration
hash reference. The values passed in this hash override the default
behaviour of the run function. The configuration options available at this
moment are:

=over 4

=item C<pretty_print>

When enabled it will print to stdout, in a formatted way the results
of the benchmarks as they finish running. This option should de used
when you want to run benchmarks and want to see the results progress
as the tests run. You can disable it, so you can perform automated
benchmarks.

Options: true (1) or false (0)

Default: false (0)

=item C<iters>

This is the number of iterations that each test will run.

Options: integer greater than 1

Default: 5

=item C<args>

This is a reference to an anonymous function that will calculate the
command argument based on the iteraction number.

Options: any function reference that returns a string

Default: empty function: always returns an empty string, which means no
arguments will be given to the command

=back

=func pretty_print

This function is used to print the final result to STDOUT before returning 
from the C<run> function.


=func time_this

This function is not meant to be used directly, although it can be useful.
It receives a command line and executes it via system, taking care
of registering the elapsed time.

=head1 EXAMPLES

Check files in C<examples/>.

