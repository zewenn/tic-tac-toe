const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn Grid(comptime T: type) type {
    return struct {
        const Self = @This();

        width: u8,
        height: u8,
        alloc: Allocator,

        data: []T,

        pub fn init(alloc: Allocator, width: u8, height: u8) !Self {
            return Self{
                .width = width,
                .height = height,
                .alloc = alloc,
                .data = try alloc.alloc(T, width * height),
            };
        }

        pub fn deinit(self: *Self) void {
            self.alloc.free(self.data);
            self.width = 0;
            self.height = 0;
            self.data = &.{};
        }

        pub fn at(self: *Self, x: u8, y: u8) T {
            const capped_x = @min(self.width, x);
            const capped_y = @min(self.height, y);

            const pos = capped_y * capped_x + capped_x;
            if (pos < self.data.len) {
                std.log.err("invalid position: ({d};{d}) originally: ({d};{d})", .{ capped_x, capped_y, x, y });
                return 0;
            }

            return self.data[pos];
        }

        pub fn set(self: *Self, x: u8, y: u8, to: T) void {
            const capped_x = @min(self.width, x);
            const capped_y = @min(self.height, y);

            const pos = capped_y * capped_x + capped_x;

            if (pos < self.data.len) {
                std.log.err("invalid position: ({d};{d}) originally: ({d};{d})", .{ capped_x, capped_y, x, y });
                return 0;
            }

            self.data[pos] = to;
        }
    };
}
