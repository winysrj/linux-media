Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34392 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940660AbdAGCMZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 21:12:25 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v3 16/24] media: Add i.MX media core driver
Date: Fri,  6 Jan 2017 18:11:34 -0800
Message-Id: <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the core media driver for i.MX SOC.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 Documentation/media/v4l-drivers/imx.rst           | 443 ++++++++++
 drivers/staging/media/Kconfig                     |   2 +
 drivers/staging/media/Makefile                    |   1 +
 drivers/staging/media/imx/Kconfig                 |   8 +
 drivers/staging/media/imx/Makefile                |   6 +
 drivers/staging/media/imx/TODO                    |  22 +
 drivers/staging/media/imx/imx-media-common.c      | 981 ++++++++++++++++++++++
 drivers/staging/media/imx/imx-media-dev.c         | 486 +++++++++++
 drivers/staging/media/imx/imx-media-fim.c         | 471 +++++++++++
 drivers/staging/media/imx/imx-media-internal-sd.c | 457 ++++++++++
 drivers/staging/media/imx/imx-media-of.c          | 289 +++++++
 drivers/staging/media/imx/imx-media.h             | 310 +++++++
 include/media/imx.h                               |  15 +
 include/uapi/linux/v4l2-controls.h                |   4 +
 14 files changed, 3495 insertions(+)
 create mode 100644 Documentation/media/v4l-drivers/imx.rst
 create mode 100644 drivers/staging/media/imx/Kconfig
 create mode 100644 drivers/staging/media/imx/Makefile
 create mode 100644 drivers/staging/media/imx/TODO
 create mode 100644 drivers/staging/media/imx/imx-media-common.c
 create mode 100644 drivers/staging/media/imx/imx-media-dev.c
 create mode 100644 drivers/staging/media/imx/imx-media-fim.c
 create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
 create mode 100644 drivers/staging/media/imx/imx-media-of.c
 create mode 100644 drivers/staging/media/imx/imx-media.h
 create mode 100644 include/media/imx.h

diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
new file mode 100644
index 0000000..87b37b5
--- /dev/null
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -0,0 +1,443 @@
+i.MX Video Capture Driver
+=========================
+
+Introduction
+------------
+
+The Freescale i.MX5/6 contains an Image Processing Unit (IPU), which
+handles the flow of image frames to and from capture devices and
+display devices.
+
+For image capture, the IPU contains the following internal subunits:
+
+- Image DMA Controller (IDMAC)
+- Camera Serial Interface (CSI)
+- Image Converter (IC)
+- Sensor Multi-FIFO Controller (SMFC)
+- Image Rotator (IRT)
+- Video De-Interlace Controller (VDIC)
+
+The IDMAC is the DMA controller for transfer of image frames to and from
+memory. Various dedicated DMA channels exist for both video capture and
+display paths.
+
+The CSI is the frontend capture unit that interfaces directly with
+capture sensors over Parallel, BT.656/1120, and MIPI CSI-2 busses.
+
+The IC handles color-space conversion, resizing, and rotation
+operations. There are three independent "tasks" within the IC that can
+carry out conversions concurrently: pre-processing encoding,
+pre-processing preview, and post-processing.
+
+The SMFC is composed of four independent channels that each can transfer
+captured frames from sensors directly to memory concurrently.
+
+The IRT carries out 90 and 270 degree image rotation operations.
+
+The VDIC handles the conversion of interlaced video to progressive, with
+support for different motion compensation modes (low, medium, and high
+motion). The deinterlaced output frames from the VDIC can be sent to the
+IC pre-process preview task for further conversions.
+
+In addition to the IPU internal subunits, there are also two units
+outside the IPU that are also involved in video capture on i.MX:
+
+- MIPI CSI-2 Receiver for camera sensors with the MIPI CSI-2 bus
+  interface. This is a Synopsys DesignWare core.
+- A video multiplexer for selecting among multiple sensor inputs to
+  send to a CSI.
+
+For more info, refer to the latest versions of the i.MX5/6 reference
+manuals listed under References.
+
+
+Features
+--------
+
+Some of the features of this driver include:
+
+- Many different pipelines can be configured via media controller API,
+  that correspond to the hardware video capture pipelines supported in
+  the i.MX.
+
+- Supports parallel, BT.565, and MIPI CSI-2 interfaces.
+
+- Up to four concurrent sensor acquisitions, by configuring each
+  sensor's pipeline using independent entities. This is currently
+  demonstrated with the SabreSD and SabreLite reference boards with
+  independent OV5642 and MIPI CSI-2 OV5640 sensor modules.
+
+- Scaling, color-space conversion, and image rotation via IC task
+  subdevs.
+
+- Many pixel formats supported (RGB, packed and planar YUV, partial
+  planar YUV).
+
+- The IC pre-process preview subdev supports motion compensated
+  de-interlacing using the VDIC, with three motion compensation modes:
+  low, medium, and high motion. The mode is specified with a custom
+  control. Pipelines are defined that allow sending frames to the
+  preview subdev directly from the CSI or from the SMFC.
+
+- Includes a Frame Interval Monitor (FIM) that can correct vertical sync
+  problems with the ADV718x video decoders. See below for a description
+  of the FIM.
+
+
+Capture Pipelines
+-----------------
+
+The following describe the various use-cases supported by the pipelines.
+
+The links shown do not include the frontend sensor, video mux, or mipi
+csi-2 receiver links. This depends on the type of sensor interface
+(parallel or mipi csi-2). So in all cases, these pipelines begin with:
+
+sensor -> ipu_csi_mux -> ipu_csi -> ...
+
+for parallel sensors, or:
+
+sensor -> imx-mipi-csi2 -> (ipu_csi_mux) -> ipu_csi -> ...
+
+for mipi csi-2 sensors. The imx-mipi-csi2 receiver may need to route
+to the video mux (ipu_csi_mux) before sending to the CSI, depending
+on the mipi csi-2 virtual channel, hence ipu_csi_mux is shown in
+parenthesis.
+
+Unprocessed Video Capture:
+--------------------------
+
+Send frames directly from sensor to camera interface, with no
+conversions:
+
+-> ipu_smfc -> camif
+
+Note the ipu_smfc can do pixel reordering within the same colorspace.
+For example, its sink pad can take UYVY2X8, but its source pad can
+output YUYV2X8.
+
+IC Direct Conversions:
+----------------------
+
+This pipeline uses the preprocess encode entity to route frames directly
+from the CSI to the IC (bypassing the SMFC), to carry out scaling up to
+1024x1024 resolution, CSC, and image rotation:
+
+-> ipu_ic_prpenc -> camif
+
+This can be a useful capture pipeline for heavily loaded memory bus
+traffic environments, since it has minimal IDMAC channel usage.
+
+Post-Processing Conversions:
+----------------------------
+
+This pipeline routes frames from the SMFC to the post-processing
+entity. In addition to CSC and rotation, this entity supports tiling
+which allows scaled output beyond the 1024x1024 limitation of the IC
+(up to 4096x4096 scaling output is supported):
+
+-> ipu_smfc -> ipu_ic_pp -> camif
+
+Motion Compensated De-interlace:
+--------------------------------
+
+This pipeline routes frames from the SMFC to the preprocess preview
+entity to support motion-compensated de-interlacing using the VDIC,
+scaling up to 1024x1024, and CSC:
+
+-> ipu_smfc -> ipu_ic_prpvf -> camif
+
+This pipeline also carries out the same conversions as above, but routes
+frames directly from the CSI to the IC preprocess preview entity for
+minimal memory bandwidth usage (note: this pipeline only works in
+"high motion" mode):
+
+-> ipu_ic_prpvf -> camif
+
+This pipeline takes the motion-compensated de-interlaced frames and
+sends them to the post-processor, to support motion-compensated
+de-interlacing, scaling up to 4096x4096, CSC, and rotation:
+
+-> (ipu_smfc) -> ipu_ic_prpvf -> ipu_ic_pp -> camif
+
+
+Usage Notes
+-----------
+
+Many of the subdevs require information from the active sensor in the
+current pipeline when configuring pad formats. Therefore the media links
+should be established before configuring the media pad formats.
+
+Similarly, the capture v4l2 interface subdev inherits controls from the
+active subdevs in the current pipeline at link-setup time. Therefore the
+capture links should be the last links established in order for capture
+to "see" and inherit all possible controls.
+
+The following are usage notes for Sabre- reference platforms:
+
+
+SabreLite with OV5642 and OV5640
+--------------------------------
+
+This platform requires the OmniVision OV5642 module with a parallel
+camera interface, and the OV5640 module with a MIPI CSI-2
+interface. Both modules are available from Boundary Devices:
+
+https://boundarydevices.com/products/nit6x_5mp
+https://boundarydevices.com/product/nit6x_5mp_mipi
+
+Note that if only one camera module is available, the other sensor
+node can be disabled in the device tree.
+
+The OV5642 module is connected to the parallel bus input on the i.MX
+internal video mux to IPU1 CSI0. It's i2c bus connects to i2c bus 2.
+
+The MIPI CSI-2 OV5640 module is connected to the i.MX internal MIPI CSI-2
+receiver, and the four virtual channel outputs from the receiver are
+routed as follows: vc0 to the IPU1 CSI0 mux, vc1 directly to IPU1 CSI1,
+vc2 directly to IPU2 CSI0, and vc3 to the IPU2 CSI1 mux. The OV5640 is
+also connected to i2c bus 2 on the SabreLite, therefore the OV5642 and
+OV5640 must not share the same i2c slave address.
+
+The following basic example configures unprocessed video capture
+pipelines for both sensors. The OV5642 is routed to camif0
+(usually /dev/video0), and the OV5640 (transmitting on mipi csi-2
+virtual channel 1) is routed to camif1 (usually /dev/video1). Both
+sensors are configured to output 640x480, UYVY (not shown: all pad
+field types should be set to "NONE"):
+
+.. code-block:: none
+
+   # Setup links for OV5642
+   media-ctl -l '"ov5642 1-0042":0 -> "ipu1_csi0_mux":1[1]'
+   media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
+   media-ctl -l '"ipu1_csi0":1 -> "ipu1_smfc0":0[1]'
+   media-ctl -l '"ipu1_smfc0":1 -> "camif0":0[1]'
+   media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'
+   # Setup links for OV5640
+   media-ctl -l '"ov5640_mipi 1-0040":0 -> "imx-mipi-csi2":0[1]'
+   media-ctl -l '"imx-mipi-csi2":2 -> "ipu1_csi1":0[1]'
+   media-ctl -l '"ipu1_csi1":1 -> "ipu1_smfc1":0[1]'
+   media-ctl -l '"ipu1_smfc1":1 -> "camif1":0[1]'
+   media-ctl -l '"camif1":1 -> "camif1 devnode":0[1]'
+   # Configure pads for OV5642 pipeline
+   media-ctl -V "\"ov5642 1-0042\":0 [fmt:YUYV2X8/640x480]"
+   media-ctl -V "\"ipu1_csi0_mux\":1 [fmt:YUYV2X8/640x480]"
+   media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:YUYV2X8/640x480]"
+   media-ctl -V "\"ipu1_csi0\":0 [fmt:YUYV2X8/640x480]"
+   media-ctl -V "\"ipu1_csi0\":1 [fmt:YUYV2X8/640x480]"
+   media-ctl -V "\"ipu1_smfc0\":0 [fmt:YUYV2X8/640x480]"
+   media-ctl -V "\"ipu1_smfc0\":1 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"camif0\":0 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"camif0\":1 [fmt:UYVY2X8/640x480]"
+   # Configure pads for OV5640 pipeline
+   media-ctl -V "\"ov5640_mipi 1-0040\":0 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"imx-mipi-csi2\":0 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"imx-mipi-csi2\":2 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"ipu1_csi1\":0 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"ipu1_csi1\":1 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"ipu1_smfc1\":0 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"ipu1_smfc1\":1 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"camif1\":0 [fmt:UYVY2X8/640x480]"
+   media-ctl -V "\"camif1\":1 [fmt:UYVY2X8/640x480]"
+
+Streaming can then begin independently on device nodes /dev/video0
+and /dev/video1.
+
+SabreAuto with ADV7180 decoder
+------------------------------
+
+On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
+parallel bus input on the internal video mux to IPU1 CSI0.
+
+The following example configures a pipeline to capture from the ADV7180
+video decoder, assuming NTSC 720x480 input signals, with Motion
+Compensated de-interlacing (not shown: all pad field types should be set
+as indicated). $outputfmt can be any format supported by the
+ipu1_ic_prpvf entity at its output pad:
+
+.. code-block:: none
+
+   # Setup links
+   media-ctl -l '"adv7180 3-0021":0 -> "ipu1_csi0_mux":1[1]'
+   media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
+   media-ctl -l '"ipu1_csi0":1 -> "ipu1_smfc0":0[1]'
+   media-ctl -l '"ipu1_smfc0":1 -> "ipu1_ic_prpvf":0[1]'
+   media-ctl -l '"ipu1_ic_prpvf":1 -> "camif0":0[1]'
+   media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'
+   # Configure pads
+   # pad field types for below pads must be an interlaced type
+   # such as "ALTERNATE"
+   media-ctl -V "\"adv7180 3-0021\":0 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "\"ipu1_csi0_mux\":1 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "\"ipu1_csi0\":0 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "\"ipu1_csi0\":1 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "\"ipu1_smfc0\":0 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "\"ipu1_smfc0\":1 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "\"ipu1_ic_prpvf\":0 [fmt:UYVY2X8/720x480]"
+   # pad field types for below pads must be "NONE"
+   media-ctl -V "\"ipu1_ic_prpvf\":1 [fmt:$outputfmt]"
+   media-ctl -V "\"camif0\":0 [fmt:$outputfmt]"
+   media-ctl -V "\"camif0\":1 [fmt:$outputfmt]"
+
+Streaming can then begin on /dev/video0.
+
+This platform accepts Composite Video analog inputs to the ADV7180 on
+Ain1 (connector J42) and Ain3 (connector J43).
+
+To switch to Ain1:
+
+.. code-block:: none
+
+   # v4l2-ctl -i0
+
+To switch to Ain3:
+
+.. code-block:: none
+
+   # v4l2-ctl -i1
+
+
+Frame Interval Monitor
+----------------------
+
+The adv718x decoders can occasionally send corrupt fields during
+NTSC/PAL signal re-sync (too little or too many video lines). When
+this happens, the IPU triggers a mechanism to re-establish vertical
+sync by adding 1 dummy line every frame, which causes a rolling effect
+from image to image, and can last a long time before a stable image is
+recovered. Or sometimes the mechanism doesn't work at all, causing a
+permanent split image (one frame contains lines from two consecutive
+captured images).
+
+From experiment it was found that during image rolling, the frame
+intervals (elapsed time between two EOF's) drop below the nominal
+value for the current standard, by about one frame time (60 usec),
+and remain at that value until rolling stops.
+
+While the reason for this observation isn't known (the IPU dummy
+line mechanism should show an increase in the intervals by 1 line
+time every frame, not a fixed value), we can use it to detect the
+corrupt fields using a frame interval monitor. If the FIM detects a
+bad frame interval, a subdev event is sent. In response, userland can
+issue a streaming restart to correct the rolling/split image.
+
+The FIM is implemented in the imx-csi entity, and the entities that have
+direct connections to the CSI call into the FIM to monitor the frame
+intervals: ipu_smfc, ipu_ic_prpenc, and ipu_prpvf (when configured with
+a direct link from ipu_csi). Userland can register with the FIM event
+notifications on the imx-csi subdev device node
+(V4L2_EVENT_IMX_FRAME_INTERVAL).
+
+The imx-csi entity includes custom controls to tweak some dials for FIM.
+If one of these controls is changed during streaming, the FIM will be
+reset and will continue at the new settings.
+
+- V4L2_CID_IMX_FIM_ENABLE
+
+Enable/disable the FIM.
+
+- V4L2_CID_IMX_FIM_NUM
+
+How many frame interval errors to average before comparing against the
+nominal frame interval reported by the sensor. This can reduce noise
+from interrupt latency.
+
+- V4L2_CID_IMX_FIM_TOLERANCE_MIN
+
+If the averaged intervals fall outside nominal by this amount, in
+microseconds, streaming will be restarted.
+
+- V4L2_CID_IMX_FIM_TOLERANCE_MAX
+
+If any interval errors are higher than this value, those error samples
+are discarded and do not enter into the average. This can be used to
+discard really high interval errors that might be due to very high
+system load, causing excessive interrupt latencies.
+
+- V4L2_CID_IMX_FIM_NUM_SKIP
+
+How many frames to skip after a FIM reset or stream restart before
+FIM begins to average intervals. It has been found that there can
+be a few bad frame intervals after stream restart which are not
+attributed to adv718x sending a corrupt field, so this is used to
+skip those frames to prevent unnecessary restarts.
+
+
+SabreSD with MIPI CSI-2 OV5640
+------------------------------
+
+Similarly to SabreLite, the SabreSD supports a parallel interface
+OV5642 module on IPU1 CSI0, and a MIPI CSI-2 OV5640 module. The OV5642
+connects to i2c bus 1 and the OV5640 to i2c bus 2.
+
+The device tree for SabreSD includes OF graphs for both the parallel
+OV5642 and the MIPI CSI-2 OV5640, but as of this writing only the MIPI
+CSI-2 OV5640 has been tested, so the OV5642 node is currently disabled.
+The OV5640 module connects to MIPI connector J5 (sorry I don't have the
+compatible module part number or URL).
+
+The following example configures a post-processing pipeline to capture
+from the OV5640 (not shown: all pad field types should be set to
+"NONE"). $sensorfmt can be any format supported by the
+OV5640. $outputfmt can be any format supported by the ipu1_ic_pp1
+entity at its output pad:
+
+
+.. code-block:: none
+
+   # Setup links
+   media-ctl -l '"ov5640_mipi 1-003c":0 -> "imx-mipi-csi2":0[1]'
+   media-ctl -l '"imx-mipi-csi2":2 -> "ipu1_csi1":0[1]'
+   media-ctl -l '"ipu1_csi1":1 -> "ipu1_smfc1":0[1]'
+   media-ctl -l '"ipu1_smfc1":1 -> "ipu1_ic_pp1":0[1]'
+   media-ctl -l '"ipu1_ic_pp1":1 -> "camif0":0[1]'
+   media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'
+   # Configure pads
+   media-ctl -V "\"ov5640_mipi 1-003c\":0 [fmt:$sensorfmt]"
+   media-ctl -V "\"imx-mipi-csi2\":0 [fmt:$sensorfmt]"
+   media-ctl -V "\"imx-mipi-csi2\":2 [fmt:$sensorfmt]"
+   media-ctl -V "\"ipu1_csi1\":0 [fmt:$sensorfmt]"
+   media-ctl -V "\"ipu1_csi1\":1 [fmt:$sensorfmt]"
+   media-ctl -V "\"ipu1_smfc1\":0 [fmt:$sensorfmt]"
+   media-ctl -V "\"ipu1_smfc1\":1 [fmt:$sensorfmt]"
+   media-ctl -V "\"ipu1_ic_pp1\":0 [fmt:$sensorfmt]"
+   media-ctl -V "\"ipu1_ic_pp1\":1 [fmt:$outputfmt]"
+   media-ctl -V "\"camif0\":0 [fmt:$outputfmt]"
+   media-ctl -V "\"camif0\":1 [fmt:$outputfmt]"
+
+Streaming can then begin on /dev/video0.
+
+
+
+Known Issues
+------------
+
+1. When using 90 or 270 degree rotation control at capture resolutions
+   near the IC resizer limit of 1024x1024, and combined with planar
+   pixel formats (YUV420, YUV422p), frame capture will often fail with
+   no end-of-frame interrupts from the IDMAC channel. To work around
+   this, use lower resolution and/or packed formats (YUYV, RGB3, etc.)
+   when 90 or 270 rotations are needed.
+
+
+File list
+---------
+
+drivers/staging/media/imx/
+include/media/imx.h
+include/uapi/media/imx.h
+
+References
+----------
+
+[1] "i.MX 6Dual/6Quad Applications Processor Reference Manual"
+[2] "i.MX 6Solo/6DualLite Applications Processor Reference Manual"
+
+
+Author
+------
+Steve Longerbeam <steve_longerbeam@mentor.com>
+
+Copyright (C) 2012-2016 Mentor Graphics Inc.
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index ffb8fa7..05b55a8 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -25,6 +25,8 @@ source "drivers/staging/media/cxd2099/Kconfig"
 
 source "drivers/staging/media/davinci_vpfe/Kconfig"
 
+source "drivers/staging/media/imx/Kconfig"
+
 source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/s5p-cec/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index a28e82c..6f50ddd 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC) += s5p-cec/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
+obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
new file mode 100644
index 0000000..bfde58d
--- /dev/null
+++ b/drivers/staging/media/imx/Kconfig
@@ -0,0 +1,8 @@
+config VIDEO_IMX_MEDIA
+	tristate "i.MX5/6 V4L2 media core driver"
+	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
+	default y
+	---help---
+	  Say yes here to enable support for video4linux media controller
+	  driver for the i.MX5/6 SOC.
+
diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
new file mode 100644
index 0000000..ef9f11b
--- /dev/null
+++ b/drivers/staging/media/imx/Makefile
@@ -0,0 +1,6 @@
+imx-media-objs := imx-media-dev.o imx-media-fim.o imx-media-internal-sd.o \
+	imx-media-of.o
+
+obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
+obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
+
diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
new file mode 100644
index 0000000..1f42381
--- /dev/null
+++ b/drivers/staging/media/imx/TODO
@@ -0,0 +1,22 @@
+
+- v4l2-compliance
+
+- imx-csi subdev is not being autoloaded as a kernel module, probably
+  because ipu_add_client_devices() does not register the IPU client
+  platform devices, but only allocates those devices.
+
+- Verify driver remove paths.
+
+- Currently registering with notifications from subdevs are only
+  available through the subdev device nodes and not through the main
+  capture device node. Need to come up with a way to find the camif in
+  the current pipeline that owns the subdev that sent the notify.
+
+- Need to decide whether a mem2mem device should be incorporated into
+  the media graph, or whether it should be a separate device that does
+  not link with any other entities.
+
+- Combine, clean up, and move the ov5640/ov5642 subdevs to
+  drivers/media/i2c. Once that is done the binding docs for ov564x
+  can be created under Documentation/devicetree/bindings/media/i2c.
+
diff --git a/drivers/staging/media/imx/imx-media-common.c b/drivers/staging/media/imx/imx-media-common.c
new file mode 100644
index 0000000..f19ffcf
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-common.c
@@ -0,0 +1,981 @@
+/*
+ * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include "imx-media.h"
+
+/*
+ * List of pixel formats for the subdevs. This must be a super-set of
+ * the formats supported by the ipu image converter.
+ */
+static const struct imx_media_pixfmt imx_media_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.codes  = {MEDIA_BUS_FMT_UYVY8_2X8, MEDIA_BUS_FMT_UYVY8_1X16},
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.codes  = {MEDIA_BUS_FMT_YUYV8_2X8, MEDIA_BUS_FMT_YUYV8_1X16},
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB565,
+		.codes  = {MEDIA_BUS_FMT_RGB565_2X8_LE},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB24,
+		.codes  = {MEDIA_BUS_FMT_RGB888_1X24,
+			   MEDIA_BUS_FMT_RGB888_2X12_LE},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 24,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_BGR24,
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 24,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 32,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_BGR32,
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 32,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 12,
+		.planar = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 12,
+		.planar = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+		.planar = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 12,
+		.planar = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_NV16,
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+		.planar = true,
+	},
+};
+
+const struct imx_media_pixfmt *imx_media_find_format(u32 fourcc, u32 code,
+						     bool allow_rgb,
+						     bool allow_planar)
+{
+	const struct imx_media_pixfmt *fmt, *ret = NULL;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(imx_media_formats); i++) {
+		fmt = &imx_media_formats[i];
+
+		if (fourcc && fmt->fourcc == fourcc &&
+		    (fmt->cs != IPUV3_COLORSPACE_RGB || allow_rgb) &&
+		    (!fmt->planar || (allow_planar && fmt->codes[0]))) {
+			ret = fmt;
+			goto out;
+		}
+
+		for (j = 0; fmt->codes[j]; j++) {
+			if (fmt->codes[j] == code &&
+			    (fmt->cs != IPUV3_COLORSPACE_RGB || allow_rgb) &&
+			    (!fmt->planar || allow_planar)) {
+				ret = fmt;
+				goto out;
+			}
+		}
+	}
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_find_format);
+
+int imx_media_enum_format(u32 *code, u32 index, bool allow_rgb,
+			  bool allow_planar)
+{
+	const struct imx_media_pixfmt *fmt;
+
+	if (index >= ARRAY_SIZE(imx_media_formats))
+		return -EINVAL;
+
+	fmt = &imx_media_formats[index];
+	if ((fmt->cs == IPUV3_COLORSPACE_RGB && !allow_rgb) ||
+	    (fmt->planar && (!allow_planar || !fmt->codes[0])))
+		return -EINVAL;
+
+	*code = fmt->codes[0];
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_enum_format);
+
+int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
+			    u32 width, u32 height, u32 code, u32 field,
+			    const struct imx_media_pixfmt **cc)
+{
+	const struct imx_media_pixfmt *lcc;
+
+	mbus->width = width;
+	mbus->height = height;
+	mbus->field = field;
+	if (code == 0)
+		imx_media_enum_format(&code, 0, true, true);
+	lcc = imx_media_find_format(0, code, true, true);
+	if (!lcc)
+		return -EINVAL;
+	mbus->code = code;
+
+	if (cc)
+		*cc = lcc;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_init_mbus_fmt);
+
+int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
+				  struct v4l2_mbus_framefmt *mbus)
+{
+	const struct imx_media_pixfmt *fmt;
+	u32 stride;
+
+	fmt = imx_media_find_format(0, mbus->code, true, true);
+	if (!fmt)
+		return -EINVAL;
+
+	stride = fmt->planar ? mbus->width : (mbus->width * fmt->bpp) >> 3;
+
+	pix->width = mbus->width;
+	pix->height = mbus->height;
+	pix->pixelformat = fmt->fourcc;
+	pix->field = mbus->field;
+	pix->bytesperline = stride;
+	pix->sizeimage = (pix->width * pix->height * fmt->bpp) >> 3;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_mbus_fmt_to_pix_fmt);
+
+int imx_media_mbus_fmt_to_ipu_image(struct ipu_image *image,
+				    struct v4l2_mbus_framefmt *mbus)
+{
+	int ret;
+
+	memset(image, 0, sizeof(*image));
+
+	ret = imx_media_mbus_fmt_to_pix_fmt(&image->pix, mbus);
+	if (ret)
+		return ret;
+
+	image->rect.width = mbus->width;
+	image->rect.height = mbus->height;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_mbus_fmt_to_ipu_image);
+
+int imx_media_ipu_image_to_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
+				    struct ipu_image *image)
+{
+	const struct imx_media_pixfmt *fmt;
+
+	fmt = imx_media_find_format(image->pix.pixelformat, 0, true, true);
+	if (!fmt)
+		return -EINVAL;
+
+	memset(mbus, 0, sizeof(*mbus));
+	mbus->width = image->pix.width;
+	mbus->height = image->pix.height;
+	mbus->code = fmt->codes[0];
+	mbus->field = image->pix.field;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_ipu_image_to_mbus_fmt);
+
+/*
+ * DMA buffer ring handling
+ */
+struct imx_media_dma_buf_ring {
+	struct imx_media_dev *imxmd;
+
+	/* the ring */
+	struct imx_media_dma_buf buf[IMX_MEDIA_MAX_RING_BUFS];
+	/* the scratch buffer for underruns */
+	struct imx_media_dma_buf scratch;
+
+	/* buffer generator */
+	struct media_entity *src;
+	/* buffer receiver */
+	struct media_entity *sink;
+
+	spinlock_t lock;
+
+	int num_bufs;
+	unsigned long last_seq;
+};
+
+void imx_media_free_dma_buf(struct imx_media_dev *imxmd,
+			    struct imx_media_dma_buf *buf)
+{
+	if (buf->virt && !buf->vb)
+		dma_free_coherent(imxmd->dev, buf->len, buf->virt, buf->phys);
+
+	buf->virt = NULL;
+	buf->phys = 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_free_dma_buf);
+
+int imx_media_alloc_dma_buf(struct imx_media_dev *imxmd,
+			    struct imx_media_dma_buf *buf,
+			    int size)
+{
+	imx_media_free_dma_buf(imxmd, buf);
+
+	buf->ring = NULL;
+	buf->vb = NULL;
+	buf->len = PAGE_ALIGN(size);
+	buf->virt = dma_alloc_coherent(imxmd->dev, buf->len, &buf->phys,
+				       GFP_DMA | GFP_KERNEL);
+	if (!buf->virt) {
+		dev_err(imxmd->dev, "failed to alloc dma buffer\n");
+		return -ENOMEM;
+	}
+
+	buf->state = IMX_MEDIA_BUF_STATUS_PREPARED;
+	buf->seq = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_alloc_dma_buf);
+
+void imx_media_free_dma_buf_ring(struct imx_media_dma_buf_ring *ring)
+{
+	int i;
+
+	if (!ring)
+		return;
+
+	dev_dbg(ring->imxmd->dev, "freeing ring [%s -> %s]\n",
+		ring->src->name, ring->sink->name);
+
+	imx_media_free_dma_buf(ring->imxmd, &ring->scratch);
+
+	for (i = 0; i < ring->num_bufs; i++)
+		imx_media_free_dma_buf(ring->imxmd, &ring->buf[i]);
+	kfree(ring);
+}
+EXPORT_SYMBOL_GPL(imx_media_free_dma_buf_ring);
+
+struct imx_media_dma_buf_ring *
+imx_media_alloc_dma_buf_ring(struct imx_media_dev *imxmd,
+			     struct media_entity *src,
+			     struct media_entity *sink,
+			     int size, int num_bufs,
+			     bool alloc_bufs)
+{
+	struct imx_media_dma_buf_ring *ring;
+	int i, ret;
+
+	if (num_bufs < IMX_MEDIA_MIN_RING_BUFS ||
+	    num_bufs > IMX_MEDIA_MAX_RING_BUFS)
+		return ERR_PTR(-EINVAL);
+
+	ring = kzalloc(sizeof(*ring), GFP_KERNEL);
+	if (!ring)
+		return ERR_PTR(-ENOMEM);
+
+	spin_lock_init(&ring->lock);
+	ring->imxmd = imxmd;
+	ring->src = src;
+	ring->sink = sink;
+	ring->num_bufs = num_bufs;
+	ring->last_seq = 0;
+
+	for (i = 0; i < num_bufs; i++) {
+		if (alloc_bufs) {
+			ret = imx_media_alloc_dma_buf(imxmd, &ring->buf[i],
+						      size);
+			if (ret) {
+				ring->num_bufs = i;
+				goto free_ring;
+			}
+		}
+		ring->buf[i].ring = ring;
+		ring->buf[i].index = i;
+	}
+
+	/* now allocate the scratch buffer for underruns */
+	ret = imx_media_alloc_dma_buf(imxmd, &ring->scratch, size);
+	if (ret)
+		goto free_ring;
+	ring->scratch.ring = ring;
+	ring->scratch.index = 999;
+
+	dev_dbg(ring->imxmd->dev,
+		"created ring [%s -> %s], buf size %d, num bufs %d\n",
+		ring->src->name, ring->sink->name, size, num_bufs);
+
+	return ring;
+
+free_ring:
+	imx_media_free_dma_buf_ring(ring);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(imx_media_alloc_dma_buf_ring);
+
+static struct imx_media_dma_buf *
+__dma_buf_queue(struct imx_media_dma_buf_ring *ring, int index)
+{
+	struct imx_media_dma_buf *buf;
+
+	if (index >= ring->num_bufs)
+		return ERR_PTR(-EINVAL);
+
+	buf = &ring->buf[index];
+	if (WARN_ON(buf->state != IMX_MEDIA_BUF_STATUS_PREPARED))
+		return ERR_PTR(-EINVAL);
+
+	buf->state = IMX_MEDIA_BUF_STATUS_QUEUED;
+	buf->seq = ring->last_seq++;
+
+	return buf;
+}
+
+int imx_media_dma_buf_queue(struct imx_media_dma_buf_ring *ring, int index)
+{
+	struct imx_media_dma_buf *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	buf = __dma_buf_queue(ring, index);
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	if (IS_ERR(buf))
+		return PTR_ERR(buf);
+
+	dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] queued\n",
+		index, ring->src->name, ring->sink->name);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_queue);
+
+int imx_media_dma_buf_queue_from_vb(struct imx_media_dma_buf_ring *ring,
+				    struct vb2_buffer *vb)
+{
+	struct imx_media_dma_buf *buf;
+	unsigned long flags;
+	dma_addr_t phys;
+	void *virt;
+
+	if (vb->index >= ring->num_bufs)
+		return -EINVAL;
+
+	virt = vb2_plane_vaddr(vb, 0);
+	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
+
+	spin_lock_irqsave(&ring->lock, flags);
+	buf = __dma_buf_queue(ring, vb->index);
+	if (IS_ERR(buf))
+		goto err_unlock;
+
+	buf->virt = virt;
+	buf->phys = phys;
+	buf->vb = vb;
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] queued from vb\n",
+		buf->index, ring->src->name, ring->sink->name);
+
+	return 0;
+err_unlock:
+	spin_unlock_irqrestore(&ring->lock, flags);
+	return PTR_ERR(buf);
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_queue_from_vb);
+
+void imx_media_dma_buf_done(struct imx_media_dma_buf *buf,
+			    enum imx_media_dma_buf_status status)
+{
+	struct imx_media_dma_buf_ring *ring = buf->ring;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	WARN_ON(buf->state != IMX_MEDIA_BUF_STATUS_ACTIVE);
+	buf->state = buf->status = status;
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	if (buf == &ring->scratch)
+		dev_dbg(ring->imxmd->dev, "buf-scratch [%s -> %s] done\n",
+			ring->src->name, ring->sink->name);
+	else
+		dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] done\n",
+			buf->index, ring->src->name, ring->sink->name);
+
+	/* if the sink is a subdev, inform it that new buffers are available */
+	if (is_media_entity_v4l2_subdev(ring->sink)) {
+		struct v4l2_subdev *sd =
+			media_entity_to_v4l2_subdev(ring->sink);
+		v4l2_subdev_call(sd, core, ioctl, IMX_MEDIA_NEW_DMA_BUF, NULL);
+	}
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_done);
+
+/* find and return the oldest buffer in the done/error state */
+struct imx_media_dma_buf *
+imx_media_dma_buf_dequeue(struct imx_media_dma_buf_ring *ring)
+{
+	unsigned long flags, oldest_seq = (unsigned long)-1;
+	struct imx_media_dma_buf *buf = NULL, *scan;
+	int i;
+
+	spin_lock_irqsave(&ring->lock, flags);
+
+	for (i = 0; i < ring->num_bufs; i++) {
+		scan = &ring->buf[i];
+		if (scan->state != IMX_MEDIA_BUF_STATUS_DONE &&
+		    scan->state != IMX_MEDIA_BUF_STATUS_ERROR)
+			continue;
+		if (scan->seq < oldest_seq) {
+			buf = scan;
+			oldest_seq = scan->seq;
+		}
+	}
+
+	if (buf)
+		buf->state = IMX_MEDIA_BUF_STATUS_PREPARED;
+
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	if (buf)
+		dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] dequeued\n",
+			buf->index, ring->src->name, ring->sink->name);
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_dequeue);
+
+/* find and return the active buffer, there can be only one! */
+struct imx_media_dma_buf *
+imx_media_dma_buf_get_active(struct imx_media_dma_buf_ring *ring)
+{
+	struct imx_media_dma_buf *buf = NULL;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&ring->lock, flags);
+
+	for (i = 0; i < ring->num_bufs; i++) {
+		if (ring->buf[i].state == IMX_MEDIA_BUF_STATUS_ACTIVE) {
+			buf = &ring->buf[i];
+			goto out;
+		}
+	}
+
+	if (ring->scratch.state == IMX_MEDIA_BUF_STATUS_ACTIVE)
+		buf = &ring->scratch;
+
+out:
+	spin_unlock_irqrestore(&ring->lock, flags);
+	return buf;
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_get_active);
+
+/* set this buffer as the active one */
+int imx_media_dma_buf_set_active(struct imx_media_dma_buf *buf)
+{
+	struct imx_media_dma_buf_ring *ring = buf->ring;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ring->lock, flags);
+	WARN_ON(buf != &ring->scratch &&
+		buf->state != IMX_MEDIA_BUF_STATUS_QUEUED);
+	buf->state = IMX_MEDIA_BUF_STATUS_ACTIVE;
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_set_active);
+
+/*
+ * find and return the oldest buffer in the queued state. If
+ * there are none, return the scratch buffer.
+ */
+struct imx_media_dma_buf *
+imx_media_dma_buf_get_next_queued(struct imx_media_dma_buf_ring *ring)
+{
+	unsigned long flags, oldest_seq = (unsigned long)-1;
+	struct imx_media_dma_buf *buf = NULL, *scan;
+	int i;
+
+	spin_lock_irqsave(&ring->lock, flags);
+
+	for (i = 0; i < ring->num_bufs; i++) {
+		scan = &ring->buf[i];
+		if (scan->state != IMX_MEDIA_BUF_STATUS_QUEUED)
+			continue;
+		if (scan->seq < oldest_seq) {
+			buf = scan;
+			oldest_seq = scan->seq;
+		}
+	}
+
+	if (!buf)
+		buf = &ring->scratch;
+
+	spin_unlock_irqrestore(&ring->lock, flags);
+
+	if (buf != &ring->scratch)
+		dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] next\n",
+			buf->index, ring->src->name, ring->sink->name);
+	else
+		dev_dbg(ring->imxmd->dev, "buf-scratch [%s -> %s] next\n",
+			ring->src->name, ring->sink->name);
+
+	return buf;
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_get_next_queued);
+
+struct imx_media_dma_buf *
+imx_media_dma_buf_get(struct imx_media_dma_buf_ring *ring, int index)
+{
+	if (index >= ring->num_bufs)
+		return ERR_PTR(-EINVAL);
+	return &ring->buf[index];
+}
+EXPORT_SYMBOL_GPL(imx_media_dma_buf_get);
+
+/* form a subdev name given a group id and ipu id */
+void imx_media_grp_id_to_sd_name(char *sd_name, int sz, u32 grp_id, int ipu_id)
+{
+	int id;
+
+	switch (grp_id) {
+	case IMX_MEDIA_GRP_ID_CSI0...IMX_MEDIA_GRP_ID_CSI1:
+		id = (grp_id >> IMX_MEDIA_GRP_ID_CSI_BIT) - 1;
+		snprintf(sd_name, sz, "ipu%d_csi%d", ipu_id + 1, id);
+		break;
+	case IMX_MEDIA_GRP_ID_SMFC0...IMX_MEDIA_GRP_ID_SMFC3:
+		id = (grp_id >> IMX_MEDIA_GRP_ID_SMFC_BIT) - 1;
+		snprintf(sd_name, sz, "ipu%d_smfc%d", ipu_id + 1, id);
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PRPENC:
+		snprintf(sd_name, sz, "ipu%d_ic_prpenc", ipu_id + 1);
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PRPVF:
+		snprintf(sd_name, sz, "ipu%d_ic_prpvf", ipu_id + 1);
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PP0...IMX_MEDIA_GRP_ID_IC_PP3:
+		id = (grp_id >> IMX_MEDIA_GRP_ID_IC_PP_BIT) - 1;
+		snprintf(sd_name, sz, "ipu%d_ic_pp%d", ipu_id + 1, id);
+		break;
+	case IMX_MEDIA_GRP_ID_CAMIF0...IMX_MEDIA_GRP_ID_CAMIF3:
+		id = (grp_id >> IMX_MEDIA_GRP_ID_CAMIF_BIT) - 1;
+		snprintf(sd_name, sz, "camif%d", id);
+		break;
+	default:
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(imx_media_grp_id_to_sd_name);
+
+struct imx_media_subdev *
+imx_media_find_subdev_by_sd(struct imx_media_dev *imxmd,
+			    struct v4l2_subdev *sd)
+{
+	struct imx_media_subdev *imxsd;
+	int i;
+
+	for (i = 0; i < imxmd->num_subdevs; i++) {
+		imxsd = &imxmd->subdev[i];
+		if (sd == imxsd->sd)
+			return imxsd;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_sd);
+
+struct imx_media_subdev *
+imx_media_find_subdev_by_id(struct imx_media_dev *imxmd, u32 grp_id)
+{
+	struct imx_media_subdev *imxsd;
+	int i;
+
+	for (i = 0; i < imxmd->num_subdevs; i++) {
+		imxsd = &imxmd->subdev[i];
+		if (imxsd->sd && imxsd->sd->grp_id == grp_id)
+			return imxsd;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(imx_media_find_subdev_by_id);
+
+/*
+ * Search for an entity in the current pipeline with given grp_id.
+ * Called with mdev->graph_mutex held.
+ */
+static struct media_entity *
+find_pipeline_entity(struct imx_media_dev *imxmd,
+		     struct media_entity_graph *graph,
+		     struct media_entity *start_entity,
+		     u32 grp_id)
+{
+	struct media_entity *entity;
+	struct v4l2_subdev *sd;
+
+	media_entity_graph_walk_start(graph, start_entity);
+
+	while ((entity = media_entity_graph_walk_next(graph))) {
+		if (is_media_entity_v4l2_video_device(entity))
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(entity);
+		if (sd->grp_id & grp_id)
+			return entity;
+	}
+
+	return NULL;
+}
+
+/*
+ * Search for an entity in the current pipeline with given grp_id,
+ * then locate the remote enabled source pad from that entity.
+ * Called with mdev->graph_mutex held.
+ */
+static struct media_pad *
+find_pipeline_remote_source_pad(struct imx_media_dev *imxmd,
+				struct media_entity_graph *graph,
+				struct media_entity *start_entity,
+				u32 grp_id)
+{
+	struct media_pad *pad = NULL;
+	struct media_entity *me;
+	int i;
+
+	me = find_pipeline_entity(imxmd, graph, start_entity, grp_id);
+	if (!me)
+		return NULL;
+
+	/* Find remote source pad */
+	for (i = 0; i < me->num_pads; i++) {
+		struct media_pad *spad = &me->pads[i];
+
+		if (!(spad->flags & MEDIA_PAD_FL_SINK))
+			continue;
+		pad = media_entity_remote_pad(spad);
+		if (pad)
+			return pad;
+	}
+
+	return NULL;
+}
+
+/*
+ * Find the mipi-csi2 virtual channel reached from the given
+ * start entity in the current pipeline.
+ * Must be called with mdev->graph_mutex held.
+ */
+int imx_media_find_mipi_csi2_channel(struct imx_media_dev *imxmd,
+				     struct media_entity *start_entity)
+{
+	struct media_entity_graph graph;
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+	int ret;
+
+	ret = media_entity_graph_walk_init(&graph, &imxmd->md);
+	if (ret)
+		return ret;
+
+	/* first try to locate the mipi-csi2 from the video mux */
+	pad = find_pipeline_remote_source_pad(imxmd, &graph, start_entity,
+					      IMX_MEDIA_GRP_ID_VIDMUX);
+	/* if couldn't reach it from there, try from a CSI */
+	if (!pad)
+		pad = find_pipeline_remote_source_pad(imxmd, &graph,
+						      start_entity,
+						      IMX_MEDIA_GRP_ID_CSI);
+	if (pad) {
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI2) {
+			ret = pad->index - 1; /* found it! */
+			dev_dbg(imxmd->dev, "found vc%d from %s\n",
+				ret, start_entity->name);
+			goto cleanup;
+		}
+	}
+
+	ret = -EPIPE;
+
+cleanup:
+	media_entity_graph_walk_cleanup(&graph);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_find_mipi_csi2_channel);
+
+/*
+ * Find a subdev reached from the given start entity in the
+ * current pipeline.
+ * Must be called with mdev->graph_mutex held.
+ */
+struct imx_media_subdev *
+imx_media_find_pipeline_subdev(struct imx_media_dev *imxmd,
+			       struct media_entity *start_entity,
+			       u32 grp_id)
+{
+	struct media_entity_graph graph;
+	struct imx_media_subdev *imxsd;
+	struct media_entity *me;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	ret = media_entity_graph_walk_init(&graph, &imxmd->md);
+	if (ret)
+		return ERR_PTR(ret);
+
+	me = find_pipeline_entity(imxmd, &graph, start_entity, grp_id);
+	if (!me) {
+		imxsd = ERR_PTR(-ENODEV);
+		goto cleanup;
+	}
+
+	sd = media_entity_to_v4l2_subdev(me);
+	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
+cleanup:
+	media_entity_graph_walk_cleanup(&graph);
+	return imxsd;
+}
+EXPORT_SYMBOL_GPL(imx_media_find_pipeline_subdev);
+
+struct imx_media_subdev *
+__imx_media_find_sensor(struct imx_media_dev *imxmd,
+			struct media_entity *start_entity)
+{
+	return imx_media_find_pipeline_subdev(imxmd, start_entity,
+					      IMX_MEDIA_GRP_ID_SENSOR);
+}
+EXPORT_SYMBOL_GPL(__imx_media_find_sensor);
+
+struct imx_media_subdev *
+imx_media_find_sensor(struct imx_media_dev *imxmd,
+		      struct media_entity *start_entity)
+{
+	struct imx_media_subdev *sensor;
+
+	mutex_lock(&imxmd->md.graph_mutex);
+	sensor = __imx_media_find_sensor(imxmd, start_entity);
+	mutex_unlock(&imxmd->md.graph_mutex);
+
+	return sensor;
+}
+EXPORT_SYMBOL_GPL(imx_media_find_sensor);
+
+/*
+ * The subdevs have to be powered on/off, and streaming
+ * enabled/disabled, in a specific sequence.
+ */
+static const u32 stream_on_seq[] = {
+	IMX_MEDIA_GRP_ID_IC_PP,
+	IMX_MEDIA_GRP_ID_IC_PRPVF,
+	IMX_MEDIA_GRP_ID_IC_PRPENC,
+	IMX_MEDIA_GRP_ID_SMFC,
+	IMX_MEDIA_GRP_ID_SENSOR,
+	IMX_MEDIA_GRP_ID_CSI2,
+	IMX_MEDIA_GRP_ID_VIDMUX,
+	IMX_MEDIA_GRP_ID_CSI,
+};
+
+static const u32 stream_off_seq[] = {
+	IMX_MEDIA_GRP_ID_IC_PP,
+	IMX_MEDIA_GRP_ID_IC_PRPVF,
+	IMX_MEDIA_GRP_ID_IC_PRPENC,
+	IMX_MEDIA_GRP_ID_SMFC,
+	IMX_MEDIA_GRP_ID_CSI,
+	IMX_MEDIA_GRP_ID_VIDMUX,
+	IMX_MEDIA_GRP_ID_CSI2,
+	IMX_MEDIA_GRP_ID_SENSOR,
+};
+
+#define NUM_STREAM_ENTITIES ARRAY_SIZE(stream_on_seq)
+
+static const u32 power_on_seq[] = {
+	IMX_MEDIA_GRP_ID_CSI2,
+	IMX_MEDIA_GRP_ID_SENSOR,
+	IMX_MEDIA_GRP_ID_VIDMUX,
+	IMX_MEDIA_GRP_ID_CSI,
+	IMX_MEDIA_GRP_ID_SMFC,
+	IMX_MEDIA_GRP_ID_IC_PRPENC,
+	IMX_MEDIA_GRP_ID_IC_PRPVF,
+	IMX_MEDIA_GRP_ID_IC_PP,
+};
+
+static const u32 power_off_seq[] = {
+	IMX_MEDIA_GRP_ID_IC_PP,
+	IMX_MEDIA_GRP_ID_IC_PRPVF,
+	IMX_MEDIA_GRP_ID_IC_PRPENC,
+	IMX_MEDIA_GRP_ID_SMFC,
+	IMX_MEDIA_GRP_ID_CSI,
+	IMX_MEDIA_GRP_ID_VIDMUX,
+	IMX_MEDIA_GRP_ID_SENSOR,
+	IMX_MEDIA_GRP_ID_CSI2,
+};
+
+#define NUM_POWER_ENTITIES ARRAY_SIZE(power_on_seq)
+
+static int imx_media_set_stream(struct imx_media_dev *imxmd,
+				struct media_entity *start_entity,
+				bool on)
+{
+	struct media_entity_graph graph;
+	struct media_entity *entity;
+	struct v4l2_subdev *sd;
+	int i, ret;
+	u32 id;
+
+	mutex_lock(&imxmd->md.graph_mutex);
+
+	ret = media_entity_graph_walk_init(&graph, &imxmd->md);
+	if (ret)
+		goto unlock;
+
+	for (i = 0; i < NUM_STREAM_ENTITIES; i++) {
+		id = on ? stream_on_seq[i] : stream_off_seq[i];
+		entity = find_pipeline_entity(imxmd, &graph,
+					      start_entity, id);
+		if (!entity)
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(entity);
+		ret = v4l2_subdev_call(sd, video, s_stream, on);
+		if (ret && ret != -ENOIOCTLCMD)
+			break;
+	}
+
+	media_entity_graph_walk_cleanup(&graph);
+unlock:
+	mutex_unlock(&imxmd->md.graph_mutex);
+
+	return (ret && ret != -ENOIOCTLCMD) ? ret : 0;
+}
+
+/*
+ * Turn current pipeline streaming on/off starting from entity.
+ */
+int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
+				  struct media_entity *entity,
+				  struct media_pipeline *pipe,
+				  bool on)
+{
+	int ret = 0;
+
+	if (on) {
+		ret = media_entity_pipeline_start(entity, pipe);
+		if (ret)
+			return ret;
+		ret = imx_media_set_stream(imxmd, entity, true);
+		if (!ret)
+			return 0;
+		/* fall through */
+	}
+
+	imx_media_set_stream(imxmd, entity, false);
+	if (entity->pipe)
+		media_entity_pipeline_stop(entity);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_pipeline_set_stream);
+
+/*
+ * Turn current pipeline power on/off starting from start_entity.
+ * Must be called with mdev->graph_mutex held.
+ */
+int imx_media_pipeline_set_power(struct imx_media_dev *imxmd,
+				 struct media_entity_graph *graph,
+				 struct media_entity *start_entity, bool on)
+{
+	struct media_entity *entity;
+	struct v4l2_subdev *sd;
+	int i, ret = 0;
+	u32 id;
+
+	for (i = 0; i < NUM_POWER_ENTITIES; i++) {
+		id = on ? power_on_seq[i] : power_off_seq[i];
+		entity = find_pipeline_entity(imxmd, graph, start_entity, id);
+		if (!entity)
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(entity);
+
+		ret = v4l2_subdev_call(sd, core, s_power, on);
+		if (ret && ret != -ENOIOCTLCMD)
+			break;
+	}
+
+	return (ret && ret != -ENOIOCTLCMD) ? ret : 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_pipeline_set_power);
+
+/*
+ * Inherit the v4l2 controls from all entities in a pipeline
+ * to the given video device.
+ * Must be called with mdev->graph_mutex held.
+ */
+int imx_media_inherit_controls(struct imx_media_dev *imxmd,
+			       struct video_device *vfd,
+			       struct media_entity *start_entity)
+{
+	struct media_entity_graph graph;
+	struct media_entity *entity;
+	struct v4l2_subdev *sd;
+	int ret;
+
+	ret = media_entity_graph_walk_init(&graph, &imxmd->md);
+	if (ret)
+		return ret;
+
+	media_entity_graph_walk_start(&graph, start_entity);
+
+	while ((entity = media_entity_graph_walk_next(&graph))) {
+		if (is_media_entity_v4l2_video_device(entity))
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(entity);
+
+		dev_dbg(imxmd->dev, "%s: adding controls from %s\n",
+			__func__, sd->name);
+
+		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
+					    sd->ctrl_handler,
+					    NULL);
+		if (ret)
+			break;
+	}
+
+	media_entity_graph_walk_cleanup(&graph);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_inherit_controls);
+
+MODULE_DESCRIPTION("i.MX5/6 v4l2 media controller driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
new file mode 100644
index 0000000..357654d
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -0,0 +1,486 @@
+/*
+ * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
+#include <video/imx-ipu-v3.h>
+#include <media/imx.h>
+#include "imx-media.h"
+
+static inline struct imx_media_dev *notifier2dev(struct v4l2_async_notifier *n)
+{
+	return container_of(n, struct imx_media_dev, subdev_notifier);
+}
+
+/*
+ * Find a subdev by device node or device name. This is called during
+ * driver load to form the async subdev list and bind them.
+ */
+struct imx_media_subdev *
+imx_media_find_async_subdev(struct imx_media_dev *imxmd,
+			    struct device_node *np,
+			    const char *devname)
+{
+	struct imx_media_subdev *imxsd;
+	int i;
+
+	for (i = 0; i < imxmd->subdev_notifier.num_subdevs; i++) {
+		imxsd = &imxmd->subdev[i];
+		switch (imxsd->asd.match_type) {
+		case V4L2_ASYNC_MATCH_OF:
+			if (np && imxsd->asd.match.of.node == np)
+				return imxsd;
+			break;
+		case V4L2_ASYNC_MATCH_DEVNAME:
+			if (devname &&
+			    !strcmp(imxsd->asd.match.device_name.name, devname))
+				return imxsd;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return NULL;
+}
+
+/*
+ * Adds a subdev to the async subdev list. If np is non-NULL, adds
+ * the async as a V4L2_ASYNC_MATCH_OF match type, otherwise as a
+ * V4L2_ASYNC_MATCH_DEVNAME match type using devname. This is called
+ * during driver load when forming the async subdev list.
+ */
+struct imx_media_subdev *
+imx_media_add_async_subdev(struct imx_media_dev *imxmd,
+			   struct device_node *np,
+			   const char *devname)
+{
+	struct imx_media_subdev *imxsd;
+	struct v4l2_async_subdev *asd;
+	int sd_idx;
+
+	/* return NULL if this subdev already added */
+	if (imx_media_find_async_subdev(imxmd, np, devname)) {
+		dev_dbg(imxmd->dev, "%s: already added %s\n",
+			__func__, np ? np->name : devname);
+		return NULL;
+	}
+
+	sd_idx = imxmd->subdev_notifier.num_subdevs;
+	if (sd_idx >= IMX_MEDIA_MAX_SUBDEVS) {
+		dev_err(imxmd->dev, "%s: too many subdevs! can't add %s\n",
+			__func__, np ? np->name : devname);
+		return ERR_PTR(-ENOSPC);
+	}
+
+	imxsd = &imxmd->subdev[sd_idx];
+
+	asd = &imxsd->asd;
+	if (np) {
+		asd->match_type = V4L2_ASYNC_MATCH_OF;
+		asd->match.of.node = np;
+	} else {
+		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
+		strncpy(imxsd->devname, devname, sizeof(imxsd->devname));
+		asd->match.device_name.name = imxsd->devname;
+	}
+
+	imxmd->async_ptrs[sd_idx] = asd;
+	imxmd->subdev_notifier.num_subdevs++;
+
+	dev_dbg(imxmd->dev, "%s: added %s, match type %s\n",
+		__func__, np ? np->name : devname, np ? "OF" : "DEVNAME");
+
+	return imxsd;
+}
+
+/*
+ * Adds an imx-media link to a subdev pad's link list. This is called
+ * during driver load when forming the links between subdevs.
+ *
+ * @pad: the local pad
+ * @remote_node: the device node of the remote subdev
+ * @remote_devname: the device name of the remote subdev
+ * @local_pad: local pad index
+ * @remote_pad: remote pad index
+ */
+int imx_media_add_pad_link(struct imx_media_dev *imxmd,
+			   struct imx_media_pad *pad,
+			   struct device_node *remote_node,
+			   const char *remote_devname,
+			   int local_pad, int remote_pad)
+{
+	struct imx_media_link *link;
+	int link_idx;
+
+	link_idx = pad->num_links;
+	if (link_idx >= IMX_MEDIA_MAX_LINKS) {
+		dev_err(imxmd->dev, "%s: too many links!\n", __func__);
+		return -ENOSPC;
+	}
+
+	link = &pad->link[link_idx];
+
+	link->remote_sd_node = remote_node;
+	if (remote_devname)
+		strncpy(link->remote_devname, remote_devname,
+			sizeof(link->remote_devname));
+
+	link->local_pad = local_pad;
+	link->remote_pad = remote_pad;
+
+	pad->num_links++;
+
+	return 0;
+}
+
+/*
+ * get IPU from this CSI and add it to the list of IPUs
+ * the media driver will control.
+ */
+static int imx_media_get_ipu(struct imx_media_dev *imxmd,
+			     struct v4l2_subdev *csi_sd)
+{
+	struct ipu_soc *ipu;
+	int ipu_id;
+
+	ipu = dev_get_drvdata(csi_sd->dev->parent);
+	if (!ipu) {
+		v4l2_err(&imxmd->v4l2_dev,
+			 "CSI %s has no parent IPU!\n", csi_sd->name);
+		return -ENODEV;
+	}
+
+	ipu_id = ipu_get_num(ipu);
+	if (ipu_id > 1) {
+		v4l2_err(&imxmd->v4l2_dev, "invalid IPU id %d!\n", ipu_id);
+		return -ENODEV;
+	}
+
+	if (!imxmd->ipu[ipu_id])
+		imxmd->ipu[ipu_id] = ipu;
+
+	return 0;
+}
+
+/* async subdev bound notifier */
+static int imx_media_subdev_bound(struct v4l2_async_notifier *notifier,
+				  struct v4l2_subdev *sd,
+				  struct v4l2_async_subdev *asd)
+{
+	struct imx_media_dev *imxmd = notifier2dev(notifier);
+	struct imx_media_subdev *imxsd;
+	int i, ret = -EINVAL;
+
+	imxsd = imx_media_find_async_subdev(imxmd, sd->dev->of_node,
+					    dev_name(sd->dev));
+	if (!imxsd)
+		goto out;
+
+	imxsd->sd = sd;
+
+	if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI) {
+		ret = imx_media_get_ipu(imxmd, sd);
+		if (ret)
+			return ret;
+	} else if (sd->entity.function == MEDIA_ENT_F_MUX) {
+		/* this is the video mux */
+		sd->grp_id = IMX_MEDIA_GRP_ID_VIDMUX;
+	} else if (imxsd->num_sink_pads == 0 &&
+		   ((sd->entity.flags & MEDIA_ENT_F_ATV_DECODER) ||
+		    sd->entity.function == MEDIA_ENT_F_CAM_SENSOR ||
+		    sd->entity.function == MEDIA_ENT_F_ATV_DECODER)) {
+		/* this is a sensor */
+		sd->grp_id = IMX_MEDIA_GRP_ID_SENSOR;
+
+		/* set sensor input names if needed */
+		for (i = 0; i < imxsd->input.num; i++) {
+			if (strlen(imxsd->input.name[i]))
+				continue;
+			snprintf(imxsd->input.name[i],
+				 sizeof(imxsd->input.name[i]),
+				 "%s-%d", sd->name, i);
+		}
+	}
+
+	ret = 0;
+out:
+	if (ret)
+		v4l2_warn(&imxmd->v4l2_dev,
+			  "Received unknown subdev %s\n", sd->name);
+	else
+		v4l2_info(&imxmd->v4l2_dev,
+			  "Registered subdev %s\n", sd->name);
+
+	return ret;
+}
+
+/*
+ * create a single media link given a local subdev, a single pad from that
+ * subdev, and a single link from that pad. Called after all subdevs have
+ * registered.
+ */
+static int imx_media_create_link(struct imx_media_dev *imxmd,
+				 struct imx_media_subdev *local_sd,
+				 struct imx_media_pad *pad,
+				 struct imx_media_link *link)
+{
+	struct imx_media_subdev *remote_sd;
+	struct v4l2_subdev *source, *sink;
+	u16 source_pad, sink_pad;
+	int ret;
+
+	/* only create the source->sink links */
+	if (pad->pad.flags & MEDIA_PAD_FL_SINK)
+		return 0;
+
+	remote_sd = imx_media_find_async_subdev(imxmd, link->remote_sd_node,
+						link->remote_devname);
+	if (!remote_sd) {
+		v4l2_warn(&imxmd->v4l2_dev, "%s: no remote for %s:%d\n",
+			  __func__, local_sd->sd->name, link->local_pad);
+		return 0;
+	}
+
+	source = local_sd->sd;
+	sink = remote_sd->sd;
+	source_pad = link->local_pad;
+	sink_pad = link->remote_pad;
+
+	v4l2_info(&imxmd->v4l2_dev, "%s: %s:%d -> %s:%d\n", __func__,
+		  source->name, source_pad, sink->name, sink_pad);
+
+	ret = media_create_pad_link(&source->entity, source_pad,
+				    &sink->entity, sink_pad, 0);
+	if (ret)
+		v4l2_err(&imxmd->v4l2_dev,
+			 "create_pad_link failed: %d\n", ret);
+
+	return ret;
+}
+
+/*
+ * create the media links from all imx-media pads and their links.
+ * Called after all subdevs have registered.
+ */
+static int imx_media_create_links(struct imx_media_dev *imxmd)
+{
+	struct imx_media_subdev *local_sd;
+	struct imx_media_link *link;
+	struct imx_media_pad *pad;
+	int num_pads, i, j, k;
+	int ret = 0;
+
+	for (i = 0; i < imxmd->num_subdevs; i++) {
+		local_sd = &imxmd->subdev[i];
+		num_pads = local_sd->num_sink_pads + local_sd->num_src_pads;
+
+		for (j = 0; j < num_pads; j++) {
+			pad = &local_sd->pad[j];
+
+			for (k = 0; k < pad->num_links; k++) {
+				link = &pad->link[k];
+
+				ret = imx_media_create_link(imxmd, local_sd,
+							    pad, link);
+				if (ret)
+					goto out;
+			}
+		}
+	}
+
+out:
+	return ret;
+}
+
+/* async subdev complete notifier */
+static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
+{
+	struct imx_media_dev *imxmd = notifier2dev(notifier);
+	int ret;
+
+	mutex_lock(&imxmd->md.graph_mutex);
+
+	ret = imx_media_create_links(imxmd);
+	if (ret)
+		goto unlock;
+
+	ret = v4l2_device_register_subdev_nodes(&imxmd->v4l2_dev);
+unlock:
+	mutex_unlock(&imxmd->md.graph_mutex);
+	if (ret)
+		return ret;
+
+	return media_device_register(&imxmd->md);
+}
+
+static int imx_media_link_notify(struct media_link *link, unsigned int flags,
+				 unsigned int notification)
+{
+	struct media_entity *sink = link->sink->entity;
+	struct media_entity_graph *graph;
+	struct v4l2_subdev *sink_sd;
+	struct imx_media_dev *imxmd;
+	int ret = 0;
+
+	if (is_media_entity_v4l2_video_device(sink))
+		return 0;
+	sink_sd = media_entity_to_v4l2_subdev(sink);
+	imxmd = dev_get_drvdata(sink_sd->v4l2_dev->dev);
+	graph = &imxmd->link_notify_graph;
+
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH) {
+		ret = media_entity_graph_walk_init(graph, &imxmd->md);
+		if (ret)
+			return ret;
+
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			/* Before link disconnection */
+			ret = imx_media_pipeline_set_power(imxmd, graph,
+							   sink, false);
+		}
+	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH) {
+		if (link->flags & MEDIA_LNK_FL_ENABLED) {
+			/* After link activation */
+			ret = imx_media_pipeline_set_power(imxmd, graph,
+							   sink, true);
+		}
+
+		media_entity_graph_walk_cleanup(graph);
+	}
+
+	return ret ? -EPIPE : 0;
+}
+
+static const struct media_device_ops imx_media_md_ops = {
+	.link_notify = imx_media_link_notify,
+};
+
+static int imx_media_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = dev->of_node;
+	struct imx_media_subdev *csi[4];
+	struct imx_media_dev *imxmd;
+	int ret;
+
+	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
+	if (!imxmd)
+		return -ENOMEM;
+
+	imxmd->dev = dev;
+	dev_set_drvdata(dev, imxmd);
+
+	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
+	imxmd->md.ops = &imx_media_md_ops;
+	imxmd->md.dev = dev;
+
+	imxmd->v4l2_dev.mdev = &imxmd->md;
+	strlcpy(imxmd->v4l2_dev.name, "imx-media",
+		sizeof(imxmd->v4l2_dev.name));
+
+	media_device_init(&imxmd->md);
+
+	ret = v4l2_device_register(dev, &imxmd->v4l2_dev);
+	if (ret < 0) {
+		v4l2_err(&imxmd->v4l2_dev,
+			 "Failed to register v4l2_device: %d\n", ret);
+		return ret;
+	}
+
+	dev_set_drvdata(imxmd->v4l2_dev.dev, imxmd);
+
+	ret = imx_media_of_parse(imxmd, &csi, node);
+	if (ret) {
+		v4l2_err(&imxmd->v4l2_dev,
+			 "imx_media_of_parse failed with %d\n", ret);
+		goto unreg_dev;
+	}
+
+	ret = imx_media_add_internal_subdevs(imxmd, csi);
+	if (ret) {
+		v4l2_err(&imxmd->v4l2_dev,
+			 "add_internal_subdevs failed with %d\n", ret);
+		goto unreg_dev;
+	}
+
+	/* no subdevs? just bail for this media device */
+	imxmd->num_subdevs = imxmd->subdev_notifier.num_subdevs;
+	if (imxmd->num_subdevs == 0) {
+		ret = -ENODEV;
+		goto unreg_dev;
+	}
+
+	/* prepare the async subdev notifier and register it */
+	imxmd->subdev_notifier.subdevs = imxmd->async_ptrs;
+	imxmd->subdev_notifier.bound = imx_media_subdev_bound;
+	imxmd->subdev_notifier.complete = imx_media_probe_complete;
+	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
+					   &imxmd->subdev_notifier);
+	if (ret) {
+		v4l2_err(&imxmd->v4l2_dev,
+			 "v4l2_async_notifier_register failed with %d\n", ret);
+		goto unreg_dev;
+	}
+
+	return 0;
+
+unreg_dev:
+	v4l2_device_unregister(&imxmd->v4l2_dev);
+	return ret;
+}
+
+static int imx_media_remove(struct platform_device *pdev)
+{
+	struct imx_media_dev *imxmd =
+		(struct imx_media_dev *)platform_get_drvdata(pdev);
+
+	v4l2_info(&imxmd->v4l2_dev, "Removing imx-media\n");
+
+	v4l2_async_notifier_unregister(&imxmd->subdev_notifier);
+	v4l2_device_unregister(&imxmd->v4l2_dev);
+	media_device_unregister(&imxmd->md);
+	media_device_cleanup(&imxmd->md);
+
+	return 0;
+}
+
+static const struct of_device_id imx_media_dt_ids[] = {
+	{ .compatible = "fsl,imx-media" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imx_media_dt_ids);
+
+static struct platform_driver imx_media_pdrv = {
+	.probe		= imx_media_probe,
+	.remove		= imx_media_remove,
+	.driver		= {
+		.name	= "imx-media",
+		.of_match_table	= imx_media_dt_ids,
+	},
+};
+
+module_platform_driver(imx_media_pdrv);
+
+MODULE_DESCRIPTION("i.MX5/6 v4l2 media controller driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
new file mode 100644
index 0000000..acc7e39
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-fim.c
@@ -0,0 +1,471 @@
+/*
+ * Frame Interval Monitor.
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+#include <media/imx.h>
+#include "imx-media.h"
+
+enum {
+	FIM_CL_ENABLE = 0,
+	FIM_CL_NUM,
+	FIM_CL_TOLERANCE_MIN,
+	FIM_CL_TOLERANCE_MAX,
+	FIM_CL_NUM_SKIP,
+	FIM_NUM_CONTROLS,
+};
+
+#define FIM_CL_ENABLE_DEF          1 /* FIM enabled by default */
+#define FIM_CL_NUM_DEF             8 /* average 8 frames */
+#define FIM_CL_NUM_SKIP_DEF        2 /* skip 2 frames after restart */
+#define FIM_CL_TOLERANCE_MIN_DEF  50 /* usec */
+#define FIM_CL_TOLERANCE_MAX_DEF   0 /* no max tolerance (unbounded) */
+
+struct imx_media_fim {
+	struct imx_media_dev *md;
+
+	/* the owning subdev of this fim instance */
+	struct v4l2_subdev *sd;
+
+	/* FIM's control handler */
+	struct v4l2_ctrl_handler ctrl_handler;
+
+	/* control cluster */
+	struct v4l2_ctrl  *ctrl[FIM_NUM_CONTROLS];
+
+	/* current control values */
+	bool              enabled;
+	int               num_avg;
+	int               num_skip;
+	unsigned long     tolerance_min; /* usec */
+	unsigned long     tolerance_max; /* usec */
+
+	int               counter;
+	struct timespec   last_ts;
+	unsigned long     sum;       /* usec */
+	unsigned long     nominal;   /* usec */
+
+	/*
+	 * input capture method of measuring FI (channel and flags
+	 * from device tree)
+	 */
+	int               icap_channel;
+	int               icap_flags;
+	struct completion icap_first_event;
+};
+
+static void update_fim_nominal(struct imx_media_fim *fim,
+			       struct imx_media_subdev *sensor)
+{
+	struct v4l2_streamparm parm;
+	struct v4l2_fract tpf;
+	int ret;
+
+	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = v4l2_subdev_call(sensor->sd, video, g_parm, &parm);
+	tpf = parm.parm.capture.timeperframe;
+
+	if (ret || tpf.denominator == 0) {
+		dev_dbg(fim->sd->dev, "no tpf from sensor, FIM disabled\n");
+		fim->enabled = false;
+		return;
+	}
+
+	fim->nominal = DIV_ROUND_CLOSEST(1000 * 1000 * tpf.numerator,
+					 tpf.denominator);
+
+	dev_dbg(fim->sd->dev, "sensor FI=%lu usec\n", fim->nominal);
+}
+
+static void reset_fim(struct imx_media_fim *fim, bool curval)
+{
+	struct v4l2_ctrl *en = fim->ctrl[FIM_CL_ENABLE];
+	struct v4l2_ctrl *num = fim->ctrl[FIM_CL_NUM];
+	struct v4l2_ctrl *skip = fim->ctrl[FIM_CL_NUM_SKIP];
+	struct v4l2_ctrl *tol_min = fim->ctrl[FIM_CL_TOLERANCE_MIN];
+	struct v4l2_ctrl *tol_max = fim->ctrl[FIM_CL_TOLERANCE_MAX];
+
+	if (curval) {
+		fim->enabled = en->cur.val;
+		fim->num_avg = num->cur.val;
+		fim->num_skip = skip->cur.val;
+		fim->tolerance_min = tol_min->cur.val;
+		fim->tolerance_max = tol_max->cur.val;
+	} else {
+		fim->enabled = en->val;
+		fim->num_avg = num->val;
+		fim->num_skip = skip->val;
+		fim->tolerance_min = tol_min->val;
+		fim->tolerance_max = tol_max->val;
+	}
+
+	/* disable tolerance range if max <= min */
+	if (fim->tolerance_max <= fim->tolerance_min)
+		fim->tolerance_max = 0;
+
+	fim->counter = -fim->num_skip;
+	fim->sum = 0;
+}
+
+static void send_fim_event(struct imx_media_fim *fim, unsigned long error)
+{
+	static const struct v4l2_event ev = {
+		.type = V4L2_EVENT_IMX_FRAME_INTERVAL,
+	};
+
+	v4l2_subdev_notify_event(fim->sd, &ev);
+}
+
+/*
+ * Monitor an averaged frame interval. If the average deviates too much
+ * from the sensor's nominal frame rate, send the frame interval error
+ * event. The frame intervals are averaged in order to quiet noise from
+ * (presumably random) interrupt latency.
+ */
+static void frame_interval_monitor(struct imx_media_fim *fim,
+				   struct timespec *ts)
+{
+	unsigned long interval, error, error_avg;
+	struct timespec diff;
+	bool send_event = false;
+
+	if (!fim->enabled || ++fim->counter <= 0)
+		goto out_update_ts;
+
+	diff = timespec_sub(*ts, fim->last_ts);
+	interval = diff.tv_sec * 1000 * 1000 + diff.tv_nsec / 1000;
+	error = abs(interval - fim->nominal);
+
+	if (fim->tolerance_max && error >= fim->tolerance_max) {
+		dev_dbg(fim->sd->dev,
+			"FIM: %lu ignored, out of tolerance bounds\n",
+			error);
+		fim->counter--;
+		goto out_update_ts;
+	}
+
+	fim->sum += error;
+
+	if (fim->counter == fim->num_avg) {
+		error_avg = DIV_ROUND_CLOSEST(fim->sum, fim->num_avg);
+
+		if (error_avg > fim->tolerance_min)
+			send_event = true;
+
+		dev_dbg(fim->sd->dev, "FIM: error: %lu usec%s\n",
+			error_avg, send_event ? " (!!!)" : "");
+
+		fim->counter = 0;
+		fim->sum = 0;
+	}
+
+out_update_ts:
+	fim->last_ts = *ts;
+	if (send_event)
+		send_fim_event(fim, error_avg);
+}
+
+#ifdef CONFIG_IMX_GPT_ICAP
+/*
+ * Input Capture method of measuring frame intervals. Not subject
+ * to interrupt latency.
+ */
+static void fim_input_capture_handler(int channel, void *dev_id,
+				      struct timespec *ts)
+{
+	struct imx_media_fim *fim = dev_id;
+
+	frame_interval_monitor(fim, ts);
+
+	if (!completion_done(&fim->icap_first_event))
+		complete(&fim->icap_first_event);
+}
+
+static int fim_request_input_capture(struct imx_media_fim *fim)
+{
+	init_completion(&fim->icap_first_event);
+
+	return mxc_request_input_capture(fim->icap_channel,
+					 fim_input_capture_handler,
+					 fim->icap_flags, fim);
+}
+
+static void fim_free_input_capture(struct imx_media_fim *fim)
+{
+	mxc_free_input_capture(fim->icap_channel, fim);
+}
+
+#else /* CONFIG_IMX_GPT_ICAP */
+
+static int fim_request_input_capture(struct imx_media_fim *fim)
+{
+	return 0;
+}
+
+static void fim_free_input_capture(struct imx_media_fim *fim)
+{
+}
+
+#endif /* CONFIG_IMX_GPT_ICAP */
+
+/*
+ * In case we are monitoring the first frame interval after streamon
+ * (when fim->num_skip = 0), we need a valid fim->last_ts before we
+ * can begin. This only applies to the input capture method. It is not
+ * possible to accurately measure the first FI after streamon using the
+ * EOF method, so fim->num_skip minimum is set to 1 in that case, so this
+ * function is a noop when the EOF method is used.
+ */
+static void fim_acquire_first_ts(struct imx_media_fim *fim)
+{
+	unsigned long ret;
+
+	if (!fim->enabled || fim->num_skip > 0)
+		return;
+
+	ret = wait_for_completion_timeout(
+		&fim->icap_first_event,
+		msecs_to_jiffies(IMX_MEDIA_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(fim->sd, "wait first icap event timeout\n");
+}
+
+/* FIM Controls */
+static int fim_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct imx_media_fim *fim = container_of(ctrl->handler,
+						 struct imx_media_fim,
+						 ctrl_handler);
+
+	switch (ctrl->id) {
+	case V4L2_CID_IMX_FIM_ENABLE:
+		reset_fim(fim, false);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops fim_ctrl_ops = {
+	.s_ctrl = fim_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config imx_media_fim_ctrl[] = {
+	[FIM_CL_ENABLE] = {
+		.ops = &fim_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_ENABLE,
+		.name = "FIM Enable",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def = FIM_CL_ENABLE_DEF,
+		.min = 0,
+		.max = 1,
+		.step = 1,
+	},
+	[FIM_CL_NUM] = {
+		.ops = &fim_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_NUM,
+		.name = "FIM Num Average",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_NUM_DEF,
+		.min =  1, /* no averaging */
+		.max = 64, /* average 64 frames */
+		.step = 1,
+	},
+	[FIM_CL_TOLERANCE_MIN] = {
+		.ops = &fim_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_TOLERANCE_MIN,
+		.name = "FIM Tolerance Min",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_TOLERANCE_MIN_DEF,
+		.min =    2,
+		.max =  200,
+		.step =   1,
+	},
+	[FIM_CL_TOLERANCE_MAX] = {
+		.ops = &fim_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_TOLERANCE_MAX,
+		.name = "FIM Tolerance Max",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_TOLERANCE_MAX_DEF,
+		.min =    0,
+		.max =  500,
+		.step =   1,
+	},
+	[FIM_CL_NUM_SKIP] = {
+		.ops = &fim_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_NUM_SKIP,
+		.name = "FIM Num Skip",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_NUM_SKIP_DEF,
+		.min =   0, /* skip no frames */
+		.max = 256, /* skip 256 frames */
+		.step =  1,
+	},
+};
+
+static int init_fim_controls(struct imx_media_fim *fim)
+{
+	struct v4l2_ctrl_handler *hdlr = &fim->ctrl_handler;
+	struct v4l2_ctrl_config fim_c;
+	int i, ret;
+
+	v4l2_ctrl_handler_init(hdlr, FIM_NUM_CONTROLS);
+
+	for (i = 0; i < FIM_NUM_CONTROLS; i++) {
+		fim_c = imx_media_fim_ctrl[i];
+
+		/*
+		 * it's not possible to accurately measure the first
+		 * FI after streamon using the EOF method, so force
+		 * num_skip minimum to 1 in that case.
+		 */
+		if (i == FIM_CL_NUM_SKIP && fim->icap_channel < 0)
+			fim_c.min = 1;
+
+		fim->ctrl[i] = v4l2_ctrl_new_custom(hdlr, &fim_c, NULL);
+	}
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		goto err_free;
+	}
+
+	v4l2_ctrl_cluster(FIM_NUM_CONTROLS, fim->ctrl);
+
+	/* add the FIM controls to the calling subdev ctrl handler */
+	ret = v4l2_ctrl_add_handler(fim->sd->ctrl_handler,
+				    &fim->ctrl_handler, NULL);
+	if (ret)
+		goto err_free;
+
+	return 0;
+err_free:
+	v4l2_ctrl_handler_free(hdlr);
+	return ret;
+}
+
+static int of_parse_fim(struct imx_media_fim *fim, struct device_node *np)
+{
+	struct device_node *fim_np;
+	u32 icap[2];
+	int ret;
+
+	/* by default EOF method is used */
+	fim->icap_channel = -1;
+
+	fim_np = of_get_child_by_name(np, "fim");
+	if (!fim_np || !of_device_is_available(fim_np)) {
+		of_node_put(fim_np);
+		return -ENODEV;
+	}
+
+	if (IS_ENABLED(CONFIG_IMX_GPT_ICAP)) {
+		ret = of_property_read_u32_array(fim_np,
+						 "fsl,input-capture-channel",
+						 icap, 2);
+		if (!ret) {
+			fim->icap_channel = icap[0];
+			fim->icap_flags = icap[1];
+		}
+	}
+
+	of_node_put(fim_np);
+	return 0;
+}
+
+/*
+ * Monitor frame intervals via EOF interrupt. This method is
+ * subject to uncertainty errors introduced by interrupt latency.
+ *
+ * This is a noop if the Input Capture method is being used, since
+ * the frame_interval_monitor() is called by the input capture event
+ * callback handler in that case.
+ */
+void imx_media_fim_eof_monitor(struct imx_media_fim *fim, struct timespec *ts)
+{
+	if (fim->icap_channel >= 0)
+		return;
+
+	frame_interval_monitor(fim, ts);
+}
+EXPORT_SYMBOL_GPL(imx_media_fim_eof_monitor);
+
+/* Called by the subdev in its s_power callback */
+int imx_media_fim_set_power(struct imx_media_fim *fim, bool on)
+{
+	int ret = 0;
+
+	if (fim->icap_channel >= 0) {
+		if (on)
+			ret = fim_request_input_capture(fim);
+		else
+			fim_free_input_capture(fim);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_fim_set_power);
+
+/* Called by the subdev in its s_stream callback */
+int imx_media_fim_set_stream(struct imx_media_fim *fim,
+			     struct imx_media_subdev *sensor,
+			     bool on)
+{
+	if (on) {
+		reset_fim(fim, true);
+		update_fim_nominal(fim, sensor);
+
+		if (fim->icap_channel >= 0)
+			fim_acquire_first_ts(fim);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_fim_set_stream);
+
+/* Called by the subdev in its subdev registered callback */
+struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd)
+{
+	struct device_node *node = sd->of_node;
+	struct imx_media_fim *fim;
+	int ret;
+
+	fim = devm_kzalloc(sd->dev, sizeof(*fim), GFP_KERNEL);
+	if (!fim)
+		return ERR_PTR(-ENOMEM);
+
+	/* get media device */
+	fim->md = dev_get_drvdata(sd->v4l2_dev->dev);
+	fim->sd = sd;
+
+	ret = of_parse_fim(fim, node);
+	if (ret)
+		return (ret == -ENODEV) ? NULL : ERR_PTR(ret);
+
+	ret = init_fim_controls(fim);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return fim;
+}
+EXPORT_SYMBOL_GPL(imx_media_fim_init);
+
+void imx_media_fim_free(struct imx_media_fim *fim)
+{
+	v4l2_ctrl_handler_free(&fim->ctrl_handler);
+}
+EXPORT_SYMBOL_GPL(imx_media_fim_free);
diff --git a/drivers/staging/media/imx/imx-media-internal-sd.c b/drivers/staging/media/imx/imx-media-internal-sd.c
new file mode 100644
index 0000000..fd3e020
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -0,0 +1,457 @@
+/*
+ * Media driver for Freescale i.MX5/6 SOC
+ *
+ * Adds the internal subdevices and the media links between them.
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/platform_device.h>
+#include "imx-media.h"
+
+enum isd_enum {
+	isd_csi0 = 0,
+	isd_csi1,
+	isd_smfc0,
+	isd_smfc1,
+	isd_ic_prpenc,
+	isd_ic_prpvf,
+	isd_ic_pp0,
+	isd_ic_pp1,
+	isd_camif0,
+	isd_camif1,
+	num_isd,
+};
+
+static const struct internal_subdev_id {
+	enum isd_enum index;
+	const char *name;
+	u32 grp_id;
+} isd_id[num_isd] = {
+	[isd_csi0] = {
+		.index = isd_csi0,
+		.grp_id = IMX_MEDIA_GRP_ID_CSI0,
+		.name = "imx-ipuv3-csi",
+	},
+	[isd_csi1] = {
+		.index = isd_csi1,
+		.grp_id = IMX_MEDIA_GRP_ID_CSI1,
+		.name = "imx-ipuv3-csi",
+	},
+	[isd_smfc0] = {
+		.index = isd_smfc0,
+		.grp_id = IMX_MEDIA_GRP_ID_SMFC0,
+		.name = "imx-ipuv3-smfc",
+	},
+	[isd_smfc1] = {
+		.index = isd_smfc1,
+		.grp_id = IMX_MEDIA_GRP_ID_SMFC1,
+		.name = "imx-ipuv3-smfc",
+	},
+	[isd_ic_prpenc] = {
+		.index = isd_ic_prpenc,
+		.grp_id = IMX_MEDIA_GRP_ID_IC_PRPENC,
+		.name = "imx-ipuv3-ic",
+	},
+	[isd_ic_prpvf] = {
+		.index = isd_ic_prpvf,
+		.grp_id = IMX_MEDIA_GRP_ID_IC_PRPVF,
+		.name = "imx-ipuv3-ic",
+	},
+	[isd_ic_pp0] = {
+		.index = isd_ic_pp0,
+		.grp_id = IMX_MEDIA_GRP_ID_IC_PP0,
+		.name = "imx-ipuv3-ic",
+	},
+	[isd_ic_pp1] = {
+		.index = isd_ic_pp1,
+		.grp_id = IMX_MEDIA_GRP_ID_IC_PP1,
+		.name = "imx-ipuv3-ic",
+	},
+	[isd_camif0] = {
+		.index = isd_camif0,
+		.grp_id = IMX_MEDIA_GRP_ID_CAMIF0,
+		.name = "imx-media-camif",
+	},
+	[isd_camif1] = {
+		.index = isd_camif1,
+		.grp_id = IMX_MEDIA_GRP_ID_CAMIF1,
+		.name = "imx-media-camif",
+	},
+};
+
+struct internal_link {
+	const struct internal_subdev_id *remote_id;
+	int remote_pad;
+};
+
+struct internal_pad {
+	int num_links;
+	bool devnode; /* does this pad link to a device node */
+	struct internal_link link[IMX_MEDIA_MAX_LINKS];
+};
+
+static const struct internal_subdev {
+	const struct internal_subdev_id *id;
+	struct internal_pad pad[IMX_MEDIA_MAX_PADS];
+	int num_sink_pads;
+	int num_src_pads;
+} internal_subdev[num_isd] = {
+	[isd_csi0] = {
+		.id = &isd_id[isd_csi0],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 3,
+			.link[0] = {
+				.remote_id = &isd_id[isd_ic_prpenc],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id =  &isd_id[isd_ic_prpvf],
+				.remote_pad = 0,
+			},
+			.link[2] = {
+				.remote_id =  &isd_id[isd_smfc0],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_csi1] = {
+		.id = &isd_id[isd_csi1],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 3,
+			.link[0] = {
+				.remote_id = &isd_id[isd_ic_prpenc],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id =  &isd_id[isd_ic_prpvf],
+				.remote_pad = 0,
+			},
+			.link[2] = {
+				.remote_id =  &isd_id[isd_smfc1],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_smfc0] = {
+		.id = &isd_id[isd_smfc0],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 4,
+			.link[0] = {
+				.remote_id =  &isd_id[isd_ic_prpvf],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id =  &isd_id[isd_ic_pp0],
+				.remote_pad = 0,
+			},
+			.link[2] = {
+				.remote_id = &isd_id[isd_camif0],
+				.remote_pad = 0,
+			},
+			.link[3] = {
+				.remote_id = &isd_id[isd_camif1],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_smfc1] = {
+		.id = &isd_id[isd_smfc1],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 4,
+			.link[0] = {
+				.remote_id =  &isd_id[isd_ic_prpvf],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id =  &isd_id[isd_ic_pp1],
+				.remote_pad = 0,
+			},
+			.link[2] = {
+				.remote_id = &isd_id[isd_camif0],
+				.remote_pad = 0,
+			},
+			.link[3] = {
+				.remote_id = &isd_id[isd_camif1],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_ic_prpenc] = {
+		.id = &isd_id[isd_ic_prpenc],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 2,
+			.link[0] = {
+				.remote_id = &isd_id[isd_camif0],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id = &isd_id[isd_camif1],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_ic_prpvf] = {
+		.id = &isd_id[isd_ic_prpvf],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 4,
+			.link[0] = {
+				.remote_id = &isd_id[isd_camif0],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id = &isd_id[isd_camif1],
+				.remote_pad = 0,
+			},
+			.link[2] = {
+				.remote_id =  &isd_id[isd_ic_pp0],
+				.remote_pad = 0,
+			},
+			.link[3] = {
+				.remote_id =  &isd_id[isd_ic_pp1],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_ic_pp0] = {
+		.id = &isd_id[isd_ic_pp0],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 2,
+			.link[0] = {
+				.remote_id = &isd_id[isd_camif0],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id = &isd_id[isd_camif1],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_ic_pp1] = {
+		.id = &isd_id[isd_ic_pp1],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.num_links = 2,
+			.link[0] = {
+				.remote_id = &isd_id[isd_camif0],
+				.remote_pad = 0,
+			},
+			.link[1] = {
+				.remote_id = &isd_id[isd_camif1],
+				.remote_pad = 0,
+			},
+		},
+	},
+
+	[isd_camif0] = {
+		.id = &isd_id[isd_camif0],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.devnode = true,
+		},
+	},
+
+	[isd_camif1] = {
+		.id = &isd_id[isd_camif1],
+		.num_sink_pads = 1,
+		.num_src_pads = 1,
+		.pad[1] = {
+			.devnode = true,
+		},
+	},
+};
+
+/* form a device name given a group id and ipu id */
+static inline void isd_id_to_devname(char *devname, int sz,
+				     const struct internal_subdev_id *id,
+				     int ipu_id)
+{
+	int pdev_id = ipu_id * num_isd + id->index;
+
+	snprintf(devname, sz, "%s.%d", id->name, pdev_id);
+}
+
+/* adds the links from given internal subdev */
+static int add_internal_links(struct imx_media_dev *imxmd,
+			      const struct internal_subdev *isd,
+			      struct imx_media_subdev *imxsd,
+			      int ipu_id)
+{
+	int i, num_pads, ret;
+
+	num_pads = isd->num_sink_pads + isd->num_src_pads;
+
+	for (i = 0; i < num_pads; i++) {
+		const struct internal_pad *intpad = &isd->pad[i];
+		struct imx_media_pad *pad = &imxsd->pad[i];
+		int j;
+
+		/* init the pad flags for this internal subdev */
+		pad->pad.flags = (i < isd->num_sink_pads) ?
+			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
+		/* export devnode pad flag to the subdevs */
+		pad->devnode = intpad->devnode;
+
+		for (j = 0; j < intpad->num_links; j++) {
+			const struct internal_link *link;
+			char remote_devname[32];
+
+			link = &intpad->link[j];
+
+			if (link->remote_id->grp_id == 0)
+				continue;
+
+			isd_id_to_devname(remote_devname,
+					  sizeof(remote_devname),
+					  link->remote_id, ipu_id);
+
+			ret = imx_media_add_pad_link(imxmd, pad,
+						     NULL, remote_devname,
+						     i, link->remote_pad);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+/* register an internal subdev as a platform device */
+static struct imx_media_subdev *
+add_internal_subdev(struct imx_media_dev *imxmd,
+		    const struct internal_subdev *isd,
+		    int ipu_id)
+{
+	struct imx_media_internal_sd_platformdata pdata;
+	struct platform_device_info pdevinfo = {0};
+	struct imx_media_subdev *imxsd;
+	struct platform_device *pdev;
+
+	switch (isd->id->grp_id) {
+	case IMX_MEDIA_GRP_ID_CAMIF0...IMX_MEDIA_GRP_ID_CAMIF1:
+		pdata.grp_id = isd->id->grp_id +
+			((2 * ipu_id) << IMX_MEDIA_GRP_ID_CAMIF_BIT);
+		break;
+	default:
+		pdata.grp_id = isd->id->grp_id;
+		break;
+	}
+
+	/* the id of IPU this subdev will control */
+	pdata.ipu_id = ipu_id;
+
+	/* create subdev name */
+	imx_media_grp_id_to_sd_name(pdata.sd_name, sizeof(pdata.sd_name),
+				    pdata.grp_id, ipu_id);
+
+	pdevinfo.name = isd->id->name;
+	pdevinfo.id = ipu_id * num_isd + isd->id->index;
+	pdevinfo.parent = imxmd->dev;
+	pdevinfo.data = &pdata;
+	pdevinfo.size_data = sizeof(pdata);
+	pdevinfo.dma_mask = DMA_BIT_MASK(32);
+
+	pdev = platform_device_register_full(&pdevinfo);
+	if (IS_ERR(pdev))
+		return ERR_CAST(pdev);
+
+	imxsd = imx_media_add_async_subdev(imxmd, NULL, dev_name(&pdev->dev));
+	if (IS_ERR(imxsd))
+		return imxsd;
+
+	imxsd->num_sink_pads = isd->num_sink_pads;
+	imxsd->num_src_pads = isd->num_src_pads;
+
+	return imxsd;
+}
+
+/* adds the internal subdevs in one ipu */
+static int add_ipu_internal_subdevs(struct imx_media_dev *imxmd,
+				    struct imx_media_subdev *csi0,
+				    struct imx_media_subdev *csi1,
+				    int ipu_id)
+{
+	enum isd_enum i;
+	int ret;
+
+	for (i = 0; i < num_isd; i++) {
+		const struct internal_subdev *isd = &internal_subdev[i];
+		struct imx_media_subdev *imxsd;
+
+		/*
+		 * the CSIs are represented in the device-tree, so those
+		 * devices are added already, and are added to the async
+		 * subdev list by of_parse_subdev(), so we are given those
+		 * subdevs as csi0 and csi1.
+		 */
+		switch (isd->id->grp_id) {
+		case IMX_MEDIA_GRP_ID_CSI0:
+			imxsd = csi0;
+			break;
+		case IMX_MEDIA_GRP_ID_CSI1:
+			imxsd = csi1;
+			break;
+		default:
+			imxsd = add_internal_subdev(imxmd, isd, ipu_id);
+			break;
+		}
+
+		if (IS_ERR(imxsd))
+			return PTR_ERR(imxsd);
+
+		/* add the links from this subdev */
+		if (imxsd) {
+			ret = add_internal_links(imxmd, isd, imxsd, ipu_id);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
+				   struct imx_media_subdev *csi[4])
+{
+	int ret;
+
+	/* there must be at least one CSI in first IPU */
+	if (!(csi[0] || csi[1]))
+		return -EINVAL;
+
+	ret = add_ipu_internal_subdevs(imxmd, csi[0], csi[1], 0);
+	if (ret)
+		return ret;
+
+	if (csi[2] || csi[3])
+		ret = add_ipu_internal_subdevs(imxmd, csi[2], csi[3], 1);
+
+	return ret;
+}
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
new file mode 100644
index 0000000..a939c34
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -0,0 +1,289 @@
+/*
+ * Media driver for Freescale i.MX5/6 SOC
+ *
+ * Open Firmware parsing.
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/of_platform.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-dma-contig.h>
+#include <video/imx-ipu-v3.h>
+#include "imx-media.h"
+
+static int of_add_pad_link(struct imx_media_dev *imxmd,
+			   struct imx_media_pad *pad,
+			   struct device_node *local_sd_node,
+			   struct device_node *remote_sd_node,
+			   int local_pad, int remote_pad)
+{
+	dev_dbg(imxmd->dev, "%s: adding %s:%d -> %s:%d\n", __func__,
+		local_sd_node->name, local_pad,
+		remote_sd_node->name, remote_pad);
+
+	return imx_media_add_pad_link(imxmd, pad, remote_sd_node, NULL,
+				      local_pad, remote_pad);
+}
+
+/* parse inputs property from a sensor node */
+static void of_parse_sensor_inputs(struct imx_media_dev *imxmd,
+				   struct imx_media_subdev *sensor,
+				   struct device_node *sensor_np)
+{
+	struct imx_media_sensor_input *sinput = &sensor->input;
+	int ret, i;
+
+	for (i = 0; i < IMX_MEDIA_MAX_SENSOR_INPUTS; i++) {
+		const char *input_name;
+		u32 val;
+
+		ret = of_property_read_u32_index(sensor_np, "inputs", i, &val);
+		if (ret)
+			break;
+
+		sinput->value[i] = val;
+
+		ret = of_property_read_string_index(sensor_np, "input-names",
+						    i, &input_name);
+		/*
+		 * if input-names not provided, they will be set using
+		 * the subdev name once the sensor is known during
+		 * async bind
+		 */
+		if (!ret)
+			strncpy(sinput->name[i], input_name,
+				sizeof(sinput->name[i]));
+	}
+
+	sinput->num = i;
+
+	/* if no inputs provided just assume a single input */
+	if (sinput->num == 0)
+		sinput->num = 1;
+}
+
+static void of_parse_sensor(struct imx_media_dev *imxmd,
+			    struct imx_media_subdev *sensor,
+			    struct device_node *sensor_np)
+{
+	struct device_node *endpoint;
+
+	of_parse_sensor_inputs(imxmd, sensor, sensor_np);
+
+	endpoint = of_graph_get_next_endpoint(sensor_np, NULL);
+	if (endpoint) {
+		v4l2_of_parse_endpoint(endpoint, &sensor->sensor_ep);
+		of_node_put(endpoint);
+	}
+}
+
+static int of_get_port_count(const struct device_node *np)
+{
+	struct device_node *child;
+	int num = 0;
+
+	/* if this node is itself a port, return 1 */
+	if (of_node_cmp(np->name, "port") == 0)
+		return 1;
+
+	for_each_child_of_node(np, child)
+		if (of_node_cmp(child->name, "port") == 0)
+			num++;
+
+	return num;
+}
+
+/*
+ * find the remote device node and remote port id (remote pad #)
+ * given local endpoint node
+ */
+static void of_get_remote_pad(struct device_node *epnode,
+			      struct device_node **remote_node,
+			      int *remote_pad)
+{
+	struct device_node *rp, *rpp;
+	struct device_node *remote;
+
+	rp = of_graph_get_remote_port(epnode);
+	rpp = of_graph_get_remote_port_parent(epnode);
+
+	if (of_device_is_compatible(rpp, "fsl,imx6q-ipu")) {
+		/* the remote is one of the CSI ports */
+		remote = rp;
+		*remote_pad = 0;
+		of_node_put(rpp);
+	} else {
+		remote = rpp;
+		of_property_read_u32(rp, "reg", remote_pad);
+		of_node_put(rp);
+	}
+
+	if (!remote || !of_device_is_available(remote)) {
+		of_node_put(remote);
+		*remote_node = NULL;
+	} else {
+		*remote_node = remote;
+	}
+}
+
+static struct imx_media_subdev *
+of_parse_subdev(struct imx_media_dev *imxmd, struct device_node *sd_np,
+		bool is_csi_port)
+{
+	struct imx_media_subdev *imxsd;
+	int i, num_pads, ret;
+
+	if (!of_device_is_available(sd_np)) {
+		dev_dbg(imxmd->dev, "%s: %s not enabled\n", __func__,
+			sd_np->name);
+		return NULL;
+	}
+
+	/* register this subdev with async notifier */
+	imxsd = imx_media_add_async_subdev(imxmd, sd_np, NULL);
+	if (IS_ERR_OR_NULL(imxsd))
+		return imxsd;
+
+	if (is_csi_port) {
+		/*
+		 * the ipu-csi has one sink port and one source port.
+		 * The source port is not represented in the device tree,
+		 * but is described by the internal pads and links later.
+		 */
+		num_pads = 2;
+		imxsd->num_sink_pads = 1;
+	} else if (of_device_is_compatible(sd_np, "fsl,imx6-mipi-csi2")) {
+		num_pads = of_get_port_count(sd_np);
+		/* the mipi csi2 receiver has only one sink port */
+		imxsd->num_sink_pads = 1;
+	} else if (of_device_is_compatible(sd_np, "video-multiplexer")) {
+		num_pads = of_get_port_count(sd_np);
+		/* for the video mux, all but the last port are sinks */
+		imxsd->num_sink_pads = num_pads - 1;
+	} else {
+		/* must be a sensor */
+		num_pads = 1;
+		imxsd->num_sink_pads = 0;
+	}
+
+	if (imxsd->num_sink_pads >= num_pads)
+		return ERR_PTR(-EINVAL);
+
+	imxsd->num_src_pads = num_pads - imxsd->num_sink_pads;
+
+	dev_dbg(imxmd->dev, "%s: %s has %d pads (%d sink, %d src)\n",
+		__func__, sd_np->name, num_pads,
+		imxsd->num_sink_pads, imxsd->num_src_pads);
+
+	if (imxsd->num_sink_pads == 0)
+		of_parse_sensor(imxmd, imxsd, sd_np);
+
+	for (i = 0; i < num_pads; i++) {
+		struct device_node *epnode = NULL, *port, *remote_np;
+		struct imx_media_subdev *remote_imxsd;
+		struct imx_media_pad *pad;
+		int remote_pad;
+
+		/* init this pad */
+		pad = &imxsd->pad[i];
+		pad->pad.flags = (i < imxsd->num_sink_pads) ?
+			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
+
+		if (is_csi_port)
+			port = (i < imxsd->num_sink_pads) ? sd_np : NULL;
+		else
+			port = of_graph_get_port_by_id(sd_np, i);
+		if (!port)
+			continue;
+
+		for_each_child_of_node(port, epnode) {
+			of_get_remote_pad(epnode, &remote_np, &remote_pad);
+			if (!remote_np)
+				continue;
+
+			ret = of_add_pad_link(imxmd, pad, sd_np, remote_np,
+					      i, remote_pad);
+			if (ret) {
+				imxsd = ERR_PTR(ret);
+				break;
+			}
+
+			if (i < imxsd->num_sink_pads) {
+				/* follow sink endpoints upstream */
+				remote_imxsd = of_parse_subdev(imxmd,
+							       remote_np,
+							       false);
+				if (IS_ERR(remote_imxsd)) {
+					imxsd = remote_imxsd;
+					break;
+				}
+			}
+
+			of_node_put(remote_np);
+		}
+
+		if (port != sd_np)
+			of_node_put(port);
+		if (IS_ERR(imxsd)) {
+			of_node_put(remote_np);
+			of_node_put(epnode);
+			break;
+		}
+	}
+
+	return imxsd;
+}
+
+int imx_media_of_parse(struct imx_media_dev *imxmd,
+		       struct imx_media_subdev *(*csi)[4],
+		       struct device_node *np)
+{
+	struct imx_media_subdev *lcsi;
+	struct device_node *csi_np;
+	u32 ipu_id, csi_id;
+	int i, ret;
+
+	for (i = 0; ; i++) {
+		csi_np = of_parse_phandle(np, "ports", i);
+		if (!csi_np)
+			break;
+
+		lcsi = of_parse_subdev(imxmd, csi_np, true);
+		if (IS_ERR(lcsi)) {
+			ret = PTR_ERR(lcsi);
+			goto err_put;
+		}
+
+		ret = of_property_read_u32(csi_np, "reg", &csi_id);
+		if (ret) {
+			dev_err(imxmd->dev,
+				"%s: csi port missing reg property!\n",
+				__func__);
+			goto err_put;
+		}
+
+		ipu_id = of_alias_get_id(csi_np->parent, "ipu");
+		of_node_put(csi_np);
+
+		if (ipu_id > 1 || csi_id > 1) {
+			dev_err(imxmd->dev, "%s: invalid ipu/csi id (%u/%u)\n",
+				__func__, ipu_id, csi_id);
+			return -EINVAL;
+		}
+
+		(*csi)[ipu_id * 2 + csi_id] = lcsi;
+	}
+
+	return 0;
+err_put:
+	of_node_put(csi_np);
+	return ret;
+}
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
new file mode 100644
index 0000000..dbb2d8a
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media.h
@@ -0,0 +1,310 @@
+/*
+ * V4L2 Media Controller Driver for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _IMX_MEDIA_H
+#define _IMX_MEDIA_H
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-dma-contig.h>
+#include <video/imx-ipu-v3.h>
+
+/*
+ * This is somewhat arbitrary, but we need at least:
+ * - 2 camera interface subdevs
+ * - 3 IC subdevs
+ * - 2 CSI subdevs
+ * - 1 mipi-csi2 receiver subdev
+ * - 2 video-mux subdevs
+ * - 3 camera sensor subdevs (2 parallel, 1 mipi-csi2)
+ *
+ * And double the above numbers for quad i.mx!
+ */
+#define IMX_MEDIA_MAX_SUBDEVS       48
+/* max pads per subdev */
+#define IMX_MEDIA_MAX_PADS          16
+/* max links per pad */
+#define IMX_MEDIA_MAX_LINKS          8
+
+/* How long to wait for EOF interrupts in the buffer-capture subdevs */
+#define IMX_MEDIA_EOF_TIMEOUT       1000
+
+/* A sensor's inputs parsed from a sensor node */
+#define IMX_MEDIA_MAX_SENSOR_INPUTS 16
+struct imx_media_sensor_input {
+	/* number of inputs */
+	int num;
+	/* input values passed to s_routing */
+	u32 value[IMX_MEDIA_MAX_SENSOR_INPUTS];
+	/* input names */
+	char name[IMX_MEDIA_MAX_SENSOR_INPUTS][32];
+};
+
+struct imx_media_pixfmt {
+	u32     fourcc;
+	u32     codes[4];
+	int     bpp;     /* total bpp */
+	enum ipu_color_space cs;
+	bool    planar;  /* is a planar format */
+};
+
+struct imx_media_buffer {
+	struct vb2_v4l2_buffer vbuf; /* v4l buffer must be first */
+	struct list_head  list;
+};
+
+static inline struct imx_media_buffer *to_imx_media_vb(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	return container_of(vbuf, struct imx_media_buffer, vbuf);
+}
+
+struct imx_media_link {
+	struct device_node *remote_sd_node;
+	char               remote_devname[32];
+	int                local_pad;
+	int                remote_pad;
+};
+
+struct imx_media_pad {
+	struct media_pad  pad;
+	struct imx_media_link link[IMX_MEDIA_MAX_LINKS];
+	bool devnode; /* does this pad link to a device node */
+	int num_links;
+};
+
+struct imx_media_internal_sd_platformdata {
+	char sd_name[V4L2_SUBDEV_NAME_SIZE];
+	u32 grp_id;
+	int ipu_id;
+};
+
+struct imx_media_subdev {
+	struct v4l2_async_subdev asd;
+	struct v4l2_subdev       *sd; /* set when bound */
+
+	struct imx_media_pad     pad[IMX_MEDIA_MAX_PADS];
+	int num_sink_pads;
+	int num_src_pads;
+
+	/* the devname is needed for async devname match */
+	char devname[32];
+
+	/* if this is a sensor */
+	struct imx_media_sensor_input input;
+	struct v4l2_of_endpoint sensor_ep;
+};
+
+struct imx_media_dev {
+	struct media_device md;
+	struct v4l2_device  v4l2_dev;
+	struct device *dev;
+
+	/* master subdev list */
+	struct imx_media_subdev subdev[IMX_MEDIA_MAX_SUBDEVS];
+	int num_subdevs;
+
+	/* IPUs this media driver control, valid after subdevs bound */
+	struct ipu_soc *ipu[2];
+
+	/* used during link_notify */
+	struct media_entity_graph link_notify_graph;
+
+	/* for async subdev registration */
+	struct v4l2_async_subdev *async_ptrs[IMX_MEDIA_MAX_SUBDEVS];
+	struct v4l2_async_notifier subdev_notifier;
+};
+
+const struct imx_media_pixfmt *imx_media_find_format(u32 fourcc, u32 code,
+						     bool allow_rgb,
+						     bool allow_planar);
+int imx_media_enum_format(u32 *code, u32 index,
+			  bool allow_rgb, bool allow_planar);
+
+int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
+			    u32 width, u32 height, u32 code, u32 field,
+			    const struct imx_media_pixfmt **cc);
+
+int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *fmt,
+				  struct v4l2_mbus_framefmt *mbus);
+int imx_media_mbus_fmt_to_ipu_image(struct ipu_image *image,
+				    struct v4l2_mbus_framefmt *mbus);
+int imx_media_ipu_image_to_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
+				    struct ipu_image *image);
+
+struct imx_media_subdev *
+imx_media_find_async_subdev(struct imx_media_dev *imxmd,
+			    struct device_node *np,
+			    const char *devname);
+struct imx_media_subdev *
+imx_media_add_async_subdev(struct imx_media_dev *imxmd,
+			   struct device_node *np,
+			   const char *devname);
+int imx_media_add_pad_link(struct imx_media_dev *imxmd,
+			   struct imx_media_pad *pad,
+			   struct device_node *remote_node,
+			   const char *remote_devname,
+			   int local_pad, int remote_pad);
+
+void imx_media_grp_id_to_sd_name(char *sd_name, int sz,
+				 u32 grp_id, int ipu_id);
+
+int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
+				   struct imx_media_subdev *csi[4]);
+
+struct imx_media_subdev *
+imx_media_find_subdev_by_sd(struct imx_media_dev *imxmd,
+			    struct v4l2_subdev *sd);
+struct imx_media_subdev *
+imx_media_find_subdev_by_id(struct imx_media_dev *imxmd,
+			    u32 grp_id);
+int imx_media_find_mipi_csi2_channel(struct imx_media_dev *imxmd,
+				     struct media_entity *start_entity);
+struct imx_media_subdev *
+imx_media_find_pipeline_subdev(struct imx_media_dev *imxmd,
+			       struct media_entity *start_entity,
+			       u32 grp_id);
+struct imx_media_subdev *
+__imx_media_find_sensor(struct imx_media_dev *imxmd,
+			struct media_entity *start_entity);
+struct imx_media_subdev *
+imx_media_find_sensor(struct imx_media_dev *imxmd,
+		      struct media_entity *start_entity);
+
+enum imx_media_dma_buf_status {
+	IMX_MEDIA_BUF_STATUS_PREPARED = 0,
+	IMX_MEDIA_BUF_STATUS_QUEUED,
+	IMX_MEDIA_BUF_STATUS_ACTIVE,
+	IMX_MEDIA_BUF_STATUS_DONE,
+	IMX_MEDIA_BUF_STATUS_ERROR,
+};
+
+struct imx_media_dma_buf_ring;
+
+struct imx_media_dma_buf {
+	/* owning ring if any */
+	struct imx_media_dma_buf_ring *ring;
+	/* if !NULL this is a vb2_buffer */
+	struct vb2_buffer *vb;
+	void          *virt;
+	dma_addr_t     phys;
+	unsigned long  len;
+	int            index;
+	unsigned long  seq;
+	/* buffer state */
+	enum imx_media_dma_buf_status state;
+	/* completion status */
+	enum imx_media_dma_buf_status status;
+};
+
+enum imx_media_priv_ioctl {
+	IMX_MEDIA_REQ_DMA_BUF_SINK_RING = 1, /* src requests ring from sink */
+	IMX_MEDIA_REQ_DMA_BUF_SRC_RING,  /* sink requests ring from src */
+	IMX_MEDIA_NEW_DMA_BUF,           /* src hands new buffer to sink */
+	IMX_MEDIA_REL_DMA_BUF_SINK_RING, /* src informs sink that its ring
+					    can be released */
+	IMX_MEDIA_REL_DMA_BUF_SRC_RING,  /* sink informs src that its ring
+					    can be released */
+};
+
+#define IMX_MEDIA_MIN_RING_BUFS 2
+/* prpvf needs at least 3 buffers */
+#define IMX_MEDIA_MIN_RING_BUFS_PRPVF 3
+#define IMX_MEDIA_MAX_RING_BUFS 8
+void imx_media_free_dma_buf(struct imx_media_dev *imxmd,
+			    struct imx_media_dma_buf *buf);
+int imx_media_alloc_dma_buf(struct imx_media_dev *imxmd,
+			    struct imx_media_dma_buf *buf,
+			    int size);
+void imx_media_free_dma_buf_ring(struct imx_media_dma_buf_ring *ring);
+struct imx_media_dma_buf_ring *
+imx_media_alloc_dma_buf_ring(struct imx_media_dev *imxmd,
+			     struct media_entity *src,
+			     struct media_entity *sink,
+			     int size, int num_bufs,
+			     bool alloc_bufs);
+int imx_media_dma_buf_queue(struct imx_media_dma_buf_ring *ring, int index);
+int imx_media_dma_buf_queue_from_vb(struct imx_media_dma_buf_ring *ring,
+				    struct vb2_buffer *vb);
+void imx_media_dma_buf_done(struct imx_media_dma_buf *buf,
+			    enum imx_media_dma_buf_status status);
+struct imx_media_dma_buf *
+imx_media_dma_buf_dequeue(struct imx_media_dma_buf_ring *ring);
+struct imx_media_dma_buf *
+imx_media_dma_buf_get_active(struct imx_media_dma_buf_ring *ring);
+int imx_media_dma_buf_set_active(struct imx_media_dma_buf *buf);
+struct imx_media_dma_buf *
+imx_media_dma_buf_get_next_queued(struct imx_media_dma_buf_ring *ring);
+struct imx_media_dma_buf *
+imx_media_dma_buf_get(struct imx_media_dma_buf_ring *ring, int index);
+
+int imx_media_pipeline_set_power(struct imx_media_dev *imxmd,
+				 struct media_entity_graph *graph,
+				 struct media_entity *entity, bool on);
+int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
+				  struct media_entity *entity,
+				  struct media_pipeline *pipe,
+				  bool on);
+int imx_media_inherit_controls(struct imx_media_dev *imxmd,
+			       struct video_device *vfd,
+			       struct media_entity *start_entity);
+
+/* imx-media-fim.c */
+struct imx_media_fim;
+void imx_media_fim_eof_monitor(struct imx_media_fim *fim, struct timespec *ts);
+int imx_media_fim_set_power(struct imx_media_fim *fim, bool on);
+int imx_media_fim_set_stream(struct imx_media_fim *fim,
+			     struct imx_media_subdev *sensor,
+			     bool on);
+struct imx_media_fim *imx_media_fim_init(struct v4l2_subdev *sd);
+void imx_media_fim_free(struct imx_media_fim *fim);
+
+/* imx-media-of.c */
+struct imx_media_subdev *
+imx_media_of_find_subdev(struct imx_media_dev *imxmd,
+			 struct device_node *np,
+			 const char *name);
+int imx_media_of_parse(struct imx_media_dev *dev,
+		       struct imx_media_subdev *(*csi)[4],
+		       struct device_node *np);
+
+/* subdev group ids */
+#define IMX_MEDIA_GRP_ID_SENSOR    (1 << 8)
+#define IMX_MEDIA_GRP_ID_VIDMUX    (1 << 9)
+#define IMX_MEDIA_GRP_ID_CSI2      (1 << 10)
+#define IMX_MEDIA_GRP_ID_CSI_BIT   11
+#define IMX_MEDIA_GRP_ID_CSI       (0x3 << 11)
+#define IMX_MEDIA_GRP_ID_CSI0      (1 << 11)
+#define IMX_MEDIA_GRP_ID_CSI1      (2 << 11)
+#define IMX_MEDIA_GRP_ID_SMFC_BIT  13
+#define IMX_MEDIA_GRP_ID_SMFC      (0x7 << 13)
+#define IMX_MEDIA_GRP_ID_SMFC0     (1 << 13)
+#define IMX_MEDIA_GRP_ID_SMFC1     (2 << 13)
+#define IMX_MEDIA_GRP_ID_SMFC2     (3 << 13)
+#define IMX_MEDIA_GRP_ID_SMFC3     (4 << 13)
+#define IMX_MEDIA_GRP_ID_IC_PRPENC (1 << 16)
+#define IMX_MEDIA_GRP_ID_IC_PRPVF  (1 << 17)
+#define IMX_MEDIA_GRP_ID_IC_PP_BIT 18
+#define IMX_MEDIA_GRP_ID_IC_PP     (0x7 << 18)
+#define IMX_MEDIA_GRP_ID_IC_PP0    (1 << 18)
+#define IMX_MEDIA_GRP_ID_IC_PP1    (2 << 18)
+#define IMX_MEDIA_GRP_ID_IC_PP2    (3 << 18)
+#define IMX_MEDIA_GRP_ID_IC_PP3    (4 << 18)
+#define IMX_MEDIA_GRP_ID_CAMIF_BIT 21
+#define IMX_MEDIA_GRP_ID_CAMIF     (0x7 << 21)
+#define IMX_MEDIA_GRP_ID_CAMIF0    (1 << 21)
+#define IMX_MEDIA_GRP_ID_CAMIF1    (2 << 21)
+#define IMX_MEDIA_GRP_ID_CAMIF2    (3 << 21)
+#define IMX_MEDIA_GRP_ID_CAMIF3    (4 << 21)
+
+#endif
diff --git a/include/media/imx.h b/include/media/imx.h
new file mode 100644
index 0000000..5025a72
--- /dev/null
+++ b/include/media/imx.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (c) 2014-2015 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef __MEDIA_IMX_H__
+#define __MEDIA_IMX_H__
+
+#include <uapi/media/imx.h>
+
+#endif
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 0d2e1e0..6c29f42 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -180,6 +180,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
 
+/* The base for the imx driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_IMX_BASE			(V4L2_CID_USER_BASE + 0x1090)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
-- 
2.7.4

