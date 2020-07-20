
source /opt/intel/openvino/bin/setupvars.sh -pyver 3.6

cd webservice/server/node-server
node ./server.js &

cd /
 ffserver -f ./ffmpeg/server.conf &



