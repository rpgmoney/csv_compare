#!/usr/bin/perl
# Source encoded in utf-8
use strict;
use warnings;
use Text::CSV_XS;
my $filename = "compare_".time();
my $gfile = $filename.".csv";
open(MYGFILE, ">$gfile") or die "File: $gfile open error\n";   
my $csv = Text::CSV_XS->new ({ binary => 1 }) or die "Cannot use CSV: ".Text::CSV->error_diag ();
my $csv2 = Text::CSV_XS->new ({ binary => 1 }) or die "Cannot use CSV: ".Text::CSV->error_diag ();
my $file = $ARGV[0];
my $file2 = $ARGV[1];
#my $file = 'data1_2_1_import.csv';
#my $file2 = 'data1_2_1_export.csv';
my $rows = 0;
my $field_count = 1;   
open (CSV, "<", $file) or die $!;
while(<CSV>)
{
    my $status = $csv->parse($_);
    my @columns = $csv->fields();
    if($rows != 0)
    {
        my $rows2 = 0;
        my $compare = 0;  
        open (CSV2, "<", $file2) or die $!;
        while(<CSV2>)
        {
            my $status2 = $csv2->parse($_);
            my @columns2 = $csv2->fields();
            if($rows2 != 0)
            {
                my $e = 0;
                for(my $i=0;$i<=$field_count;$i++)
                {
                    if($columns[$i] ne $columns2[$i])
                    {
                        $e = 1;
                        last;
                    }
                }
                if(0 == $e)
                {
                    $compare = 1;
                    last;
                }
            }
            $rows2++; 
        }
        if($compare == 0)
        {
            #print MYGFILE $columns[0]. ", " . $columns[1] . ", " . $columns[2] . ", ". $columns[3] . ", " . $columns[4] . "\n";
            print MYGFILE "@columns \n";
        }
    }
    else
    {
        $field_count = $#columns;
    }
    $rows++;
}