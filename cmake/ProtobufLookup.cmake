find_package(Protobuf CONFIG)
if(NOT Protobuf_FOUND)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(FIND_LIBRARY_USE_LIB64_PATHS TRUE)
        set(FIND_LIBRARY_USE_LIBX32_PATHS FALSE)
        set(FIND_LIBRARY_USE_LIB32_PATHS FALSE)
    else()
        set(FIND_LIBRARY_USE_LIBX32_PATHS TRUE)
        set(FIND_LIBRARY_USE_LIB32_PATHS TRUE)
        set(FIND_LIBRARY_USE_LIB64_PATHS FALSE)
    endif()

    find_library(Protobuf_LIBRARY protobuf)
    if(NOT TARGET protobuf::libprotobuf AND NOT Protobuf_LIBRARY STREQUAL PROTOBUF_LIBRARY-NOTFOUND)
        add_library(protobuf::libprotobuf SHARED IMPORTED)
        set_target_properties(protobuf::libprotobuf PROPERTIES IMPORTED_LOCATION ${Protobuf_LIBRARY})
    endif()

    find_program(Protobuf_PROTOC_EXECUTABLE protoc)
    if(NOT TARGET protobuf::protoc AND NOT Protobuf_PROTOC_EXECUTABLE STREQUAL Protobuf_PROTOC_EXECUTABLE-NOTFOUND)
        add_executable(protobuf::protoc IMPORTED)
        set_target_properties(protobuf::protoc PROPERTIES IMPORTED_LOCATION ${Protobuf_PROTOC_EXECUTABLE})
    endif()

    find_package(Threads)
    find_library(Protobuf_PROTOC_LIBRARY protoc)
    if(NOT TARGET protobuf::libprotoc AND NOT Protobuf_PROTOC_LIBRARY STREQUAL PROTOBUF_PROTOC_LIBRARY-NOTFOUND)
        add_library(protobuf::libprotoc SHARED IMPORTED)
        set_target_properties(protobuf::libprotoc PROPERTIES IMPORTED_LOCATION ${Protobuf_PROTOC_LIBRARY}
            INTERFACE_LINK_LIBRARIES Threads::Threads)
    endif()

    unset(Protobuf_FOUND)
    if(TARGET protobuf::libprotoc AND TARGET protobuf::protoc AND TARGET protobuf::libprotobuf)
        set(Protobuf_FOUND TRUE)
        message(STATUS "Found protobuf installation: ${Protobuf_PROTOC_EXECUTABLE} ${Protobuf_PROTOC_LIBRARY} ${Protobuf_LIBRARY}")
    else()
        message(FATAL_ERROR "Protobuf is a hard dependency of the project. You may install it (with gRPC) by following instructions in cmake/gRPCBuild.cmake script.")
        unset(Protobuf_LIBRARY)
        unset(Protobuf_PROTOC_EXECUTABLE)
        unset(Protobuf_PROTOC_LIBRARY)
    endif()
endif()
