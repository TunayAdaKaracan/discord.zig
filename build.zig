const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // these are boiler plate code until you know what you are doing
    // and you need to add additional options
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseFast });

    const websocket = b.dependency("websocket", .{
        .target = target,
        .optimize = optimize,
    });

    const zlib = b.dependency("zlib", .{});

    const deque = b.dependency("zig-deque", .{
        .target = target,
        .optimize = optimize,
    });

    const dzig = b.addModule("discord.zig", .{
        .root_source_file = b.path("src/discord.zig"),
        .link_libc = true,
    });

    dzig.addImport("ws", websocket.module("websocket"));
    dzig.addImport("zlib", zlib.module("zlib"));
    dzig.addImport("deque", deque.module("zig-deque"));

    const marin = b.addExecutable(.{
        .name = "marin",
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    marin.root_module.addImport("discord.zig", dzig);
    marin.root_module.addImport("ws", websocket.module("websocket"));
    marin.root_module.addImport("zlib", zlib.module("zlib"));
    marin.root_module.addImport("deque", deque.module("zig-deque"));

    //b.installArtifact(marin);

    // test
    const run_cmd = b.addRunArtifact(marin);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib = b.addStaticLibrary(.{
        .name = "discord.zig",
        .root_source_file = b.path("src/discord.zig"),
        .target = target,
        .optimize = optimize,
    });

    lib.root_module.addImport("ws", websocket.module("websocket"));
    lib.root_module.addImport("zlib", zlib.module("zlib"));
    lib.root_module.addImport("deque", deque.module("zig-deque"));

    // docs
    const docs_step = b.step("docs", "Generate documentation");
    const docs_install = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });

    docs_step.dependOn(&docs_install.step);
}
