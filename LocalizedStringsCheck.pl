#!/usr/bin/perl -w

# settings:
# .swift files may be set as well, just set "swift" if needed
    my $sourceFileExtension = "m";

# if set, the script will only check Localizable.strings files, otherwse all available .strings files
    my $stringsFileName = "Localizable.strings"; 

# set if you are using shorthand macros wrapping NSLocalizedString, otherwise keep the default "_" value
    my $NSLocalizedStringMacros = "_"; 

# the script recursively looks through all subdirectories
    my $projectPath = "/Users/username/Documents/ProjectName"; 


use File::Slurp;
use strict;
use warnings;

sub get_all_files {
    my ($extension, $path, $fname) = (@_);
    
    opendir (DIR, $path)
    or die "Unable to open $path: $!";
    
    my @files =
    map { $path . '/' . $_ }
    grep { !/^\.{1,2}$/ }
    readdir (DIR);
    
    # Rather than using a for() loop, we can just
    # return a directly filtered list.
    my $grepRegEx;
    if (defined($fname) && $fname ne ""){
        $grepRegEx = "$fname";
    } else {
        $grepRegEx = "\.$extension\$";
    }
    return
    grep { (/$grepRegEx/) &&
        (! -l $_) }
    map { -d $_ ? get_all_files($extension, $_, $fname) : $_ }
    @files;
}

# collect all .m files
my @mFiles = get_all_files($sourceFileExtension, $projectPath);

# collect all used strings from .m files
my @allUsedStrings;
foreach my $i (@mFiles) {
    my $text = read_file($i);
    while ($text =~ m {(?:$NSLocalizedStringMacros|NSLocalizedString)\s*\(\s*@("(?:)|(?:.*?)[^\\]")?(?:\s*,\s*.*)?\s*\)}g){
        my $string = $1;
        push @allUsedStrings, $string;
    }
}
my @usedStrings = do { my %seen; grep { !$seen{$_}++ } @allUsedStrings };


# collect all available strings from .strings
my @stringsFiles = get_all_files("", $projectPath, $stringsFileName);

# collect all available strings from .stirngs files
my @allAvailableStrings;
foreach my $i (@stringsFiles) {
    my $text = read_file($i);
    while ($text =~ m {(?:("(?:.*?)[^\\]")\s*=\s*".*?"\s*;)}g){
        my $string = $1;
        push @allAvailableStrings, $string;
    }
}
my @availableStrings = do { my %seen; grep { !$seen{$_}++ } @allAvailableStrings };


#output 1
{
    print "UNLOCALIZED STRINGS:\n";
    my %in_bl = map {$_ => 1} @availableStrings;
    my @diff  = grep {not $in_bl{$_}} @usedStrings;
    foreach my $string (@diff) {
        print "    $string\n";
    }
}
print "\n\n";

#output 2
{
    print "UNUSED LOCALIZED STRINGS:\n";
    my %in_bl = map {$_ => 1} @usedStrings;
    my @diff  = grep {not $in_bl{$_}} @availableStrings;
    foreach my $string (@diff) {
        print "    $string\n";
    }
}
