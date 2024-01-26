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

my $rsv = to-rsv(@array)
                my @array = from-rsv($rsv)

=end code

=end pod
