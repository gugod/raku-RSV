module RSV {
    constant \EOV = blob8.new(255);
    constant \EOR = blob8.new(253);
    constant \NULL = blob8.new(254);

    sub to-rsv (@rows --> blob8) is export {
        blob8.new: |<< @rows.map(-> @values { [~] (|@values.map({ (.defined ?? .encode("utf-8") !! NULL) ~ EOV }), EOR) })
    }

    sub from-rsv (blob8 $rsv) is export {
        my $i = 0;
        my @rows := [];
        my @values := [];
        for 0..$rsv.end -> $j {
            given $rsv.subbuf($j,1) {
                when EOV {
                    @values.push: do given $rsv.subbuf($i..^$j) {
                        when NULL { Nil }
                        when Nil { "" }
                        default { .decode("utf-8") }
                    };
                    $i = $j+1;
                }
                when EOR {
                    @rows.push(@values);
                    @values := [];
                    $i = $j+1;
                }
            }
        }

        return @rows
    }
}

=begin pod

=head1 NAME

RSV - encoder and decoder of Rows of String Values

=head1 SYNOPSYS

=begin code :lang<raku>

use RSV;

my blob8 $rsv = to-rsv(@array);
my @array2 = from-rsv($rsv);

=end code

=head1 DESCRIPTION

RSV is a binary format for storing simple string values. As the name suggest, it support only Rows of String Values. It is not a generic serialization framework, but more of a replacement of CSV or TSV.

The C<RSV> module provide two functions: C<to-rsv> and C<from-rsv>.
                                                                                         C<to-rsv> function is a RSV encoder that produces a blob8 value from the given input. The input must be an array, in which each element must be an array of string or null value. Or in a more concise type-annotion: C<Array[Array[String|Nil]]>

=head1 REFERENCES

RSV: L<https://github.com/Stenway/RSV-Specification>

=end pod
