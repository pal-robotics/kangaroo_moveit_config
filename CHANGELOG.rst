^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package kangaroo_moveit_config
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

2.1.0 (2026-07-02)
------------------
* Merge branch 'fix/renamed_sole_links/detachable_feet' into 'humble-devel'
  Fix the renamed sole links of the detachable feet
  See merge request robots/kangaroo_moveit_config!18
* Fix the renamed sole links of the detachable feet
* Contributors: Sai Kishor Kothakota

2.0.3 (2026-07-01)
------------------
* Enforce some disable_collisions and fix file path lookup
* Fix move_group for mujoco simulation disabling collisions for mj_tags.xacro
* Remove feet suffix from disable_collisions paths
* Fix srdf with new arguments and create new disable_collisions
* Remove has_legs and legs_type arguments
* Contributors: Isaac Acevedo, Noel Jimenez

2.0.2 (2026-05-12)
------------------
* Merge branch 'fix/move_group_arguments' into 'humble-devel'
  Fix launch arguments for move group
  See merge request robots/kangaroo_moveit_config!14
* Fix launch arguments for move group
* Contributors: Noel Jimenez, Sai Kishor Kothakota

2.0.1 (2026-02-04)
------------------
* Merge branch 'sma/update_pkg_dependencies' into 'humble-devel'
  updated dependencies
  See merge request robots/kangaroo_moveit_config!13
* removed test dependency
* removed test dependencies
* updated dependencies
* Contributors: Sai Kishor Kothakota, sergiacosta

2.0.0 (2026-02-04)
------------------
* coppied tiago model file
* updated launchfiles
* updated config files
* created ros2 package
* Contributors: sergiacosta

0.1.0 (2025-11-05)
------------------
* add the lower body with arms controller yaml
* Merge branch 'sma/add_arm7dof' into 'master'
  Add 7 DoF arm with gripper integration
  See merge request robots/kangaroo_moveit_config!10
* remove the whitespace
* Merge branch 'sma/add_gripper_on_7dof' into 'sma/add_arm7dof'
  Add pal pro gripper on 7dof arm
  See merge request robots/kangaroo_moveit_config!11
* added gripper controller list
* added exclude collision for gripper
* added gripper configuration
* renamed file with correct robot_type
* added robot_type logic for 7dof arm
* added 7dof arm option
* Contributors: Sai Kishor Kothakota, sergiacosta

0.0.8 (2025-09-15)
------------------
* Merge branch 'lm/arms_motions_rebased' into 'master'
  Lm/arms motions rebased
  See merge request robots/kangaroo_moveit_config!9
* Remove the pelvis related changes in no pelvis configuration
* Removing pelvis joints from srdf without pelvis
* Dissable collisions between back_handle and leg\_<side>_link_1
* Adding dissable collisions for pelvis' links in kangaroo_pelvis_no_arms srdf
* Adding dissable collisions for pelvis' links in kangaroo_full srdf
* remove self colisions
* add adjacent links next to pelvis to blacklist
* Generate SRDF with pelvis joints
* Contributors: Luca Marchionni, Sai Kishor Kothakota, antoniomartinez

0.0.7 (2025-05-22)
------------------
* Merge branch 'lm/arms_motions' into 'master'
  Lm/arms motions
  See merge request robots/kangaroo_moveit_config!7
* Add arguments and config files for different configurations
* tested on the robot and used for video motions
* generated configiration for arms moveit
* Contributors: Adria Roig, Luca Marchionni

0.0.6 (2024-09-10)
------------------
* Merge branch 'update/moveit_config/2023' into 'master'
  update the moveit config with the new 2023 configuration
  See merge request robots/kangaroo_moveit_config!5
* update the moveit config with the new 2023 configuration
* Contributors: Sai Kishor Kothakota

0.0.5 (2024-05-08)
------------------
* Merge branch 'add_more_collision_pairs' into 'master'
  Add more collision pairs after testing on the robot
  See merge request robots/kangaroo_moveit_config!4
* Add more collision pairs after testing on the robot
* Contributors: Adria Roig, Sai Kishor Kothakota

0.0.4 (2024-05-07)
------------------
* Merge branch 'update/052024/kangaroo_version_2023' into 'master'
  Update the moveit configuration for the kangaroo version 2023
  See merge request robots/kangaroo_moveit_config!3
* Add moveit_simple_controller_manager dependency
* Add the new SRDF configuration
* Contributors: Adria Roig, Sai Kishor Kothakota

0.0.3 (2022-05-04)
------------------
* remove kangaroo description dependency
* Contributors: Sai Kishor Kothakota

0.0.2 (2021-11-18)
------------------
* Merge branch 'both_legs_group' into 'master'
  added move group configuration for the both legs
  See merge request robots/kangaroo_moveit_config!2
* added the collision info between knee link and the leg length
* added move group configuration for the both legs
* Contributors: Adria Roig, Sai Kishor Kothakota

0.0.1 (2021-09-02)
------------------
* Update configuration using MoveIt setup assistant
* Remove everything
* Initial commit
* Contributors: Adria Roig, Sai Kishor Kothakota
