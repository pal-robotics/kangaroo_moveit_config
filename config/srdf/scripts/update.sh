#!/bin/bash
set -e
set -o pipefail
pal_moveit_config_generator=$(ros2 pkg prefix pal_moveit_config_generator)
moveit_srdf="$(ros2 pkg prefix kangaroo_moveit_config)/share/kangaroo_moveit_config/config/srdf"
source "$pal_moveit_config_generator/share/pal_moveit_config_generator/srdf_utils.sh" "$(dirname "${BASH_SOURCE[0]}")/../kangaroo.srdf.xacro"

end_effectors=()
for end_effector_file in "$moveit_srdf"/end_effectors/*.srdf.xacro; do
     end_effectors+=($(basename "$end_effector_file" .srdf.xacro))
done

ft_sensors=(no-ft-sensor ati)

get_valid_end_effectors() {
    local arm_type="$1"
    local -n result="$2"

    case "$arm_type" in
        4dof) result=("no-end-effector") ;;
        5dof) result=("no-end-effector" "RH8D") ;;
        7dof) result=("no-end-effector" "gripper") ;;
        *) result=() ;;
    esac
}

# crawl all end effectors and ft_sensors and generate the corresponding subtree SRDF
for arm_type in 4dof 5dof 7dof; do

    get_valid_end_effectors "$arm_type" valid_end_effectors

    for end_effector in "${valid_end_effectors[@]}"; do

        if [ "$end_effector" = "no-end-effector" ]; then
            end_effector_value="no-ee"
        else
            end_effector_value="$end_effector"
        fi

        for ft_sensor in "${ft_sensors[@]}"; do

            args=(
                "arm_type:=$arm_type"
                "ft_sensor_left:=$ft_sensor"
                "ft_sensor_right:=$ft_sensor"
                "end_effector_left:=$end_effector"
                "end_effector_right:=$end_effector"
            )

            for side in left right; do

                if [ "$ft_sensor" != "no-ft-sensor" ]; then
                    generate_disable_collisions_subtree \
                        "arm_${side}_tool_link" \
                        "${side}_${arm_type}_${end_effector_value}_${ft_sensor}" \
                        "${side}_${arm_type}_${end_effector_value}" \
                        "${args[@]}"
                else
                    generate_disable_collisions_subtree \
                        "arm_${side}_tool_link" \
                        "${side}_${arm_type}_${end_effector_value}" \
                        "" \
                        "${args[@]}"
                fi
            done
        done
    done
done

function get_name() {
    local end_effector=$1; shift
    local ft_sensor=$1; shift
            if [ "$end_effector" = "no-end-effector" ]; then
                end_effector="no-ee"
            fi

            name=
            if [ "$ft_sensor" != "no-ft-sensor" ]; then
                echo "${end_effector}_$ft_sensor"
            else
                echo "${end_effector}"
            fi
}

# Generate base disable collision pairs
prefix="${robot}"
args=(ft_sensor_left:="no-ft-sensor" ft_sensor_right:="no-ft-sensor" end_effector_left:="no-end-effector" end_effector_right:="no-end-effector")

# legs only with fixed feet
generate_disable_collisions "${prefix}_no-arms_no-pelvis_fixed" "" "${args[@]}" arm_type:="no-arm" has_pelvis:="False" feet_type:="fixed"
# arms 4dof only with fixed feet
generate_disable_collisions "${prefix}_4dof_no-pelvis_fixed" "${prefix}_no-arms_no-pelvis_fixed" "${args[@]}" arm_type:="4dof" has_pelvis:="False" feet_type:="fixed"
# arms 5dof only with fixed feet
generate_disable_collisions "${prefix}_5dof_no-pelvis_fixed" "${prefix}_4dof_no-pelvis_fixed" "${args[@]}" arm_type:="5dof" has_pelvis:="False" feet_type:="fixed"
# arms 7dof only with fixed feet
generate_disable_collisions "${prefix}_7dof_no-pelvis_fixed" "${prefix}_5dof_no-pelvis_fixed" "${args[@]}" arm_type:="7dof" has_pelvis:="False" feet_type:="fixed"


# legs with pelvis with fixed feet
generate_disable_collisions "${prefix}_no-arms_with-pelvis_fixed" "${prefix}_no-arms_no-pelvis_fixed" "${args[@]}" arm_type:="no-arm" has_pelvis:="True" feet_type:="fixed"
# arms 4dof with pelvis with fixed feet
generate_disable_collisions "${prefix}_4dof_with-pelvis_fixed" "${prefix}_no-arms_with-pelvis_fixed" "${args[@]}" arm_type:="4dof" has_pelvis:="True" feet_type:="fixed"
# arms 5dof with pelvis with fixed feet
generate_disable_collisions "${prefix}_5dof_with-pelvis_fixed" "${prefix}_4dof_with-pelvis_fixed" "${args[@]}" arm_type:="5dof" has_pelvis:="True" feet_type:="fixed"
# arms 7dof with pelvis with fixed feet
generate_disable_collisions "${prefix}_7dof_with-pelvis_fixed" "${prefix}_5dof_with-pelvis_fixed" "${args[@]}" arm_type:="7dof" has_pelvis:="True" feet_type:="fixed"


# legs only with detachable feet
generate_disable_collisions "${prefix}_no-arms_no-pelvis_detachable" "" "${args[@]}" arm_type:="no-arm" has_pelvis:="False" feet_type:="detachable"
# arms 4dof only with detachable feet
generate_disable_collisions "${prefix}_4dof_no-pelvis_detachable" "${prefix}_no-arms_no-pelvis_detachable" "${args[@]}" arm_type:="4dof" has_pelvis:="False" feet_type:="detachable"
# arms 5dof only with detachable feet
generate_disable_collisions "${prefix}_5dof_no-pelvis_detachable" "${prefix}_4dof_no-pelvis_detachable" "${args[@]}" arm_type:="5dof" has_pelvis:="False" feet_type:="detachable"
# arms 7dof only with detachable feet
generate_disable_collisions "${prefix}_7dof_no-pelvis_detachable" "${prefix}_5dof_no-pelvis_detachable" "${args[@]}" arm_type:="7dof" has_pelvis:="False" feet_type:="detachable"  


# legs with pelvis with detachable feet
generate_disable_collisions "${prefix}_no-arms_with-pelvis_detachable" "${prefix}_no-arms_no-pelvis_detachable" "${args[@]}" arm_type:="no-arm" has_pelvis:="True" feet_type:="detachable"
# arms 4dof with pelvis with detachable feet
generate_disable_collisions "${prefix}_4dof_with-pelvis_detachable" "${prefix}_no-arms_with-pelvis_detachable" "${args[@]}" arm_type:="4dof" has_pelvis:="True" feet_type:="detachable"
# arms 5dof with pelvis with detachable feet
generate_disable_collisions "${prefix}_5dof_with-pelvis_detachable" "${prefix}_4dof_with-pelvis_detachable" "${args[@]}" arm_type:="5dof" has_pelvis:="True" feet_type:="detachable"
# arms 7dof with pelvis with detachable feet
generate_disable_collisions "${prefix}_7dof_with-pelvis_detachable" "${prefix}_5dof_with-pelvis_detachable" "${args[@]}" arm_type:="7dof" has_pelvis:="True" feet_type:="detachable"


# Generate collisions for arms with different end effectors and ft_sensors
for arm_type in 4dof 5dof 7dof; do

    get_valid_end_effectors "$arm_type" valid_ee

    for end_effector_left in "${valid_ee[@]}"; do
        for ft_sensor_left in "${ft_sensors[@]}"; do

            for end_effector_right in "${valid_ee[@]}"; do
                for ft_sensor_right in "${ft_sensors[@]}"; do

                    left_name="$(get_name "$end_effector_left" "$ft_sensor_left")"
                    right_name="$(get_name "$end_effector_right" "$ft_sensor_right")"
                    echo "Generating SRDF for end effectors: $end_effector_left ($ft_sensor_left) and $end_effector_right ($ft_sensor_right)"
                    generate_srdf \
                        "${prefix}_${arm_type}_${left_name}_${right_name}" \
                        "left_${arm_type}_${left_name}:right_${arm_type}_${right_name}" \
                        arm_type:="$arm_type" \
                        ft_sensor_left:="$ft_sensor_left" \
                        ft_sensor_right:="$ft_sensor_right" \
                        end_effector_left:="$end_effector_left" \
                        end_effector_right:="$end_effector_right"

                done
            done

        done
    done
done
