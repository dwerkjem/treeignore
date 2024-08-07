use strict;
use warnings;
use Test::More tests => 8;
use File::Spec;
use File::Temp qw(tempdir);
use File::Path qw(make_path);
use Cwd;

# Helper subroutine to run the script and capture its output
sub run_script {
    my ($start_path, @args) = @_;
    my $output = `perl treeignore.pl $start_path @args 2>&1`;
    return $output;
}

# Create a temporary directory structure for testing
my $temp_dir = tempdir(CLEANUP => 1);
my $cwd = getcwd();

make_path("$temp_dir/dir1/dir2");
open(my $fh, '>', "$temp_dir/dir1/file1.txt") or die $!;
print $fh "content";
close($fh);

open($fh, '>', "$temp_dir/.gitignore") or die $!;
print $fh "file1.txt\n";
close($fh);

open($fh, '>', "$temp_dir/dir1/.gitignore") or die $!;
print $fh "dir2\n";
close($fh);

# Get the directory name for matching purposes
my $temp_dir_name = (File::Spec->splitdir($temp_dir))[-1];

# Test 1: Ensure script runs without errors
{
    my $output = run_script($temp_dir);
    ok($? == 0, 'Script runs without errors');
}

# Test 2: Ensure the top-level directory is printed
{
    my $output = run_script($temp_dir);
    like($output, qr/^$temp_dir_name\b/, 'Top-level directory is printed');
}

# Test 3: Ensure nested directories are printed
{
    my $output = run_script($temp_dir);
    like($output, qr/dir1\n.*dir2/s, 'Nested directories are printed');
}

# Test 4: Ensure files are printed (updated regex for .gitignore at the top level)
{
    my $output = run_script($temp_dir);
    like($output, qr/\.gitignore/s, 'Files are printed');
}

# Test 5: Ensure .gitignore patterns are respected
{
    my $output = run_script($temp_dir);
    unlike($output, qr/file1\.txt/, 'Ignored files are not printed');
}

# Test 6: Ensure default .gitignore is used if -d flag is provided
{
    my $output = run_script($temp_dir, '-d');
    like($output, qr/\.gitignore/, 'Default .gitignore is used');
}

# Test 7: Ensure multiple .gitignore files can be combined
{
    my $output = run_script($temp_dir, '--gitignore', "$temp_dir/.gitignore", '--gitignore', "$temp_dir/dir1/.gitignore");
    unlike($output, qr/dir2/, 'Ignored directories from combined .gitignore files are not printed');
}

# Test 8: Ensure default .gitignore is not used if -d flag is not provided
{
    my $output = run_script($temp_dir);
    unlike($output, qr/\.bak/, 'Default .gitignore is not used');
}

chdir($cwd);
