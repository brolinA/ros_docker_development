#!/bin/sh

IMAGE_NAME=ros_melodic_dev_trial:latest
#ROS_VER=osrf/ros:melodic-desktop-full
ROS_VER=melodic
UBUNTU_VER=18.04

NVIDIA_DRIVER=NVIDIA-Linux-x86_64-470.103.01.run  # path to nvidia driver

cp ${NVIDIA_DRIVER} NVIDIA-DRIVER.run
sudo docker build -t ${IMAGE_NAME} --build-arg ROS_VERSION=${ROS_VER} --build-arg UBUNTU_VERSION=${UBUNTU_VER} .
