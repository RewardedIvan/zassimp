const std = @import("std");

pub fn addAssimp(step: *std.Build.Step.Compile, b: *std.Build) void {
    const assimp = b.dependency("assimp", .{});
    const tinyusdz = b.dependency("tinyusdz", .{});

    step.linkLibC();
    step.linkLibCpp();

    const assimp_config = b.addConfigHeader(
        .{
            .style = .{ .cmake = assimp.path("include/assimp/config.h.in") },
            .include_path = "assimp/config.h",
        },
        .{ .ASSIMP_DOUBLE_PRECISION = false },
    );

    const assimp_revision_config = b.addConfigHeader(
        .{
            .style = .{ .cmake = assimp.path("include/assimp/revision.h.in") },
            .include_path = "assimp/revision.h",
        },
        .{
            .GIT_COMMIT_HASH = "DEADBEEF",
            .GIT_BRANCH = "DEADBEEF",
            .ASSIMP_VERSION_MAJOR = 0,
            .ASSIMP_VERSION_MINOR = 0,
            .ASSIMP_VERSION_PATCH = 0,
            .ASSIMP_PACKAGE_VERSION = 0,
            .CMAKE_SHARED_LIBRARY_PREFIX = "",
            .LIBRARY_SUFFIX = "",
            .CMAKE_DEBUG_POSTFIX = "",
        },
    );

    step.addConfigHeader(assimp_config);
    step.addConfigHeader(assimp_revision_config);

    const zlib_config = b.addConfigHeader(
        .{
            .style = .{ .cmake = assimp.path("contrib/zlib/zconf.h.in") },
            .include_path = "zconf.h",
        },
        .{},
    );

    step.addConfigHeader(zlib_config);

    // only way i could think of to alias a header file
    const meshlab_hack = b.addConfigHeader(
        .{
            .style = .{ .cmake = b.path("meshlab/Parser.h") },
            .include_path = "contrib/meshlab/autoclone/meshlab_repo-src/src/meshlabplugins/io_x3d/vrml/Parser.h",
        },
        .{},
    );

    step.addConfigHeader(meshlab_hack);
    step.addIncludePath(b.path("meshlab"));
    step.addCSourceFiles(.{
        .files = &.{ "Parser.cpp", "Scanner.cpp" },
        .root = b.path("meshlab"),
    });

    step.addIncludePath(tinyusdz.path("src"));
    step.addCSourceFiles(.{
        .files = &.{
            "src/asset-resolution.cc",
            "src/tinyusdz.cc",
            "src/xform.cc",
            "src/performance.cc",
            "src/ascii-parser.cc",
            "src/ascii-parser-basetype.cc",
            "src/ascii-parser-timesamples.cc",
            "src/ascii-parser-timesamples-array.cc",
            "src/audio-loader.cc",
            "src/usda-reader.cc",
            "src/usdc-reader.cc",
            "src/usda-writer.cc",
            "src/usdc-writer.cc",
            "src/composition.cc",
            "src/crate-reader.cc",
            "src/crate-format.cc",
            "src/crate-writer.cc",
            "src/crate-pprint.cc",
            "src/path-util.cc",
            "src/prim-reconstruct.cc",
            "src/prim-composition.cc",
            "src/prim-types.cc",
            "src/primvar.cc",
            "src/str-util.cc",
            "src/value-pprint.cc",
            "src/value-types.cc",
            "src/tiny-format.cc",
            "src/io-util.cc",
            "src/image-loader.cc",
            "src/image-writer.cc",
            "src/image-util.cc",
            "src/linear-algebra.cc",
            "src/usdGeom.cc",
            "src/usdSkel.cc",
            "src/usdShade.cc",
            "src/usdLux.cc",
            // usdMtlX has less dependency(pugixml), so add it to core component
            "src/usdMtlx.cc",
            "src/usdObj.cc",
            "src/image-loader.cc",
            "src/pprinter.cc",
            "src/stage.cc",
            "src/stage.hh",
            "src/tydra/facial.cc",
            "src/tydra/facial.hh",
            "src/tydra/prim-apply.cc",
            "src/tydra/prim-apply.hh",
            "src/tydra/scene-access.cc",
            "src/tydra/scene-access.hh",
            "src/tydra/attribute-eval.hh",
            "src/tydra/attribute-eval.cc",
            "src/tydra/attribute-eval-typed.cc",
            "src/tydra/attribute-eval-typed-animatable.cc",
            "src/tydra/attribute-eval-typed-fallback.cc",
            "src/tydra/attribute-eval-typed-animatable-fallback.cc",
            "src/tydra/obj-export.cc",
            "src/tydra/usd-export.cc",
            "src/tydra/shader-network.cc",
            "src/tydra/shader-network.hh",
            "src/tydra/render-data.cc",
            "src/tydra/render-data.hh",
            "src/tydra/texture-util.cc",
            "src/tydra/texture-util.hh",
            "src/integerCoding.cpp",
            "src/lz4-compression.cc",
            "src/lz4/lz4.c",
        },
        .root = tinyusdz.path(""),
    });

    step.addIncludePath(assimp.path(""));
    step.addIncludePath(assimp.path("include"));
    step.installHeadersDirectory(assimp.path("include"), "", .{});
    step.addIncludePath(assimp.path("contrib"));
    step.addIncludePath(assimp.path("code"));
    step.addIncludePath(assimp.path("contrib/pugixml/src/"));
    step.addIncludePath(assimp.path("contrib/rapidjson/include"));
    step.addIncludePath(assimp.path("contrib/unzip"));
    step.addIncludePath(assimp.path("contrib/zlib"));
    step.addIncludePath(assimp.path("contrib/openddlparser/include"));
    step.addIncludePath(assimp.path("contrib/utf8cpp/source"));
    step.addIncludePath(assimp.path("contrib/tinyusdz"));

    step.addCSourceFiles(.{
        .files = &.{
            "code/CApi/AssimpCExport.cpp",
            "code/CApi/CInterfaceIOWrapper.cpp",
            "code/Common/AssertHandler.cpp",
            "code/Common/Assimp.cpp",
            "code/Common/Base64.cpp",
            "code/Common/BaseImporter.cpp",
            "code/Common/BaseProcess.cpp",
            "code/Common/Bitmap.cpp",
            "code/Common/CreateAnimMesh.cpp",
            "code/Common/Compression.cpp",
            "code/Common/DefaultIOStream.cpp",
            "code/Common/IOSystem.cpp",
            "code/Common/DefaultIOSystem.cpp",
            "code/Common/DefaultLogger.cpp",
            "code/Common/Exceptional.cpp",
            "code/Common/Exporter.cpp",
            "code/Common/Importer.cpp",
            "code/Common/ImporterRegistry.cpp",
            "code/Common/material.cpp",
            "code/Common/PostStepRegistry.cpp",
            "code/Common/RemoveComments.cpp",
            "code/Common/scene.cpp",
            "code/Common/SceneCombiner.cpp",
            "code/Common/ScenePreprocessor.cpp",
            "code/Common/SGSpatialSort.cpp",
            "code/Common/simd.cpp",
            "code/Common/SkeletonMeshBuilder.cpp",
            "code/Common/SpatialSort.cpp",
            "code/Common/StandardShapes.cpp",
            "code/Common/Subdivision.cpp",
            "code/Common/TargetAnimation.cpp",
            "code/Common/Version.cpp",
            "code/Common/VertexTriangleAdjacency.cpp",
            "code/Common/ZipArchiveIOSystem.cpp",
            "code/Geometry/GeometryUtils.cpp",
            "code/Material/MaterialSystem.cpp",
            "code/Pbrt/PbrtExporter.cpp",
            "code/PostProcessing/ArmaturePopulate.cpp",
            "code/PostProcessing/CalcTangentsProcess.cpp",
            "code/PostProcessing/ComputeUVMappingProcess.cpp",
            "code/PostProcessing/ConvertToLHProcess.cpp",
            "code/PostProcessing/DeboneProcess.cpp",
            "code/PostProcessing/DropFaceNormalsProcess.cpp",
            "code/PostProcessing/EmbedTexturesProcess.cpp",
            "code/PostProcessing/FindDegenerates.cpp",
            "code/PostProcessing/FindInstancesProcess.cpp",
            "code/PostProcessing/FindInvalidDataProcess.cpp",
            "code/PostProcessing/FixNormalsStep.cpp",
            "code/PostProcessing/GenBoundingBoxesProcess.cpp",
            "code/PostProcessing/GenFaceNormalsProcess.cpp",
            "code/PostProcessing/GenVertexNormalsProcess.cpp",
            "code/PostProcessing/ImproveCacheLocality.cpp",
            "code/PostProcessing/JoinVerticesProcess.cpp",
            "code/PostProcessing/LimitBoneWeightsProcess.cpp",
            "code/PostProcessing/MakeVerboseFormat.cpp",
            "code/PostProcessing/OptimizeGraph.cpp",
            "code/PostProcessing/OptimizeMeshes.cpp",
            "code/PostProcessing/PretransformVertices.cpp",
            "code/PostProcessing/ProcessHelper.cpp",
            "code/PostProcessing/RemoveRedundantMaterials.cpp",
            "code/PostProcessing/RemoveVCProcess.cpp",
            "code/PostProcessing/ScaleProcess.cpp",
            "code/PostProcessing/SortByPTypeProcess.cpp",
            "code/PostProcessing/SplitByBoneCountProcess.cpp",
            "code/PostProcessing/SplitLargeMeshes.cpp",
            "code/PostProcessing/TextureTransform.cpp",
            "code/PostProcessing/TriangulateProcess.cpp",
            "code/PostProcessing/ValidateDataStructure.cpp",
            "contrib/unzip/unzip.c",
            "contrib/unzip/ioapi.c",
            // "contrib/unzip/crypt.c",
            "contrib/zip/src/zip.c",
            "contrib/zlib/inflate.c",
            "contrib/zlib/infback.c",
            "contrib/zlib/gzclose.c",
            "contrib/zlib/gzread.c",
            "contrib/zlib/inftrees.c",
            "contrib/zlib/gzwrite.c",
            "contrib/zlib/compress.c",
            "contrib/zlib/inffast.c",
            "contrib/zlib/uncompr.c",
            "contrib/zlib/gzlib.c",
            // "contrib/zlib/contrib/testzlib/testzlib.c",
            // "contrib/zlib/contrib/inflate86/inffas86.c",
            // "contrib/zlib/contrib/masmx64/inffas8664.c",
            // "contrib/zlib/contrib/infback9/infback9.c",
            // "contrib/zlib/contrib/infback9/inftree9.c",
            // "contrib/zlib/contrib/minizip/miniunz.c",
            // "contrib/zlib/contrib/minizip/minizip.c",
            // "contrib/zlib/contrib/minizip/unzip.c",
            // "contrib/zlib/contrib/minizip/ioapi.c",
            // "contrib/zlib/contrib/minizip/mztools.c",
            // "contrib/zlib/contrib/minizip/zip.c",
            // "contrib/zlib/contrib/minizip/iowin32.c",
            // "contrib/zlib/contrib/puff/pufftest.c",
            // "contrib/zlib/contrib/puff/puff.c",
            // "contrib/zlib/contrib/blast/blast.c",
            // "contrib/zlib/contrib/untgz/untgz.c",
            "contrib/zlib/trees.c",
            "contrib/zlib/zutil.c",
            "contrib/zlib/deflate.c",
            "contrib/zlib/crc32.c",
            "contrib/zlib/adler32.c",
            "contrib/poly2tri/poly2tri/common/shapes.cc",
            "contrib/poly2tri/poly2tri/sweep/sweep_context.cc",
            "contrib/poly2tri/poly2tri/sweep/advancing_front.cc",
            "contrib/poly2tri/poly2tri/sweep/cdt.cc",
            "contrib/poly2tri/poly2tri/sweep/sweep.cc",
            "contrib/clipper/clipper.cpp",
            "contrib/openddlparser/code/OpenDDLParser.cpp",
            "contrib/openddlparser/code/OpenDDLExport.cpp",
            "contrib/openddlparser/code/DDLNode.cpp",
            "contrib/openddlparser/code/OpenDDLCommon.cpp",
            "contrib/openddlparser/code/Value.cpp",
            "contrib/openddlparser/code/OpenDDLStream.cpp",
            "code/AssetLib/3DS/3DSConverter.cpp",
            "code/AssetLib/3DS/3DSExporter.cpp",
            "code/AssetLib/3DS/3DSLoader.cpp",
            "code/AssetLib/3MF/D3MFExporter.cpp",
            "code/AssetLib/3MF/D3MFImporter.cpp",
            "code/AssetLib/3MF/D3MFOpcPackage.cpp",
            "code/AssetLib/3MF/XmlSerializer.cpp",
            "code/AssetLib/AC/ACLoader.cpp",
            "code/AssetLib/AMF/AMFImporter_Geometry.cpp",
            "code/AssetLib/AMF/AMFImporter_Material.cpp",
            "code/AssetLib/AMF/AMFImporter_Postprocess.cpp",
            "code/AssetLib/AMF/AMFImporter.cpp",
            "code/AssetLib/ASE/ASELoader.cpp",
            "code/AssetLib/ASE/ASEParser.cpp",
            "code/AssetLib/Assbin/AssbinExporter.cpp",
            "code/AssetLib/Assbin/AssbinFileWriter.cpp",
            "code/AssetLib/Assbin/AssbinLoader.cpp",
            "code/AssetLib/Assjson/cencode.c",
            "code/AssetLib/Assjson/json_exporter.cpp",
            "code/AssetLib/Assjson/mesh_splitter.cpp",
            "code/AssetLib/Assxml/AssxmlExporter.cpp",
            "code/AssetLib/Assxml/AssxmlFileWriter.cpp",
            "code/AssetLib/B3D/B3DImporter.cpp",
            "code/AssetLib/Blender/BlenderBMesh.cpp",
            "code/AssetLib/Blender/BlenderCustomData.cpp",
            "code/AssetLib/Blender/BlenderDNA.cpp",
            "code/AssetLib/Blender/BlenderLoader.cpp",
            "code/AssetLib/Blender/BlenderModifier.cpp",
            "code/AssetLib/Blender/BlenderScene.cpp",
            "code/AssetLib/Blender/BlenderTessellator.cpp",
            "code/AssetLib/BVH/BVHLoader.cpp",
            // "code/AssetLib/C4D/C4DImporter.cpp",
            "code/AssetLib/COB/COBLoader.cpp",
            "code/AssetLib/Collada/ColladaExporter.cpp",
            "code/AssetLib/Collada/ColladaHelper.cpp",
            "code/AssetLib/Collada/ColladaLoader.cpp",
            "code/AssetLib/Collada/ColladaParser.cpp",
            "code/AssetLib/CSM/CSMLoader.cpp",
            "code/AssetLib/DXF/DXFLoader.cpp",
            "code/AssetLib/FBX/FBXAnimation.cpp",
            "code/AssetLib/FBX/FBXBinaryTokenizer.cpp",
            "code/AssetLib/FBX/FBXConverter.cpp",
            "code/AssetLib/FBX/FBXDeformer.cpp",
            "code/AssetLib/FBX/FBXDocument.cpp",
            "code/AssetLib/FBX/FBXDocumentUtil.cpp",
            "code/AssetLib/FBX/FBXExporter.cpp",
            "code/AssetLib/FBX/FBXExportNode.cpp",
            "code/AssetLib/FBX/FBXExportProperty.cpp",
            "code/AssetLib/FBX/FBXImporter.cpp",
            "code/AssetLib/FBX/FBXMaterial.cpp",
            "code/AssetLib/FBX/FBXMeshGeometry.cpp",
            "code/AssetLib/FBX/FBXModel.cpp",
            "code/AssetLib/FBX/FBXNodeAttribute.cpp",
            "code/AssetLib/FBX/FBXParser.cpp",
            "code/AssetLib/FBX/FBXProperties.cpp",
            "code/AssetLib/FBX/FBXTokenizer.cpp",
            "code/AssetLib/FBX/FBXUtil.cpp",
            "code/AssetLib/glTF/glTFCommon.cpp",
            "code/AssetLib/glTF/glTFExporter.cpp",
            "code/AssetLib/glTF/glTFImporter.cpp",
            "code/AssetLib/glTF2/glTF2Exporter.cpp",
            "code/AssetLib/glTF2/glTF2Importer.cpp",
            "code/AssetLib/HMP/HMPLoader.cpp",
            "code/AssetLib/IFC/IFCBoolean.cpp",
            "code/AssetLib/IFC/IFCCurve.cpp",
            "code/AssetLib/IFC/IFCGeometry.cpp",
            "code/AssetLib/IFC/IFCLoader.cpp",
            "code/AssetLib/IFC/IFCMaterial.cpp",
            "code/AssetLib/IFC/IFCOpenings.cpp",
            "code/AssetLib/IFC/IFCProfile.cpp",
            // "code/AssetLib/IFC/IFCReaderGen_4.cpp", // not used?
            "code/AssetLib/IFC/IFCReaderGen1_2x3.cpp",
            "code/AssetLib/IFC/IFCReaderGen2_2x3.cpp",
            "code/AssetLib/IFC/IFCUtil.cpp",
            "code/AssetLib/Irr/IRRLoader.cpp",
            "code/AssetLib/Irr/IRRShared.cpp",
            "code/AssetLib/Irr/IRRMeshLoader.cpp",
            "code/AssetLib/Irr/IRRShared.cpp",
            "code/AssetLib/IQM/IQMImporter.cpp",
            "code/AssetLib/LWO/LWOAnimation.cpp",
            "code/AssetLib/LWO/LWOBLoader.cpp",
            "code/AssetLib/LWO/LWOLoader.cpp",
            "code/AssetLib/LWO/LWOMaterial.cpp",
            "code/AssetLib/LWS/LWSLoader.cpp",
            "code/AssetLib/M3D/M3DExporter.cpp",
            "code/AssetLib/M3D/M3DImporter.cpp",
            "code/AssetLib/M3D/M3DWrapper.cpp",
            "code/AssetLib/MD2/MD2Loader.cpp",
            "code/AssetLib/MD3/MD3Loader.cpp",
            "code/AssetLib/MD5/MD5Loader.cpp",
            "code/AssetLib/MD5/MD5Parser.cpp",
            "code/AssetLib/MDC/MDCLoader.cpp",
            "code/AssetLib/MDL/HalfLife/HL1MDLLoader.cpp",
            "code/AssetLib/MDL/HalfLife/UniqueNameGenerator.cpp",
            "code/AssetLib/MDL/MDLLoader.cpp",
            "code/AssetLib/MDL/MDLMaterialLoader.cpp",
            "code/AssetLib/MMD/MMDImporter.cpp",
            "code/AssetLib/MMD/MMDPmxParser.cpp",
            "code/AssetLib/MS3D/MS3DLoader.cpp",
            "code/AssetLib/NDO/NDOLoader.cpp",
            "code/AssetLib/NFF/NFFLoader.cpp",
            "code/AssetLib/Obj/ObjExporter.cpp",
            "code/AssetLib/Obj/ObjFileImporter.cpp",
            "code/AssetLib/Obj/ObjFileMtlImporter.cpp",
            "code/AssetLib/Obj/ObjFileParser.cpp",
            "code/AssetLib/OFF/OFFLoader.cpp",
            "code/AssetLib/Ogre/OgreBinarySerializer.cpp",
            "code/AssetLib/Ogre/OgreImporter.cpp",
            "code/AssetLib/Ogre/OgreMaterial.cpp",
            "code/AssetLib/Ogre/OgreStructs.cpp",
            "code/AssetLib/Ogre/OgreXmlSerializer.cpp",
            "code/AssetLib/OpenGEX/OpenGEXExporter.cpp",
            "code/AssetLib/OpenGEX/OpenGEXImporter.cpp",
            "code/AssetLib/Ply/PlyExporter.cpp",
            "code/AssetLib/Ply/PlyLoader.cpp",
            "code/AssetLib/Ply/PlyParser.cpp",
            "code/AssetLib/Q3BSP/Q3BSPFileImporter.cpp",
            "code/AssetLib/Q3BSP/Q3BSPFileParser.cpp",
            "code/AssetLib/Q3D/Q3DLoader.cpp",
            "code/AssetLib/Raw/RawLoader.cpp",
            "code/AssetLib/SIB/SIBImporter.cpp",
            "code/AssetLib/SMD/SMDLoader.cpp",
            "code/AssetLib/Step/StepExporter.cpp",
            "code/AssetLib/STEPParser/STEPFileEncoding.cpp",
            "code/AssetLib/STEPParser/STEPFileReader.cpp",
            "code/AssetLib/STL/STLExporter.cpp",
            "code/AssetLib/STL/STLLoader.cpp",
            "code/AssetLib/Terragen/TerragenLoader.cpp",
            "code/AssetLib/Unreal/UnrealLoader.cpp",
            "code/AssetLib/X/XFileExporter.cpp",
            "code/AssetLib/X/XFileImporter.cpp",
            "code/AssetLib/X/XFileParser.cpp",
            "code/AssetLib/VRML/VrmlConverter.cpp",
            "code/AssetLib/X3D/X3DExporter.cpp",
            "code/AssetLib/X3D/X3DImporter.cpp",
            "code/AssetLib/X3D/X3DImporter_Geometry2D.cpp",
            "code/AssetLib/X3D/X3DImporter_Geometry3D.cpp",
            "code/AssetLib/X3D/X3DImporter_Group.cpp",
            "code/AssetLib/X3D/X3DImporter_Light.cpp",
            "code/AssetLib/X3D/X3DImporter_Metadata.cpp",
            "code/AssetLib/X3D/X3DImporter_Networking.cpp",
            "code/AssetLib/X3D/X3DImporter_Postprocess.cpp",
            "code/AssetLib/X3D/X3DImporter_Rendering.cpp",
            "code/AssetLib/X3D/X3DImporter_Shape.cpp",
            "code/AssetLib/X3D/X3DImporter_Texturing.cpp",
            "code/AssetLib/X3D/X3DGeoHelper.cpp",
            "code/AssetLib/X3D/X3DXmlHelper.cpp",
            "code/AssetLib/XGL/XGLLoader.cpp",
            "code/AssetLib/USD/USDLoader.cpp",
            "code/AssetLib/USD/USDLoaderImplTinyusdz.cpp",
            "code/AssetLib/USD/USDLoaderImplTinyusdzHelper.cpp",
            "code/AssetLib/USD/USDLoaderUtil.cpp",
        },
        .root = assimp.path(""),
        .flags = &.{ "-DRAPIDJSON_HAS_STDSTRING=1", "-DASSIMP_BUILD_NO_C4D_IMPORTER=1" },
    });
}

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    // This creates a "module", which represents a collection of source files alongside
    // some compilation options, such as optimization mode and linked system libraries.
    // Every executable or library we compile will be based on one or more modules.
    const lib_mod = b.createModule(.{
        // `root_source_file` is the Zig "entry point" of the module. If a module
        // only contains e.g. external object files, you can make this `null`.
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Now, we will create a static library based on the module we created above.
    // This creates a `std.Build.Step.Compile`, which is the build step responsible
    // for actually invoking the compiler.
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "zassimp",
        .root_module = lib_mod,
    });
    addAssimp(lib, b);

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    // const lib_unit_tests = b.addTest(.{
    //     .root_source_file = b.path("src/root.zig"),
    //     .target = target,
    //     .optimize = optimize,
    // });
    // lib_unit_tests.linkLibrary(lib);

    // b.installArtifact(lib_unit_tests);
    // addAssimp(lib_unit_tests, b);

    // const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // // Similar to creating the run step earlier, this exposes a `test` step to
    // // the `zig build --help` menu, providing a way for the user to request
    // // running the unit tests.
    // const test_step = b.step("test", "Run unit tests");
    // test_step.dependOn(&run_lib_unit_tests.step);
}
