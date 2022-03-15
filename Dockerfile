ARG ROS_VERSION=melodic
ARG UBUNTU_VERSION=18.04
FROM ubuntu:${UBUNTU_VERSION}
FROM osrf/ros:${ROS_VERSION}-desktop-full

LABEL key="github.com/brolinA"

# # install ros packages
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ros-melodic-desktop-full \
#     && rm -rf /var/lib/apt/lists/*

#Dependencies for building packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool build-essential \
    python-pip \
    python-catkin-tools \
    && rm -rf /var/lib/apt/lists/*


ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}

ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


RUN apt-get update && apt-get install -y mesa-utils kmod apt-utils build-essential psmisc vim-gtk
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#install ROS package
COPY ros-pkg-install.sh .
RUN /bin/bash -c '. bash ros-pkg-install.sh $ROS_DISTRO \
                    ; rm -rf /var/lib/apt/lists/*'

#install UBUNTU dependencies
COPY ubuntu_packages.txt .
RUN apt-get update && xargs -r -a ubuntu_packages.txt apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# # install nvidia driver
# RUN apt-get install -y binutils
# ADD NVIDIA-DRIVER.run /tmp/NVIDIA-DRIVER.run
# RUN sh /tmp/NVIDIA-DRIVER.run -a -N --ui=none --no-kernel-module
# RUN rm /tmp/NVIDIA-DRIVER.run

#source ros environment
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc

#build packages

RUN mkdir -p /home/catkin_ws/src
WORKDIR /home/catkin_ws/src
RUN /bin/bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash; cd /home/catkin_ws/; catkin build'

#source workspace
RUN echo "source /home/catkin_ws/devel/setup.bash" >> ~/.bashrc
