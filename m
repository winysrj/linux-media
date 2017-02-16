Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34785 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754693AbdBPNDG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Feb 2017 08:03:06 -0500
Message-ID: <1487250123.2377.53.camel@pengutronix.de>
Subject: Re: [PATCH v4 18/36] media: Add i.MX media core driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 16 Feb 2017 14:02:03 +0100
In-Reply-To: <1487211578-11360-19-git-send-email-steve_longerbeam@mentor.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
         <1487211578-11360-19-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-02-15 at 18:19 -0800, Steve Longerbeam wrote:
> Add the core media driver for i.MX SOC.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  Documentation/media/v4l-drivers/imx.rst           | 542 +++++++++++++++++
>  drivers/staging/media/Kconfig                     |   2 +
>  drivers/staging/media/Makefile                    |   1 +
>  drivers/staging/media/imx/Kconfig                 |   7 +
>  drivers/staging/media/imx/Makefile                |   6 +
>  drivers/staging/media/imx/TODO                    |  36 ++
>  drivers/staging/media/imx/imx-media-dev.c         | 487 +++++++++++++++
>  drivers/staging/media/imx/imx-media-fim.c         | 471 +++++++++++++++
>  drivers/staging/media/imx/imx-media-internal-sd.c | 349 +++++++++++
>  drivers/staging/media/imx/imx-media-of.c          | 267 ++++++++
>  drivers/staging/media/imx/imx-media-utils.c       | 701 ++++++++++++++++++++++
>  drivers/staging/media/imx/imx-media.h             | 297 +++++++++
>  include/media/imx.h                               |  15 +
>  include/uapi/linux/v4l2-controls.h                |   4 +
>  14 files changed, 3185 insertions(+)
>  create mode 100644 Documentation/media/v4l-drivers/imx.rst
>  create mode 100644 drivers/staging/media/imx/Kconfig
>  create mode 100644 drivers/staging/media/imx/Makefile
>  create mode 100644 drivers/staging/media/imx/TODO
>  create mode 100644 drivers/staging/media/imx/imx-media-dev.c
>  create mode 100644 drivers/staging/media/imx/imx-media-fim.c
>  create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
>  create mode 100644 drivers/staging/media/imx/imx-media-of.c
>  create mode 100644 drivers/staging/media/imx/imx-media-utils.c
>  create mode 100644 drivers/staging/media/imx/imx-media.h
>  create mode 100644 include/media/imx.h
> 
> diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
> new file mode 100644
> index 0000000..f085e43
> --- /dev/null
> +++ b/Documentation/media/v4l-drivers/imx.rst
> @@ -0,0 +1,542 @@
> +i.MX Video Capture Driver
> +=========================
> +
> +Introduction
> +------------
> +
> +The Freescale i.MX5/6 contains an Image Processing Unit (IPU), which
> +handles the flow of image frames to and from capture devices and
> +display devices.
> +
> +For image capture, the IPU contains the following internal subunits:
> +
> +- Image DMA Controller (IDMAC)
> +- Camera Serial Interface (CSI)
> +- Image Converter (IC)
> +- Sensor Multi-FIFO Controller (SMFC)
> +- Image Rotator (IRT)
> +- Video De-Interlacing or Combining Block (VDIC)
> +
> +The IDMAC is the DMA controller for transfer of image frames to and from
> +memory. Various dedicated DMA channels exist for both video capture and
> +display paths. During transfer, the IDMAC is also capable of vertical
> +image flip, 8x8 block transfer (see IRT description), pixel component
> +re-ordering (for example UYVY to YUYV) within the same colorspace, and
> +even packed <--> planar conversion. It can also perform a simple
> +de-interlacing by interleaving even and odd lines during transfer
> +(without motion compensation which requires the VDIC).
> +
> +The CSI is the backend capture unit that interfaces directly with
> +camera sensors over Parallel, BT.656/1120, and MIPI CSI-2 busses.
> +
> +The IC handles color-space conversion, resizing (downscaling and
> +upscaling), horizontal flip, and 90/270 degree rotation operations.
> +
> +There are three independent "tasks" within the IC that can carry out
> +conversions concurrently: pre-process encoding, pre-process viewfinder,
> +and post-processing. Within each task, conversions are split into three
> +sections: downsizing section, main section (upsizing, flip, colorspace
> +conversion, and graphics plane combining), and rotation section.
> +
> +The IPU time-shares the IC task operations. The time-slice granularity
> +is one burst of eight pixels in the downsizing section, one image line
> +in the main processing section, one image frame in the rotation section.
> +
> +The SMFC is composed of four independent FIFOs that each can transfer
> +captured frames from sensors directly to memory concurrently via four
> +IDMAC channels.
> +
> +The IRT carries out 90 and 270 degree image rotation operations. The
> +rotation operation is carried out on 8x8 pixel blocks at a time. This
> +operation is supported by the IDMAC which handles the 8x8 block transfer
> +along with block reordering, in coordination with vertical flip.
> +
> +The VDIC handles the conversion of interlaced video to progressive, with
> +support for different motion compensation modes (low, medium, and high
> +motion). The deinterlaced output frames from the VDIC can be sent to the
> +IC pre-process viewfinder task for further conversions. The VDIC also
> +contains a Combiner that combines two image planes, with alpha blending
> +and color keying.
> +
> +In addition to the IPU internal subunits, there are also two units
> +outside the IPU that are also involved in video capture on i.MX:
> +
> +- MIPI CSI-2 Receiver for camera sensors with the MIPI CSI-2 bus
> +  interface. This is a Synopsys DesignWare core.
> +- Two video multiplexers for selecting among multiple sensor inputs
> +  to send to a CSI.
> +
> +For more info, refer to the latest versions of the i.MX5/6 reference
> +manuals listed under References.
> +
> +
> +Features
> +--------
> +
> +Some of the features of this driver include:
> +
> +- Many different pipelines can be configured via media controller API,
> +  that correspond to the hardware video capture pipelines supported in
> +  the i.MX.
> +
> +- Supports parallel, BT.565, and MIPI CSI-2 interfaces.
> +
> +- Up to four concurrent sensor acquisitions, by configuring each
> +  sensor's pipeline using independent entities. This is currently
> +  demonstrated with the SabreSD and SabreLite reference boards with
> +  independent OV5642 and MIPI CSI-2 OV5640 sensor modules.
> +
> +- Scaling, color-space conversion, horizontal and vertical flip, and
> +  image rotation via IC task subdevs.
> +
> +- Many pixel formats supported (RGB, packed and planar YUV, partial
> +  planar YUV).
> +
> +- The VDIC subdev supports motion compensated de-interlacing, with three
> +  motion compensation modes: low, medium, and high motion. The mode is
> +  specified with a custom control. Pipelines are defined that allow
> +  sending frames to the VDIC subdev directly from the CSI or from
> +  memory buffers via an output/mem2mem device node. For low and medium
> +  motion modes, the VDIC must receive from memory buffers via a device
> +  node.
> +
> +- Includes a Frame Interval Monitor (FIM) that can correct vertical sync
> +  problems with the ADV718x video decoders. See below for a description
> +  of the FIM.
> +
> +
> +Entities
> +--------
> +
> +imx6-mipi-csi2
> +--------------
> +
> +This is the MIPI CSI-2 receiver entity. It has one sink pad to receive
> +the MIPI CSI-2 stream (usually from a MIPI CSI-2 camera sensor). It has
> +four source pads, corresponding to the four MIPI CSI-2 demuxed virtual
> +channel outputs.
> +
> +This entity actually consists of two sub-blocks. One is the MIPI CSI-2
> +core. This is a Synopsys Designware MIPI CSI-2 core. The other sub-block
> +is a "CSI-2 to IPU gasket". The gasket acts as a demultiplexer of the
> +four virtual channels streams, providing four separate parallel buses
> +containing each virtual channel that are routed to CSIs or video
> +multiplexers as described below.
> +
> +On i.MX6 solo/dual-lite, all four virtual channel buses are routed to
> +two video multiplexers. Both CSI0 and CSI1 can receive any virtual
> +channel, as selected by the video multiplexers.
> +
> +On i.MX6 Quad, virtual channel 0 is routed to IPU1-CSI0 (after selected
> +by a video mux), virtual channels 1 and 2 are hard-wired to IPU1-CSI1
> +and IPU2-CSI0, respectively, and virtual channel 3 is routed to
> +IPU2-CSI1 (again selected by a video mux).
> +
> +ipuX_csiY_mux
> +-------------
> +
> +These are the video multiplexers. They have two or more sink pads to
> +select from either camera sensors with a parallel interface, or from
> +MIPI CSI-2 virtual channels from imx6-mipi-csi2 entity. They have a
> +single source pad that routes to a CSI (ipuX_csiY entities).
> +
> +On i.MX6 solo/dual-lite, there are two video mux entities. One sits
> +in front of IPU1-CSI0 to select between a parallel sensor and any of
> +the four MIPI CSI-2 virtual channels (a total of five sink pads). The
> +other mux sits in front of IPU1-CSI1, and again has five sink pads to
> +select between a parallel sensor and any of the four MIPI CSI-2 virtual
> +channels.
> +
> +On i.MX6 Quad, there are two video mux entities. One sits in front of
> +IPU1-CSI0 to select between a parallel sensor and MIPI CSI-2 virtual
> +channel 0 (two sink pads). The other mux sits in front of IPU2-CSI1 to
> +select between a parallel sensor and MIPI CSI-2 virtual channel 3 (two
> +sink pads).
> +
> +ipuX_csiY
> +---------
> +
> +These are the CSI entities. They have a single sink pad receiving from
> +either a video mux or from a MIPI CSI-2 virtual channel as described
> +above.
> +
> +This entity has two source pads. The first source pad can link directly
> +to the ipuX_vdic entity or the ipuX_ic_prp entity, using hardware links
> +that require no IDMAC memory buffer transfer.
> +
> +When the direct source pad is routed to the ipuX_ic_prp entity, frames
> +from the CSI will be processed by one of the IC pre-processing tasks.
> +
> +When the direct source pad is routed to the ipuX_vdic entity, the VDIC
> +will carry out motion-compensated de-interlace using "high motion" mode
> +(see description of ipuX_vdic entity).
> +
> +The second source pad sends video frames to memory buffers via the SMFC
> +and an IDMAC channel. This source pad is routed to a capture device
> +node.
> +
> +Note that since the IDMAC source pad makes use of an IDMAC channel, it
> +can do pixel reordering within the same colorspace. For example, the
> +sink pad can take UYVY2X8, but the IDMAC source pad can output YUYV2X8.
> +If the sink pad is receiving YUV, the output at the capture device can
> +also be converted to a planar YUV format such as YUV420.
> +
> +It will also perform simple de-interlace without motion compensation,
> +which is activated if the sink pad's field type is an interlaced type,
> +and the IDMAC source pad field type is set to none.
> +
> +ipuX_vdic
> +---------
> +
> +The VDIC carries out motion compensated de-interlacing, with three
> +motion compensation modes: low, medium, and high motion. The mode is
> +specified with a custom v4l2 control. It has two sink pads and a
> +single source pad.
> +
> +The direct sink pad receives from an ipuX_csiY direct pad. With this
> +link the VDIC can only operate in high motion mode.
> +
> +When the IDMAC sink pad is activated, it receives from an output
> +or mem2mem device node. With this pipeline, it can also operate
> +in low and medium modes, because these modes require receiving
> +frames from memory buffers. Note that an output or mem2mem device
> +is not implemented yet, so this sink pad currently has no links.
> +
> +The source pad routes to the IC pre-processing entity ipuX_ic_prp.
> +
> +ipuX_ic_prp
> +-----------
> +
> +This is the IC pre-processing entity. It acts as a router, routing
> +data from its sink pad to one or both of its source pads.
> +
> +It has a single sink pad. The sink pad can receive from the ipuX_csiY
> +direct pad, or from ipuX_vdic.
> +
> +This entity has two source pads. One source pad routes to the
> +pre-process encode task entity (ipuX_ic_prpenc), the other to the
> +pre-process viewfinder task entity (ipuX_ic_prpvf). Both source pads
> +can be activated at the same time if the sink pad is receiving from
> +ipuX_csiY. Only the source pad to the pre-process viewfinder task entity
> +can be activated if the sink pad is receiving from ipuX_vdic (frames
> +from the VDIC can only be processed by the pre-process viewfinder task).
> +
> +ipuX_ic_prpenc
> +--------------
> +
> +This is the IC pre-processing encode entity. It has a single sink pad
> +from ipuX_ic_prp, and a single source pad. The source pad is routed
> +to a capture device node.
> +
> +This entity performs the IC pre-process encode task operations:
> +color-space conversion, resizing (downscaling and upscaling), horizontal
> +and vertical flip, and 90/270 degree rotation.
> +
> +Like the ipuX_csiY IDMAC source, it can also perform simple de-interlace
> +without motion compensation, and pixel reordering.
> +
> +ipuX_ic_prpvf
> +-------------
> +
> +This is the IC pre-processing viewfinder entity. It has a single sink pad
> +from ipuX_ic_prp, and a single source pad. The source pad is routed to
> +a capture device node.
> +
> +It is identical in operation to ipuX_ic_prpenc. It will receive and
> +process de-interlaced frames from the ipuX_vdic if ipuX_ic_prp is
> +receiving from ipuX_vdic.
> +
> +Like the ipuX_csiY IDMAC source, it can perform simple de-interlace
> +without motion compensation. However, note that if the ipuX_vdic is
> +included in the pipeline (ipuX_ic_prp is receiving from ipuX_vdic),
> +it's not possible to use simple de-interlace in ipuX_ic_prpvf, since
> +the ipuX_vdic has already carried out de-interlacing (with motion
> +compensation) and therefore the field type output from ipuX_ic_prp can
> +only be none.
> +
> +Capture Pipelines
> +-----------------
> +
> +The following describe the various use-cases supported by the pipelines.
> +
> +The links shown do not include the backend sensor, video mux, or mipi
> +csi-2 receiver links. This depends on the type of sensor interface
> +(parallel or mipi csi-2). So in all cases, these pipelines begin with:
> +
> +sensor -> ipuX_csiY_mux -> ...
> +
> +for parallel sensors, or:
> +
> +sensor -> imx6-mipi-csi2 -> (ipuX_csiY_mux) -> ...
> +
> +for mipi csi-2 sensors. The imx6-mipi-csi2 receiver may need to route
> +to the video mux (ipuX_csiY_mux) before sending to the CSI, depending
> +on the mipi csi-2 virtual channel, hence ipuX_csiY_mux is shown in
> +parenthesis.
> +
> +Unprocessed Video Capture:
> +--------------------------
> +
> +Send frames directly from sensor to camera device interface node, with
> +no conversions:
> +
> +-> ipuX_csiY IDMAC pad -> capture node
> +
> +IC Direct Conversions:
> +----------------------
> +
> +This pipeline uses the preprocess encode entity to route frames directly
> +from the CSI to the IC, to carry out scaling up to 1024x1024 resolution,
> +CSC, flipping, and image rotation:
> +
> +-> ipuX_csiY direct pad -> ipuX_ic_prp -> ipuX_ic_prpenc -> capture node
> +
> +Motion Compensated De-interlace:
> +--------------------------------
> +
> +This pipeline routes frames from the CSI direct pad to the VDIC entity to
> +support motion-compensated de-interlacing (high motion mode only),
> +scaling up to 1024x1024, CSC, flip, and rotation:
> +
> +-> ipuX_csiY direct pad -> ipuX_vdic direct pad -> ipuX_ic_prp ->
> +   ipuX_ic_prpvf -> capture node
> +
> +
> +Usage Notes
> +-----------
> +
> +Many of the subdevs require information from the active sensor in the
> +current pipeline when configuring pad formats. Therefore the media links
> +should be established before configuring the media pad formats.
> +
> +Similarly, the capture device interfaces inherit controls from the
> +active entities in the current pipeline at link-setup time. Therefore
> +the capture device node links should be the last links established in
> +order for the capture interfaces to "see" and inherit all possible
> +controls.
> +
> +The following are usage notes for Sabre- reference platforms:
> +
> +
> +SabreLite with OV5642 and OV5640
> +--------------------------------
> +
> +This platform requires the OmniVision OV5642 module with a parallel
> +camera interface, and the OV5640 module with a MIPI CSI-2
> +interface. Both modules are available from Boundary Devices:
> +
> +https://boundarydevices.com/products/nit6x_5mp
> +https://boundarydevices.com/product/nit6x_5mp_mipi
> +
> +Note that if only one camera module is available, the other sensor
> +node can be disabled in the device tree.
> +
> +The OV5642 module is connected to the parallel bus input on the i.MX
> +internal video mux to IPU1 CSI0. It's i2c bus connects to i2c bus 2.
> +
> +The MIPI CSI-2 OV5640 module is connected to the i.MX internal MIPI CSI-2
> +receiver, and the four virtual channel outputs from the receiver are
> +routed as follows: vc0 to the IPU1 CSI0 mux, vc1 directly to IPU1 CSI1,
> +vc2 directly to IPU2 CSI0, and vc3 to the IPU2 CSI1 mux. The OV5640 is
> +also connected to i2c bus 2 on the SabreLite, therefore the OV5642 and
> +OV5640 must not share the same i2c slave address.
> +
> +The following basic example configures unprocessed video capture
> +pipelines for both sensors. The OV5642 is routed to ipu1_csi0, and
> +the OV5640 (transmitting on mipi csi-2 virtual channel 1) is routed
> +to ipu1_csi1. Both sensors are configured to output 640x480, the
> +OV5642 outputs YUYV2X8, the OV5640 UYVY2X8:
> +
> +.. code-block:: none
> +
> +   # Setup links for OV5642
> +   media-ctl -l '"ov5642 1-0042":0 -> "ipu1_csi0_mux":1[1]'
> +   media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> +   media-ctl -l '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]'
> +   # Setup links for OV5640
> +   media-ctl -l '"ov5640_mipi 1-0040":0 -> "imx6-mipi-csi2":0[1]'
> +   media-ctl -l '"imx6-mipi-csi2":2 -> "ipu1_csi1":0[1]'
> +   media-ctl -l '"ipu1_csi1":2 -> "ipu1_csi1 capture":0[1]'
> +   # Configure pads for OV5642 pipeline
> +   media-ctl -V "\"ov5642 1-0042\":0 [fmt:YUYV2X8/640x480 field:none]"
> +   media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:YUYV2X8/640x480 field:none]"
> +   media-ctl -V "\"ipu1_csi0\":2 [fmt:YUYV2X8/640x480 field:none]"
> +   # Configure pads for OV5640 pipeline
> +   media-ctl -V "\"ov5640_mipi 1-0040\":0 [fmt:UYVY2X8/640x480 field:none]"
> +   media-ctl -V "\"imx6-mipi-csi2\":2 [fmt:UYVY2X8/640x480 field:none]"
> +   media-ctl -V "\"ipu1_csi1\":2 [fmt:UYVY2X8/640x480 field:none]"
> +
> +Streaming can then begin independently on the capture device nodes
> +"ipu1_csi0 capture" and "ipu1_csi1 capture".
> +
> +SabreAuto with ADV7180 decoder
> +------------------------------
> +
> +On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
> +parallel bus input on the internal video mux to IPU1 CSI0.
> +
> +The following example configures a pipeline to capture from the ADV7180
> +video decoder, assuming NTSC 720x480 input signals, with Motion
> +Compensated de-interlacing. Pad field types assume the adv7180 outputs
> +"alternate", which the ipu1_csi0 entity converts to "seq-tb" at its
> +source pad. $outputfmt can be any format supported by the ipu1_ic_prpvf
> +entity at its output pad:
> +
> +.. code-block:: none
> +
> +   # Setup links
> +   media-ctl -l '"adv7180 4-0021":0 -> "ipu1_csi0_mux":1[1]'
> +   media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> +   media-ctl -l '"ipu1_csi0":2 -> "ipu1_vdic":0[1]'
> +   media-ctl -l '"ipu1_vdic":2 -> "ipu1_ic_prp":0[1]'
> +   media-ctl -l '"ipu1_ic_prp":2 -> "ipu1_ic_prpvf":0[1]'
> +   media-ctl -l '"ipu1_ic_prpvf":1 -> "ipu1_ic_prpvf capture":0[1]'
> +   # Configure pads
> +   media-ctl -V "\"adv7180 4-0021\":0 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:UYVY2X8/720x480 field:alternate]"
> +   media-ctl -V "\"ipu1_csi0\":1 [fmt:AYUV32/720x480 field:seq-tb]"
> +   media-ctl -V "\"ipu1_vdic\":2 [fmt:AYUV32/720x480 field:none]"
> +   media-ctl -V "\"ipu1_ic_prp\":2 [fmt:AYUV32/720x480 field:none]"
> +   media-ctl -V "\"ipu1_ic_prpvf\":1 [fmt:$outputfmt field:none]"
> +
> +Streaming can then begin on the capture device node at
> +"ipu1_ic_prpvf capture".
> +
> +This platform accepts Composite Video analog inputs to the ADV7180 on
> +Ain1 (connector J42).
> +
> +Frame Interval Monitor
> +----------------------
> +
> +The adv718x decoders can occasionally send corrupt fields during
> +NTSC/PAL signal re-sync (too little or too many video lines). When
> +this happens, the IPU triggers a mechanism to re-establish vertical
> +sync by adding 1 dummy line every frame, which causes a rolling effect
> +from image to image, and can last a long time before a stable image is
> +recovered. Or sometimes the mechanism doesn't work at all, causing a
> +permanent split image (one frame contains lines from two consecutive
> +captured images).
> +
> +From experiment it was found that during image rolling, the frame
> +intervals (elapsed time between two EOF's) drop below the nominal
> +value for the current standard, by about one frame time (60 usec),
> +and remain at that value until rolling stops.
> +
> +While the reason for this observation isn't known (the IPU dummy
> +line mechanism should show an increase in the intervals by 1 line
> +time every frame, not a fixed value), we can use it to detect the
> +corrupt fields using a frame interval monitor. If the FIM detects a
> +bad frame interval, a subdev event is sent. In response, userland can
> +issue a streaming restart to correct the rolling/split image.
> +
> +The FIM is implemented in the ipuX_csiY entity, and the entities that
> +generate End-Of-Frame interrupts call into the FIM to monitor the frame
> +intervals: ipuX_ic_prpenc, and ipuX_ic_prpvf. Userland can register with
> +the FIM event notifications on the ipuX_csiY subdev device node
> +(V4L2_EVENT_IMX_FRAME_INTERVAL).
> +
> +The ipuX_csiY entity includes custom controls to tweak some dials for
> +FIM. If one of these controls is changed during streaming, the FIM will
> +be reset and will continue at the new settings.
> +
> +- V4L2_CID_IMX_FIM_ENABLE
> +
> +Enable/disable the FIM.
> +
> +- V4L2_CID_IMX_FIM_NUM
> +
> +How many frame interval errors to average before comparing against the
> +nominal frame interval reported by the sensor. This can reduce noise
> +from interrupt latency.
> +
> +- V4L2_CID_IMX_FIM_TOLERANCE_MIN
> +
> +If the averaged intervals fall outside nominal by this amount, in
> +microseconds, streaming will be restarted.
> +
> +- V4L2_CID_IMX_FIM_TOLERANCE_MAX
> +
> +If any interval errors are higher than this value, those error samples
> +are discarded and do not enter into the average. This can be used to
> +discard really high interval errors that might be due to very high
> +system load, causing excessive interrupt latencies.
> +
> +- V4L2_CID_IMX_FIM_NUM_SKIP
> +
> +How many frames to skip after a FIM reset or stream restart before
> +FIM begins to average intervals. It has been found that there can
> +be a few bad frame intervals after stream restart which are not
> +attributed to adv718x sending a corrupt field, so this is used to
> +skip those frames to prevent unnecessary restarts.
> +
> +
> +SabreSD with MIPI CSI-2 OV5640
> +------------------------------
> +
> +Similarly to SabreLite, the SabreSD supports a parallel interface
> +OV5642 module on IPU1 CSI0, and a MIPI CSI-2 OV5640 module. The OV5642
> +connects to i2c bus 1 and the OV5640 to i2c bus 2.
> +
> +The device tree for SabreSD includes OF graphs for both the parallel
> +OV5642 and the MIPI CSI-2 OV5640, but as of this writing only the MIPI
> +CSI-2 OV5640 has been tested, so the OV5642 node is currently disabled.
> +The OV5640 module connects to MIPI connector J5 (sorry I don't have the
> +compatible module part number or URL).
> +
> +The following example configures a direct conversion pipeline to capture
> +from the OV5640. $sensorfmt can be any format supported by the OV5640.
> +$sensordim is the frame dimension part of $sensorfmt (minus the mbus
> +pixel code). $outputfmt can be any format supported by the
> +ipu1_ic_prpenc entity at its output pad:
> +
> +.. code-block:: none
> +
> +   # Setup links
> +   media-ctl -l '"ov5640_mipi 1-003c":0 -> "imx6-mipi-csi2":0[1]'
> +   media-ctl -l '"imx6-mipi-csi2":2 -> "ipu1_csi1":0[1]'
> +   media-ctl -l '"ipu1_csi1":1 -> "ipu1_ic_prp":0[1]'
> +   media-ctl -l '"ipu1_ic_prp":1 -> "ipu1_ic_prpenc":0[1]'
> +   media-ctl -l '"ipu1_ic_prpenc":1 -> "ipu1_ic_prpenc capture":0[1]'
> +   # Configure pads
> +   media-ctl -V "\"ov5640_mipi 1-003c\":0 [fmt:$sensorfmt field:none]"
> +   media-ctl -V "\"imx6-mipi-csi2\":2 [fmt:$sensorfmt field:none]"
> +   media-ctl -V "\"ipu1_csi1\":1 [fmt:AYUV32/$sensordim field:none]"
> +   media-ctl -V "\"ipu1_ic_prp\":1 [fmt:AYUV32/$sensordim field:none]"
> +   media-ctl -V "\"ipu1_ic_prpenc\":1 [fmt:$outputfmt field:none]"
> +
> +Streaming can then begin on "ipu1_ic_prpenc capture" node.
> +
> +
> +
> +Known Issues
> +------------
> +
> +1. When using 90 or 270 degree rotation control at capture resolutions
> +   near the IC resizer limit of 1024x1024, and combined with planar
> +   pixel formats (YUV420, YUV422p), frame capture will often fail with
> +   no end-of-frame interrupts from the IDMAC channel. To work around
> +   this, use lower resolution and/or packed formats (YUYV, RGB3, etc.)
> +   when 90 or 270 rotations are needed.
> +
> +
> +File list
> +---------
> +
> +drivers/staging/media/imx/
> +include/media/imx.h
> +include/uapi/media/imx.h
> +
> +References
> +----------
> +
> +[1] "i.MX 6Dual/6Quad Applications Processor Reference Manual"
> +[2] "i.MX 6Solo/6DualLite Applications Processor Reference Manual"
> +
> +
> +Authors
> +-------
> +Steve Longerbeam <steve_longerbeam@mentor.com>
> +Philipp Zabel <kernel@pengutronix.de>
> +Russell King - ARM Linux <linux@armlinux.org.uk>
> +
> +Copyright (C) 2012-2017 Mentor Graphics Inc.
> diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
> index ffb8fa7..05b55a8 100644
> --- a/drivers/staging/media/Kconfig
> +++ b/drivers/staging/media/Kconfig
> @@ -25,6 +25,8 @@ source "drivers/staging/media/cxd2099/Kconfig"
>  
>  source "drivers/staging/media/davinci_vpfe/Kconfig"
>  
> +source "drivers/staging/media/imx/Kconfig"
> +
>  source "drivers/staging/media/omap4iss/Kconfig"
>  
>  source "drivers/staging/media/s5p-cec/Kconfig"
> diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> index a28e82c..6f50ddd 100644
> --- a/drivers/staging/media/Makefile
> +++ b/drivers/staging/media/Makefile
> @@ -1,6 +1,7 @@
>  obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC) += s5p-cec/
>  obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
> +obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
>  obj-$(CONFIG_LIRC_STAGING)	+= lirc/
>  obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
>  obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> new file mode 100644
> index 0000000..722ed55
> --- /dev/null
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -0,0 +1,7 @@
> +config VIDEO_IMX_MEDIA
> +	tristate "i.MX5/6 V4L2 media core driver"
> +	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
> +	---help---
> +	  Say yes here to enable support for video4linux media controller
> +	  driver for the i.MX5/6 SOC.
> +
> diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
> new file mode 100644
> index 0000000..ba8e4fb
> --- /dev/null
> +++ b/drivers/staging/media/imx/Makefile
> @@ -0,0 +1,6 @@
> +imx-media-objs := imx-media-dev.o imx-media-internal-sd.o imx-media-of.o
> +imx-media-common-objs := imx-media-utils.o imx-media-fim.o
> +
> +obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media.o
> +obj-$(CONFIG_VIDEO_IMX_MEDIA) += imx-media-common.o
> +
> diff --git a/drivers/staging/media/imx/TODO b/drivers/staging/media/imx/TODO
> new file mode 100644
> index 0000000..f6d2bac
> --- /dev/null
> +++ b/drivers/staging/media/imx/TODO
> @@ -0,0 +1,36 @@
> +
> +- Finish v4l2-compliance
>+
> +- imx-csi subdev is not being autoloaded as a kernel module, probably
> +  because ipu_add_client_devices() does not register the IPU client
> +  platform devices, but only allocates those devices.

As Russell points out, this is an issue with the ipu-v3 driver, which
needs to be fixed to stop setting the ipu client devices' dev->of_node
field.

> +- Currently registering with notifications from subdevs are only
> +  available through the subdev device nodes and not through the main
> +  capture device node. Need to come up with a way to find the capture
> +  device in the current pipeline that owns the subdev that sent the
> +  notify.
> +
> +- Clean up and move the ov5642 subdev driver to drivers/media/i2c, and
> +  create the binding docs for it.

This is done already, right?

> +- The Frame Interval Monitor could be exported to v4l2-core for
> +  general use.
>+
> +- The subdev that is the original source of video data (referred to as
> +  the "sensor" in the code), is called from various subdevs in the
> +  pipeline in order to set/query the video standard ({g|s|enum}_std)
> +  and to get/set the original frame interval from the capture interface
> +  ([gs]_parm). Instead, the entities that need this info should call its
> +  direct neighbor, and the neighbor should propagate the call to its
> +  neighbor in turn if necessary.

Especially the [gs]_parm fix is necessary to present userspace with the
correct frame interval in case of frame skipping in the CSI.

> +- At driver load time, the device-tree node that is the original source
> +  (the "sensor"), is parsed to record its media bus configuration, and
> +  this info is required in various subdevs to setup the pipeline.
> +  Laurent Pinchart argues that instead the subdev should call its
> +  neighbor's g_mbus_config op (which should be propagated if necessary)
> +  to get this info. However Hans Verkuil is planning to remove the
> +  g_mbus_config op. For now this driver uses the parsed DT mbus config
> +  method until this issue is resolved.
> +
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> new file mode 100644
> index 0000000..e2041ad
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-dev.c
[...]
> +static inline u32 pixfmt_to_colorspace(const struct imx_media_pixfmt *fmt)
> +{
> +	return (fmt->cs == IPUV3_COLORSPACE_RGB) ?
> +		V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
> +}

This ...

[...]
> +int imx_media_mbus_fmt_to_pix_fmt(struct v4l2_pix_format *pix,
> +				  struct v4l2_mbus_framefmt *mbus,
> +				  const struct imx_media_pixfmt *cc)
> +{
> +	u32 stride;
> +
> +	if (!cc) {
> +		cc = imx_media_find_format(0, mbus->code, true, false);
> +		if (!cc)
> +			return -EINVAL;
> +	}
> +
> +	stride = cc->planar ? mbus->width : (mbus->width * cc->bpp) >> 3;
> +
> +	pix->width = mbus->width;
> +	pix->height = mbus->height;
> +	pix->pixelformat = cc->fourcc;
> +	pix->colorspace = pixfmt_to_colorspace(cc);

... is not right. The colorspace should be taken from the input pad
colorspace everywhere (except for the IC output pad in the future, once
that supports changing YCbCr encoding and quantization), not guessed
based on the media bus format.

regards
Philipp
