#!/bin/bash

ROS_DISTRO=$1
echo "Installing package for ROS" $ROS_DISTRO

PACKAGE_LIST=(
    gmapping
    sbpl
    map-server
    robot-localization
    controller-manager
    hector-gazebo-plugins
    realtime-tools
    gazebo-ros-control
    joint-state-controller
    twist-mux
    joy
    tf
)

TOTAL_PACKAGES=""
for package in ${PACKAGE_LIST[@]}
do
    TOTAL_PACKAGES+=" ros-$ROS_DISTRO-${package} "
done

sudo apt install -y ${TOTAL_PACKAGES} --no-install-recommends