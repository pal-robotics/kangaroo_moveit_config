# Copyright (c) 2022 PAL Robotics S.L. All rights reserved.
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

import os
from pathlib import Path
from dataclasses import dataclass

from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, OpaqueFunction
from launch_pal.arg_utils import read_launch_argument
from launch_pal.arg_utils import LaunchArgumentsBase
from launch_pal.robot_arguments import CommonArgs
from launch_ros.actions import Node

from moveit_configs_utils import MoveItConfigsBuilder
from kangaroo_description.launch_arguments import KangarooArgs


@dataclass(frozen=True)
class LaunchArguments(LaunchArgumentsBase):
    ## Common

    # ["True", "False"]
    use_sim_time: DeclareLaunchArgument = CommonArgs.use_sim_time
    use_sensor_manager_arg: DeclareLaunchArgument = CommonArgs.use_sensor_manager

    ## Kangaroo specific

    # ["mujoco-ros2-control", "mujoco", "no-simulation"]
    sim_type: DeclareLaunchArgument = KangarooArgs.sim_type

    # ["mesh", "capsule"]
    collision_type: DeclareLaunchArgument = KangarooArgs.collision_type

    # ["True", "False"]
    use_mimic: DeclareLaunchArgument = KangarooArgs.use_mimic
    has_head: DeclareLaunchArgument = KangarooArgs.has_head
    has_pelvis: DeclareLaunchArgument = KangarooArgs.has_pelvis

    # ["no-arm", "4dof", "5dof", "7dof"]
    arm_type: DeclareLaunchArgument = KangarooArgs.arm_type

    # ["no-end-effector", "fake-forearm", "gripper", "RH8D"]
    end_effector_left: DeclareLaunchArgument = KangarooArgs.end_effector_left
    end_effector_right: DeclareLaunchArgument = KangarooArgs.end_effector_right

    # ["no-ft-sensor", "ati"]
    ankle_ft_left: DeclareLaunchArgument = KangarooArgs.ankle_ft_left
    ankle_ft_right: DeclareLaunchArgument = KangarooArgs.ankle_ft_right

    ft_sensor_right: DeclareLaunchArgument = KangarooArgs.ft_sensor_right
    ft_sensor_left: DeclareLaunchArgument = KangarooArgs.ft_sensor_left

    # ["fixed", "detachable"]
    feet_type: DeclareLaunchArgument = KangarooArgs.feet_type

    # Fixation type ["crane", "fixed", "floating"]
    fixation_type: DeclareLaunchArgument = KangarooArgs.fixation_type


def declare_actions(launch_description: LaunchDescription, launch_args: LaunchArguments):

    launch_description.add_action(OpaqueFunction(function=start_rviz))
    return


def start_rviz(context, *args, **kwargs):

    end_effector_right = read_launch_argument('end_effector_right', context)
    end_effector_left = read_launch_argument('end_effector_left', context)
    has_pelvis = read_launch_argument('has_pelvis', context)

    srdf_file_path = Path(
        os.path.join(
            get_package_share_directory("kangaroo_moveit_config"),
            "config", "srdf",
            "kangaroo.srdf.xacro",
        )
    )

    srdf_input_args = {
        'ankle_ft_left': read_launch_argument('ankle_ft_left', context),
        'ankle_ft_right': read_launch_argument('ankle_ft_right', context),
        'arm_type': read_launch_argument('arm_type', context),
        'end_effector_left': end_effector_left,
        'end_effector_right': end_effector_right,
        'feet_type': read_launch_argument('feet_type', context),
        'ft_sensor_left': read_launch_argument('ft_sensor_left', context),
        'ft_sensor_right': read_launch_argument('ft_sensor_right', context),
        'has_pelvis': has_pelvis,
    }

    # Build the controllers file suffix the same way move_group does
    arm_type = read_launch_argument('arm_type', context)
    suffix = '_' + f'{arm_type}_' + f'{end_effector_right}' + \
        '_' + f'{"with-pelvis" if has_pelvis else "no-pelvis"}'

    # Trajectory Execution Functionality
    moveit_simple_controllers_path = (
        f'config/controllers/controllers{suffix}.yaml')

    planning_scene_monitor_parameters = {
        'publish_planning_scene': True,
        'publish_geometry_updates': True,
        'publish_state_updates': True,
        'publish_transforms_updates': True,
    }

    # The robot description is read from the topic /robot_description if the parameter is empty
    moveit_config = (
        MoveItConfigsBuilder('kangaroo')
        .robot_description_semantic(file_path=srdf_file_path, mappings=srdf_input_args)
        .robot_description_kinematics(file_path=os.path.join('config', 'kinematics_kdl.yaml'))
        .trajectory_execution(moveit_simple_controllers_path)
        .joint_limits(file_path=os.path.join('config', 'joint_limits.yaml'))
        .planning_pipelines(pipelines=['ompl', 'chomp'], default_planning_pipeline='ompl')
        .planning_scene_monitor(planning_scene_monitor_parameters)
        .pilz_cartesian_limits(file_path=os.path.join('config', 'pilz_cartesian_limits.yaml'))
        .to_moveit_configs()
    )

    # RViz
    rviz_base = os.path.join(get_package_share_directory(
        'kangaroo_moveit_config'), 'config', 'rviz')
    rviz_full_config = os.path.join(rviz_base, 'moveit.rviz')
    rviz_node = Node(
        package='rviz2',
        executable='rviz2',
        output='log',
        arguments=['-d', rviz_full_config],
        emulate_tty=True,
        parameters=[
            moveit_config.robot_description,
            moveit_config.robot_description_semantic,
            moveit_config.planning_pipelines,
            moveit_config.robot_description_kinematics,
        ],
    )

    return [rviz_node]


def generate_launch_description():

    # Create the launch description and populate
    ld = LaunchDescription()
    launch_arguments = LaunchArguments()

    launch_arguments.add_to_launch_description(ld)

    declare_actions(ld, launch_arguments)

    return ld
