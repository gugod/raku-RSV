use Test;
use RSV;

my @cases = (
    [] => blob8.new(),
    [[],] => blob8.new(253),
    [[""],] => blob8.new(255,253),
    [[Nil],] => blob8.new(254,255,253),
    [["",Nil],] => blob8.new(255,254,255,253),
    [["",Nil],["",Nil],] => blob8.new(255,254,255,253, 255,254,255,253),
    [[Nil,"",Nil],] => blob8.new(254,255, 255, 254,255, 253),

    # The same example as seen in the Simple RSV Example
    # https://github.com/Stenway/RSV-Specification#simple-rsv-example
    [["Hello", "🌎"],[],[Nil,""]] => blob8.new(
        # 1st row
        72,101,108,108,111, # Hello
        255,                # <EOV>
        240,159,140,142,    # 🌎
        255,                # <EOV>
        253,                # <EOR>

        # 2nd row (an empty row. no values, and thus no EOVs)
        253,                # <EOR>

        # 3rd row
        254,                # <NULL>
        255,                # <EOV>
        255,                # <EOV>
        253,                # <EOR>
    ),
);

for @cases {
    my (@rows, $rsv) := .kv;
    is to-rsv(@rows), $rsv, "to-rsv: " ~ @rows.raku;

    my $rsv2 = from-rsv($rsv);
    unless (is-deeply $rsv2, @rows, "from-rsv: " ~ @rows.raku) {
        note "# RSV: " ~ $rsv.gist;
    }
}
