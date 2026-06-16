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

# crawl all end effectors and generate the corresponding subtree SRDF
for end_effector in "${end_effectors[@]}"; do
    for side in left right; do
        generate_disable_collisions_subtree "arm_${side}_tool_link" "${side}_${end_effector}"  "" "${args[@]}"
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
args=()
# legs only
generate_disable_collisions "${prefix}_no-arms_no-pelvis_leg" "" "${args[@]}" arm_type:="no-arm" has_pelvis:="False" end_effector_type:="cover"

# pelvis only
generate_disable_collisions "${prefix}_no-arms_with-pelvis_leg" "${prefix}_no-arms_no-pelvis_leg" "${args[@]}" arm_type:="no-arm" has_pelvis:="True" end_effector_type:="cover"
# arms_4dof only
generate_disable_collisions "${prefix}_4dof_no-pelvis_leg" "${prefix}_no-arms_no-pelvis_leg" "${args[@]}" arm_type:="4dof" has_pelvis:="False" end_effector_type:="fake-forearm"
# arms_5dof only
generate_disable_collisions "${prefix}_5dof_no-pelvis_leg" "${prefix}_4dof_no-pelvis_leg" "${args[@]}" arm_type:="5dof" has_pelvis:="False" end_effector_type:="no-end-effector"
# arms_7dof only 
generate_disable_collisions "${prefix}_7dof_no-pelvis_leg" "${prefix}_5dof_no-pelvis_leg" "${args[@]}" arm_type:="7dof" has_pelvis:="False" end_effector_type:="no-end-effector"

# pelvis & arms_4dof
generate_disable_collisions "${prefix}_4dof_with-pelvis_leg" "${prefix}_no-arms_with-pelvis_leg" "${args[@]}" arm_type:="4dof" has_pelvis:="True" end_effector_type:="fake-forearm"
# pelvis & arms_5dof
generate_disable_collisions "${prefix}_5dof_with-pelvis_leg" "${prefix}_4dof_with-pelvis_leg" "${args[@]}" arm_type:="5dof" has_pelvis:="True" end_effector_type:="no-end-effector"
# pelvis & arms_7dof
generate_disable_collisions "${prefix}_7dof_with-pelvis_leg" "${prefix}_5dof_with-pelvis_leg" "${args[@]}" arm_type:="7dof" has_pelvis:="True" end_effector_type:="no-end-effector"

# generate_disable_collisions "${prefix}_4dof_with-pelvis_no-legs" "${prefix}_no-arm-left_no-arm-right" "${args[@]}" arm_type_left:="no-arm" # pelvis & arms_4dof
# generate_disable_collisions "${prefix}_5dof_with-pelvis_no-legs" "${prefix}_no-arm-left_no-arm-right" "${args[@]}" arm_type_left:="no-arm" # pelvis & arms_5dof
# generate_disable_collisions "${prefix}_7dof_with-pelvis_no-legs" "${prefix}_no-arm-left_no-arm-right" "${args[@]}" arm_type_left:="no-arm" # pelvis & arms_7dof

# # Generate disable collision for single arm configurations
# for end_effector in "${end_effectors[@]}"; do
#     for ft_sensor in "${ft_sensors[@]}"; do
#         name="$(get_name "$end_effector" "$ft_sensor")"
#         generate_srdf "${prefix}_${name}_no-arm-right" \
#                         "${prefix}_no-arm-right:left_${name}" \
#                         arm_type_right:="no-arm" \
#                         ft_sensor_left:="$ft_sensor"\
#                         ft_sensor_right:="no-ft-sensor" \
#                         end_effector_left:="$end_effector" \
#                         end_effector_right:="no-end-effector" \
#                         wrist_model_left:="spherical-wrist"

#         generate_srdf "${prefix}_no-arm-left_${name}" \
#                         "${prefix}_no-arm-left:right_${name}" \
#                         arm_type_left:="no-arm" \
#                         ft_sensor_left:="no-ft-sensor" \
#                         ft_sensor_right:="$ft_sensor" \
#                         end_effector_left:="no-end-effector" \
#                         end_effector_right:="$end_effector" \
#                         wrist_model_right:="spherical-wrist"
#     done
# done

# Generate disable collision for dual arm configurations
# for end_effector in "${end_effectors[@]}"; do
#     left_name=$end_effector
#     right_name=$end_effector
#     generate_srdf "${prefix}_${left_name}_${right_name}" \
#                     "${prefix}_no-ee_no-ee:${prefix}_${left_name}_no-arm-right:${prefix}_no-arm-left_${right_name}" \
#                     ft_sensor_left:="$ft_sensor_left" \
#                     has_pelvis:="$ft_sensor_right" \
#                     end_effector_type:="$end_effector_left" \
                    
# done