Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323F6C67872
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E226320645
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:51:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E226320645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbeLMJvZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:51:25 -0500
Received: from mga04.intel.com ([192.55.52.120]:43354 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbeLMJvY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:51:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 01:51:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,348,1539673200"; 
   d="scan'208";a="101204861"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2018 01:51:22 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 5BAB921007;
        Thu, 13 Dec 2018 11:51:21 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gXNeJ-0003uG-2i; Thu, 13 Dec 2018 11:51:19 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, laurent.pinchart@ideasonboard.com,
        rajmohan.mani@intel.com
Subject: [PATCH v9 21/22] staging/ipu3-imgu: Address documentation comments
Date:   Thu, 13 Dec 2018 11:51:06 +0200
Message-Id: <20181213095107.14894-22-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
References: <20181213095107.14894-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Address comments on the documentation after Yong's original patch.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../media/uapi/v4l/pixfmt-meta-intel-ipu3.rst      |   2 +-
 Documentation/media/v4l-drivers/ipu3.rst           | 343 ++++++++++++---------
 drivers/staging/media/ipu3/TODO                    |   7 +
 3 files changed, 201 insertions(+), 151 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
index 8cd30ffbf8b8b..dc871006b41a5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
@@ -175,4 +175,4 @@ video node in ``V4L2_BUF_TYPE_META_CAPTURE`` format.
 Intel IPU3 ImgU uAPI data types
 ===============================
 
-.. kernel-doc:: include/uapi/linux/intel-ipu3.h
+.. kernel-doc:: drivers/staging/media/ipu3/include/intel-ipu3.h
diff --git a/Documentation/media/v4l-drivers/ipu3.rst b/Documentation/media/v4l-drivers/ipu3.rst
index 045bf4222b1a0..f89b51dafadd0 100644
--- a/Documentation/media/v4l-drivers/ipu3.rst
+++ b/Documentation/media/v4l-drivers/ipu3.rst
@@ -9,196 +9,241 @@ Copyright |copy| 2018 Intel Corporation
 Introduction
 ============
 
-This file documents Intel IPU3 (3rd generation Image Processing Unit) Imaging
-Unit driver located under drivers/media/pci/intel/ipu3.
+This file documents the Intel IPU3 (3rd generation Image Processing Unit)
+Imaging Unit drivers located under drivers/media/pci/intel/ipu3 (CIO2) as well
+as under drivers/staging/media/ipu3 (ImgU).
 
 The Intel IPU3 found in certain Kaby Lake (as well as certain Sky Lake)
-platforms (U/Y processor lines) is made up of two parts namely Imaging Unit
-(ImgU) and CIO2 device (MIPI CSI2 receiver).
+platforms (U/Y processor lines) is made up of two parts namely the Imaging Unit
+(ImgU) and the CIO2 device (MIPI CSI2 receiver).
 
-The CIO2 device receives the raw bayer data from the sensors and outputs the
-frames in a format that is specific to IPU3 (for consumption by IPU3 ImgU).
-CIO2 driver is available as drivers/media/pci/intel/ipu3/ipu3-cio2* and is
-enabled through the CONFIG_VIDEO_IPU3_CIO2 config option.
+The CIO2 device receives the raw Bayer data from the sensors and outputs the
+frames in a format that is specific to the IPU3 (for consumption by the IPU3
+ImgU). The CIO2 driver is available as drivers/media/pci/intel/ipu3/ipu3-cio2*
+and is enabled through the CONFIG_VIDEO_IPU3_CIO2 config option.
 
 The Imaging Unit (ImgU) is responsible for processing images captured
-through IPU3 CIO2 device. The ImgU driver sources can be found under
-drivers/media/pci/intel/ipu3 directory. The driver is enabled through the
+by the IPU3 CIO2 device. The ImgU driver sources can be found under
+drivers/staging/media/ipu3 directory. The driver is enabled through the
 CONFIG_VIDEO_IPU3_IMGU config option.
 
-The two driver modules are named ipu3-csi2 and ipu3-imgu, respectively.
+The two driver modules are named ipu3_csi2 and ipu3_imgu, respectively.
 
-The driver has been tested on Kaby Lake platforms (U/Y processor lines).
+The drivers has been tested on Kaby Lake platforms (U/Y processor lines).
 
-The driver implements V4L2, Media controller and V4L2 sub-device interfaces.
-Camera sensors that have CSI-2 bus, which are connected to the IPU3 CIO2
-device are supported. Support for lens and flash drivers depends on the
-above sensors.
+Both of the drivers implement V4L2, Media Controller and V4L2 sub-device
+interfaces. The IPU3 CIO2 driver supports camera sensors connected to the CIO2
+MIPI CSI-2 interfaces through V4L2 sub-device sensor drivers.
 
-ImgU device nodes
-=================
+CIO2
+====
 
-The ImgU is represented as two V4L2 subdevs, each of which provides a V4L2
-subdev interface to the user space.
+The CIO2 is represented as a single V4L2 subdev, which provides a V4L2 subdev
+interface to the user space. There is a video node for each CSI-2 receiver,
+with a single media controller interface for the entire device.
 
-Each V4L2 subdev represents a pipe, which can support a maximum of 2
-streams. A private ioctl can be used to configure the mode (video or still)
-of the pipe.
+The CIO2 contains four independent capture channel, each with its own MIPI CSI-2
+receiver and DMA engine. Each channel is modelled as a V4L2 sub-device exposed
+to userspace as a V4L2 sub-device node and has two pads:
 
-This helps to support advanced camera features like Continuous View Finder
-(CVF) and Snapshot During Video(SDV).
+.. tabularcolumns:: |p{0.8cm}|p{4.0cm}|p{4.0cm}|
 
-CIO2 device
-===========
+.. flat-table::
 
-The CIO2 is represented as a single V4L2 subdev, which provides a V4L2 subdev
-interface to the user space. There is a video node for each CSI-2 receiver,
-with a single media controller interface for the entire device.
+    * - pad
+      - direction
+      - purpose
 
-Media controller
-----------------
+    * - 0
+      - sink
+      - MIPI CSI-2 input, connected to the sensor subdev
 
-The media device interface allows to configure the ImgU links, which defines
-the behavior of the IPU3 firmware.
+    * - 1
+      - source
+      - Raw video capture, connected to the V4L2 video interface
 
-Device operation
-----------------
+The V4L2 video interfaces model the DMA engines. They are exposed to userspace
+as V4L2 video device nodes.
 
-With IPU3, once the input video node ("ipu3-imgu 0/1":0,
-in <entity>:<pad-number> format) is queued with buffer (in packed raw bayer
-format), IPU3 ISP starts processing the buffer and produces the video output
-in YUV format and statistics output on respective output nodes. The driver
-is expected to have buffers ready for all of parameter, output and
-statistics nodes, when input video node is queued with buffer.
+Capturing frames in raw Bayer format
+------------------------------------
 
-At a minimum, all of input, main output, 3A statistics and viewfinder
-video nodes should be enabled for IPU3 to start image processing.
+CIO2 MIPI CSI2 receiver is used to capture frames (in packed raw Bayer format)
+from the raw sensors connected to the CSI2 ports. The captured frames are used
+as input to the ImgU driver.
 
-Each ImgU V4L2 subdev has the following set of video nodes.
+Image processing using IPU3 ImgU requires tools such as raw2pnm [#f1]_, and
+yavta [#f2]_ due to the following unique requirements and / or features specific
+to IPU3.
 
-input, output and viewfinder video nodes
-----------------------------------------
+-- The IPU3 CSI2 receiver outputs the captured frames from the sensor in packed
+raw Bayer format that is specific to IPU3.
 
-The frames (in packed raw bayer format specific to IPU3) received by the
-input video node is processed by the IPU3 Imaging Unit and is output to 2
-video nodes, with each targeting different purpose (main output and viewfinder
-output).
+-- Multiple video nodes have to be operated simultaneously.
 
-Details on raw bayer format specific to IPU3 can be found as below.
-Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
+Let us take the example of ov5670 sensor connected to CSI2 port 0, for a
+2592x1944 image capture.
 
-The driver supports V4L2 Video Capture Interface as defined at :ref:`devices`.
+Using the media contorller APIs, the ov5670 sensor is configured to send
+frames in packed raw Bayer format to IPU3 CSI2 receiver.
 
-Only the multi-planar API is supported. More details can be found at
-:ref:`planar-apis`.
+# This example assumes /dev/media0 as the CIO2 media device
 
+export MDEV=/dev/media0
 
-parameters video node
----------------------
+# and that ov5670 sensor is connected to i2c bus 10 with address 0x36
 
-The parameter video node receives the ISP algorithm parameters that are used
-to configure how the ISP algorithms process the image.
+export SDEV=$(media-ctl -d $MDEV -e "ov5670 10-0036")
 
-Details on raw bayer format specific to IPU3 can be found as below.
-Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst
+# Establish the link for the media devices using media-ctl [#f3]_
+media-ctl -d $MDEV -l "ov5670:0 -> ipu3-csi2 0:0[1]"
 
-3A statistics video node
-------------------------
+# Set the format for the media devices
+media-ctl -d $MDEV -V "ov5670:0 [fmt:SGRBG10/2592x1944]"
 
-3A statistics video node is used by the ImgU driver to output the 3A (auto
-focus, auto exposure and auto white balance) statistics for the frames that
-are being processed by the ISP to user space applications. User space
-applications can use this statistics data to arrive at desired algorithm
-parameters for ISP.
+media-ctl -d $MDEV -V "ipu3-csi2 0:0 [fmt:SGRBG10/2592x1944]"
 
-CIO2 device nodes
-=================
+media-ctl -d $MDEV -V "ipu3-csi2 0:1 [fmt:SGRBG10/2592x1944]"
 
-CIO2 is represented as a single V4L2 sub-device with a video node for each
-CSI-2 receiver. The video node represents the DMA engine.
+Once the media pipeline is configured, desired sensor specific settings
+(such as exposure and gain settings) can be set, using the yavta tool.
 
-Configuring the Intel IPU3
-==========================
+e.g
 
-The Intel IPU3 ImgU driver supports V4L2 interface. Using V4L2 ioctl calls,
-the ISP can be configured and enabled.
+yavta -w 0x009e0903 444 $SDEV
 
-The IPU3 ImgU pipelines can be configured using media controller APIs,
-defined at :ref:`media_controller`.
+yavta -w 0x009e0913 1024 $SDEV
 
-Capturing frames in raw bayer format
-------------------------------------
+yavta -w 0x009e0911 2046 $SDEV
 
-IPU3 MIPI CSI2 receiver is used to capture frames (in packed raw bayer
-format) from the raw sensors connected to the CSI2 ports. The captured
-frames are used as input to the ImgU driver.
+Once the desired sensor settings are set, frame captures can be done as below.
 
-Image processing using IPU3 ImgU requires tools such as v4l2n [#f1]_,
-raw2pnm [#f1]_, and yavta [#f2]_ due to the following unique requirements
-and / or features specific to IPU3.
+e.g
 
--- The IPU3 CSI2 receiver outputs the captured frames from the sensor in
-packed raw bayer format that is specific to IPU3
+yavta --data-prefix -u -c10 -n5 -I -s2592x1944 --file=/tmp/frame-#.bin \
+      -f IPU3_SGRBG10 $(media-ctl -d $MDEV -e "ipu3-cio2 0")
 
--- Multiple video nodes have to be operated simultaneously
+With the above command, 10 frames are captured at 2592x1944 resolution, with
+sGRBG10 format and output as IPU3_SGRBG10 format.
 
-Let us take the example of ov5670 sensor connected to CSI2 port 0, for a
-2592x1944 image capture.
+The captured frames are available as /tmp/frame-#.bin files.
 
-Using the media contorller APIs, the ov5670 sensor is configured to send
-frames in packed raw bayer format to IPU3 CSI2 receiver.
+ImgU
+====
 
-# This example assumes /dev/media0 as the ImgU media device
+The ImgU is represented as two V4L2 subdevs, each of which provides a V4L2
+subdev interface to the user space.
 
-export MDEV=/dev/media0
+Each V4L2 subdev represents a pipe, which can support a maximum of 2 streams.
+This helps to support advanced camera features like Continuous View Finder (CVF)
+and Snapshot During Video(SDV).
 
-# and that ov5670 sensor is connected to i2c bus 10 with address 0x36
+The ImgU contains two independent pipes, each modelled as a V4L2 sub-device
+exposed to userspace as a V4L2 sub-device node.
 
-export SDEV="ov5670 10-0036"
+Each pipe has two sink pads and three source pads for the following purpose:
 
-# Establish the link for the media devices using media-ctl [#f3]_
-media-ctl -d $MDEV -l "ov5670 ":0 -> "ipu3-csi2 0":0[1]
+.. tabularcolumns:: |p{0.8cm}|p{4.0cm}|p{4.0cm}|
 
-media-ctl -d $MDEV -l "ipu3-csi2 0":1 -> "ipu3-cio2 0":0[1]
+.. flat-table::
 
-# Set the format for the media devices
-media-ctl -d $MDEV -V "ov5670 ":0 [fmt:SGRBG10/2592x1944]
+    * - pad
+      - direction
+      - purpose
 
-media-ctl -d $MDEV -V "ipu3-csi2 0":0 [fmt:SGRBG10/2592x1944]
+    * - 0
+      - sink
+      - Input raw video stream
 
-media-ctl -d $MDEV -V "ipu3-csi2 0":1 [fmt:SGRBG10/2592x1944]
+    * - 1
+      - sink
+      - Processing parameters
 
-Once the media pipeline is configured, desired sensor specific settings
-(such as exposure and gain settings) can be set, using the yavta tool.
+    * - 2
+      - source
+      - Output processed video stream
 
-e.g
+    * - 3
+      - source
+      - Output viewfinder video stream
 
-yavta -w 0x009e0903 444 $(media-ctl -d $MDEV -e "$SDEV")
+    * - 4
+      - source
+      - 3A statistics
 
-yavta -w 0x009e0913 1024 $(media-ctl -d $MDEV -e "$SDEV")
+Each pad is connected to a corresponding V4L2 video interface, exposed to 
+userspace as a V4L2 video device node.
+
+Device operation
+----------------
 
-yavta -w 0x009e0911 2046 $(media-ctl -d $MDEV -e "$SDEV")
+With ImgU, once the input video node ("ipu3-imgu 0/1":0, in
+<entity>:<pad-number> format) is queued with buffer (in packed raw Bayer
+format), ImgU starts processing the buffer and produces the video output in YUV
+format and statistics output on respective output nodes. The driver is expected
+to have buffers ready for all of parameter, output and statistics nodes, when
+input video node is queued with buffer.
 
-Once the desired sensor settings are set, frame captures can be done as below.
+At a minimum, all of input, main output, 3A statistics and viewfinder
+video nodes should be enabled for IPU3 to start image processing.
 
-e.g
+Each ImgU V4L2 subdev has the following set of video nodes.
 
-yavta --data-prefix -u -c10 -n5 -I -s2592x1944 --file=/tmp/frame-#.bin
--f IPU3_GRBG10 media-ctl -d $MDEV -e ipu3-cio2 0
+input, output and viewfinder video nodes
+----------------------------------------
 
-With the above command, 10 frames are captured at 2592x1944 resolution, with
-sGRBG10 format and output as IPU3_GRBG10 format.
+The frames (in packed raw Bayer format specific to the IPU3) received by the
+input video node is processed by the IPU3 Imaging Unit and are output to 2 video
+nodes, with each targeting a different purpose (main output and viewfinder
+output).
 
-The captured frames are available as /tmp/frame-#.bin files.
+Details onand the Bayer format specific to the IPU3 can be found in
+:ref:`v4l2-pix-fmt-ipu3-sbggr10`.
 
-Processing the image in raw bayer format
+The driver supports V4L2 Video Capture Interface as defined at :ref:`devices`.
+
+Only the multi-planar API is supported. More details can be found at
+:ref:`planar-apis`.
+
+Parameters video node
+---------------------
+
+The parameters video node receives the ImgU algorithm parameters that are used
+to configure how the ImgU algorithms process the image.
+
+Details on processing parameters specific to the IPU3 can be found in
+:ref:`v4l2-meta-fmt-params`.
+
+3A statistics video node
+------------------------
+
+3A statistics video node is used by the ImgU driver to output the 3A (auto
+focus, auto exposure and auto white balance) statistics for the frames that are
+being processed by the ImgU to user space applications. User space applications
+can use this statistics data to compute the desired algorithm parameters for
+the ImgU.
+
+Configuring the Intel IPU3
+==========================
+
+The IPU3 ImgU pipelines can be configured using the Media Controller, defined at
+:ref:`media_controller`.
+
+Firmware binary selection
+-------------------------
+
+The firmware binary is selected using the V4L2_CID_INTEL_IPU3_MODE, currently
+defined in drivers/staging/media/ipu3/include/intel-ipu3.h . "VIDEO" and "STILL"
+modes are available.
+
+Processing the image in raw Bayer format
 ----------------------------------------
 
 Configuring ImgU V4L2 subdev for image processing
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-The ImgU V4L2 subdevs have to be configured with media controller APIs to
-have all the video nodes setup correctly.
+The ImgU V4L2 subdevs have to be configured with media controller APIs to have
+all the video nodes setup correctly.
 
 Let us take "ipu3-imgu 0" subdev as an example.
 
@@ -206,40 +251,38 @@ media-ctl -d $MDEV -r
 
 media-ctl -d $MDEV -l "ipu3-imgu 0 input":0 -> "ipu3-imgu 0":0[1]
 
-media-ctl -d $MDEV -l "ipu3-imgu 0":2 -> "output":0[1]
+media-ctl -d $MDEV -l "ipu3-imgu 0":2 -> "ipu3-imgu 0 output":0[1]
 
-media-ctl -d $MDEV -l "ipu3-imgu 0":3 -> "viewfinder":0[1]
+media-ctl -d $MDEV -l "ipu3-imgu 0":3 -> "ipu3-imgu 0 viewfinder":0[1]
 
-media-ctl -d $MDEV -l "ipu3-imgu 0":4 -> "3a stat":0[1]
+media-ctl -d $MDEV -l "ipu3-imgu 0":4 -> "ipu3-imgu 0 3a stat":0[1]
 
-Also the pipe mode of the corresponding V4L2 subdev should be set as
-desired (e.g 0 for video mode or 1 for still mode) through the
-control id 0x009819a1 as below.
-
-e.g
+Also the pipe mode of the corresponding V4L2 subdev should be set as desired
+(e.g 0 for video mode or 1 for still mode) through the control id 0x009819a1 as
+below.
 
-v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1
+yavta -w "0x009819A1 1" /dev/v4l-subdev7
 
-RAW bayer frames go through the following ISP pipeline HW blocks to
-have the processed image output to the DDR memory.
+RAW Bayer frames go through the following ImgU pipeline HW blocks to have the
+processed image output to the DDR memory.
 
-RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) -> Geometric
+RAW Bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) -> Geometric
 Distortion Correction (GDC) -> DDR
 
-The ImgU V4L2 subdev has to be configured with the supported resolutions
-in all the above HW blocks, for a given input resolution.
+The ImgU V4L2 subdev has to be configured with the supported resolutions in all
+the above HW blocks, for a given input resolution.
 
-For a given supported resolution for an input frame, the Input Feeder,
-Bayer Down Scaling and GDC blocks should be configured with the supported
-resolutions. This information can be obtained by looking at the following
-IPU3 ISP configuration table.
+For a given supported resolution for an input frame, the Input Feeder, Bayer
+Down Scaling and GDC blocks should be configured with the supported resolutions.
+This information can be obtained by looking at the following IPU3 ImgU
+configuration table.
 
 https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/master
 
-Under baseboard-poppy/media-libs/arc-camera3-hal-configs-poppy/files/gcss
+Under baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files/gcss
 directory, graph_settings_ov5670.xml can be used as an example.
 
-The following steps prepare the ImgU ISP pipeline for the image processing.
+The following steps prepare the ImgU pipeline for the image processing.
 
 1. The ImgU V4L2 subdev data format should be set by using the
 VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained above.
@@ -257,14 +300,14 @@ For the ov5670 example, for an input frame with a resolution of 2592x1944
 for input feeder, BDS and GDC are 2592x1944, 2592x1944 and 2560x1920
 respectively.
 
-Once this is done, the received raw bayer frames can be input to the ImgU
-V4L2 subdev as below, using the open source application v4l2n.
+Once this is done, the received raw Bayer frames can be input to the ImgU
+V4L2 subdev as below, using the open source application v4l2n [#f1]_.
 
 For an image captured with 2592x1944 [#f4]_ resolution, with desired output
 resolution as 2560x1920 and viewfinder resolution as 2560x1920, the following
-v4l2n command can be used. This helps process the raw bayer frames and
-produces the desired results for the main output image and the viewfinder
-output, in NV12 format.
+v4l2n command can be used. This helps process the raw Bayer frames and produces
+the desired results for the main output image and the viewfinder output, in NV12
+format.
 
 v4l2n --pipe=4 --load=/tmp/frame-#.bin --open=/dev/video4
 --fmt=type:VIDEO_OUTPUT_MPLANE,width=2592,height=1944,pixelformat=0X47337069
@@ -281,7 +324,7 @@ v4l2n --pipe=4 --load=/tmp/frame-#.bin --open=/dev/video4
 where /dev/video4, /dev/video5, /dev/video6 and /dev/video7 devices point to
 input, output, viewfinder and 3A statistics video nodes respectively.
 
-Converting the raw bayer image into YUV domain
+Converting the raw Bayer image into YUV domain
 ----------------------------------------------
 
 The processed images after the above step, can be converted to YUV domain
@@ -290,7 +333,7 @@ as below.
 Main output frames
 ~~~~~~~~~~~~~~~~~~
 
-raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.out /tmp/frames.out.pnm
+raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.out /tmp/frames.out.ppm
 
 where 2560x1920 is output resolution, NV12 is the video format, followed
 by input frame and output PNM file.
@@ -298,7 +341,7 @@ by input frame and output PNM file.
 Viewfinder output frames
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
-raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.vf /tmp/frames.vf.pnm
+raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.vf /tmp/frames.vf.ppm
 
 where 2560x1920 is output resolution, NV12 is the video format, followed
 by input frame and output PNM file.
@@ -315,7 +358,7 @@ The source can be located under hal/intel directory.
 References
 ==========
 
-include/uapi/linux/intel-ipu3.h
+.. [#f5] include/uapi/linux/intel-ipu3.h
 
 .. [#f1] https://github.com/intel/nvt
 
diff --git a/drivers/staging/media/ipu3/TODO b/drivers/staging/media/ipu3/TODO
index 922b885f10a70..d3076f5ebec1a 100644
--- a/drivers/staging/media/ipu3/TODO
+++ b/drivers/staging/media/ipu3/TODO
@@ -21,3 +21,10 @@ staging directory.
   Further clarification on some ambiguities such as data type conversion of
   IEFD CU inputs. (Sakari)
   Move acronyms to doc-rst file. (Mauro)
+
+- Switch to yavta from v4l2n in driver docs.
+
+- Elaborate the functionality of different selection rectangles in driver
+  documentation. This may require driver changes as well.
+
+- More detailed documentation on calculating BDS, GCD etc. sizes needed.
-- 
2.11.0

