# Copyright 2016 Proyectos y Sistemas de Mantenimiento SL (eProsima).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

macro(find_eprosima_package package)
    if(NOT ${package}_FOUND AND NOT (EPROSIMA_INSTALLER AND (MSVC OR MSVC_IDE)))

        option(THIRDPARTY_${package} "Activate the use of internal thirdparty ${package}" OFF)

        if(THIRDPARTY)
                set(LIST_OF_OPTIONS "")
                set(next_is_option FALSE)
                foreach(arg ${ARGN})
                    if(next_is_option)
                        set(next_is_option FALSE)
                        list(APPEND LIST_OF_OPTIONS "-D${arg}=ON")
                    elseif("${arg}" STREQUAL "OPTION")
                        set(next_is_option TRUE)
                    endif()
                endforeach()
        endif()

        option(THIRDPARTY_${package} "Activate the use of internal thirdparty ${package}" OFF)

        if(THIRDPARTY OR THIRDPARTY_${package})
            execute_process(
                COMMAND git submodule update --recursive --init "thirdparty/${package}"
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                RESULT_VARIABLE EXECUTE_RESULT
                )

            if(NOT EXECUTE_RESULT EQUAL 0)
                message(WARNING "Cannot configure Git submodule ${package}")
            endif()

            add_subdirectory(${PROJECT_SOURCE_DIR}/thirdparty/${package})

            set(${package}_FOUND TRUE $<$<NOT:IS_TOP_LEVEL>:PARENT_SCOPE>)
        else()
            find_package(${package} QUIET)
        endif()

        if(${package}_FOUND)
            message(STATUS "${package} library found...")
        else()
            message(STATUS "${package} library not found...")
        endif()
    endif()
endmacro()

macro(find_eprosima_thirdparty package thirdparty_name)
    if(NOT (EPROSIMA_INSTALLER AND (MSVC OR MSVC_IDE)))
        option(THIRDPARTY_${package} "Activate the use of internal thirdparty ${package}" OFF)

        if(THIRDPARTY OR THIRDPARTY_${package})
            execute_process(
                COMMAND git submodule update --recursive --init "thirdparty/${thirdparty_name}"
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                RESULT_VARIABLE EXECUTE_RESULT
                )

            if(NOT EXECUTE_RESULT EQUAL 0)
                message(FATAL_ERROR "Cannot configure Git submodule ${package}")
            endif()
        endif()

        set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${PROJECT_SOURCE_DIR}/thirdparty/${thirdparty_name})
        set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} ${PROJECT_SOURCE_DIR}/thirdparty/${thirdparty_name}/${thirdparty_name})

        find_package(${package} REQUIRED)
    endif()
endmacro()
