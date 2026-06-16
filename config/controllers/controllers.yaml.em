moveit_controller_manager: moveit_ros_control_interface/Ros2ControlManager
moveit_simple_controller_manager:
  controller_names:
@[if has_arms]@
    - arm_left_controller
    - arm_right_controller
@[end if]@
    - leg_left_controller
    - leg_right_controller
@[if has_pelvis]@
    - pelvis_controller
@[end if]@
@[if end_effector == "gripper"]@
    - gripper_left_controller
    - gripper_right_controller
@[end if]@
@[if end_effector == "RH8D"]@
    - hand_left_controller
    - hand_right_controller
@[end if]@
@[if arm_type in ["4dof", "5dof", "7dof"]]@
  arm_left_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - arm_left_1_joint
      - arm_left_2_joint
      - arm_left_3_joint
      - arm_left_4_joint
@[end if]@
@[if arm_type in ["5dof", "7dof"]]@
      - arm_left_5_joint
@[end if]@
@[if arm_type in ["7dof"]]@
      - arm_left_6_joint
      - arm_left_7_joint
@[end if]@
@[if arm_type in ["4dof", "5dof", "7dof"]]@
  arm_right_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - arm_right_1_joint
      - arm_right_2_joint
      - arm_right_3_joint
      - arm_right_4_joint
@[end if]@
@[if arm_type in ["5dof", "7dof"]]@
      - arm_right_5_joint
@[end if]@
@[if arm_type in ["7dof"]]@
      - arm_right_6_joint
      - arm_right_7_joint
@[end if]@
@[if has_pelvis]@
  pelvis_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - pelvis_1_joint
      - pelvis_2_joint
@[end if]@
  leg_left_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - leg_left_1_joint
      - leg_left_2_joint
      - leg_left_3_joint
      - leg_left_length_joint
      - leg_left_4_joint
      - leg_left_5_joint
  leg_right_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - leg_right_1_joint
      - leg_right_2_joint
      - leg_right_3_joint
      - leg_right_length_joint
      - leg_right_4_joint
      - leg_right_5_joint

@[if end_effector == "gripper"]@
  gripper_left_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - gripper_left_left_finger_joint
  gripper_right_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - gripper_right_left_finger_joint
@[end if]@
@[if end_effector == "RH8D"]@
  hand_left_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - hand_left_index_virtual_joint
      - hand_left_middle_virtual_joint
      - hand_left_ring_small_virtual_joint
      - hand_left_thumb_virtual_joint
      - hand_left_palm_roll_joint
      - hand_left_palm_pitch_joint
      - hand_left_thumb_base_joint
  hand_right_controller:
    action_ns: follow_joint_trajectory
    type: FollowJointTrajectory
    default: true
    joints:
      - hand_right_index_virtual_joint
      - hand_right_middle_virtual_joint
      - hand_right_ring_small_virtual_joint
      - hand_right_thumb_virtual_joint
      - hand_right_palm_roll_joint
      - hand_right_palm_pitch_joint
      - hand_right_thumb_base_joint
@[end if]@
trajectory_execution:
  allowed_execution_duration_scaling: 1.2
  allowed_goal_duration_margin: 0.5
  allowed_start_tolerance: 0.01
