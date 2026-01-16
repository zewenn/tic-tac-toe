const std = @import("std");
const kb_input = @import("kb_input");
const Grid = @import("Grid.zig").Grid;

const ALLOCATOR = std.heap.smp_allocator;

pub fn main() !void {
    var main_grid = try Grid(Grid(u8)).init(ALLOCATOR, 3, 3);
    defer {
        for (main_grid.data) |*element| {
            element.deinit();
        }
        main_grid.deinit();
    }

    for (main_grid.data) |*element| {
        element.* = try .init(ALLOCATOR, 3, 3);
        for (element.data) |*child| {
            child.* = 0;
        }
    }

    try kb_input.init(ALLOCATOR);
    defer kb_input.deinit();

    var running = true;
    while (running) {
        kb_input.update();

        if (kb_input.getKeyDown('q')) {
            running = false;
        }
    }
}
