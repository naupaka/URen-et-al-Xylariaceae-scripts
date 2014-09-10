#!env perl
use strict;
use warnings;

use Bio::DB::GenBank;
use Bio::SeqIO;
use Getopt::Long;

# remote retrieval of sequences from GenBank
my $db = Bio::DB::GenBank->new;

my $cache = 'cache';
mkdir($cache) unless -d $cache;

my $debug = 0;
GetOptions(
    'c|cache:s' => \$cache,
    'v|debug!'  => \$debug,
    );

my $infile = shift || 'test.fa'; # provide filename on cmdline

open(my $fh => $infile) || die $!;
# in Jana's example the input file is a FASTA file of the 
# sequences where the name we want to investigate is the 
# accession number encoded in the ID like
# >DQ068350_fungal_sp_VI7
# we can just use regular perl parsing

# if you want to change this where you just provide a simple file of
# IDs (either accession numbers, GI numbers, or some other ID
# that will also work, but will need to change this next loop

my @ids;
while(<$fh>) {
    if( /^>(\S+)/) {
	my $id = $1;
	# accession is the first value of this string
	# in Jana's example
	my ($acc) = split(/_/,$id);
	push @ids, $acc;
    } 
}

my $out = Bio::SeqIO->new(-format => 'genbank');
for my $id (@ids ) {
    my $cache_file = File::Spec->catfile($cache,"$id.gbk");
    my $seq;
    if( ! -f $cache_file ) {
	$seq = $db->get_Seq_by_acc($id);
	if( $seq ) {
	    Bio::SeqIO->new(-format => 'genbank',
			    -file =>">".$cache_file)->write_seq($seq);
	} else {
	    warn("cannot find seq $seq\n");
	}
    } else {
	$seq = Bio::SeqIO->new(-format => 'genbank',
			       -file => $cache_file)->next_seq;
    }
    print $id, "\n";
    for my $feature ( $seq->get_SeqFeatures() ) {	
	if( $feature->primary_tag eq 'source' ) {
	    for my $tag ( $feature->get_all_tags ) {
		next if( $tag =~ /PCR_primers/ );
		print join("\t", '',$tag, 
			   join(";", $feature->get_tag_values($tag))),"\n";
	    }
	}
    }
    last if $debug;
}