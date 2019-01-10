Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D95CC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C04BD2173B
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 12:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="fDp3cquO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbfAJMJv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 07:09:51 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:47820 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbfAJMJu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 07:09:50 -0500
Received: from avalon.bb.dnainternet.fi (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 27202597;
        Thu, 10 Jan 2019 13:09:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547122186;
        bh=heG4FsgzLi07HY4FDYV9YGVNgpF+8qxPw4OqJeEv/8M=;
        h=From:To:Cc:Subject:Date:From;
        b=fDp3cquOdFyiZxRo4JG3yx0du2+LX5lJl09L04r8c1eTPkOPk4VRM1c6Gd+G/b+Vt
         7ikR974gzWzE2m9IBYjVqFxZwteHEIdj1V6kGgtrtXxtqrJU/KJ+l6dNSeUT/lWEjj
         mVWMs8IeSBEEv2Gk9uOWimv5zoxCBhhWV6qs/Uo8=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     linux-media@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Yong Zhi <yong.zhi@intel.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>
Subject: [PATCH] media: Documentation: staging/ipu3-imgu: Miscellaneous improvements
Date:   Thu, 10 Jan 2019 14:10:52 +0200
Message-Id: <20190110121052.10116-1-laurent.pinchart@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Implement miscellaneous changes that have been proposed in review
comments but not captured, rephrase and clarify parts of the
documentation, and mark shell code blocks appropriately.

Major changes are still required, included rewriting the examples
without the v4l2n tool, and documenting the internal blocks of the ImgU.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/media/v4l-drivers/ipu3.rst | 201 +++++++++++------------
 1 file changed, 94 insertions(+), 107 deletions(-)

diff --git a/Documentation/media/v4l-drivers/ipu3.rst b/Documentation/media/v4l-drivers/ipu3.rst
index 804f37300623..f9846276e138 100644
--- a/Documentation/media/v4l-drivers/ipu3.rst
+++ b/Documentation/media/v4l-drivers/ipu3.rst
@@ -2,9 +2,9 @@
 
 .. include:: <isonum.txt>
 
-===============================================================
-Intel Image Processing Unit 3 (IPU3) Imaging Unit (ImgU) driver
-===============================================================
+=========================================================================
+Intel Image Processing Unit 3 (IPU3) CIO2 and Imaging Unit (ImgU) drivers
+=========================================================================
 
 Copyright |copy| 2018 Intel Corporation
 
@@ -12,8 +12,8 @@ Introduction
 ============
 
 This file documents the Intel IPU3 (3rd generation Image Processing Unit)
-Imaging Unit drivers located under drivers/media/pci/intel/ipu3 (CIO2) as well
-as under drivers/staging/media/ipu3 (ImgU).
+drivers located under drivers/media/pci/intel/ipu3 (CIO2) and
+drivers/staging/media/ipu3 (Imaging Unit, ImgU).
 
 The Intel IPU3 found in certain Kaby Lake (as well as certain Sky Lake)
 platforms (U/Y processor lines) is made up of two parts namely the Imaging Unit
@@ -31,19 +31,15 @@ CONFIG_VIDEO_IPU3_IMGU config option.
 
 The two driver modules are named ipu3_csi2 and ipu3_imgu, respectively.
 
-The drivers has been tested on Kaby Lake platforms (U/Y processor lines).
+The drivers have been tested on Kaby Lake platforms (U/Y processor lines).
 
-Both of the drivers implement V4L2, Media Controller and V4L2 sub-device
+Both drivers implement the V4L2, Media Controller and V4L2 sub-device
 interfaces. The IPU3 CIO2 driver supports camera sensors connected to the CIO2
 MIPI CSI-2 interfaces through V4L2 sub-device sensor drivers.
 
 CIO2
 ====
 
-The CIO2 is represented as a single V4L2 subdev, which provides a V4L2 subdev
-interface to the user space. There is a video node for each CSI-2 receiver,
-with a single media controller interface for the entire device.
-
 The CIO2 contains four independent capture channel, each with its own MIPI CSI-2
 receiver and DMA engine. Each channel is modelled as a V4L2 sub-device exposed
 to userspace as a V4L2 sub-device node and has two pads:
@@ -67,6 +63,8 @@ to userspace as a V4L2 sub-device node and has two pads:
 The V4L2 video interfaces model the DMA engines. They are exposed to userspace
 as V4L2 video device nodes.
 
+All four channels are part of a single media controller graph.
+
 Capturing frames in raw Bayer format
 ------------------------------------
 
@@ -86,44 +84,44 @@ raw Bayer format that is specific to IPU3.
 Let us take the example of ov5670 sensor connected to CSI2 port 0, for a
 2592x1944 image capture.
 
-Using the media contorller APIs, the ov5670 sensor is configured to send
+Using the media controller APIs, the ov5670 sensor is configured to send
 frames in packed raw Bayer format to IPU3 CSI2 receiver.
 
-# This example assumes /dev/media0 as the CIO2 media device
-
-export MDEV=/dev/media0
+.. code-block:: shell
 
-# and that ov5670 sensor is connected to i2c bus 10 with address 0x36
+  # This example assumes /dev/media0 as the CIO2 media device
+  export MDEV=/dev/media0
 
-export SDEV=$(media-ctl -d $MDEV -e "ov5670 10-0036")
+  # and that ov5670 sensor is connected to i2c bus 10 with address 0x36
+  export SDEV=$(media-ctl -d $MDEV -e "ov5670 10-0036")
 
-# Establish the link for the media devices using media-ctl [#f3]_
-media-ctl -d $MDEV -l "ov5670:0 -> ipu3-csi2 0:0[1]"
+  # Establish the link for the media devices using media-ctl [#f3]_
+  media-ctl -d $MDEV -l "ov5670:0 -> ipu3-csi2 0:0[1]"
 
-# Set the format for the media devices
-media-ctl -d $MDEV -V "ov5670:0 [fmt:SGRBG10/2592x1944]"
-
-media-ctl -d $MDEV -V "ipu3-csi2 0:0 [fmt:SGRBG10/2592x1944]"
-
-media-ctl -d $MDEV -V "ipu3-csi2 0:1 [fmt:SGRBG10/2592x1944]"
+  # Set the format for the media devices
+  media-ctl -d $MDEV -V "ov5670:0 [fmt:SGRBG10/2592x1944]"
+  media-ctl -d $MDEV -V "ipu3-csi2 0:0 [fmt:SGRBG10/2592x1944]"
+  media-ctl -d $MDEV -V "ipu3-csi2 0:1 [fmt:SGRBG10/2592x1944]"
 
 Once the media pipeline is configured, desired sensor specific settings
 (such as exposure and gain settings) can be set, using the yavta tool.
 
 e.g
 
-yavta -w 0x009e0903 444 $SDEV
-
-yavta -w 0x009e0913 1024 $SDEV
+.. code-block:: shell
 
-yavta -w 0x009e0911 2046 $SDEV
+  yavta -w 0x009e0903 444 $SDEV
+  yavta -w 0x009e0913 1024 $SDEV
+  yavta -w 0x009e0911 2046 $SDEV
 
 Once the desired sensor settings are set, frame captures can be done as below.
 
 e.g
 
-yavta --data-prefix -u -c10 -n5 -I -s2592x1944 --file=/tmp/frame-#.bin \
-      -f IPU3_SGRBG10 $(media-ctl -d $MDEV -e "ipu3-cio2 0")
+.. code-block:: shell
+
+  yavta --data-prefix -u -c10 -n5 -I -s2592x1944 --file=/tmp/frame-#.bin \
+        -f IPU3_SGRBG10 $(media-ctl -d $MDEV -e "ipu3-cio2 0")
 
 With the above command, 10 frames are captured at 2592x1944 resolution, with
 sGRBG10 format and output as IPU3_SGRBG10 format.
@@ -179,27 +177,26 @@ userspace as a V4L2 video device node.
 Device operation
 ----------------
 
-With ImgU, once the input video node ("ipu3-imgu 0/1":0, in
-<entity>:<pad-number> format) is queued with buffer (in packed raw Bayer
-format), ImgU starts processing the buffer and produces the video output in YUV
-format and statistics output on respective output nodes. The driver is expected
-to have buffers ready for all of parameter, output and statistics nodes, when
-input video node is queued with buffer.
+With ImgU, a buffer is queued on the input video node ("ipu3-imgu 0/1":0, in
+<entity>:<pad-number> format), the ImgU starts processing the buffer and
+produces the video output in YUV format and statistics output on respective
+output nodes. The driver is expected to have buffers ready for all of parameter,
+output and statistics nodes, when a buffer is queued on the input video node.
 
 At a minimum, all of input, main output, 3A statistics and viewfinder
 video nodes should be enabled for IPU3 to start image processing.
 
 Each ImgU V4L2 subdev has the following set of video nodes.
 
-input, output and viewfinder video nodes
-----------------------------------------
+Input, output and viewfinder video nodes
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The frames (in packed raw Bayer format specific to the IPU3) received by the
-input video node is processed by the IPU3 Imaging Unit and are output to 2 video
-nodes, with each targeting a different purpose (main output and viewfinder
+input video node are processed by the IPU3 Imaging Unit and are output to 2
+video nodes, with each targeting a different purpose (main output and viewfinder
 output).
 
-Details onand the Bayer format specific to the IPU3 can be found in
+Details about the Bayer format specific to the IPU3 can be found in
 :ref:`v4l2-pix-fmt-ipu3-sbggr10`.
 
 The driver supports V4L2 Video Capture Interface as defined at :ref:`devices`.
@@ -208,7 +205,7 @@ Only the multi-planar API is supported. More details can be found at
 :ref:`planar-apis`.
 
 Parameters video node
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 The parameters video node receives the ImgU algorithm parameters that are used
 to configure how the ImgU algorithms process the image.
@@ -217,7 +214,7 @@ Details on processing parameters specific to the IPU3 can be found in
 :ref:`v4l2-meta-fmt-params`.
 
 3A statistics video node
-------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~
 
 3A statistics video node is used by the ImgU driver to output the 3A (auto
 focus, auto exposure and auto white balance) statistics for the frames that are
@@ -225,54 +222,47 @@ being processed by the ImgU to user space applications. User space applications
 can use this statistics data to compute the desired algorithm parameters for
 the ImgU.
 
-Configuring the Intel IPU3
-==========================
-
-The IPU3 ImgU pipelines can be configured using the Media Controller, defined at
-:ref:`media_controller`.
+Processing raw Bayer images
+---------------------------
 
 Firmware binary selection
--------------------------
+~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The firmware binary is selected using the V4L2_CID_INTEL_IPU3_MODE, currently
 defined in drivers/staging/media/ipu3/include/intel-ipu3.h . "VIDEO" and "STILL"
 modes are available.
 
-Processing the image in raw Bayer format
-----------------------------------------
+Configuring the ImgU
+~~~~~~~~~~~~~~~~~~~~
 
-Configuring ImgU V4L2 subdev for image processing
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-The ImgU V4L2 subdevs have to be configured with media controller APIs to have
-all the video nodes setup correctly.
+The ImgU has to be configured with the Media Controller and V4L2 subdev APIs to
+setup the processing pipeline.
 
 Let us take "ipu3-imgu 0" subdev as an example.
 
-media-ctl -d $MDEV -r
-
-media-ctl -d $MDEV -l "ipu3-imgu 0 input":0 -> "ipu3-imgu 0":0[1]
-
-media-ctl -d $MDEV -l "ipu3-imgu 0":2 -> "ipu3-imgu 0 output":0[1]
+.. code-block:: shell
 
-media-ctl -d $MDEV -l "ipu3-imgu 0":3 -> "ipu3-imgu 0 viewfinder":0[1]
-
-media-ctl -d $MDEV -l "ipu3-imgu 0":4 -> "ipu3-imgu 0 3a stat":0[1]
+  media-ctl -d $MDEV -r
+  media-ctl -d $MDEV -l "ipu3-imgu 0 input":0 -> "ipu3-imgu 0":0[1]
+  media-ctl -d $MDEV -l "ipu3-imgu 0":2 -> "ipu3-imgu 0 output":0[1]
+  media-ctl -d $MDEV -l "ipu3-imgu 0":3 -> "ipu3-imgu 0 viewfinder":0[1]
+  media-ctl -d $MDEV -l "ipu3-imgu 0":4 -> "ipu3-imgu 0 3a stat":0[1]
 
 Also the pipe mode of the corresponding V4L2 subdev should be set as desired
-(e.g 0 for video mode or 1 for still mode) through the control id 0x009819a1 as
-below.
+(e.g 0 for video mode or 1 for still mode) through the control id 0x009819a1.
+
+.. code-block:: shell
 
-yavta -w "0x009819A1 1" /dev/v4l-subdev7
+  yavta -w "0x009819A1 1" /dev/v4l-subdev7
 
-RAW Bayer frames go through the following ImgU pipeline HW blocks to have the
-processed image output to the DDR memory.
+RAW Bayer frames go through the following ImgU pipeline processing blocks to
+have the processed image output to memory.
 
 RAW Bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) -> Geometric
-Distortion Correction (GDC) -> DDR
+Distortion Correction (GDC) -> Memory
 
 The ImgU V4L2 subdev has to be configured with the supported resolutions in all
-the above HW blocks, for a given input resolution.
+the above processing blocks, for a given input resolution.
 
 For a given supported resolution for an input frame, the Input Feeder, Bayer
 Down Scaling and GDC blocks should be configured with the supported resolutions.
@@ -302,8 +292,11 @@ For the ov5670 example, for an input frame with a resolution of 2592x1944
 for input feeder, BDS and GDC are 2592x1944, 2592x1944 and 2560x1920
 respectively.
 
-Once this is done, the received raw Bayer frames can be input to the ImgU
-V4L2 subdev as below, using the open source application v4l2n [#f1]_.
+Processing frames
+~~~~~~~~~~~~~~~~~
+
+Once configuration is complete, raw Bayer frames can be input to the ImgU V4L2
+subdev as below, using the open source application v4l2n [#f1]_.
 
 For an image captured with 2592x1944 [#f4]_ resolution, with desired output
 resolution as 2560x1920 and viewfinder resolution as 2560x1920, the following
@@ -311,51 +304,43 @@ v4l2n command can be used. This helps process the raw Bayer frames and produces
 the desired results for the main output image and the viewfinder output, in NV12
 format.
 
-v4l2n --pipe=4 --load=/tmp/frame-#.bin --open=/dev/video4
---fmt=type:VIDEO_OUTPUT_MPLANE,width=2592,height=1944,pixelformat=0X47337069
---reqbufs=type:VIDEO_OUTPUT_MPLANE,count:1 --pipe=1 --output=/tmp/frames.out
---open=/dev/video5
---fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
---reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=2 --output=/tmp/frames.vf
---open=/dev/video6
---fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
---reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=3 --open=/dev/video7
---output=/tmp/frames.3A --fmt=type:META_CAPTURE,?
---reqbufs=count:1,type:META_CAPTURE --pipe=1,2,3,4 --stream=5
+.. code-block:: shell
+
+  v4l2n --pipe=4 --load=/tmp/frame-#.bin --open=/dev/video4
+  --fmt=type:VIDEO_OUTPUT_MPLANE,width=2592,height=1944,pixelformat=0X47337069
+  --reqbufs=type:VIDEO_OUTPUT_MPLANE,count:1 --pipe=1 --output=/tmp/frames.out
+  --open=/dev/video5
+  --fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
+  --reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=2 --output=/tmp/frames.vf
+  --open=/dev/video6
+  --fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
+  --reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=3 --open=/dev/video7
+  --output=/tmp/frames.3A --fmt=type:META_CAPTURE,?
+  --reqbufs=count:1,type:META_CAPTURE --pipe=1,2,3,4 --stream=5
 
 where /dev/video4, /dev/video5, /dev/video6 and /dev/video7 devices point to
 input, output, viewfinder and 3A statistics video nodes respectively.
 
-Converting the raw Bayer image into YUV domain
-----------------------------------------------
-
-The processed images after the above step, can be converted to YUV domain
-as below.
+Viewing YUV raw data
+--------------------
 
-Main output frames
-~~~~~~~~~~~~~~~~~~
+The ImgU outputs frames as raw YUV data. While the hardware support multiple YUV
+formats, the driver only implements support for NV12.
 
-raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.out /tmp/frames.out.ppm
+The NV12 format is understood by a wide variety of tools, but raw NV12 isn't
+easily viewable by image viewers. Output frames can be converted to PPM image
+files to viewing with the raw2pnm [#f1]_ or raw2rgbpnm [#f6]_ tools.
 
-where 2560x1920 is output resolution, NV12 is the video format, followed
-by input frame and output PNM file.
+.. code-block:: shell
 
-Viewfinder output frames
-~~~~~~~~~~~~~~~~~~~~~~~~
-
-raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.vf /tmp/frames.vf.ppm
-
-where 2560x1920 is output resolution, NV12 is the video format, followed
-by input frame and output PNM file.
+  raw2pnm -fNV12 -x2560 -y1920 /tmp/frames.out /tmp/frames.out.ppm
+  raw2rgbpnm -f NV12 -s 2560x1920 /tmp/frames.out /tmp/frames.out.ppm
 
 Example user space code for IPU3
 ================================
 
-User space code that configures and uses IPU3 is available here.
-
-https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master/
-
-The source can be located under hal/intel directory.
+User space code that configures and uses IPU3 is available at
+https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master/hal/intel/
 
 References
 ==========
@@ -369,3 +354,5 @@ References
 .. [#f3] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
 
 .. [#f4] ImgU limitation requires an additional 16x16 for all input resolutions
+
+.. [#f6] https://git.retiisi.org.uk/?p=~sailus/raw2rgbpnm.git
-- 
Regards,

Laurent Pinchart

