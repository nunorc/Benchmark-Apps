# NAME

Benchmark::Apps - simple interface to benchmark applications.

# VERSION

version 0.05

# SYNOPSIS

This module provides a simple interface to benchmark applications (not
necessarily Perl applications).

    use Benchmark::Apps;

    my $commands = {
         cmd1 => 'run_command_1 with arguments',
         cmd2 => 'run_command_2 with other arguments',
       };

    my $conf = { pretty_print=>1, iters=>5 };

    Benchmark::Apps::run( $commands, $conf );

# DESCRIPTION

This module can be used to perform simple benchmarks on programs. Basically,
it can be used to benchmark any program that can be called with a system
call.

# FUNCTIONS

## run

This function is used to run benchmarks. It runs the commands described in 
the hash passed as argument. It returns an hash of the results each command.
A second hash reference can be passed to this function: a configuration
hash reference. The values passed in this hash override the default
behaviour of the run function. The configuration options available at this
moment are:

- `pretty_print`

    When enabled it will print to stdout, in a formatted way the results
    of the benchmarks as they finish running. This option should de used
    when you want to run benchmarks and want to see the results progress
    as the tests run. You can disable it, so you can perform automated
    benchmarks.

    Options: true (1) or false (0)

    Default: false (0)

- `iters`

    This is the number of iterations that each test will run.

    Options: integer greater than 1

    Default: 5

- `args`

    This is a reference to an anonymous function that will calculate the
    command argument based on the iteraction number.

    Options: any function reference that returns a string

    Default: empty function: always returns an empty string, which means no
    arguments will be given to the command

## pretty\_print

This function is used to print the final result to STDOUT before returning 
from the `run` function.

## time\_this

This function is not meant to be used directly, although it can be useful.
It receives a command line and executes it via system, taking care
of registering the elapsed time.

Benchmark::Apps - Simple interface to benchmark applications.

# EXAMPLES

Check files in `examples/`.

# AUTHORS

- Alberto Simões <ambs@cpan.org>
- Nuno Carvalho <smash@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 - 2017 by Projecto Natura <natura@natura.di.uminho.pt>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
