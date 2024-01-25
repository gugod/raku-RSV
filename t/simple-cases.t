use Test;
use RSV;

my @cases = (
    # [[],] => blob8.new(),
    [[Nil],] => blob8.new(254,255,253),
    [["",Nil],] => blob8.new(255,254,255,253),
    [["",Nil],["",Nil],] => blob8.new(255,254,255,253, 255,254,255,253),
    [[Nil,"",Nil],] => blob8.new(254,255, 255, 254,255, 253),
);

for @cases {
    my (@rows, $rsv) := .kv;
    is to-rsv(@rows), $rsv, @rows.raku;
}
