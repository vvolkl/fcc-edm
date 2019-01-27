include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/datamodel
)

file(GLOB sources src/*.cc)
file(GLOB headers datamodel/*.h podio/PythonEventStore.h)

add_library(datamodel-fcclegacy SHARED ${sources} ${headers})
target_link_libraries(datamodel-fcclegacy podio)

REFLEX_GENERATE_DICTIONARY(datamodel-fcclegacy ${headers} SELECTION src/selection.xml )
add_library(datamodel-fcclegacyDict SHARED datamodel-fcclegacy.cxx)
add_dependencies(datamodel-fcclegacyDict datamodel-fcclegacy-dictgen)
target_link_libraries(datamodel-fcclegacyDict datamodel-fcclegacy podio ${ROOT_LIBRARIES})

set_target_properties(datamodel-fcclegacy PROPERTIES
  PUBLIC_HEADER "${headers}")

install(TARGETS datamodel-fcclegacy datamodel-fcclegacyDict
  # IMPORTANT: Add the datamodel-fcclegacy library to the "export-set"
  EXPORT fccedmTargets
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
  LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
  PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/datamodel"
  COMPONENT dev)

install(FILES
  "${PROJECT_BINARY_DIR}/datamodel/datamodel-fcclegacyDict.rootmap"
  DESTINATION "${INSTALL_LIB_DIR}" COMPONENT dev)

if (${ROOT_VERSION} GREATER 6)
  install(FILES
      "${PROJECT_BINARY_DIR}/datamodel/datamodel-fcclegacy_rdict.pcm"
      DESTINATION "${INSTALL_LIB_DIR}" COMPONENT dev)
endif()
