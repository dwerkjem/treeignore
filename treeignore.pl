use strict;
use warnings;
use File::Find;
use File::Spec;
use File::Basename;

# Load .gitignore patterns
sub load_gitignore_patterns {
    my $gitignore_file = shift;
    my @patterns;

    if (open my $fh, '<', $gitignore_file) {
        while (my $line = <$fh>) {
            chomp $line;
            next if $line =~ /^\s*#/; # Skip comments
            next if $line =~ /^\s*$/; # Skip empty lines
            push @patterns, $line;
        }
        close $fh;
    }

    return @patterns;
}

# Check if a path matches any ignore pattern
sub is_ignored {
    my ($path, $patterns) = @_;
    foreach my $pattern (@$patterns) {
        return 1 if ($path =~ /$pattern/);
    }
    return 0;
}

# Print the project tree
sub print_tree {
    my ($directory, $patterns, $prefix) = @_;
    $prefix ||= '';

    opendir my $dh, $directory or die "Cannot open directory $directory: $!";
    my @entries = sort { lc($a) cmp lc($b) } grep { $_ ne '.' && $_ ne '..' } readdir $dh;
    closedir $dh;

    foreach my $i (0 .. $#entries) {
        my $entry = $entries[$i];
        my $path = File::Spec->catfile($directory, $entry);
        my $connector = ($i < $#entries) ? '├── ' : '└── ';

        if (!is_ignored($entry, $patterns)) {
            print "$prefix$connector$entry\n";
            if (-d $path) {
                my $new_prefix = $prefix . (($i < $#entries) ? '│   ' : '    ');
                print_tree($path, $patterns, $new_prefix);
            }
        }
    }
}

# Generate the project tree
sub generate_project_tree {
    my $start_path = shift || '.';
    my @patterns = load_gitignore_patterns(File::Spec->catfile($start_path, '.gitignore'));

    my ($vol, $dirs, $file) = File::Spec->splitpath($start_path);
    my $root_name = ($file) ? $file : basename($dirs);

    print "$root_name\n";
    print_tree($start_path, \@patterns, '');
}

# Main
generate_project_tree(shift @ARGV);
