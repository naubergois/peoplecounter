 python3 main1.py -i resources/r1.mp4 \
         -m /model/intel/person-detection-retail-0013/FP32/person-detection-retail-0013.xml -d CPU -pt 0.4 | ffmpeg -v warning -f rawvideo -pixel_format bgr24 -video_size 768x432 -framerate 24 -i - http://0.0.0.0:3004/fac.ffm

