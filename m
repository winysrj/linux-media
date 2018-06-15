Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:7746 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964995AbeFOD3u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 23:29:50 -0400
From: Yong Zhi <yong.zhi@intel.com>
To: sakari.ailus@linux.intel.com, linux-media@vger.kernel.org
Cc: tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        laurent.pinchart@ideasonboard.com, rajmohan.mani@intel.com,
        jian.xu.zheng@intel.com, jerry.w.hu@intel.com, chao.c.li@intel.com,
        tian.shu.qiu@intel.com
Subject: [PATCH v1 1/2] doc-rst: Add Intel IPU3 documentation
Date: Thu, 14 Jun 2018 22:29:32 -0500
Message-Id: <1529033373-15724-2-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
References: <1529033373-15724-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rajmohan Mani <rajmohan.mani@intel.com>

This patch adds the details about the IPU3 Imaging Unit driver.

Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
Signed-off-by: Tian Shu Qiu <tian.shu.qiu@intel.com>
---
 Documentation/media/v4l-drivers/index.rst |   1 +
 Documentation/media/v4l-drivers/ipu3.rst  | 304 ++++++++++++++++++++++++++++++
 2 files changed, 305 insertions(+)
 create mode 100644 Documentation/media/v4l-drivers/ipu3.rst

diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 679238e..179a393 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -44,6 +44,7 @@ For more details see the file COPYING in the source distribution of Linux.
 	davinci-vpbe
 	fimc
 	imx
+	ipu3
 	ivtv
 	max2175
 	meye
diff --git a/Documentation/media/v4l-drivers/ipu3.rst b/Documentation/media/v4l-drivers/ipu3.rst
new file mode 100644
index 0000000..a4550d8
--- /dev/null
+++ b/Documentation/media/v4l-drivers/ipu3.rst
@@ -0,0 +1,304 @@
+.. include:: <isonum.txt>
+
+===============================================================
+Intel Image Processing Unit 3 (IPU3) Imaging Unit (ImgU) driver
+===============================================================
+
+Copyright |copy| 2018 Intel Corporation
+
+Introduction
+============
+
+This file documents Intel IPU3 (3rd generation Image Processing Unit) Imaging
+Unit driver located under drivers/media/pci/intel/ipu3.
+
+The Intel IPU3 found in certain Kaby Lake (as well as certain Sky Lake)
+platforms (U/Y processor lines) is made up of two parts namely Imaging Unit
+(ImgU) and CIO2 device (MIPI CSI2 receiver).
+
+The CIO2 device receives the raw bayer data from the sensors and outputs the
+frames in a format that is specific to IPU3 (for consumption by IPU3 ImgU).
+CIO2 driver is available as drivers/media/pci/intel/ipu3/ipu3-cio2* and is
+enabled through the CONFIG_VIDEO_IPU3_CIO2 config option.
+
+The Imaging Unit (ImgU) is responsible for processing images captured
+through IPU3 CIO2 device. The ImgU driver sources can be found under
+drivers/media/pci/intel/ipu3 directory. The driver is enabled through the
+CONFIG_VIDEO_IPU3_IMGU config option.
+
+The two driver modules are named ipu3-csi2 and ipu3-imgu, respectively.
+
+The driver has been tested on Kaby Lake platforms (U/Y processor lines).
+
+The driver implements V4L2, Media controller and V4L2 sub-device interfaces.
+Camera sensors that have CSI-2 bus, which are connected to the IPU3 CIO2
+device are supported. Support for lens and flash drivers depends on the
+above sensors.
+
+ImgU device nodes
+=================
+
+The ImgU is represented as a single V4L2 subdev, which provides a V4L2 subdev
+interface to the user space.
+
+CIO2 device
+===========
+
+The CIO2 is represented as a single V4L2 subdev, which provides a V4L2 subdev
+interface to the user space. There is a video node for each CSI-2 receiver,
+with a single media controller interface for the entire device.
+
+Media controller
+----------------
+
+The media device interface allows to configure the ImgU links, which defines
+the behavior of the IPU3 firmware. The link configuration tells the firmware
+whether viewfinder or postview ISP pipeline should be enabled.
+
+Device operation
+----------------
+
+With IPU3, once the input video node ("ipu3-imgu":0, in <entity>:<pad-number>
+format) is queued with buffer (in packed raw bayer format), IPU3 ISP starts
+processing the buffer and produces the video output in YUV format and
+statistics output on respective output nodes. The driver is expected to have
+buffers ready for all of parameter, output and statistics nodes, when input
+video node is queued with buffer.
+
+At a minimum, all of input, main output, 3A statistics, and either of
+viewfinder or postview video nodes should be enabled for IPU3 to start image
+processing. viewfinder and postview video nodes are mutually exclusive.
+
+input, output, viewfinder and postview video nodes
+--------------------------------------------------
+
+The frames (in packed raw bayer format specific to IPU3) received by the
+input video node is processed by the IPU3 Imaging Unit and is output to 2
+video nodes, with each targeting different purpose (main output and viewfinder
+or postview output).
+
+Details on raw bayer format specific to IPU3 can be found as below.
+Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
+
+The driver supports V4L2 Video Capture Interface as defined at :ref:`devices`.
+
+Only the multi-planar API is supported. More details can be found at
+:ref:`planar-apis`.
+
+
+parameters video node
+---------------------
+
+The parameter video node receives the ISP algorithm parameters that are used
+to configure how the ISP algorithms process the image.
+
+Details on raw bayer format specific to IPU3 can be found as below.
+Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
+
+3A statistics video node
+------------------------
+
+3A statistics video node is used by the ImgU driver to output the 3A (auto
+focus, auto exposure and auto white balance) statistics for the frames that
+are being processed by the ISP to user space applications. User space
+applications can use this statistics data to arrive at desired algorithm
+parameters for ISP.
+
+CIO2 device nodes
+=================
+
+CIO2 is represented as a single V4L2 sub-device with a video node for each
+CSI-2 receiver. The video node represents the DMA engine.
+
+Configuring the Intel IPU3
+==========================
+
+The Intel IPU3 ImgU driver supports V4L2 interface. Using V4L2 ioctl calls,
+the ISP can be configured and enabled.
+
+The IPU3 ImgU pipelines can be configured using media controller APIs,
+defined at :ref:`media_controller`.
+
+Capturing frames in raw bayer format
+------------------------------------
+
+IPU3 MIPI CSI2 receiver is used to capture frames (in packed raw bayer
+format) from the raw sensors connected to the CSI2 ports. The captured
+frames are used as input to the ImgU driver.
+
+Image processing using IPU3 ImgU requires tools such as v4l2n [#f1]_,
+raw2pnm [#f1]_, and yavta [#f2]_ due to the following unique requirements
+and / or features specific to IPU3.
+
+-- The IPU3 CSI2 receiver outputs the captured frames from the sensor in
+packed raw bayer format that is specific to IPU3
+
+-- Multiple video nodes have to be operated simultaneously
+
+Let us take the example of ov5670 sensor connected to CSI2 port 0, for a
+2592x1944 image capture.
+
+Using the media contorller APIs, the ov5670 sensor is configured to send
+frames in packed raw bayer format to IPU3 CSI2 receiver.
+
+# This example assumes /dev/media0 as the ImgU media device
+
+export MDEV=/dev/media0
+
+# and that ov5670 sensor is connected to i2c bus 10 with address 0x36
+
+export SDEV="ov5670 10-0036"
+
+# Establish the link for the media devices using media-ctl [#f3]_
+media-ctl -d $MDEV -l "ov5670 ":0 -> "ipu3-csi2 0":0[1]
+
+media-ctl -d $MDEV -l "ipu3-csi2 0":1 -> "ipu3-cio2 0":0[1]
+
+# Set the format for the media devices
+media-ctl -d $MDEV -V "ov5670 ":0 [fmt:SGRBG10/2592x1944]
+
+media-ctl -d $MDEV -V "ipu3-csi2 0":0 [fmt:SGRBG10/2592x1944]
+
+media-ctl -d $MDEV -V "ipu3-csi2 0":1 [fmt:SGRBG10/2592x1944]
+
+Once the media pipeline is configured, desired sensor specific settings
+(such as exposure and gain settings) can be set, using the yavta tool.
+
+e.g
+
+yavta -w 0x009e0903 444 $(media-ctl -d $MDEV -e "$SDEV")
+
+yavta -w 0x009e0913 1024 $(media-ctl -d $MDEV -e "$SDEV")
+
+yavta -w 0x009e0911 2046 $(media-ctl -d $MDEV -e "$SDEV")
+
+Once the desired sensor settings are set, frame captures can be done as below.
+
+e.g
+
+yavta --data-prefix -u -c10 -n5 -I -s2592x1944 --file=/tmp/frame-#.bin
+-f IPU3_GRBG10 media-ctl -d $MDEV -e ipu3-cio2 0
+
+With the above command, 10 frames are captured at 2592x1944 resolution, with
+sGRBG10 format and output as IPU3_GRBG10 format.
+
+The captured frames are available as /tmp/frame-#.bin files.
+
+Processing the image in raw bayer format
+----------------------------------------
+
+Configuring ImgU V4L2 subdev for image processing
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The ImgU V4L2 subdev has to be configured with media controller APIs to
+have all the video nodes setup correctly.
+
+media-ctl -d $MDEV -l "ipu3-imgu":2 -> "output":0[1]
+
+media-ctl -d $MDEV -l "ipu3-imgu":3 -> "viewfinder":0[0]
+
+media-ctl -d $MDEV -l "ipu3-imgu":4 -> "postview":0[1]
+
+media-ctl -d $MDEV -l "ipu3-imgu":5 -> "3a stat":0[1]
+
+In this particular example, postview node is enabled.
+
+RAW bayer frames go through the following ISP pipeline HW blocks to
+have the processed image output to the DDR memory.
+
+RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) -> Geometric
+Distortion Correction (GDC) -> DDR
+
+The ImgU V4L2 subdev has to be configured with the supported resolutions
+in all the above HW blocks, for a given input resolution.
+
+For a given supported resolution for an input frame, the Input Feeder,
+Bayer Down Scaling and GDC blocks should be configured with the supported
+resolutions. This information can be obtained by looking at the following
+IPU3 ISP configuration table.
+
+https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/master
+
+Under baseboard-poppy/media-libs/arc-camera3-hal-configs-poppy/files/gcss
+directory, graph_settings_ov5670.xml can be used as an example.
+
+The following steps prepare the ImgU ISP pipeline for the image processing.
+
+1. The ImgU V4L2 subdev data format should be set by using the
+VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained above.
+
+2. The ImgU V4L2 subdev cropping should be set by using the
+VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as the target,
+using the input feeder height and width.
+
+3. The ImgU V4L2 subdev composing should be set by using the
+VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the target,
+using the BDS height and width.
+
+For the ov5670 example, for an input frame with a resolution of 2592x1944
+(which is input to the ImgU subdev pad 0), the corresponding resolutions
+for input feeder, BDS and GDC are 2592x1944, 2592x1944 and 2560x1920
+respectively.
+
+Once this is done, the received raw bayer frames can be input to the ImgU
+V4L2 subdev as below, using the open source application v4l2n.
+
+For an image captured with 2592x1944 [#f4]_ resolution, with desired output
+resolution as 2560x1920 and viewfinder resolution as 2560x1920, the following
+v4l2n command can be used. This helps process the raw bayer frames and
+produces the desired results for the main output image and the viewfinder
+output, in NV12 format.
+
+v4l2n --pipe=4 --load=/tmp/frame-#.bin --open=$MDEV
+--fmt=type:VIDEO_OUTPUT_MPLANE,width=2592,height=1944,pixelformat=0X47337069
+--reqbufs=type:VIDEO_OUTPUT_MPLANE,count:1 --pipe=1 --output=/tmp/frames.out
+--open= --fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
+--reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=2 --output=/tmp/frames.vf
+--open= --fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
+--reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=3 --open=
+--output=/tmp/frames.3A --fmt=type:META_CAPTURE,?
+--reqbufs=count:1,type:META_CAPTURE --pipe=1,2,3,4 --stream=5
+
+Converting the raw bayer image into YUV domain
+----------------------------------------------
+
+The processed images after the above step, can be converted to YUV domain
+as below.
+
+Main output frames
+~~~~~~~~~~~~~~~~~~
+
+raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.out /tmp/frames.out.pnm
+
+where 2560x1920 is output resolution, NV12 is the video format, followed
+by input frame and output PNM file.
+
+Viewfinder output frames
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.vf /tmp/frames.vf.pnm
+
+where 2560x1920 is output resolution, NV12 is the video format, followed
+by input frame and output PNM file.
+
+Example user space code for IPU3
+================================
+
+User space code that configures and uses IPU3 is available here.
+
+https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master/
+
+The source can be located under hal/intel directory.
+
+References
+==========
+
+include/uapi/linux/intel-ipu3.h
+
+.. [#f1] https://github.com/intel/nvt
+
+.. [#f2] http://git.ideasonboard.org/yavta.git
+
+.. [#f3] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
+
+.. [#f4] ImgU limitation requires an additional 16x16 for all input resolutions
-- 
2.7.4
