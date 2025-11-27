# Copyright (c) 2024 PAL Robotics S.L. All rights reserved.
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

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, OpaqueFunction
from launch.substitutions import LaunchConfiguration
from launch_pal.arg_utils import read_launch_argument
from launch_ros.actions import Node

from moveit_configs_utils import MoveItConfigsBuilder
from launch_pal.arg_utils import LaunchArgumentsBase
from launch_pal.robot_arguments import CommonArgs
from kangaroo_description.launch_arguments import KangarooArgs
from dataclasses import dataclass
from ament_index_python.packages import get_package_share_directory


@dataclass(frozen=True)
class LaunchArguments(LaunchArgumentsBase):
    ## Common

    # ["True", "False"]
    use_sim_time: DeclareLaunchArgument = CommonArgs.use_sim_time
    moveit: DeclareLaunchArgument = CommonArgs.moveit
    use_sensor_manager_arg: DeclareLaunchArgument = CommonArgs.use_sensor_manager

    # ["false", "position", "motor"]
    mj_control: DeclareLaunchArgument = CommonArgs.mj_control
    
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
    
    # ["ft-leg", "leg", "no-leg"]
    legs_type: DeclareLaunchArgument = KangarooArgs.legs_type
    
    # ["cover", "fake-forearm", "ft-gripper", "gripper", "RA8D"]
    end_effector_type: DeclareLaunchArgument = KangarooArgs.end_effector_type

    # Fixation type ["crane", "fixed", "floating"]
    fixation_type: DeclareLaunchArgument = KangarooArgs.fixation_type


def declare_actions(launch_description: LaunchDescription, launch_args: LaunchArguments):

    launch_description.add_action(OpaqueFunction(function=start_move_group))

    return

def start_move_group(context, *args, **kwargs):

    arm_type = read_launch_argument('arm_type', context)
    end_effector_type = read_launch_argument('end_effector_type', context)
    has_pelvis = read_launch_argument('has_pelvis', context)
    leg_type = read_launch_argument('legs_type', context)
    use_sensor_manager = read_launch_argument('use_sensor_manager', context)

    suffix = '_' + f'{arm_type}_' + f'{end_effector_type}'+ '_' + f'{"with-pelvis" if has_pelvis else "no-pelvis"}_' + f'{leg_type}'

    # Define SRDF Path and Parameters
    srdf_file_path = Path(
        os.path.join(
            get_package_share_directory("kangaroo_moveit_config"),
            "config", "srdf",
            "kangaroo.srdf.xacro",
        )
    )

    srdf_input_args = {
        'arm_type': arm_type,
        'end_effector_type': end_effector_type,
        'has_pelvis': has_pelvis,
        'leg_type': leg_type,
    }

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
        .planning_pipelines(pipelines=['ompl'], default_planning_pipeline='ompl')
        .planning_scene_monitor(planning_scene_monitor_parameters)
        .pilz_cartesian_limits(file_path=os.path.join('config', 'pilz_cartesian_limits.yaml'))
    )

    # Add sensor manager if required
    if use_sensor_manager == "True":
        # moveit_sensors path
        moveit_sensors_path = 'config/sensors_3d.yaml'
        moveit_config.sensors_3d(moveit_sensors_path)

    # Finalize MoveIt2 Configuration
    moveit_config.to_moveit_configs()

    move_group_configuration = {
        'use_sim_time': LaunchConfiguration('use_sim_time'),
        'publish_robot_description_semantic': True,
        'robot_description_timeout': 60.0,
    }

    move_group_params = [
        moveit_config.to_dict(),
        move_group_configuration,
    ]

    # Start the actual move_group node/action server
    run_move_group_node = Node(
        package='moveit_ros_move_group',
        executable='move_group',
        output='screen',
        emulate_tty=True,
        parameters=move_group_params,
    )

    return [run_move_group_node]


def generate_launch_description():

    # Create the launch description and populate
    ld = LaunchDescription()
    launch_arguments = LaunchArguments()

    launch_arguments.add_to_launch_description(ld)

    declare_actions(ld, launch_arguments)

    return ld
