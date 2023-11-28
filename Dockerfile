ARG ROS_DISTRO=humble

FROM ros:${ROS_DISTRO}-ros-core

RUN apt update && apt install -y --no-install-recommends \
    python3-pip \
    python3-colcon-common-extensions \
    build-essential \
    git libpcl-dev ros-${ROS_DISTRO}-pcl-conversions \
    && rm -rf /var/lib/apt/lists/*

COPY ros_entrypoint.sh .

WORKDIR /colcon_ws

COPY livox_ros_driver2 src/livox_ros_driver2 

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release --event-handlers console_direct+

ENV LAUNCH_COMMAND='ros2 launch livox_ros_driver2 livox_lidar_launch.py'

# Create build and run aliases
RUN echo 'alias build="colcon build --symlink-install  --event-handlers console_direct+"' >> /etc/bash.bashrc && \
    echo 'alias run="su - ros /run.sh"' >> /etc/bash.bashrc && \
    echo "source /colcon_ws/install/setup.bash; $LAUNCH_COMMAND" >> /run.sh && chmod +x /run.sh
