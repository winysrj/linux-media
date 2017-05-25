Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34105 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423165AbdEYAa5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 20:30:57 -0400
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
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v7 20/34] media: Add i.MX media core driver
Date: Wed, 24 May 2017 17:29:35 -0700
Message-Id: <1495672189-29164-21-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the core media driver for i.MX SOC.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Add the bayer formats to imx-media's list of supported pixel and bus
formats.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/media/v4l-drivers/imx.rst           | 590 +++++++++++++++
 drivers/staging/media/Kconfig                     |   2 +
 drivers/staging/media/Makefile                    |   1 +
 drivers/staging/media/imx/Kconfig                 |   6 +
 drivers/staging/media/imx/Makefile                |   5 +
 drivers/staging/media/imx/TODO                    |  15 +
 drivers/staging/media/imx/imx-media-dev.c         | 665 +++++++++++++++++
 drivers/staging/media/imx/imx-media-fim.c         | 463 ++++++++++++
 drivers/staging/media/imx/imx-media-internal-sd.c | 349 +++++++++
 drivers/staging/media/imx/imx-media-of.c          | 268 +++++++
 drivers/staging/media/imx/imx-media-utils.c       | 834 ++++++++++++++++++++++
 drivers/staging/media/imx/imx-media.h             | 324 +++++++++
 include/media/imx.h                               |  15 +
 include/uapi/linux/v4l2-controls.h                |   4 +
 14 files changed, 3541 insertions(+)
 create mode 100644 Documentation/media/v4l-drivers/imx.rst
 create mode 100644 drivers/staging/media/imx/Kconfig
 create mode 100644 drivers/staging/media/imx/Makefile
 create mode 100644 drivers/staging/media/imx/TODO
 create mode 100644 drivers/staging/media/imx/imx-media-dev.c
 create mode 100644 drivers/staging/media/imx/imx-media-fim.c
 create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
 create mode 100644 drivers/staging/media/imx/imx-media-of.c
 create mode 100644 drivers/staging/media/imx/imx-media-utils.c
 create mode 100644 drivers/staging/media/imx/imx-media.h
 create mode 100644 include/media/imx.h

diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
new file mode 100644
index 0000000..b8796e4
--- /dev/null
+++ b/Documentation/media/v4l-drivers/imx.rst
@@ -0,0 +1,590 @@
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
+- Video De-Interlacing or Combining Block (VDIC)
+
+The IDMAC is the DMA controller for transfer of image frames to and from
+memory. Various dedicated DMA channels exist for both video capture and
+display paths. During transfer, the IDMAC is also capable of vertical
+image flip, 8x8 block transfer (see IRT description), pixel component
+re-ordering (for example UYVY to YUYV) within the same colorspace, and
+even packed <--> planar conversion. It can also perform a simple
+de-interlacing by interleaving even and odd lines during transfer
+(without motion compensation which requires the VDIC).
+
+The CSI is the backend capture unit that interfaces directly with
+camera sensors over Parallel, BT.656/1120, and MIPI CSI-2 busses.
+
+The IC handles color-space conversion, resizing (downscaling and
+upscaling), horizontal flip, and 90/270 degree rotation operations.
+
+There are three independent "tasks" within the IC that can carry out
+conversions concurrently: pre-process encoding, pre-process viewfinder,
+and post-processing. Within each task, conversions are split into three
+sections: downsizing section, main section (upsizing, flip, colorspace
+conversion, and graphics plane combining), and rotation section.
+
+The IPU time-shares the IC task operations. The time-slice granularity
+is one burst of eight pixels in the downsizing section, one image line
+in the main processing section, one image frame in the rotation section.
+
+The SMFC is composed of four independent FIFOs that each can transfer
+captured frames from sensors directly to memory concurrently via four
+IDMAC channels.
+
+The IRT carries out 90 and 270 degree image rotation operations. The
+rotation operation is carried out on 8x8 pixel blocks at a time. This
+operation is supported by the IDMAC which handles the 8x8 block transfer
+along with block reordering, in coordination with vertical flip.
+
+The VDIC handles the conversion of interlaced video to progressive, with
+support for different motion compensation modes (low, medium, and high
+motion). The deinterlaced output frames from the VDIC can be sent to the
+IC pre-process viewfinder task for further conversions. The VDIC also
+contains a Combiner that combines two image planes, with alpha blending
+and color keying.
+
+In addition to the IPU internal subunits, there are also two units
+outside the IPU that are also involved in video capture on i.MX:
+
+- MIPI CSI-2 Receiver for camera sensors with the MIPI CSI-2 bus
+  interface. This is a Synopsys DesignWare core.
+- Two video multiplexers for selecting among multiple sensor inputs
+  to send to a CSI.
+
+For more info, refer to the latest versions of the i.MX5/6 reference
+manuals [#f1]_ and [#f2]_.
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
+- Concurrent independent streams, by configuring pipelines to multiple
+  video capture interfaces using independent entities.
+
+- Scaling, color-space conversion, horizontal and vertical flip, and
+  image rotation via IC task subdevs.
+
+- Many pixel formats supported (RGB, packed and planar YUV, partial
+  planar YUV).
+
+- The VDIC subdev supports motion compensated de-interlacing, with three
+  motion compensation modes: low, medium, and high motion. Pipelines are
+  defined that allow sending frames to the VDIC subdev directly from the
+  CSI. There is also support in the future for sending frames to the
+  VDIC from memory buffers via a output/mem2mem devices.
+
+- Includes a Frame Interval Monitor (FIM) that can correct vertical sync
+  problems with the ADV718x video decoders.
+
+
+Entities
+--------
+
+imx6-mipi-csi2
+--------------
+
+This is the MIPI CSI-2 receiver entity. It has one sink pad to receive
+the MIPI CSI-2 stream (usually from a MIPI CSI-2 camera sensor). It has
+four source pads, corresponding to the four MIPI CSI-2 demuxed virtual
+channel outputs. Multpiple source pads can be enabled to independently
+stream from multiple virtual channels.
+
+This entity actually consists of two sub-blocks. One is the MIPI CSI-2
+core. This is a Synopsys Designware MIPI CSI-2 core. The other sub-block
+is a "CSI-2 to IPU gasket". The gasket acts as a demultiplexer of the
+four virtual channels streams, providing four separate parallel buses
+containing each virtual channel that are routed to CSIs or video
+multiplexers as described below.
+
+On i.MX6 solo/dual-lite, all four virtual channel buses are routed to
+two video multiplexers. Both CSI0 and CSI1 can receive any virtual
+channel, as selected by the video multiplexers.
+
+On i.MX6 Quad, virtual channel 0 is routed to IPU1-CSI0 (after selected
+by a video mux), virtual channels 1 and 2 are hard-wired to IPU1-CSI1
+and IPU2-CSI0, respectively, and virtual channel 3 is routed to
+IPU2-CSI1 (again selected by a video mux).
+
+ipuX_csiY_mux
+-------------
+
+These are the video multiplexers. They have two or more sink pads to
+select from either camera sensors with a parallel interface, or from
+MIPI CSI-2 virtual channels from imx6-mipi-csi2 entity. They have a
+single source pad that routes to a CSI (ipuX_csiY entities).
+
+On i.MX6 solo/dual-lite, there are two video mux entities. One sits
+in front of IPU1-CSI0 to select between a parallel sensor and any of
+the four MIPI CSI-2 virtual channels (a total of five sink pads). The
+other mux sits in front of IPU1-CSI1, and again has five sink pads to
+select between a parallel sensor and any of the four MIPI CSI-2 virtual
+channels.
+
+On i.MX6 Quad, there are two video mux entities. One sits in front of
+IPU1-CSI0 to select between a parallel sensor and MIPI CSI-2 virtual
+channel 0 (two sink pads). The other mux sits in front of IPU2-CSI1 to
+select between a parallel sensor and MIPI CSI-2 virtual channel 3 (two
+sink pads).
+
+ipuX_csiY
+---------
+
+These are the CSI entities. They have a single sink pad receiving from
+either a video mux or from a MIPI CSI-2 virtual channel as described
+above.
+
+This entity has two source pads. The first source pad can link directly
+to the ipuX_vdic entity or the ipuX_ic_prp entity, using hardware links
+that require no IDMAC memory buffer transfer.
+
+When the direct source pad is routed to the ipuX_ic_prp entity, frames
+from the CSI can be processed by one or both of the IC pre-processing
+tasks.
+
+When the direct source pad is routed to the ipuX_vdic entity, the VDIC
+will carry out motion-compensated de-interlace using "high motion" mode
+(see description of ipuX_vdic entity).
+
+The second source pad sends video frames directly to memory buffers
+via the SMFC and an IDMAC channel, bypassing IC pre-processing. This
+source pad is routed to a capture device node, with a node name of the
+format "ipuX_csiY capture".
+
+Note that since the IDMAC source pad makes use of an IDMAC channel, it
+can do pixel reordering within the same colorspace. For example, the
+sink pad can take UYVY2X8, but the IDMAC source pad can output YUYV2X8.
+If the sink pad is receiving YUV, the output at the capture device can
+also be converted to a planar YUV format such as YUV420.
+
+It will also perform simple de-interlace without motion compensation,
+which is activated if the sink pad's field type is an interlaced type,
+and the IDMAC source pad field type is set to none.
+
+This subdev can generate the following event when enabling the second
+IDMAC source pad:
+
+- V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR
+
+The user application can subscribe to this event from the ipuX_csiY
+subdev node. This event is generated by the Frame Interval Monitor
+(see below for more on the FIM).
+
+Cropping in ipuX_csiY
+---------------------
+
+The CSI supports cropping the incoming raw sensor frames. This is
+implemented in the ipuX_csiY entities at the sink pad, using the
+crop selection subdev API.
+
+The CSI also supports fixed divide-by-two downscaling indepently in
+width and height. This is implemented in the ipuX_csiY entities at
+the sink pad, using the compose selection subdev API.
+
+The output rectangle at the ipuX_csiY source pad is the same as
+the compose rectangle at the sink pad. So the source pad rectangle
+cannot be negotiated, it must be set using the compose selection
+API at sink pad (if /w downscale is desired, otherwise source pad
+rectangle is equal to incoming rectangle).
+
+To give an example of crop and /2 downscale, this will crop a
+1280x960 input frame to 640x480, and then /2 downscale in both
+dimensions to 320x240 (assumes ipu1_csi0 is linked to ipu1_csi0_mux):
+
+media-ctl -V "'ipu1_csi0_mux':2[fmt:UYVY2X8/1280x960]"
+media-ctl -V "'ipu1_csi0':0[crop:(0,0)/640x480]"
+media-ctl -V "'ipu1_csi0':0[compose:(0,0)/320x240]"
+
+Frame Skipping in ipuX_csiY
+---------------------------
+
+The CSI supports frame rate decimation, via frame skipping. Frame
+rate decimation is specified by setting the frame intervals at
+sink and source pads. The ipuX_csiY entity then applies the best
+frame skip setting to the CSI to achieve the desired frame rate
+at the source pad.
+
+The following example reduces an assumed incoming 60 Hz frame
+rate by half at the IDMAC output source pad:
+
+media-ctl -V "'ipu1_csi0':0[fmt:UYVY2X8/640x480@1/60]"
+media-ctl -V "'ipu1_csi0':2[fmt:UYVY2X8/640x480@1/30]"
+
+Frame Interval Monitor in ipuX_csiY
+-----------------------------------
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
+bad frame interval, the ipuX_csiY subdev will send the event
+V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR. Userland can register with
+the FIM event notification on the ipuX_csiY subdev device node.
+Userland can issue a streaming restart when this event is received
+to correct the rolling/split image.
+
+The ipuX_csiY subdev includes custom controls to tweak some dials for
+FIM. If one of these controls is changed during streaming, the FIM will
+be reset and will continue at the new settings.
+
+- V4L2_CID_IMX_FIM_ENABLE
+
+Enable/disable the FIM.
+
+- V4L2_CID_IMX_FIM_NUM
+
+How many frame interval measurements to average before comparing against
+the nominal frame interval reported by the sensor. This can reduce noise
+caused by interrupt latency.
+
+- V4L2_CID_IMX_FIM_TOLERANCE_MIN
+
+If the averaged intervals fall outside nominal by this amount, in
+microseconds, the V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR event is sent.
+
+- V4L2_CID_IMX_FIM_TOLERANCE_MAX
+
+If any intervals are higher than this value, those samples are
+discarded and do not enter into the average. This can be used to
+discard really high interval errors that might be due to interrupt
+latency from high system load.
+
+- V4L2_CID_IMX_FIM_NUM_SKIP
+
+How many frames to skip after a FIM reset or stream restart before
+FIM begins to average intervals.
+
+ipuX_vdic
+---------
+
+The VDIC carries out motion compensated de-interlacing, with three
+motion compensation modes: low, medium, and high motion. The mode is
+specified with the menu control V4L2_CID_DEINTERLACING_MODE. It has
+two sink pads and a single source pad.
+
+The direct sink pad receives from an ipuX_csiY direct pad. With this
+link the VDIC can only operate in high motion mode.
+
+When the IDMAC sink pad is activated, it receives from an output
+or mem2mem device node. With this pipeline, it can also operate
+in low and medium modes, because these modes require receiving
+frames from memory buffers. Note that an output or mem2mem device
+is not implemented yet, so this sink pad currently has no links.
+
+The source pad routes to the IC pre-processing entity ipuX_ic_prp.
+
+ipuX_ic_prp
+-----------
+
+This is the IC pre-processing entity. It acts as a router, routing
+data from its sink pad to one or both of its source pads.
+
+It has a single sink pad. The sink pad can receive from the ipuX_csiY
+direct pad, or from ipuX_vdic.
+
+This entity has two source pads. One source pad routes to the
+pre-process encode task entity (ipuX_ic_prpenc), the other to the
+pre-process viewfinder task entity (ipuX_ic_prpvf). Both source pads
+can be activated at the same time if the sink pad is receiving from
+ipuX_csiY. Only the source pad to the pre-process viewfinder task entity
+can be activated if the sink pad is receiving from ipuX_vdic (frames
+from the VDIC can only be processed by the pre-process viewfinder task).
+
+ipuX_ic_prpenc
+--------------
+
+This is the IC pre-processing encode entity. It has a single sink
+pad from ipuX_ic_prp, and a single source pad. The source pad is
+routed to a capture device node, with a node name of the format
+"ipuX_ic_prpenc capture".
+
+This entity performs the IC pre-process encode task operations:
+color-space conversion, resizing (downscaling and upscaling),
+horizontal and vertical flip, and 90/270 degree rotation. Flip
+and rotation are provided via standard V4L2 controls.
+
+Like the ipuX_csiY IDMAC source, it can also perform simple de-interlace
+without motion compensation, and pixel reordering.
+
+ipuX_ic_prpvf
+-------------
+
+This is the IC pre-processing viewfinder entity. It has a single sink
+pad from ipuX_ic_prp, and a single source pad. The source pad is routed
+to a capture device node, with a node name of the format
+"ipuX_ic_prpvf capture".
+
+It is identical in operation to ipuX_ic_prpenc, with the same resizing
+and CSC operations and flip/rotation controls. It will receive and
+process de-interlaced frames from the ipuX_vdic if ipuX_ic_prp is
+receiving from ipuX_vdic.
+
+Like the ipuX_csiY IDMAC source, it can perform simple de-interlace
+without motion compensation. However, note that if the ipuX_vdic is
+included in the pipeline (ipuX_ic_prp is receiving from ipuX_vdic),
+it's not possible to use simple de-interlace in ipuX_ic_prpvf, since
+the ipuX_vdic has already carried out de-interlacing (with motion
+compensation) and therefore the field type output from ipuX_ic_prp can
+only be none.
+
+Capture Pipelines
+-----------------
+
+The following describe the various use-cases supported by the pipelines.
+
+The links shown do not include the backend sensor, video mux, or mipi
+csi-2 receiver links. This depends on the type of sensor interface
+(parallel or mipi csi-2). So these pipelines begin with:
+
+sensor -> ipuX_csiY_mux -> ...
+
+for parallel sensors, or:
+
+sensor -> imx6-mipi-csi2 -> (ipuX_csiY_mux) -> ...
+
+for mipi csi-2 sensors. The imx6-mipi-csi2 receiver may need to route
+to the video mux (ipuX_csiY_mux) before sending to the CSI, depending
+on the mipi csi-2 virtual channel, hence ipuX_csiY_mux is shown in
+parenthesis.
+
+Unprocessed Video Capture:
+--------------------------
+
+Send frames directly from sensor to camera device interface node, with
+no conversions, via ipuX_csiY IDMAC source pad:
+
+-> ipuX_csiY:2 -> ipuX_csiY capture
+
+IC Direct Conversions:
+----------------------
+
+This pipeline uses the preprocess encode entity to route frames directly
+from the CSI to the IC, to carry out scaling up to 1024x1024 resolution,
+CSC, flipping, and image rotation:
+
+-> ipuX_csiY:1 -> 0:ipuX_ic_prp:1 -> 0:ipuX_ic_prpenc:1 ->
+   ipuX_ic_prpenc capture
+
+Motion Compensated De-interlace:
+--------------------------------
+
+This pipeline routes frames from the CSI direct pad to the VDIC entity to
+support motion-compensated de-interlacing (high motion mode only),
+scaling up to 1024x1024, CSC, flip, and rotation:
+
+-> ipuX_csiY:1 -> 0:ipuX_vdic:2 -> 0:ipuX_ic_prp:2 ->
+   0:ipuX_ic_prpvf:1 -> ipuX_ic_prpvf capture
+
+
+Usage Notes
+-----------
+
+To aid in configuration and for backward compatibility with V4L2
+applications that access controls only from video device nodes, the
+capture device interfaces inherit controls from the active entities
+in the current pipeline, so controls can be accessed either directly
+from the subdev or from the active capture device interface. For
+example, the FIM controls are available either from the ipuX_csiY
+subdevs or from the active capture device.
+
+The following are specific usage notes for the Sabre* reference
+boards:
+
+
+SabreLite with OV5642 and OV5640
+--------------------------------
+
+This platform requires the OmniVision OV5642 module with a parallel
+camera interface, and the OV5640 module with a MIPI CSI-2
+interface. Both modules are available from Boundary Devices:
+
+https://boundarydevices.com/product/nit6x_5mp
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
+pipelines for both sensors. The OV5642 is routed to ipu1_csi0, and
+the OV5640, transmitting on MIPI CSI-2 virtual channel 1 (which is
+imx6-mipi-csi2 pad 2), is routed to ipu1_csi1. Both sensors are
+configured to output 640x480, and the OV5642 outputs YUYV2X8, the
+OV5640 UYVY2X8:
+
+.. code-block:: none
+
+   # Setup links for OV5642
+   media-ctl -l "'ov5642 1-0042':0 -> 'ipu1_csi0_mux':1[1]"
+   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
+   media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
+   # Setup links for OV5640
+   media-ctl -l "'ov5640 1-0040':0 -> 'imx6-mipi-csi2':0[1]"
+   media-ctl -l "'imx6-mipi-csi2':2 -> 'ipu1_csi1':0[1]"
+   media-ctl -l "'ipu1_csi1':2 -> 'ipu1_csi1 capture':0[1]"
+   # Configure pads for OV5642 pipeline
+   media-ctl -V "'ov5642 1-0042':0 [fmt:YUYV2X8/640x480 field:none]"
+   media-ctl -V "'ipu1_csi0_mux':2 [fmt:YUYV2X8/640x480 field:none]"
+   media-ctl -V "'ipu1_csi0':2 [fmt:AYUV32/640x480 field:none]"
+   # Configure pads for OV5640 pipeline
+   media-ctl -V "'ov5640 1-0040':0 [fmt:UYVY2X8/640x480 field:none]"
+   media-ctl -V "'imx6-mipi-csi2':2 [fmt:UYVY2X8/640x480 field:none]"
+   media-ctl -V "'ipu1_csi1':2 [fmt:AYUV32/640x480 field:none]"
+
+Streaming can then begin independently on the capture device nodes
+"ipu1_csi0 capture" and "ipu1_csi1 capture". The v4l2-ctl tool can
+be used to select any supported YUV pixelformat on the capture device
+nodes, including planar.
+
+SabreAuto with ADV7180 decoder
+------------------------------
+
+On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
+parallel bus input on the internal video mux to IPU1 CSI0.
+
+The following example configures a pipeline to capture from the ADV7180
+video decoder, assuming NTSC 720x480 input signals, with Motion
+Compensated de-interlacing. Pad field types assume the adv7180 outputs
+"interlaced". $outputfmt can be any format supported by the ipu1_ic_prpvf
+entity at its output pad:
+
+.. code-block:: none
+
+   # Setup links
+   media-ctl -l "'adv7180 3-0021':0 -> 'ipu1_csi0_mux':1[1]"
+   media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]"
+   media-ctl -l "'ipu1_csi0':1 -> 'ipu1_vdic':0[1]"
+   media-ctl -l "'ipu1_vdic':2 -> 'ipu1_ic_prp':0[1]"
+   media-ctl -l "'ipu1_ic_prp':2 -> 'ipu1_ic_prpvf':0[1]"
+   media-ctl -l "'ipu1_ic_prpvf':1 -> 'ipu1_ic_prpvf capture':0[1]"
+   # Configure pads
+   media-ctl -V "'adv7180 3-0021':0 [fmt:UYVY2X8/720x480]"
+   media-ctl -V "'ipu1_csi0_mux':2 [fmt:UYVY2X8/720x480 field:interlaced]"
+   media-ctl -V "'ipu1_csi0':1 [fmt:AYUV32/720x480 field:interlaced]"
+   media-ctl -V "'ipu1_vdic':2 [fmt:AYUV32/720x480 field:none]"
+   media-ctl -V "'ipu1_ic_prp':2 [fmt:AYUV32/720x480 field:none]"
+   media-ctl -V "'ipu1_ic_prpvf':1 [fmt:$outputfmt field:none]"
+
+Streaming can then begin on the capture device node at
+"ipu1_ic_prpvf capture". The v4l2-ctl tool can be used to select any
+supported YUV or RGB pixelformat on the capture device node.
+
+This platform accepts Composite Video analog inputs to the ADV7180 on
+Ain1 (connector J42).
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
+The following example configures a direct conversion pipeline to capture
+from the OV5640, transmitting on MIPI CSI-2 virtual channel 1. $sensorfmt
+can be any format supported by the OV5640. $sensordim is the frame
+dimension part of $sensorfmt (minus the mbus pixel code). $outputfmt can
+be any format supported by the ipu1_ic_prpenc entity at its output pad:
+
+.. code-block:: none
+
+   # Setup links
+   media-ctl -l "'ov5640 1-003c':0 -> 'imx6-mipi-csi2':0[1]"
+   media-ctl -l "'imx6-mipi-csi2':2 -> 'ipu1_csi1':0[1]"
+   media-ctl -l "'ipu1_csi1':1 -> 'ipu1_ic_prp':0[1]"
+   media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
+   media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
+   # Configure pads
+   media-ctl -V "'ov5640 1-003c':0 [fmt:$sensorfmt field:none]"
+   media-ctl -V "'imx6-mipi-csi2':2 [fmt:$sensorfmt field:none]"
+   media-ctl -V "'ipu1_csi1':1 [fmt:AYUV32/$sensordim field:none]"
+   media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/$sensordim field:none]"
+   media-ctl -V "'ipu1_ic_prpenc':1 [fmt:$outputfmt field:none]"
+
+Streaming can then begin on "ipu1_ic_prpenc capture" node. The v4l2-ctl
+tool can be used to select any supported YUV or RGB pixelformat on the
+capture device node.
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
+include/linux/imx-media.h
+
+References
+----------
+
+.. [#f1] http://www.nxp.com/assets/documents/data/en/reference-manuals/IMX6DQRM.pdf
+.. [#f2] http://www.nxp.com/assets/documents/data/en/reference-manuals/IMX6SDLRM.pdf
+
+
+Authors
+-------
+Steve Longerbeam <steve_longerbeam@mentor.com>
+Philipp Zabel <kernel@pengutronix.de>
+Russell King <linux@armlinux.org.uk>
+
+Copyright (C) 2012-2017 Mentor Graphics Inc.
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index dbda4d9..f8c25ee 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -27,6 +27,8 @@ source "drivers/staging/media/cxd2099/Kconfig"
 
 source "drivers/staging/media/davinci_vpfe/Kconfig"
 
+source "drivers/staging/media/imx/Kconfig"
+
 source "drivers/staging/media/omap4iss/Kconfig"
 
 # Keep LIRC at the end, as it has sub-menus
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index c04600c..ac090c5 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
+obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
new file mode 100644
index 0000000..62a3c34
--- /dev/null
+++ b/drivers/staging/media/imx/Kconfig
@@ -0,0 +1,6 @@
+config VIDEO_IMX_MEDIA
+	tristate "i.MX5/6 V4L2 media core driver"
+	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
+	---help---
+	  Say yes here to enable support for video4linux media controller
+	  driver for the i.MX5/6 SOC.
diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
new file mode 100644
index 0000000..ddd7d94
--- /dev/null
+++ b/drivers/staging/media/imx/Makefile
@@ -0,0 +1,5 @@
+imx-media-objs := imx-media-dev.o imx-media-internal-sd.o imx-media-of.o
+imx-media-common-objs := imx-media-utils.o imx-media-fim.o
+
+obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
+obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
new file mode 100644
index 0000000..360f4ba
--- /dev/null
+++ b/drivers/staging/media/imx/TODO
@@ -0,0 +1,15 @@
+
+- Clean up and move the ov5642 subdev driver to drivers/media/i2c, and
+  create the binding docs for it.
+
+- The Frame Interval Monitor could be exported to v4l2-core for
+  general use.
+
+- At driver load time, the device-tree node that is the original source
+  (the "sensor"), is parsed to record its media bus configuration, and
+  this info is required in imx-media-csi.c to setup the CSI.
+  Laurent Pinchart argues that instead the CSI subdev should call its
+  neighbor's g_mbus_config op (which should be propagated if necessary)
+  to get this info. However Hans Verkuil is planning to remove the
+  g_mbus_config op. For now this driver uses the parsed DT mbus config
+  method until this issue is resolved.
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
new file mode 100644
index 0000000..7d8a5df
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -0,0 +1,665 @@
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
+
+/*
+ * Adds a subdev to the async subdev list. If np is non-NULL, adds
+ * the async as a V4L2_ASYNC_MATCH_OF match type, otherwise as a
+ * V4L2_ASYNC_MATCH_DEVNAME match type using the dev_name of the
+ * given platform_device. This is called during driver load when
+ * forming the async subdev list.
+ */
+struct imx_media_subdev *
+imx_media_add_async_subdev(struct imx_media_dev *imxmd,
+			   struct device_node *np,
+			   struct platform_device *pdev)
+{
+	struct imx_media_subdev *imxsd;
+	struct v4l2_async_subdev *asd;
+	const char *devname = NULL;
+	int sd_idx;
+
+	mutex_lock(&imxmd->mutex);
+
+	if (pdev)
+		devname = dev_name(&pdev->dev);
+
+	/* return NULL if this subdev already added */
+	if (imx_media_find_async_subdev(imxmd, np, devname)) {
+		dev_dbg(imxmd->md.dev, "%s: already added %s\n",
+			__func__, np ? np->name : devname);
+		imxsd = NULL;
+		goto out;
+	}
+
+	sd_idx = imxmd->subdev_notifier.num_subdevs;
+	if (sd_idx >= IMX_MEDIA_MAX_SUBDEVS) {
+		dev_err(imxmd->md.dev, "%s: too many subdevs! can't add %s\n",
+			__func__, np ? np->name : devname);
+		imxsd = ERR_PTR(-ENOSPC);
+		goto out;
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
+		imxsd->pdev = pdev;
+	}
+
+	imxmd->async_ptrs[sd_idx] = asd;
+	imxmd->subdev_notifier.num_subdevs++;
+
+	dev_dbg(imxmd->md.dev, "%s: added %s, match type %s\n",
+		__func__, np ? np->name : devname, np ? "OF" : "DEVNAME");
+
+out:
+	mutex_unlock(&imxmd->mutex);
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
+	int link_idx, ret = 0;
+
+	mutex_lock(&imxmd->mutex);
+
+	link_idx = pad->num_links;
+	if (link_idx >= IMX_MEDIA_MAX_LINKS) {
+		dev_err(imxmd->md.dev, "%s: too many links!\n", __func__);
+		ret = -ENOSPC;
+		goto out;
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
+out:
+	mutex_unlock(&imxmd->mutex);
+	return ret;
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
+	int ret = 0;
+
+	mutex_lock(&imxmd->mutex);
+
+	imxsd = imx_media_find_async_subdev(imxmd, sd->of_node,
+					    dev_name(sd->dev));
+	if (!imxsd) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (sd->grp_id & IMX_MEDIA_GRP_ID_CSI) {
+		ret = imx_media_get_ipu(imxmd, sd);
+		if (ret)
+			goto out_unlock;
+	} else if (sd->entity.function == MEDIA_ENT_F_VID_MUX) {
+		/* this is a video mux */
+		sd->grp_id = IMX_MEDIA_GRP_ID_VIDMUX;
+	} else if (imxsd->num_sink_pads == 0) {
+		/*
+		 * this is an original source of video frames, it
+		 * could be a camera sensor, an analog decoder, or
+		 * a bridge device (HDMI -> MIPI CSI-2 for example).
+		 * This group ID is used to locate the entity that
+		 * is the original source of video in a pipeline.
+		 */
+		sd->grp_id = IMX_MEDIA_GRP_ID_SENSOR;
+	}
+
+	/* attach the subdev */
+	imxsd->sd = sd;
+out:
+	if (ret)
+		v4l2_warn(&imxmd->v4l2_dev,
+			  "Received unknown subdev %s\n", sd->name);
+	else
+		v4l2_info(&imxmd->v4l2_dev,
+			  "Registered subdev %s\n", sd->name);
+
+out_unlock:
+	mutex_unlock(&imxmd->mutex);
+	return ret;
+}
+
+/*
+ * Create a single source->sink media link given a subdev and a single
+ * link from one of its source pads. Called after all subdevs have
+ * registered.
+ */
+static int imx_media_create_link(struct imx_media_dev *imxmd,
+				 struct imx_media_subdev *src,
+				 struct imx_media_link *link)
+{
+	struct imx_media_subdev *sink;
+	u16 source_pad, sink_pad;
+	int ret;
+
+	sink = imx_media_find_async_subdev(imxmd, link->remote_sd_node,
+					   link->remote_devname);
+	if (!sink) {
+		v4l2_warn(&imxmd->v4l2_dev, "%s: no sink for %s:%d\n",
+			  __func__, src->sd->name, link->local_pad);
+		return 0;
+	}
+
+	source_pad = link->local_pad;
+	sink_pad = link->remote_pad;
+
+	v4l2_info(&imxmd->v4l2_dev, "%s: %s:%d -> %s:%d\n", __func__,
+		  src->sd->name, source_pad, sink->sd->name, sink_pad);
+
+	ret = media_create_pad_link(&src->sd->entity, source_pad,
+				    &sink->sd->entity, sink_pad, 0);
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
+	struct imx_media_subdev *imxsd;
+	struct imx_media_link *link;
+	struct imx_media_pad *pad;
+	int num_pads, i, j, k;
+	int ret = 0;
+
+	for (i = 0; i < imxmd->num_subdevs; i++) {
+		imxsd = &imxmd->subdev[i];
+		num_pads = imxsd->num_sink_pads + imxsd->num_src_pads;
+
+		for (j = 0; j < num_pads; j++) {
+			pad = &imxsd->pad[j];
+
+			/* only create the source->sink links */
+			if (!(pad->pad.flags & MEDIA_PAD_FL_SOURCE))
+				continue;
+
+			for (k = 0; k < pad->num_links; k++) {
+				link = &pad->link[k];
+
+				ret = imx_media_create_link(imxmd, imxsd, link);
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
+/*
+ * adds given video device to given imx-media source pad vdev list.
+ * Continues upstream from the pad entity's sink pads.
+ */
+static int imx_media_add_vdev_to_pad(struct imx_media_dev *imxmd,
+				     struct imx_media_video_dev *vdev,
+				     struct media_pad *srcpad)
+{
+	struct media_entity *entity = srcpad->entity;
+	struct imx_media_subdev *imxsd;
+	struct imx_media_pad *imxpad;
+	struct media_link *link;
+	struct v4l2_subdev *sd;
+	int i, vdev_idx, ret;
+
+	if (!is_media_entity_v4l2_subdev(entity))
+		return -EINVAL;
+
+	sd = media_entity_to_v4l2_subdev(entity);
+	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
+	if (IS_ERR(imxsd))
+		return PTR_ERR(imxsd);
+
+	imxpad = &imxsd->pad[srcpad->index];
+	vdev_idx = imxpad->num_vdevs;
+
+	/* just return if we've been here before */
+	for (i = 0; i < vdev_idx; i++)
+		if (vdev == imxpad->vdev[i])
+			return 0;
+
+	if (vdev_idx >= IMX_MEDIA_MAX_VDEVS) {
+		dev_err(imxmd->md.dev, "can't add %s to pad %s:%u\n",
+			vdev->vfd->entity.name, entity->name, srcpad->index);
+		return -ENOSPC;
+	}
+
+	dev_dbg(imxmd->md.dev, "adding %s to pad %s:%u\n",
+		vdev->vfd->entity.name, entity->name, srcpad->index);
+	imxpad->vdev[vdev_idx] = vdev;
+	imxpad->num_vdevs++;
+
+	/* move upstream from this entity's sink pads */
+	for (i = 0; i < entity->num_pads; i++) {
+		struct media_pad *pad = &entity->pads[i];
+
+		if (!(pad->flags & MEDIA_PAD_FL_SINK))
+			continue;
+
+		list_for_each_entry(link, &entity->links, list) {
+			if (link->sink != pad)
+				continue;
+			ret = imx_media_add_vdev_to_pad(imxmd, vdev,
+							link->source);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+/* form the vdev lists in all imx-media source pads */
+static int imx_media_create_pad_vdev_lists(struct imx_media_dev *imxmd)
+{
+	struct imx_media_video_dev *vdev;
+	struct media_link *link;
+	int i, ret;
+
+	for (i = 0; i < imxmd->num_vdevs; i++) {
+		vdev = imxmd->vdev[i];
+		link = list_first_entry(&vdev->vfd->entity.links,
+					struct media_link, list);
+		ret = imx_media_add_vdev_to_pad(imxmd, vdev, link->source);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/* async subdev complete notifier */
+static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
+{
+	struct imx_media_dev *imxmd = notifier2dev(notifier);
+	int i, ret;
+
+	mutex_lock(&imxmd->mutex);
+
+	/* make sure all subdevs were bound */
+	for (i = 0; i < imxmd->num_subdevs; i++) {
+		if (!imxmd->subdev[i].sd) {
+			v4l2_err(&imxmd->v4l2_dev, "unbound subdev!\n");
+			ret = -ENODEV;
+			goto unlock;
+		}
+	}
+
+	ret = imx_media_create_links(imxmd);
+	if (ret)
+		goto unlock;
+
+	ret = imx_media_create_pad_vdev_lists(imxmd);
+	if (ret)
+		goto unlock;
+
+	ret = v4l2_device_register_subdev_nodes(&imxmd->v4l2_dev);
+unlock:
+	mutex_unlock(&imxmd->mutex);
+	if (ret)
+		return ret;
+
+	return media_device_register(&imxmd->md);
+}
+
+/*
+ * adds controls to a video device from an entity subdevice.
+ * Continues upstream from the entity's sink pads.
+ */
+static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
+				      struct video_device *vfd,
+				      struct media_entity *entity)
+{
+	int i, ret = 0;
+
+	if (is_media_entity_v4l2_subdev(entity)) {
+		struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+
+		dev_dbg(imxmd->md.dev,
+			"adding controls to %s from %s\n",
+			vfd->entity.name, sd->entity.name);
+
+		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
+					    sd->ctrl_handler,
+					    NULL);
+		if (ret)
+			return ret;
+	}
+
+	/* move upstream */
+	for (i = 0; i < entity->num_pads; i++) {
+		struct media_pad *pad, *spad = &entity->pads[i];
+
+		if (!(spad->flags & MEDIA_PAD_FL_SINK))
+			continue;
+
+		pad = media_entity_remote_pad(spad);
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			continue;
+
+		ret = imx_media_inherit_controls(imxmd, vfd, pad->entity);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int imx_media_link_notify(struct media_link *link, u32 flags,
+				 unsigned int notification)
+{
+	struct media_entity *source = link->source->entity;
+	struct imx_media_subdev *imxsd;
+	struct imx_media_pad *imxpad;
+	struct imx_media_dev *imxmd;
+	struct video_device *vfd;
+	struct v4l2_subdev *sd;
+	int i, pad_idx, ret;
+
+	ret = v4l2_pipeline_link_notify(link, flags, notification);
+	if (ret)
+		return ret;
+
+	/* don't bother if source is not a subdev */
+	if (!is_media_entity_v4l2_subdev(source))
+		return 0;
+
+	sd = media_entity_to_v4l2_subdev(source);
+	pad_idx = link->source->index;
+
+	imxmd = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	imxsd = imx_media_find_subdev_by_sd(imxmd, sd);
+	if (IS_ERR(imxsd))
+		return PTR_ERR(imxsd);
+	imxpad = &imxsd->pad[pad_idx];
+
+	/*
+	 * Before disabling a link, reset controls for all video
+	 * devices reachable from this link.
+	 *
+	 * After enabling a link, refresh controls for all video
+	 * devices reachable from this link.
+	 */
+	if (notification == MEDIA_DEV_NOTIFY_PRE_LINK_CH &&
+	    !(flags & MEDIA_LNK_FL_ENABLED)) {
+		for (i = 0; i < imxpad->num_vdevs; i++) {
+			vfd = imxpad->vdev[i]->vfd;
+			dev_dbg(imxmd->md.dev,
+				"reset controls for %s\n",
+				vfd->entity.name);
+			v4l2_ctrl_handler_free(vfd->ctrl_handler);
+			v4l2_ctrl_handler_init(vfd->ctrl_handler, 0);
+		}
+	} else if (notification == MEDIA_DEV_NOTIFY_POST_LINK_CH &&
+		   (link->flags & MEDIA_LNK_FL_ENABLED)) {
+		for (i = 0; i < imxpad->num_vdevs; i++) {
+			vfd = imxpad->vdev[i]->vfd;
+			dev_dbg(imxmd->md.dev,
+				"refresh controls for %s\n",
+				vfd->entity.name);
+			ret = imx_media_inherit_controls(imxmd, vfd,
+							 &vfd->entity);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
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
+	struct imx_media_subdev *csi[4] = {0};
+	struct imx_media_dev *imxmd;
+	int ret;
+
+	imxmd = devm_kzalloc(dev, sizeof(*imxmd), GFP_KERNEL);
+	if (!imxmd)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, imxmd);
+
+	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
+	imxmd->md.ops = &imx_media_md_ops;
+	imxmd->md.dev = dev;
+
+	mutex_init(&imxmd->mutex);
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
+		goto cleanup;
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
+	/* no subdevs? just bail */
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
+		goto del_int;
+	}
+
+	return 0;
+
+del_int:
+	imx_media_remove_internal_subdevs(imxmd);
+unreg_dev:
+	v4l2_device_unregister(&imxmd->v4l2_dev);
+cleanup:
+	media_device_cleanup(&imxmd->md);
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
+	imx_media_remove_internal_subdevs(imxmd);
+	v4l2_device_unregister(&imxmd->v4l2_dev);
+	media_device_unregister(&imxmd->md);
+	media_device_cleanup(&imxmd->md);
+
+	return 0;
+}
+
+static const struct of_device_id imx_media_dt_ids[] = {
+	{ .compatible = "fsl,imx-capture-subsystem" },
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
index 0000000..95f7ec4
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-fim.c
@@ -0,0 +1,463 @@
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
+			       const struct v4l2_fract *fi)
+{
+	if (fi->denominator == 0) {
+		dev_dbg(fim->sd->dev, "no frame interval, FIM disabled\n");
+		fim->enabled = false;
+		return;
+	}
+
+	fim->nominal = DIV_ROUND_CLOSEST_ULL(1000000ULL * (u64)fi->numerator,
+					     fi->denominator);
+
+	dev_dbg(fim->sd->dev, "FI=%lu usec\n", fim->nominal);
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
+		.type = V4L2_EVENT_IMX_FRAME_INTERVAL_ERROR,
+	};
+
+	v4l2_subdev_notify_event(fim->sd, &ev);
+}
+
+/*
+ * Monitor an averaged frame interval. If the average deviates too much
+ * from the nominal frame rate, send the frame interval error event. The
+ * frame intervals are averaged in order to quiet noise from
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
+	if (!of_device_is_available(fim_np)) {
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
+void imx_media_fim_set_stream(struct imx_media_fim *fim,
+			      const struct v4l2_fract *fi,
+			      bool on)
+{
+	if (on) {
+		reset_fim(fim, true);
+		update_fim_nominal(fim, fi);
+
+		if (fim->icap_channel >= 0)
+			fim_acquire_first_ts(fim);
+	}
+}
+EXPORT_SYMBOL_GPL(imx_media_fim_set_stream);
+
+int imx_media_fim_add_controls(struct imx_media_fim *fim)
+{
+	/* add the FIM controls to the calling subdev ctrl handler */
+	return v4l2_ctrl_add_handler(fim->sd->ctrl_handler,
+				     &fim->ctrl_handler, NULL);
+}
+EXPORT_SYMBOL_GPL(imx_media_fim_add_controls);
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
index 0000000..cdfbf40
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-internal-sd.c
@@ -0,0 +1,349 @@
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
+	isd_vdic,
+	isd_ic_prp,
+	isd_ic_prpenc,
+	isd_ic_prpvf,
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
+	[isd_vdic] = {
+		.index = isd_vdic,
+		.grp_id = IMX_MEDIA_GRP_ID_VDIC,
+		.name = "imx-ipuv3-vdic",
+	},
+	[isd_ic_prp] = {
+		.index = isd_ic_prp,
+		.grp_id = IMX_MEDIA_GRP_ID_IC_PRP,
+		.name = "imx-ipuv3-ic",
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
+};
+
+struct internal_link {
+	const struct internal_subdev_id *remote_id;
+	int remote_pad;
+};
+
+struct internal_pad {
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
+		.num_sink_pads = CSI_NUM_SINK_PADS,
+		.num_src_pads = CSI_NUM_SRC_PADS,
+		.pad[CSI_SRC_PAD_DIRECT] = {
+			.link = {
+				{
+					.remote_id = &isd_id[isd_ic_prp],
+					.remote_pad = PRP_SINK_PAD,
+				}, {
+					.remote_id =  &isd_id[isd_vdic],
+					.remote_pad = VDIC_SINK_PAD_DIRECT,
+				},
+			},
+		},
+		.pad[CSI_SRC_PAD_IDMAC] = {
+			.devnode = true,
+		},
+	},
+
+	[isd_csi1] = {
+		.id = &isd_id[isd_csi1],
+		.num_sink_pads = CSI_NUM_SINK_PADS,
+		.num_src_pads = CSI_NUM_SRC_PADS,
+		.pad[CSI_SRC_PAD_DIRECT] = {
+			.link = {
+				{
+					.remote_id = &isd_id[isd_ic_prp],
+					.remote_pad = PRP_SINK_PAD,
+				}, {
+					.remote_id =  &isd_id[isd_vdic],
+					.remote_pad = VDIC_SINK_PAD_DIRECT,
+				},
+			},
+		},
+		.pad[CSI_SRC_PAD_IDMAC] = {
+			.devnode = true,
+		},
+	},
+
+	[isd_vdic] = {
+		.id = &isd_id[isd_vdic],
+		.num_sink_pads = VDIC_NUM_SINK_PADS,
+		.num_src_pads = VDIC_NUM_SRC_PADS,
+		.pad[VDIC_SINK_PAD_IDMAC] = {
+			.devnode = true,
+		},
+		.pad[VDIC_SRC_PAD_DIRECT] = {
+			.link = {
+				{
+					.remote_id =  &isd_id[isd_ic_prp],
+					.remote_pad = PRP_SINK_PAD,
+				},
+			},
+		},
+	},
+
+	[isd_ic_prp] = {
+		.id = &isd_id[isd_ic_prp],
+		.num_sink_pads = PRP_NUM_SINK_PADS,
+		.num_src_pads = PRP_NUM_SRC_PADS,
+		.pad[PRP_SRC_PAD_PRPENC] = {
+			.link = {
+				{
+					.remote_id = &isd_id[isd_ic_prpenc],
+					.remote_pad = 0,
+				},
+			},
+		},
+		.pad[PRP_SRC_PAD_PRPVF] = {
+			.link = {
+				{
+					.remote_id = &isd_id[isd_ic_prpvf],
+					.remote_pad = 0,
+				},
+			},
+		},
+	},
+
+	[isd_ic_prpenc] = {
+		.id = &isd_id[isd_ic_prpenc],
+		.num_sink_pads = PRPENCVF_NUM_SINK_PADS,
+		.num_src_pads = PRPENCVF_NUM_SRC_PADS,
+		.pad[PRPENCVF_SRC_PAD] = {
+			.devnode = true,
+		},
+	},
+
+	[isd_ic_prpvf] = {
+		.id = &isd_id[isd_ic_prpvf],
+		.num_sink_pads = PRPENCVF_NUM_SINK_PADS,
+		.num_src_pads = PRPENCVF_NUM_SRC_PADS,
+		.pad[PRPENCVF_SRC_PAD] = {
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
+		for (j = 0; ; j++) {
+			const struct internal_link *link;
+			char remote_devname[32];
+
+			link = &intpad->link[j];
+
+			if (!link->remote_id)
+				break;
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
+	pdata.grp_id = isd->id->grp_id;
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
+	pdevinfo.parent = imxmd->md.dev;
+	pdevinfo.data = &pdata;
+	pdevinfo.size_data = sizeof(pdata);
+	pdevinfo.dma_mask = DMA_BIT_MASK(32);
+
+	pdev = platform_device_register_full(&pdevinfo);
+	if (IS_ERR(pdev))
+		return ERR_CAST(pdev);
+
+	imxsd = imx_media_add_async_subdev(imxmd, NULL, pdev);
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
+	ret = add_ipu_internal_subdevs(imxmd, csi[0], csi[1], 0);
+	if (ret)
+		goto remove;
+
+	ret = add_ipu_internal_subdevs(imxmd, csi[2], csi[3], 1);
+	if (ret)
+		goto remove;
+
+	return 0;
+
+remove:
+	imx_media_remove_internal_subdevs(imxmd);
+	return ret;
+}
+
+void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd)
+{
+	struct imx_media_subdev *imxsd;
+	int i;
+
+	for (i = 0; i < imxmd->subdev_notifier.num_subdevs; i++) {
+		imxsd = &imxmd->subdev[i];
+		if (!imxsd->pdev)
+			continue;
+		platform_device_unregister(imxsd->pdev);
+	}
+}
diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
new file mode 100644
index 0000000..658f0a5
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-of.c
@@ -0,0 +1,268 @@
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
+	dev_dbg(imxmd->md.dev, "%s: adding %s:%d -> %s:%d\n", __func__,
+		local_sd_node->name, local_pad,
+		remote_sd_node->name, remote_pad);
+
+	return imx_media_add_pad_link(imxmd, pad, remote_sd_node, NULL,
+				      local_pad, remote_pad);
+}
+
+static void of_parse_sensor(struct imx_media_dev *imxmd,
+			    struct imx_media_subdev *sensor,
+			    struct device_node *sensor_np)
+{
+	struct device_node *endpoint;
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
+	struct device_node *ports, *child;
+	int num = 0;
+
+	/* check if this node has a ports subnode */
+	ports = of_get_child_by_name(np, "ports");
+	if (ports)
+		np = ports;
+
+	for_each_child_of_node(np, child)
+		if (of_node_cmp(child->name, "port") == 0)
+			num++;
+
+	of_node_put(ports);
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
+		if (of_property_read_u32(rp, "reg", remote_pad))
+			*remote_pad = 0;
+		of_node_put(rp);
+	}
+
+	if (!of_device_is_available(remote)) {
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
+		dev_dbg(imxmd->md.dev, "%s: %s not enabled\n", __func__,
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
+		 * the ipu-csi has one sink port and two source ports.
+		 * The source ports are not represented in the device tree,
+		 * but are described by the internal pads and links later.
+		 */
+		num_pads = CSI_NUM_PADS;
+		imxsd->num_sink_pads = CSI_NUM_SINK_PADS;
+	} else if (of_device_is_compatible(sd_np, "fsl,imx6-mipi-csi2")) {
+		num_pads = of_get_port_count(sd_np);
+		/* the mipi csi2 receiver has only one sink port */
+		imxsd->num_sink_pads = 1;
+	} else if (of_device_is_compatible(sd_np, "video-mux")) {
+		num_pads = of_get_port_count(sd_np);
+		/* for the video mux, all but the last port are sinks */
+		imxsd->num_sink_pads = num_pads - 1;
+	} else {
+		num_pads = of_get_port_count(sd_np);
+		if (num_pads != 1) {
+			dev_warn(imxmd->md.dev,
+				 "%s: unknown device %s with %d ports\n",
+				 __func__, sd_np->name, num_pads);
+			return NULL;
+		}
+
+		/*
+		 * we got to this node from this single source port,
+		 * there are no sink pads.
+		 */
+		imxsd->num_sink_pads = 0;
+	}
+
+	if (imxsd->num_sink_pads >= num_pads)
+		return ERR_PTR(-EINVAL);
+
+	imxsd->num_src_pads = num_pads - imxsd->num_sink_pads;
+
+	dev_dbg(imxmd->md.dev, "%s: %s has %d pads (%d sink, %d src)\n",
+		__func__, sd_np->name, num_pads,
+		imxsd->num_sink_pads, imxsd->num_src_pads);
+
+	/*
+	 * With no sink, this subdev node is the original source
+	 * of video, parse it's media bus for use by the pipeline.
+	 */
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
+			dev_err(imxmd->md.dev,
+				"%s: csi port missing reg property!\n",
+				__func__);
+			goto err_put;
+		}
+
+		ipu_id = of_alias_get_id(csi_np->parent, "ipu");
+		of_node_put(csi_np);
+
+		if (ipu_id > 1 || csi_id > 1) {
+			dev_err(imxmd->md.dev,
+				"%s: invalid ipu/csi id (%u/%u)\n",
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
diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
new file mode 100644
index 0000000..f718422
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -0,0 +1,834 @@
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
+ * List of supported pixel formats for the subdevs.
+ *
+ * In all of these tables, the non-mbus formats (with no
+ * mbus codes) must all fall at the end of the table.
+ */
+
+static const struct imx_media_pixfmt yuv_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.codes  = {
+			MEDIA_BUS_FMT_UYVY8_2X8,
+			MEDIA_BUS_FMT_UYVY8_1X16
+		},
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.codes  = {
+			MEDIA_BUS_FMT_YUYV8_2X8,
+			MEDIA_BUS_FMT_YUYV8_1X16
+		},
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 16,
+	},
+	/***
+	 * non-mbus YUV formats start here. NOTE! when adding non-mbus
+	 * formats, NUM_NON_MBUS_YUV_FORMATS must be updated below.
+	 ***/
+	{
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
+#define NUM_NON_MBUS_YUV_FORMATS 5
+#define NUM_YUV_FORMATS ARRAY_SIZE(yuv_formats)
+#define NUM_MBUS_YUV_FORMATS (NUM_YUV_FORMATS - NUM_NON_MBUS_YUV_FORMATS)
+
+static const struct imx_media_pixfmt rgb_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_RGB565,
+		.codes  = {MEDIA_BUS_FMT_RGB565_2X8_LE},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB24,
+		.codes  = {
+			MEDIA_BUS_FMT_RGB888_1X24,
+			MEDIA_BUS_FMT_RGB888_2X12_LE
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 24,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 32,
+		.ipufmt = true,
+	},
+	/*** raw bayer formats start here ***/
+	{
+		.fourcc = V4L2_PIX_FMT_SBGGR8,
+		.codes  = {MEDIA_BUS_FMT_SBGGR8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGBRG8,
+		.codes  = {MEDIA_BUS_FMT_SGBRG8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGRBG8,
+		.codes  = {MEDIA_BUS_FMT_SGRBG8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SRGGB8,
+		.codes  = {MEDIA_BUS_FMT_SRGGB8_1X8},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 8,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SBGGR16,
+		.codes  = {
+			MEDIA_BUS_FMT_SBGGR10_1X10,
+			MEDIA_BUS_FMT_SBGGR12_1X12,
+			MEDIA_BUS_FMT_SBGGR14_1X14,
+			MEDIA_BUS_FMT_SBGGR16_1X16
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGBRG16,
+		.codes  = {
+			MEDIA_BUS_FMT_SGBRG10_1X10,
+			MEDIA_BUS_FMT_SGBRG12_1X12,
+			MEDIA_BUS_FMT_SGBRG14_1X14,
+			MEDIA_BUS_FMT_SGBRG16_1X16,
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SGRBG16,
+		.codes  = {
+			MEDIA_BUS_FMT_SGRBG10_1X10,
+			MEDIA_BUS_FMT_SGRBG12_1X12,
+			MEDIA_BUS_FMT_SGRBG14_1X14,
+			MEDIA_BUS_FMT_SGRBG16_1X16,
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	}, {
+		.fourcc = V4L2_PIX_FMT_SRGGB16,
+		.codes  = {
+			MEDIA_BUS_FMT_SRGGB10_1X10,
+			MEDIA_BUS_FMT_SRGGB12_1X12,
+			MEDIA_BUS_FMT_SRGGB14_1X14,
+			MEDIA_BUS_FMT_SRGGB16_1X16,
+		},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 16,
+		.bayer  = true,
+	},
+	/***
+	 * non-mbus RGB formats start here. NOTE! when adding non-mbus
+	 * formats, NUM_NON_MBUS_RGB_FORMATS must be updated below.
+	 ***/
+	{
+		.fourcc	= V4L2_PIX_FMT_BGR24,
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 24,
+	}, {
+		.fourcc	= V4L2_PIX_FMT_BGR32,
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 32,
+	},
+};
+
+#define NUM_NON_MBUS_RGB_FORMATS 2
+#define NUM_RGB_FORMATS ARRAY_SIZE(rgb_formats)
+#define NUM_MBUS_RGB_FORMATS (NUM_RGB_FORMATS - NUM_NON_MBUS_RGB_FORMATS)
+
+static const struct imx_media_pixfmt ipu_yuv_formats[] = {
+	{
+		.fourcc = V4L2_PIX_FMT_YUV32,
+		.codes  = {MEDIA_BUS_FMT_AYUV8_1X32},
+		.cs     = IPUV3_COLORSPACE_YUV,
+		.bpp    = 32,
+		.ipufmt = true,
+	},
+};
+
+#define NUM_IPU_YUV_FORMATS ARRAY_SIZE(ipu_yuv_formats)
+
+static const struct imx_media_pixfmt ipu_rgb_formats[] = {
+	{
+		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.codes  = {MEDIA_BUS_FMT_ARGB8888_1X32},
+		.cs     = IPUV3_COLORSPACE_RGB,
+		.bpp    = 32,
+		.ipufmt = true,
+	},
+};
+
+#define NUM_IPU_RGB_FORMATS ARRAY_SIZE(ipu_rgb_formats)
+
+static void init_mbus_colorimetry(struct v4l2_mbus_framefmt *mbus,
+				  const struct imx_media_pixfmt *fmt)
+{
+	mbus->colorspace = (fmt->cs == IPUV3_COLORSPACE_RGB) ?
+		V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
+	mbus->xfer_func = V4L2_MAP_XFER_FUNC_DEFAULT(mbus->colorspace);
+	mbus->ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(mbus->colorspace);
+	mbus->quantization =
+		V4L2_MAP_QUANTIZATION_DEFAULT(fmt->cs == IPUV3_COLORSPACE_RGB,
+					      mbus->colorspace,
+					      mbus->ycbcr_enc);
+}
+
+static const struct imx_media_pixfmt *find_format(u32 fourcc,
+						  u32 code,
+						  enum codespace_sel cs_sel,
+						  bool allow_non_mbus,
+						  bool allow_bayer)
+{
+	const struct imx_media_pixfmt *array, *fmt, *ret = NULL;
+	u32 array_size;
+	int i, j;
+
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		array_size = NUM_YUV_FORMATS;
+		array = yuv_formats;
+		break;
+	case CS_SEL_RGB:
+		array_size = NUM_RGB_FORMATS;
+		array = rgb_formats;
+		break;
+	case CS_SEL_ANY:
+		array_size = NUM_YUV_FORMATS + NUM_RGB_FORMATS;
+		array = yuv_formats;
+		break;
+	default:
+		return NULL;
+	}
+
+	for (i = 0; i < array_size; i++) {
+		if (cs_sel == CS_SEL_ANY && i >= NUM_YUV_FORMATS)
+			fmt = &rgb_formats[i - NUM_YUV_FORMATS];
+		else
+			fmt = &array[i];
+
+		if ((!allow_non_mbus && fmt->codes[0] == 0) ||
+		    (!allow_bayer && fmt->bayer))
+			continue;
+
+		if (fourcc && fmt->fourcc == fourcc) {
+			ret = fmt;
+			goto out;
+		}
+
+		for (j = 0; code && fmt->codes[j]; j++) {
+			if (code == fmt->codes[j]) {
+				ret = fmt;
+				goto out;
+			}
+		}
+	}
+
+out:
+	return ret;
+}
+
+static int enum_format(u32 *fourcc, u32 *code, u32 index,
+		       enum codespace_sel cs_sel,
+		       bool allow_non_mbus,
+		       bool allow_bayer)
+{
+	const struct imx_media_pixfmt *fmt;
+	u32 mbus_yuv_sz = NUM_MBUS_YUV_FORMATS;
+	u32 mbus_rgb_sz = NUM_MBUS_RGB_FORMATS;
+	u32 yuv_sz = NUM_YUV_FORMATS;
+	u32 rgb_sz = NUM_RGB_FORMATS;
+
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		if (index >= yuv_sz ||
+		    (!allow_non_mbus && index >= mbus_yuv_sz))
+			return -EINVAL;
+		fmt = &yuv_formats[index];
+		break;
+	case CS_SEL_RGB:
+		if (index >= rgb_sz ||
+		    (!allow_non_mbus && index >= mbus_rgb_sz))
+			return -EINVAL;
+		fmt = &rgb_formats[index];
+		if (!allow_bayer && fmt->bayer)
+			return -EINVAL;
+		break;
+	case CS_SEL_ANY:
+		if (!allow_non_mbus) {
+			if (index >= mbus_yuv_sz) {
+				index -= mbus_yuv_sz;
+				if (index >= mbus_rgb_sz)
+					return -EINVAL;
+				fmt = &rgb_formats[index];
+				if (!allow_bayer && fmt->bayer)
+					return -EINVAL;
+			} else {
+				fmt = &yuv_formats[index];
+			}
+		} else {
+			if (index >= yuv_sz + rgb_sz)
+				return -EINVAL;
+			if (index >= yuv_sz) {
+				fmt = &rgb_formats[index - yuv_sz];
+				if (!allow_bayer && fmt->bayer)
+					return -EINVAL;
+			} else {
+				fmt = &yuv_formats[index];
+			}
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (fourcc)
+		*fourcc = fmt->fourcc;
+	if (code)
+		*code = fmt->codes[0];
+
+	return 0;
+}
+
+const struct imx_media_pixfmt *
+imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel, bool allow_bayer)
+{
+	return find_format(fourcc, 0, cs_sel, true, allow_bayer);
+}
+EXPORT_SYMBOL_GPL(imx_media_find_format);
+
+int imx_media_enum_format(u32 *fourcc, u32 index, enum codespace_sel cs_sel)
+{
+	return enum_format(fourcc, NULL, index, cs_sel, true, false);
+}
+EXPORT_SYMBOL_GPL(imx_media_enum_format);
+
+const struct imx_media_pixfmt *
+imx_media_find_mbus_format(u32 code, enum codespace_sel cs_sel,
+			   bool allow_bayer)
+{
+	return find_format(0, code, cs_sel, false, allow_bayer);
+}
+EXPORT_SYMBOL_GPL(imx_media_find_mbus_format);
+
+int imx_media_enum_mbus_format(u32 *code, u32 index, enum codespace_sel cs_sel,
+			       bool allow_bayer)
+{
+	return enum_format(NULL, code, index, cs_sel, false, allow_bayer);
+}
+EXPORT_SYMBOL_GPL(imx_media_enum_mbus_format);
+
+const struct imx_media_pixfmt *
+imx_media_find_ipu_format(u32 code, enum codespace_sel cs_sel)
+{
+	const struct imx_media_pixfmt *array, *fmt, *ret = NULL;
+	u32 array_size;
+	int i, j;
+
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		array_size = NUM_IPU_YUV_FORMATS;
+		array = ipu_yuv_formats;
+		break;
+	case CS_SEL_RGB:
+		array_size = NUM_IPU_RGB_FORMATS;
+		array = ipu_rgb_formats;
+		break;
+	case CS_SEL_ANY:
+		array_size = NUM_IPU_YUV_FORMATS + NUM_IPU_RGB_FORMATS;
+		array = ipu_yuv_formats;
+		break;
+	default:
+		return NULL;
+	}
+
+	for (i = 0; i < array_size; i++) {
+		if (cs_sel == CS_SEL_ANY && i >= NUM_IPU_YUV_FORMATS)
+			fmt = &ipu_rgb_formats[i - NUM_IPU_YUV_FORMATS];
+		else
+			fmt = &array[i];
+
+		for (j = 0; code && fmt->codes[j]; j++) {
+			if (code == fmt->codes[j]) {
+				ret = fmt;
+				goto out;
+			}
+		}
+	}
+
+out:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_find_ipu_format);
+
+int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel)
+{
+	switch (cs_sel) {
+	case CS_SEL_YUV:
+		if (index >= NUM_IPU_YUV_FORMATS)
+			return -EINVAL;
+		*code = ipu_yuv_formats[index].codes[0];
+		break;
+	case CS_SEL_RGB:
+		if (index >= NUM_IPU_RGB_FORMATS)
+			return -EINVAL;
+		*code = ipu_rgb_formats[index].codes[0];
+		break;
+	case CS_SEL_ANY:
+		if (index >= NUM_IPU_YUV_FORMATS + NUM_IPU_RGB_FORMATS)
+			return -EINVAL;
+		if (index >= NUM_IPU_YUV_FORMATS) {
+			index -= NUM_IPU_YUV_FORMATS;
+			*code = ipu_rgb_formats[index].codes[0];
+		} else {
+			*code = ipu_yuv_formats[index].codes[0];
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_enum_ipu_format);
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
+		imx_media_enum_mbus_format(&code, 0, CS_SEL_YUV, false);
+	lcc = imx_media_find_mbus_format(code, CS_SEL_ANY, false);
+	if (!lcc) {
+		lcc = imx_media_find_ipu_format(code, CS_SEL_ANY);
+		if (!lcc)
+			return -EINVAL;
+	}
+
+	mbus->code = code;
+	init_mbus_colorimetry(mbus, lcc);
+	if (cc)
+		*cc = lcc;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_init_mbus_fmt);
+
+int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
+				  struct v4l2_mbus_framefmt *mbus,
+				  const struct imx_media_pixfmt *cc)
+{
+	u32 stride;
+
+	if (!cc) {
+		cc = imx_media_find_ipu_format(mbus->code, CS_SEL_ANY);
+		if (!cc)
+			cc = imx_media_find_mbus_format(mbus->code, CS_SEL_ANY,
+							true);
+		if (!cc)
+			return -EINVAL;
+	}
+
+	/*
+	 * TODO: the IPU currently does not support the AYUV32 format,
+	 * so until it does convert to a supported YUV format.
+	 */
+	if (cc->ipufmt && cc->cs == IPUV3_COLORSPACE_YUV) {
+		u32 code;
+
+		imx_media_enum_mbus_format(&code, 0, CS_SEL_YUV, false);
+		cc = imx_media_find_mbus_format(code, CS_SEL_YUV, false);
+	}
+
+	stride = cc->planar ? mbus->width : (mbus->width * cc->bpp) >> 3;
+
+	pix->width = mbus->width;
+	pix->height = mbus->height;
+	pix->pixelformat = cc->fourcc;
+	pix->colorspace = mbus->colorspace;
+	pix->xfer_func = mbus->xfer_func;
+	pix->ycbcr_enc = mbus->ycbcr_enc;
+	pix->quantization = mbus->quantization;
+	pix->field = mbus->field;
+	pix->bytesperline = stride;
+	pix->sizeimage = (pix->width * pix->height * cc->bpp) >> 3;
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
+	ret = imx_media_mbus_fmt_to_pix_fmt(&image->pix, mbus, NULL);
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
+	fmt = imx_media_find_format(image->pix.pixelformat, CS_SEL_ANY, true);
+	if (!fmt)
+		return -EINVAL;
+
+	memset(mbus, 0, sizeof(*mbus));
+	mbus->width = image->pix.width;
+	mbus->height = image->pix.height;
+	mbus->code = fmt->codes[0];
+	mbus->field = image->pix.field;
+	mbus->colorspace = image->pix.colorspace;
+	mbus->xfer_func = image->pix.xfer_func;
+	mbus->ycbcr_enc = image->pix.ycbcr_enc;
+	mbus->quantization = image->pix.quantization;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_ipu_image_to_mbus_fmt);
+
+void imx_media_free_dma_buf(struct imx_media_dev *imxmd,
+			    struct imx_media_dma_buf *buf)
+{
+	if (buf->virt)
+		dma_free_coherent(imxmd->md.dev, buf->len,
+				  buf->virt, buf->phys);
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
+	buf->len = PAGE_ALIGN(size);
+	buf->virt = dma_alloc_coherent(imxmd->md.dev, buf->len, &buf->phys,
+				       GFP_DMA | GFP_KERNEL);
+	if (!buf->virt) {
+		dev_err(imxmd->md.dev, "failed to alloc dma buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(imx_media_alloc_dma_buf);
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
+	case IMX_MEDIA_GRP_ID_VDIC:
+		snprintf(sd_name, sz, "ipu%d_vdic", ipu_id + 1);
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PRP:
+		snprintf(sd_name, sz, "ipu%d_ic_prp", ipu_id + 1);
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PRPENC:
+		snprintf(sd_name, sz, "ipu%d_ic_prpenc", ipu_id + 1);
+		break;
+	case IMX_MEDIA_GRP_ID_IC_PRPVF:
+		snprintf(sd_name, sz, "ipu%d_ic_prpvf", ipu_id + 1);
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
+ * Adds a video device to the master video device list. This is called by
+ * an async subdev that owns a video device when it is registered.
+ */
+int imx_media_add_video_device(struct imx_media_dev *imxmd,
+			       struct imx_media_video_dev *vdev)
+{
+	int vdev_idx, ret = 0;
+
+	mutex_lock(&imxmd->mutex);
+
+	vdev_idx = imxmd->num_vdevs;
+	if (vdev_idx >= IMX_MEDIA_MAX_VDEVS) {
+		dev_err(imxmd->md.dev,
+			"%s: too many video devices! can't add %s\n",
+			__func__, vdev->vfd->name);
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	imxmd->vdev[vdev_idx] = vdev;
+	imxmd->num_vdevs++;
+out:
+	mutex_unlock(&imxmd->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_add_video_device);
+
+/*
+ * Search upstream or downstream for a subdevice in the current pipeline
+ * with given grp_id, starting from start_entity. Returns the subdev's
+ * source/sink pad that it was reached from. Must be called with
+ * mdev->graph_mutex held.
+ */
+static struct media_pad *
+find_pipeline_pad(struct imx_media_dev *imxmd,
+		  struct media_entity *start_entity,
+		  u32 grp_id, bool upstream)
+{
+	struct media_entity *me = start_entity;
+	struct media_pad *pad = NULL;
+	struct v4l2_subdev *sd;
+	int i;
+
+	for (i = 0; i < me->num_pads; i++) {
+		struct media_pad *spad = &me->pads[i];
+
+		if ((upstream && !(spad->flags & MEDIA_PAD_FL_SINK)) ||
+		    (!upstream && !(spad->flags & MEDIA_PAD_FL_SOURCE)))
+			continue;
+
+		pad = media_entity_remote_pad(spad);
+		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(pad->entity);
+		if (sd->grp_id & grp_id)
+			return pad;
+
+		return find_pipeline_pad(imxmd, pad->entity, grp_id, upstream);
+	}
+
+	return NULL;
+}
+
+/*
+ * Search upstream for a subdev in the current pipeline with
+ * given grp_id. Must be called with mdev->graph_mutex held.
+ */
+static struct v4l2_subdev *
+find_upstream_subdev(struct imx_media_dev *imxmd,
+		     struct media_entity *start_entity,
+		     u32 grp_id)
+{
+	struct v4l2_subdev *sd;
+	struct media_pad *pad;
+
+	if (is_media_entity_v4l2_subdev(start_entity)) {
+		sd = media_entity_to_v4l2_subdev(start_entity);
+		if (sd->grp_id & grp_id)
+			return sd;
+	}
+
+	pad = find_pipeline_pad(imxmd, start_entity, grp_id, true);
+
+	return pad ? media_entity_to_v4l2_subdev(pad->entity) : NULL;
+}
+
+
+/*
+ * Find the upstream mipi-csi2 virtual channel reached from the given
+ * start entity in the current pipeline.
+ * Must be called with mdev->graph_mutex held.
+ */
+int imx_media_find_mipi_csi2_channel(struct imx_media_dev *imxmd,
+				     struct media_entity *start_entity)
+{
+	struct media_pad *pad;
+	int ret = -EPIPE;
+
+	pad = find_pipeline_pad(imxmd, start_entity, IMX_MEDIA_GRP_ID_CSI2,
+				true);
+	if (pad) {
+		ret = pad->index - 1;
+		dev_dbg(imxmd->md.dev, "found vc%d from %s\n",
+			ret, start_entity->name);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_find_mipi_csi2_channel);
+
+/*
+ * Find a subdev reached upstream from the given start entity in
+ * the current pipeline.
+ * Must be called with mdev->graph_mutex held.
+ */
+struct imx_media_subdev *
+imx_media_find_upstream_subdev(struct imx_media_dev *imxmd,
+			       struct media_entity *start_entity,
+			       u32 grp_id)
+{
+	struct v4l2_subdev *sd;
+
+	sd = find_upstream_subdev(imxmd, start_entity, grp_id);
+	if (!sd)
+		return ERR_PTR(-ENODEV);
+
+	return imx_media_find_subdev_by_sd(imxmd, sd);
+}
+EXPORT_SYMBOL_GPL(imx_media_find_upstream_subdev);
+
+struct imx_media_subdev *
+__imx_media_find_sensor(struct imx_media_dev *imxmd,
+			struct media_entity *start_entity)
+{
+	return imx_media_find_upstream_subdev(imxmd, start_entity,
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
+ * Turn current pipeline streaming on/off starting from entity.
+ */
+int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
+				  struct media_entity *entity,
+				  bool on)
+{
+	struct v4l2_subdev *sd;
+	int ret = 0;
+
+	if (!is_media_entity_v4l2_subdev(entity))
+		return -EINVAL;
+	sd = media_entity_to_v4l2_subdev(entity);
+
+	mutex_lock(&imxmd->md.graph_mutex);
+
+	if (on) {
+		ret = __media_pipeline_start(entity, &imxmd->pipe);
+		if (ret)
+			goto out;
+		ret = v4l2_subdev_call(sd, video, s_stream, 1);
+		if (ret)
+			__media_pipeline_stop(entity);
+	} else {
+		v4l2_subdev_call(sd, video, s_stream, 0);
+		if (entity->pipe)
+			__media_pipeline_stop(entity);
+	}
+
+out:
+	mutex_unlock(&imxmd->md.graph_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(imx_media_pipeline_set_stream);
+
+MODULE_DESCRIPTION("i.MX5/6 v4l2 media controller driver");
+MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
new file mode 100644
index 0000000..6cebbd3
--- /dev/null
+++ b/drivers/staging/media/imx/imx-media.h
@@ -0,0 +1,324 @@
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
+ * - 4 video devices per IPU
+ * - 3 IC subdevs per IPU
+ * - 1 VDIC subdev per IPU
+ * - 2 CSI subdevs per IPU
+ * - 1 mipi-csi2 receiver subdev
+ * - 2 video-mux subdevs
+ * - 2 camera sensor subdevs per IPU (1 parallel, 1 mipi-csi2)
+ *
+ */
+/* max video devices */
+#define IMX_MEDIA_MAX_VDEVS          8
+/* max subdevices */
+#define IMX_MEDIA_MAX_SUBDEVS       32
+/* max pads per subdev */
+#define IMX_MEDIA_MAX_PADS          16
+/* max links per pad */
+#define IMX_MEDIA_MAX_LINKS          8
+
+/*
+ * Pad definitions for the subdevs with multiple source or
+ * sink pads
+ */
+
+/* ipu_csi */
+enum {
+	CSI_SINK_PAD = 0,
+	CSI_SRC_PAD_DIRECT,
+	CSI_SRC_PAD_IDMAC,
+	CSI_NUM_PADS,
+};
+
+#define CSI_NUM_SINK_PADS 1
+#define CSI_NUM_SRC_PADS  2
+
+/* ipu_vdic */
+enum {
+	VDIC_SINK_PAD_DIRECT = 0,
+	VDIC_SINK_PAD_IDMAC,
+	VDIC_SRC_PAD_DIRECT,
+	VDIC_NUM_PADS,
+};
+
+#define VDIC_NUM_SINK_PADS 2
+#define VDIC_NUM_SRC_PADS  1
+
+/* ipu_ic_prp */
+enum {
+	PRP_SINK_PAD = 0,
+	PRP_SRC_PAD_PRPENC,
+	PRP_SRC_PAD_PRPVF,
+	PRP_NUM_PADS,
+};
+
+#define PRP_NUM_SINK_PADS 1
+#define PRP_NUM_SRC_PADS  2
+
+/* ipu_ic_prpencvf */
+enum {
+	PRPENCVF_SINK_PAD = 0,
+	PRPENCVF_SRC_PAD,
+	PRPENCVF_NUM_PADS,
+};
+
+#define PRPENCVF_NUM_SINK_PADS 1
+#define PRPENCVF_NUM_SRC_PADS  1
+
+/* How long to wait for EOF interrupts in the buffer-capture subdevs */
+#define IMX_MEDIA_EOF_TIMEOUT       1000
+
+struct imx_media_pixfmt {
+	u32     fourcc;
+	u32     codes[4];
+	int     bpp;     /* total bpp */
+	enum ipu_color_space cs;
+	bool    planar;  /* is a planar format */
+	bool    bayer;   /* is a raw bayer format */
+	bool    ipufmt;  /* is one of the IPU internal formats */
+};
+
+struct imx_media_buffer {
+	struct vb2_v4l2_buffer vbuf; /* v4l buffer must be first */
+	struct list_head  list;
+};
+
+struct imx_media_video_dev {
+	struct video_device *vfd;
+
+	/* the user format */
+	struct v4l2_format fmt;
+	const struct imx_media_pixfmt *cc;
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
+
+	/*
+	 * list of video devices that can be reached from this pad,
+	 * list is only valid for source pads.
+	 */
+	struct imx_media_video_dev *vdev[IMX_MEDIA_MAX_VDEVS];
+	int num_vdevs;
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
+	/* the platform device if this is an internal subdev */
+	struct platform_device *pdev;
+	/* the devname is needed for async devname match */
+	char devname[32];
+
+	/* if this is a sensor */
+	struct v4l2_of_endpoint sensor_ep;
+};
+
+struct imx_media_dev {
+	struct media_device md;
+	struct v4l2_device  v4l2_dev;
+
+	/* the pipeline object */
+	struct media_pipeline pipe;
+
+	struct mutex mutex; /* protect elements below */
+
+	/* master subdevice list */
+	struct imx_media_subdev subdev[IMX_MEDIA_MAX_SUBDEVS];
+	int num_subdevs;
+
+	/* master video device list */
+	struct imx_media_video_dev *vdev[IMX_MEDIA_MAX_VDEVS];
+	int num_vdevs;
+
+	/* IPUs this media driver control, valid after subdevs bound */
+	struct ipu_soc *ipu[2];
+
+	/* for async subdev registration */
+	struct v4l2_async_subdev *async_ptrs[IMX_MEDIA_MAX_SUBDEVS];
+	struct v4l2_async_notifier subdev_notifier;
+};
+
+enum codespace_sel {
+	CS_SEL_YUV = 0,
+	CS_SEL_RGB,
+	CS_SEL_ANY,
+};
+
+const struct imx_media_pixfmt *
+imx_media_find_format(u32 fourcc, enum codespace_sel cs_sel, bool allow_bayer);
+int imx_media_enum_format(u32 *fourcc, u32 index, enum codespace_sel cs_sel);
+const struct imx_media_pixfmt *
+imx_media_find_mbus_format(u32 code, enum codespace_sel cs_sel,
+			   bool allow_bayer);
+int imx_media_enum_mbus_format(u32 *code, u32 index, enum codespace_sel cs_sel,
+			       bool allow_bayer);
+const struct imx_media_pixfmt *
+imx_media_find_ipu_format(u32 code, enum codespace_sel cs_sel);
+int imx_media_enum_ipu_format(u32 *code, u32 index, enum codespace_sel cs_sel);
+
+int imx_media_init_mbus_fmt(struct v4l2_mbus_framefmt *mbus,
+			    u32 width, u32 height, u32 code, u32 field,
+			    const struct imx_media_pixfmt **cc);
+
+int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
+				  struct v4l2_mbus_framefmt *mbus,
+				  const struct imx_media_pixfmt *cc);
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
+			   struct platform_device *pdev);
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
+void imx_media_remove_internal_subdevs(struct imx_media_dev *imxmd);
+
+struct imx_media_subdev *
+imx_media_find_subdev_by_sd(struct imx_media_dev *imxmd,
+			    struct v4l2_subdev *sd);
+struct imx_media_subdev *
+imx_media_find_subdev_by_id(struct imx_media_dev *imxmd,
+			    u32 grp_id);
+int imx_media_add_video_device(struct imx_media_dev *imxmd,
+			       struct imx_media_video_dev *vdev);
+int imx_media_find_mipi_csi2_channel(struct imx_media_dev *imxmd,
+				     struct media_entity *start_entity);
+struct imx_media_subdev *
+imx_media_find_upstream_subdev(struct imx_media_dev *imxmd,
+			       struct media_entity *start_entity,
+			       u32 grp_id);
+struct imx_media_subdev *
+__imx_media_find_sensor(struct imx_media_dev *imxmd,
+			struct media_entity *start_entity);
+struct imx_media_subdev *
+imx_media_find_sensor(struct imx_media_dev *imxmd,
+		      struct media_entity *start_entity);
+
+struct imx_media_dma_buf {
+	void          *virt;
+	dma_addr_t     phys;
+	unsigned long  len;
+};
+
+void imx_media_free_dma_buf(struct imx_media_dev *imxmd,
+			    struct imx_media_dma_buf *buf);
+int imx_media_alloc_dma_buf(struct imx_media_dev *imxmd,
+			    struct imx_media_dma_buf *buf,
+			    int size);
+
+int imx_media_pipeline_set_stream(struct imx_media_dev *imxmd,
+				  struct media_entity *entity,
+				  bool on);
+
+/* imx-media-fim.c */
+struct imx_media_fim;
+void imx_media_fim_eof_monitor(struct imx_media_fim *fim, struct timespec *ts);
+int imx_media_fim_set_power(struct imx_media_fim *fim, bool on);
+void imx_media_fim_set_stream(struct imx_media_fim *fim,
+			      const struct v4l2_fract *frame_interval,
+			      bool on);
+int imx_media_fim_add_controls(struct imx_media_fim *fim);
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
+/* imx-media-capture.c */
+struct imx_media_video_dev *
+imx_media_capture_device_init(struct v4l2_subdev *src_sd, int pad);
+void imx_media_capture_device_remove(struct imx_media_video_dev *vdev);
+int imx_media_capture_device_register(struct imx_media_video_dev *vdev);
+void imx_media_capture_device_unregister(struct imx_media_video_dev *vdev);
+struct imx_media_buffer *
+imx_media_capture_device_next_buf(struct imx_media_video_dev *vdev);
+void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
+					 struct v4l2_pix_format *pix);
+void imx_media_capture_device_error(struct imx_media_video_dev *vdev);
+
+/* subdev group ids */
+#define IMX_MEDIA_GRP_ID_SENSOR    (1 << 8)
+#define IMX_MEDIA_GRP_ID_VIDMUX    (1 << 9)
+#define IMX_MEDIA_GRP_ID_CSI2      (1 << 10)
+#define IMX_MEDIA_GRP_ID_CSI_BIT   11
+#define IMX_MEDIA_GRP_ID_CSI       (0x3 << IMX_MEDIA_GRP_ID_CSI_BIT)
+#define IMX_MEDIA_GRP_ID_CSI0      (1 << IMX_MEDIA_GRP_ID_CSI_BIT)
+#define IMX_MEDIA_GRP_ID_CSI1      (2 << IMX_MEDIA_GRP_ID_CSI_BIT)
+#define IMX_MEDIA_GRP_ID_VDIC      (1 << 13)
+#define IMX_MEDIA_GRP_ID_IC_PRP    (1 << 14)
+#define IMX_MEDIA_GRP_ID_IC_PRPENC (1 << 15)
+#define IMX_MEDIA_GRP_ID_IC_PRPVF  (1 << 16)
+
+#endif
diff --git a/include/media/imx.h b/include/media/imx.h
new file mode 100644
index 0000000..6e5f50d
--- /dev/null
+++ b/include/media/imx.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (c) 2014-2017 Mentor Graphics Inc.
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
+#include <linux/imx-media.h>
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
