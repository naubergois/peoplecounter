FROM ubuntu:18.04

RUN apt-get -y update
RUN apt-get -y upgrade
#RUN apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libns
RUN apt -y install python3 
RUN apt -y install python3-pip

RUN python3 -m pip install --upgrade pip
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY
ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/13231/l_openvino_toolkit_p_2018.0.000.tgz
ARG INSTALL_DIR=/opt/intel/computer_vision_sdk
ARG TEMP_DIR=/tmp/openvino_installer
RUN mkdir -p $TEMP_DIR && cd $TEMP_DIR 
COPY l_openvino_toolkit_p_2020.4.287.tgz $TEMP_DIR
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    cpio \
    sudo \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*
RUN cd $TEMP_DIR && \
    tar xf l_openvino_toolkit*.tgz && \
    cd l_openvino_toolkit* && \
    sed -i 's/decline/accept/g' silent.cfg && \
    ./install.sh -s silent.cfg && \
    rm -rf $TEMP_DIR
#RUN $INSTALL_DIR/install_dependencies/install_cv_sdk_dependencies.sh
# build Inference Engine samples
#RUN mkdir $INSTALL_DIR/deployment_tools/inference_engine/samples/build && cd $INSTALL_DIR/deployment_tools/inference_engine/samples/build && \
#    /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh && cmake .. && make -j1"
RUN cd /opt/intel/openvino/deployment_tools/model_optimizer/install_prerequisites && \
	sudo ./install_prerequisites.sh
RUN  apt-get install -y software-properties-common
RUN  add-apt-repository -y -r ppa:chris-lea/node.js
RUN  rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list
RUN  rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save
RUN apt install -y curl
RUN wget https://nodejs.org/dist/v6.17.1/node-v6.17.1-linux-x64.tar.gz
RUN mkdir -p /opt/nodejs
RUN tar -xvzf node-v6.17.1-linux-x64.tar.gz -C /opt/nodejs/
RUN cd /opt/nodejs && \
	mv node-v6.17.1-linux-x64 6.17.1 && \
	ln -s 6.17.1 current && \
	ln -s /opt/nodejs/current/bin/node /bin/node
#RUN apt -y install nodejs
RUN apt -y update
RUN apt-get -y install python3-pip
RUN pip3 install numpy
RUN pip3 install paho-mqtt
RUN apt -y install libzmq3-dev libkrb5-dev
RUN apt -y install ffmpeg
RUN apt-get -y  install cmake
RUN apt -y install npm
COPY webservice /webservice
RUN cd ./webservice/server && \
	npm install && \
	cd ../ui && \
	npm install
RUN wget http://download.tensorflow.org/models/object_detection/faster_rcnn_inception_v2_coco_2018_01_28.tar.gz
RUN tar -xvf faster_rcnn_inception_v2_coco_2018_01_28.tar.gz
RUN cd faster_rcnn_inception_v2_coco_2018_01_28
#RUN python3 /opt/intel/openvino/deployment_tools/model_optimizer/mo.py --input_model faster_rcnn_inception_v2_coco_2018_01_28/frozen_inference_graph.pb --tensorflow_object_detection_api_pipeline_config pipeline.config --reverse_input_channels --tensorflow_use_custom_operations_config /opt/intel/openvino/deployment_tools/model_optimizer/extensions/front/tf/faster_rcnn_support.json
#RUN python3 /opt/intel/openvino/deployment_tools/model_optimizer/mo.py --input_model ssd_inception_v2_coco_2018_01_28/frozen_inference_graph.pb --tensorflow_object_detection_api_pipeline_config pipeline.config --reverse_input_channels --tensorflow_use_custom_operations_config /opt/intel/openvino/deployment_tools/model_optimizer/extensions/front/tf/ssd_v2_support.json
COPY ./script.sh /
CMD script.sh
COPY ffmpeg /ffmpeg
CMD ffserver -f ./ffmpeg/server.conf
COPY main.py /
COPY inference.py /
COPY resources /resources
RUN pip install opencv-python
RUN pip3 install opencv-python
CMD python3 main.py -i resources/Pedestrian_Detect_2_1_1.mp4 -m faster_rcnn_inception_v2_coco_2018_01_28/frozen_inference_graph.xml -l /opt/intel/openvino/deployment_tools/inference_engine/lib/intel64/libcpu_extension_sse4.so -d CPU -pt 0.4 | ffmpeg -v warning -f rawvideo -pixel_format bgr24 -video_size 768x432 -framerate 24 -i - http://0.0.0.0:3004/fac.ffm &
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN apt -y install python-opencv
RUN apt -y install python3-opencv
RUN pip install paho-mqtt
RUN apt -y install git
RUN git clone https://github.com/eclipse/paho.mqtt.python
RUN cd paho.mqtt.python && \
	python3 setup.py install
CMD source /opt/intel/openvino/bin/setupvars.sh -pyver 3.6
CMD /ffserver -f ./ffmpeg/server.conf
RUN cd faster_rcnn_inception_v2_coco_2018_01_28 && \
   python3 /opt/intel/openvino/deployment_tools/model_optimizer/mo.py --input_model frozen_inference_graph.pb --tensorflow_object_detection_api_pipeline_config pipeline.config --reverse_input_channels --tensorflow_use_custom_operations_config /opt/intel/openvino/deployment_tools/model_optimizer/extensions/front/tf/faster_rcnn_support.json
COPY start.sh /
RUN pip install pyyaml
RUN mkdir /model
RUN python3 /opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/downloader.py \
           --name face-detection-retail-0004  --output_dir /model
RUN python3 /opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/downloader.py \ 
           --name person-detection-retail-0013  --output_dir /model
RUN python3 /opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/downloader.py \ 
           --name age-gender-recognition-retail-0013 --output_dir /model

RUN python3 /opt/intel/openvino/deployment_tools/open_model_zoo/tools/downloader/downloader.py \ 
           --name facial-landmarks-35-adas-0002 --output_dir /model
RUN apt -y install nano
COPY main1.py /
COPY inference1.py /
COPY main2.py /
COPY inference2.py /
COPY inicia.sh /
COPY inicia2.sh /
CMD source /opt/intel/openvino/bin/setupvars.sh -pyver 3.6
COPY inito.sh /
