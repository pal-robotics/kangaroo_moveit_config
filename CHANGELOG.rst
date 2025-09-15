^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Changelog for package kangaroo_moveit_config
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
