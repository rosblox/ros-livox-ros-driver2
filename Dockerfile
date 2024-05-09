ARG ROS_DISTRO=humble

FROM ros:${ROS_DISTRO}-ros-core

RUN apt update && apt install -y --no-install-recommends \
    python3-pip \
    python3-colcon-common-extensions \
    build-essential \
    git libpcl-dev ros-${ROS_DISTRO}-pcl-conversions \
    && rm -rf /var/lib/apt/lists/*

COPY ros_entrypoint.sh .

COPY Livox-SDK2 Livox-SDK2
RUN cd Livox-SDK2 && mkdir -p build && cd build && cmake .. && make -j4 && make install

WORKDIR /colcon_ws
COPY livox_ros_driver2 src/livox_ros_driver2 

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    colcon build --symlink-install --cmake-args -DROS_EDITION=${ROS_DISTRO} -DHUMBLE_ROS=${ROS_DISTRO} -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+

ENV LAUNCH_COMMAND='ros2 launch livox_ros_driver2 msg_MID360_launch.py'

# Create build and run aliases
RUN echo 'alias build="colcon build --symlink-install  --cmake-args -DROS_EDITION=${ROS_DISTRO} -DHUMBLE_ROS=${ROS_DISTRO} -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+ "' >> /etc/bash.bashrc && \
    echo 'alias run="su - ros --whitelist-environment=\"ROS_DOMAIN_ID\" /run.sh"' >> /etc/bash.bashrc && \
    echo "source /colcon_ws/install/setup.bash; echo UID: $UID; echo ROS_DOMAIN_ID: $ROS_DOMAIN_ID; $LAUNCH_COMMAND" >> /run.sh && chmod +x /run.sh
