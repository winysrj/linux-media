Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:51257 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752291AbdAMPWX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jan 2017 10:22:23 -0500
Message-ID: <1484320822.31475.96.camel@pengutronix.de>
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
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
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 13 Jan 2017 16:20:22 +0100
In-Reply-To: <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 06.01.2017, 18:11 -0800 schrieb Steve Longerbeam:
> Add the core media driver for i.MX SOC.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  Documentation/media/v4l-drivers/imx.rst           | 443 ++++++++++
>  drivers/staging/media/Kconfig                     |   2 +
>  drivers/staging/media/Makefile                    |   1 +
>  drivers/staging/media/imx/Kconfig                 |   8 +
>  drivers/staging/media/imx/Makefile                |   6 +
>  drivers/staging/media/imx/TODO                    |  22 +
>  drivers/staging/media/imx/imx-media-common.c      | 981 ++++++++++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c         | 486 +++++++++++
>  drivers/staging/media/imx/imx-media-fim.c         | 471 +++++++++++
>  drivers/staging/media/imx/imx-media-internal-sd.c | 457 ++++++++++
>  drivers/staging/media/imx/imx-media-of.c          | 289 +++++++
>  drivers/staging/media/imx/imx-media.h             | 310 +++++++
>  include/media/imx.h                               |  15 +
>  include/uapi/linux/v4l2-controls.h                |   4 +
>  14 files changed, 3495 insertions(+)
>  create mode 100644 Documentation/media/v4l-drivers/imx.rst
>  create mode 100644 drivers/staging/media/imx/Kconfig
>  create mode 100644 drivers/staging/media/imx/Makefile
>  create mode 100644 drivers/staging/media/imx/TODO
>  create mode 100644 drivers/staging/media/imx/imx-media-common.c
>  create mode 100644 drivers/staging/media/imx/imx-media-dev.c
>  create mode 100644 drivers/staging/media/imx/imx-media-fim.c
>  create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
>  create mode 100644 drivers/staging/media/imx/imx-media-of.c
>  create mode 100644 drivers/staging/media/imx/imx-media.h
>  create mode 100644 include/media/imx.h
> 
> diff --git a/Documentation/media/v4l-drivers/imx.rst b/Documentation/media/v4l-drivers/imx.rst
> new file mode 100644
> index 0000000..87b37b5
> --- /dev/null
> +++ b/Documentation/media/v4l-drivers/imx.rst
> @@ -0,0 +1,443 @@
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
> +- Video De-Interlace Controller (VDIC)

Nitpick: Video De-Interlacing or Combining Block (VDIC)

> +
> +The IDMAC is the DMA controller for transfer of image frames to and from
> +memory. Various dedicated DMA channels exist for both video capture and
> +display paths.
> +
> +The CSI is the frontend capture unit that interfaces directly with
> +capture sensors over Parallel, BT.656/1120, and MIPI CSI-2 busses.
> +
> +The IC handles color-space conversion, resizing, and rotation
> +operations. 

And horizontal flipping.

> There are three independent "tasks" within the IC that can
> +carry out conversions concurrently: pre-processing encoding,
> +pre-processing preview, and post-processing.

s/preview/viewfinder/ seems to be the commonly used name.

This paragraph could mention that a single hardware unit is used
transparently time multiplexed by the three tasks at different
granularity for the downsizing, main processing, and rotation sections.
The downscale unit switches between tasks at 8-pixel burst granularity,
the main processing unit at line granularity. The rotation units switch
only at frame granularity.

> +The SMFC is composed of four independent channels that each can transfer
> +captured frames from sensors directly to memory concurrently.
> +
> +The IRT carries out 90 and 270 degree image rotation operations.

... on 8x8 pixel blocks, supported by the IDMAC which handles block
transfers, block reordering, and vertical flipping.

> +The VDIC handles the conversion of interlaced video to progressive, with
> +support for different motion compensation modes (low, medium, and high
> +motion). The deinterlaced output frames from the VDIC can be sent to the
> +IC pre-process preview task for further conversions.
> +
> +In addition to the IPU internal subunits, there are also two units
> +outside the IPU that are also involved in video capture on i.MX:
> +
> +- MIPI CSI-2 Receiver for camera sensors with the MIPI CSI-2 bus
> +  interface. This is a Synopsys DesignWare core.
> +- A video multiplexer for selecting among multiple sensor inputs to
> +  send to a CSI.

Two of them, actually.

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
> +- Scaling, color-space conversion, and image rotation via IC task
> +  subdevs.
> +
> +- Many pixel formats supported (RGB, packed and planar YUV, partial
> +  planar YUV).
> +
> +- The IC pre-process preview subdev supports motion compensated
> +  de-interlacing using the VDIC, with three motion compensation modes:
> +  low, medium, and high motion. The mode is specified with a custom
> +  control. Pipelines are defined that allow sending frames to the
> +  preview subdev directly from the CSI or from the SMFC.
> +
> +- Includes a Frame Interval Monitor (FIM) that can correct vertical sync
> +  problems with the ADV718x video decoders. See below for a description
> +  of the FIM.

Could this also be used to calculate more precise capture timestamps?

> +Capture Pipelines
> +-----------------
> +
> +The following describe the various use-cases supported by the pipelines.
> +
> +The links shown do not include the frontend sensor, video mux, or mipi
> +csi-2 receiver links. This depends on the type of sensor interface
> +(parallel or mipi csi-2). So in all cases, these pipelines begin with:
> +
> +sensor -> ipu_csi_mux -> ipu_csi -> ...
> +
> +for parallel sensors, or:
> +
> +sensor -> imx-mipi-csi2 -> (ipu_csi_mux) -> ipu_csi -> ...
> +
> +for mipi csi-2 sensors. The imx-mipi-csi2 receiver may need to route
> +to the video mux (ipu_csi_mux) before sending to the CSI, depending
> +on the mipi csi-2 virtual channel, hence ipu_csi_mux is shown in
> +parenthesis.
> +
> +Unprocessed Video Capture:
> +--------------------------
> +
> +Send frames directly from sensor to camera interface, with no
> +conversions:
> +
> +-> ipu_smfc -> camif

I'd call this capture interface, this is not just for cameras. Or maybe
idmac if you want to mirror hardware names?

> +Note the ipu_smfc can do pixel reordering within the same colorspace.

That isn't a feature of the SMFC, but of the IDMAC (FCW & FCR).

> +For example, its sink pad can take UYVY2X8, but its source pad can
> +output YUYV2X8.

I don't think this is correct. Re-reading "37.4.3.7 Packing to memory"
in the CSI chapter, for 8-bit per component data, the internal format
between CSI, SMFC, and IDMAC is always some 32-bit RGBx/YUVx variant
(or "bayer/generic data"). In either case, the internal format does not
change along the way.

> +IC Direct Conversions:
> +----------------------
> +
> +This pipeline uses the preprocess encode entity to route frames directly
> +from the CSI to the IC (bypassing the SMFC), to carry out scaling up to
> +1024x1024 resolution, CSC, and image rotation:
> +
> +-> ipu_ic_prpenc -> camif
> +
> +This can be a useful capture pipeline for heavily loaded memory bus
> +traffic environments, since it has minimal IDMAC channel usage.

Note that if rotation is enabled, transfers between IC processing and
rotation still have to go through memory once.

> +Post-Processing Conversions:
> +----------------------------
> +
> +This pipeline routes frames from the SMFC to the post-processing
> +entity.

No, frames written by the CSI -> SMFC -> IDMAC path are read back into
the post-processing entity.

>  In addition to CSC and rotation, this entity supports tiling
> +which allows scaled output beyond the 1024x1024 limitation of the IC
> +(up to 4096x4096 scaling output is supported):
> +
> +-> ipu_smfc -> ipu_ic_pp -> camif
> +
> +Motion Compensated De-interlace:
> +--------------------------------
> +
> +This pipeline routes frames from the SMFC to the preprocess preview
> +entity to support motion-compensated de-interlacing using the VDIC,
> +scaling up to 1024x1024, and CSC:
> +
> +-> ipu_smfc -> ipu_ic_prpvf -> camif

Same as above.

> +This pipeline also carries out the same conversions as above, but routes
> +frames directly from the CSI to the IC preprocess preview entity for
> +minimal memory bandwidth usage (note: this pipeline only works in
> +"high motion" mode):
> +
> +-> ipu_ic_prpvf -> camif
> +
> +This pipeline takes the motion-compensated de-interlaced frames and
> +sends them to the post-processor, to support motion-compensated
> +de-interlacing, scaling up to 4096x4096, CSC, and rotation:
> +
> +-> (ipu_smfc) -> ipu_ic_prpvf -> ipu_ic_pp -> camif
> +
> +
> +Usage Notes
> +-----------
[...]
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
> +pipelines for both sensors. The OV5642 is routed to camif0
> +(usually /dev/video0), and the OV5640 (transmitting on mipi csi-2
> +virtual channel 1) is routed to camif1 (usually /dev/video1). Both
> +sensors are configured to output 640x480, UYVY (not shown: all pad
> +field types should be set to "NONE"):
> +
> +.. code-block:: none
> +
> +   # Setup links for OV5642
> +   media-ctl -l '"ov5642 1-0042":0 -> "ipu1_csi0_mux":1[1]'
> +   media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> +   media-ctl -l '"ipu1_csi0":1 -> "ipu1_smfc0":0[1]'
> +   media-ctl -l '"ipu1_smfc0":1 -> "camif0":0[1]'
> +   media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'
> +   # Setup links for OV5640
> +   media-ctl -l '"ov5640_mipi 1-0040":0 -> "imx-mipi-csi2":0[1]'
> +   media-ctl -l '"imx-mipi-csi2":2 -> "ipu1_csi1":0[1]'
> +   media-ctl -l '"ipu1_csi1":1 -> "ipu1_smfc1":0[1]'
> +   media-ctl -l '"ipu1_smfc1":1 -> "camif1":0[1]'
> +   media-ctl -l '"camif1":1 -> "camif1 devnode":0[1]'
> +   # Configure pads for OV5642 pipeline
> +   media-ctl -V "\"ov5642 1-0042\":0 [fmt:YUYV2X8/640x480]"
> +   media-ctl -V "\"ipu1_csi0_mux\":1 [fmt:YUYV2X8/640x480]"
> +   media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:YUYV2X8/640x480]"
> +   media-ctl -V "\"ipu1_csi0\":0 [fmt:YUYV2X8/640x480]"
> +   media-ctl -V "\"ipu1_csi0\":1 [fmt:YUYV2X8/640x480]"
> +   media-ctl -V "\"ipu1_smfc0\":0 [fmt:YUYV2X8/640x480]"
> +   media-ctl -V "\"ipu1_smfc0\":1 [fmt:UYVY2X8/640x480]"

I think the smfc entities should be dropped.

> +   media-ctl -V "\"camif0\":0 [fmt:UYVY2X8/640x480]"
> +   media-ctl -V "\"camif0\":1 [fmt:UYVY2X8/640x480]"
> +   # Configure pads for OV5640 pipeline
> +   media-ctl -V "\"ov5640_mipi 1-0040\":0 [fmt:UYVY2X8/640x480]"
> +   media-ctl -V "\"imx-mipi-csi2\":0 [fmt:UYVY2X8/640x480]"
> +   media-ctl -V "\"imx-mipi-csi2\":2 [fmt:UYVY2X8/640x480]"
> +   media-ctl -V "\"ipu1_csi1\":0 [fmt:UYVY2X8/640x480]"
> +   media-ctl -V "\"ipu1_csi1\":1 [fmt:UYVY2X8/640x480]"
[...]
> +   media-ctl -V "\"camif1\":0 [fmt:UYVY2X8/640x480]"

I agree this looks very intuitive, but technically correct for the
csi1:1 and camif1:0 pads would be a 32-bit YUV format.
(MEDIA_BUS_FMT_YUV8_1X32_PADLO doesn't exist yet).

I think it would be better to use the correct format as that will allow
to chose the regular vs. companded packings in the future for formats
with more than 8 bits per component.

> +   media-ctl -V "\"camif1\":1 [fmt:UYVY2X8/640x480]"
>+
> +Streaming can then begin independently on device nodes /dev/video0
> +and /dev/video1.
> +
> +SabreAuto with ADV7180 decoder
> +------------------------------
> +
> +On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
> +parallel bus input on the internal video mux to IPU1 CSI0.
> +
> +The following example configures a pipeline to capture from the ADV7180
> +video decoder, assuming NTSC 720x480 input signals, with Motion
> +Compensated de-interlacing (not shown: all pad field types should be set
> +as indicated). $outputfmt can be any format supported by the
> +ipu1_ic_prpvf entity at its output pad:
> +
> +.. code-block:: none
> +
> +   # Setup links
> +   media-ctl -l '"adv7180 3-0021":0 -> "ipu1_csi0_mux":1[1]'
> +   media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
> +   media-ctl -l '"ipu1_csi0":1 -> "ipu1_smfc0":0[1]'
> +   media-ctl -l '"ipu1_smfc0":1 -> "ipu1_ic_prpvf":0[1]'
> +   media-ctl -l '"ipu1_ic_prpvf":1 -> "camif0":0[1]'
> +   media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'
> +   # Configure pads
> +   # pad field types for below pads must be an interlaced type
> +   # such as "ALTERNATE"

I think alternate should only extend as far as the CSI, since the CSI
can only capture NTSC/PAL fields in a fixed order.

> +   media-ctl -V "\"adv7180 3-0021\":0 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "\"ipu1_csi0_mux\":1 [fmt:UYVY2X8/720x480]"

>From here the interlaced field type should be sequential in the correct
order depending on NTSC/PAL.

> +   media-ctl -V "\"ipu1_csi0_mux\":2 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "\"ipu1_csi0\":0 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "\"ipu1_csi0\":1 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "\"ipu1_smfc0\":0 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "\"ipu1_smfc0\":1 [fmt:UYVY2X8/720x480]"
> +   media-ctl -V "\"ipu1_ic_prpvf\":0 [fmt:UYVY2X8/720x480]"
> +   # pad field types for below pads must be "NONE"
> +   media-ctl -V "\"ipu1_ic_prpvf\":1 [fmt:$outputfmt]"
> +   media-ctl -V "\"camif0\":0 [fmt:$outputfmt]"
> +   media-ctl -V "\"camif0\":1 [fmt:$outputfmt]"
> +
> +Streaming can then begin on /dev/video0.
> +
> +This platform accepts Composite Video analog inputs to the ADV7180 on
> +Ain1 (connector J42) and Ain3 (connector J43).
> +
> +To switch to Ain1:
> +
> +.. code-block:: none
> +
> +   # v4l2-ctl -i0
> +
> +To switch to Ain3:
> +
> +.. code-block:: none
> +
> +   # v4l2-ctl -i1
> +
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

Is it only SabreAuto on which the FIM mechanism can be used due to the
pad routing?

[...]
> +/*
> + * DMA buffer ring handling
> + */
> +struct imx_media_dma_buf_ring {
> +	struct imx_media_dev *imxmd;
> +
> +	/* the ring */
> +	struct imx_media_dma_buf buf[IMX_MEDIA_MAX_RING_BUFS];
> +	/* the scratch buffer for underruns */
> +	struct imx_media_dma_buf scratch;
> +
> +	/* buffer generator */
> +	struct media_entity *src;
> +	/* buffer receiver */
> +	struct media_entity *sink;
> +
> +	spinlock_t lock;
> +
> +	int num_bufs;
> +	unsigned long last_seq;
> +};

I don't think this belongs in the capture driver at all.
Memory-to-memory transfers should be handled at the videobuf2 level.

[...]
> +static struct imx_media_dma_buf *
> +__dma_buf_queue(struct imx_media_dma_buf_ring *ring, int index)
> +{
> +	struct imx_media_dma_buf *buf;
> +
> +	if (index >= ring->num_bufs)
> +		return ERR_PTR(-EINVAL);
> +
> +	buf = &ring->buf[index];
> +	if (WARN_ON(buf->state != IMX_MEDIA_BUF_STATUS_PREPARED))
> +		return ERR_PTR(-EINVAL);
> +
> +	buf->state = IMX_MEDIA_BUF_STATUS_QUEUED;
> +	buf->seq = ring->last_seq++;
> +
> +	return buf;
> +}

Is this a whole software buffer queue implementation? I thought the
whole point of putting the custom mem2mem framework into the capture
driver was to use the hardware FSU channel linking?

> +int imx_media_dma_buf_queue(struct imx_media_dma_buf_ring *ring, int index)
> +{
> +	struct imx_media_dma_buf *buf;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ring->lock, flags);
> +	buf = __dma_buf_queue(ring, index);
> +	spin_unlock_irqrestore(&ring->lock, flags);
> +
> +	if (IS_ERR(buf))
> +		return PTR_ERR(buf);
> +
> +	dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] queued\n",
> +		index, ring->src->name, ring->sink->name);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_dma_buf_queue);
> +
> +int imx_media_dma_buf_queue_from_vb(struct imx_media_dma_buf_ring *ring,
> +				    struct vb2_buffer *vb)
> +{
> +	struct imx_media_dma_buf *buf;
> +	unsigned long flags;
> +	dma_addr_t phys;
> +	void *virt;
> +
> +	if (vb->index >= ring->num_bufs)
> +		return -EINVAL;
> +
> +	virt = vb2_plane_vaddr(vb, 0);
> +	phys = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	spin_lock_irqsave(&ring->lock, flags);
> +	buf = __dma_buf_queue(ring, vb->index);
> +	if (IS_ERR(buf))
> +		goto err_unlock;
> +
> +	buf->virt = virt;
> +	buf->phys = phys;
> +	buf->vb = vb;
> +	spin_unlock_irqrestore(&ring->lock, flags);
> +
> +	dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] queued from vb\n",
> +		buf->index, ring->src->name, ring->sink->name);
> +
> +	return 0;
> +err_unlock:
> +	spin_unlock_irqrestore(&ring->lock, flags);
> +	return PTR_ERR(buf);
> +}
> +EXPORT_SYMBOL_GPL(imx_media_dma_buf_queue_from_vb);
> +
> +void imx_media_dma_buf_done(struct imx_media_dma_buf *buf,
> +			    enum imx_media_dma_buf_status status)
> +{
> +	struct imx_media_dma_buf_ring *ring = buf->ring;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ring->lock, flags);
> +	WARN_ON(buf->state != IMX_MEDIA_BUF_STATUS_ACTIVE);
> +	buf->state = buf->status = status;
> +	spin_unlock_irqrestore(&ring->lock, flags);
> +
> +	if (buf == &ring->scratch)
> +		dev_dbg(ring->imxmd->dev, "buf-scratch [%s -> %s] done\n",
> +			ring->src->name, ring->sink->name);
> +	else
> +		dev_dbg(ring->imxmd->dev, "buf%d [%s -> %s] done\n",
> +			buf->index, ring->src->name, ring->sink->name);
> +
> +	/* if the sink is a subdev, inform it that new buffers are available */
> +	if (is_media_entity_v4l2_subdev(ring->sink)) {
> +		struct v4l2_subdev *sd =
> +			media_entity_to_v4l2_subdev(ring->sink);
> +		v4l2_subdev_call(sd, core, ioctl, IMX_MEDIA_NEW_DMA_BUF, NULL);

What is the purpose of this if the sink should be triggered by the FSU?

[...]
> +/*
> + * The subdevs have to be powered on/off, and streaming
> + * enabled/disabled, in a specific sequence.
> + */
> +static const u32 stream_on_seq[] = {
> +	IMX_MEDIA_GRP_ID_IC_PP,
> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
> +	IMX_MEDIA_GRP_ID_SMFC,
> +	IMX_MEDIA_GRP_ID_SENSOR,
> +	IMX_MEDIA_GRP_ID_CSI2,
> +	IMX_MEDIA_GRP_ID_VIDMUX,
> +	IMX_MEDIA_GRP_ID_CSI,
> +};
> +
> +static const u32 stream_off_seq[] = {
> +	IMX_MEDIA_GRP_ID_IC_PP,
> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
> +	IMX_MEDIA_GRP_ID_SMFC,
> +	IMX_MEDIA_GRP_ID_CSI,
> +	IMX_MEDIA_GRP_ID_VIDMUX,
> +	IMX_MEDIA_GRP_ID_CSI2,
> +	IMX_MEDIA_GRP_ID_SENSOR,
> +};
> +
> +#define NUM_STREAM_ENTITIES ARRAY_SIZE(stream_on_seq)
> +
> +static const u32 power_on_seq[] = {
> +	IMX_MEDIA_GRP_ID_CSI2,
> +	IMX_MEDIA_GRP_ID_SENSOR,
> +	IMX_MEDIA_GRP_ID_VIDMUX,
> +	IMX_MEDIA_GRP_ID_CSI,
> +	IMX_MEDIA_GRP_ID_SMFC,
> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
> +	IMX_MEDIA_GRP_ID_IC_PP,
> +};
> +
> +static const u32 power_off_seq[] = {
> +	IMX_MEDIA_GRP_ID_IC_PP,
> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
> +	IMX_MEDIA_GRP_ID_SMFC,
> +	IMX_MEDIA_GRP_ID_CSI,
> +	IMX_MEDIA_GRP_ID_VIDMUX,
> +	IMX_MEDIA_GRP_ID_SENSOR,
> +	IMX_MEDIA_GRP_ID_CSI2,
> +};

This seems somewhat arbitrary. Why is a power sequence needed?

[...]
> +/*
> + * Turn current pipeline power on/off starting from start_entity.
> + * Must be called with mdev->graph_mutex held.
> + */
> +int imx_media_pipeline_set_power(struct imx_media_dev *imxmd,
> +				 struct media_entity_graph *graph,
> +				 struct media_entity *start_entity, bool on)
> +{
> +	struct media_entity *entity;
> +	struct v4l2_subdev *sd;
> +	int i, ret = 0;
> +	u32 id;
> +
> +	for (i = 0; i < NUM_POWER_ENTITIES; i++) {
> +		id = on ? power_on_seq[i] : power_off_seq[i];
> +		entity = find_pipeline_entity(imxmd, graph, start_entity, id);
> +		if (!entity)
> +			continue;
> +
> +		sd = media_entity_to_v4l2_subdev(entity);
> +
> +		ret = v4l2_subdev_call(sd, core, s_power, on);
> +		if (ret && ret != -ENOIOCTLCMD)
> +			break;
> +	}
> +
> +	return (ret && ret != -ENOIOCTLCMD) ? ret : 0;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_pipeline_set_power);

This should really be handled by v4l2_pipeline_pm_use.

> +/*
> + * Inherit the v4l2 controls from all entities in a pipeline
> + * to the given video device.
> + * Must be called with mdev->graph_mutex held.
> + */
> +int imx_media_inherit_controls(struct imx_media_dev *imxmd,
> +			       struct video_device *vfd,
> +			       struct media_entity *start_entity)
> +{
> +	struct media_entity_graph graph;
> +	struct media_entity *entity;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	ret = media_entity_graph_walk_init(&graph, &imxmd->md);
> +	if (ret)
> +		return ret;
> +
> +	media_entity_graph_walk_start(&graph, start_entity);
> +
> +	while ((entity = media_entity_graph_walk_next(&graph))) {
> +		if (is_media_entity_v4l2_video_device(entity))
> +			continue;
> +
> +		sd = media_entity_to_v4l2_subdev(entity);
> +
> +		dev_dbg(imxmd->dev, "%s: adding controls from %s\n",
> +			__func__, sd->name);
> +
> +		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
> +					    sd->ctrl_handler,
> +					    NULL);
> +		if (ret)
> +			break;
> +	}
> +
> +	media_entity_graph_walk_cleanup(&graph);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(imx_media_inherit_controls);
> +
> +MODULE_DESCRIPTION("i.MX5/6 v4l2 media controller driver");
> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> new file mode 100644
> index 0000000..357654d
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-dev.c

This file is full of code that should live in the v4l2 core.

[...]
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-internal-sd.c
[...]
> +int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
> +				   struct imx_media_subdev *csi[4])
> +{
> +	int ret;
> +
> +	/* there must be at least one CSI in first IPU */

Why?

> +	if (!(csi[0] || csi[1]))
> +		return -EINVAL;
> +
> +	ret = add_ipu_internal_subdevs(imxmd, csi[0], csi[1], 0);
> +	if (ret)
> +		return ret;
> +
> +	if (csi[2] || csi[3])
> +		ret = add_ipu_internal_subdevs(imxmd, csi[2], csi[3], 1);
> +
> +	return ret;
> +}
> diff --git a/drivers/staging/media/imx/imx-media-of.c b/drivers/staging/media/imx/imx-media-of.c
> new file mode 100644
> index 0000000..a939c34
> --- /dev/null
> +++ b/drivers/staging/media/imx/imx-media-of.c
> @@ -0,0 +1,289 @@
> +/*
> + * Media driver for Freescale i.MX5/6 SOC
> + *
> + * Open Firmware parsing.
> + *
> + * Copyright (c) 2016 Mentor Graphics Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +#include <linux/of_platform.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/videobuf2-dma-contig.h>
> +#include <video/imx-ipu-v3.h>
> +#include "imx-media.h"
> +
> +static int of_add_pad_link(struct imx_media_dev *imxmd,
> +			   struct imx_media_pad *pad,
> +			   struct device_node *local_sd_node,
> +			   struct device_node *remote_sd_node,
> +			   int local_pad, int remote_pad)
> +{
> +	dev_dbg(imxmd->dev, "%s: adding %s:%d -> %s:%d\n", __func__,
> +		local_sd_node->name, local_pad,
> +		remote_sd_node->name, remote_pad);
> +
> +	return imx_media_add_pad_link(imxmd, pad, remote_sd_node, NULL,
> +				      local_pad, remote_pad);
> +}
> +
> +/* parse inputs property from a sensor node */
> +static void of_parse_sensor_inputs(struct imx_media_dev *imxmd,
> +				   struct imx_media_subdev *sensor,
> +				   struct device_node *sensor_np)
> +{
> +	struct imx_media_sensor_input *sinput = &sensor->input;
> +	int ret, i;
> +
> +	for (i = 0; i < IMX_MEDIA_MAX_SENSOR_INPUTS; i++) {
> +		const char *input_name;
> +		u32 val;
> +
> +		ret = of_property_read_u32_index(sensor_np, "inputs", i, &val);
> +		if (ret)
> +			break;
> +
> +		sinput->value[i] = val;
> +
> +		ret = of_property_read_string_index(sensor_np, "input-names",
> +						    i, &input_name);
> +		/*
> +		 * if input-names not provided, they will be set using
> +		 * the subdev name once the sensor is known during
> +		 * async bind
> +		 */
> +		if (!ret)
> +			strncpy(sinput->name[i], input_name,
> +				sizeof(sinput->name[i]));
> +	}
> +
> +	sinput->num = i;
> +
> +	/* if no inputs provided just assume a single input */
> +	if (sinput->num == 0)
> +		sinput->num = 1;
> +}

This should be parsed by the sensor driver, not imx-media.

> +static void of_parse_sensor(struct imx_media_dev *imxmd,
> +			    struct imx_media_subdev *sensor,
> +			    struct device_node *sensor_np)
> +{
> +	struct device_node *endpoint;
> +
> +	of_parse_sensor_inputs(imxmd, sensor, sensor_np);
> +
> +	endpoint = of_graph_get_next_endpoint(sensor_np, NULL);
> +	if (endpoint) {
> +		v4l2_of_parse_endpoint(endpoint, &sensor->sensor_ep);
> +		of_node_put(endpoint);
> +	}
> +}
> +
> +static int of_get_port_count(const struct device_node *np)
> +{
> +	struct device_node *child;
> +	int num = 0;
> +
> +	/* if this node is itself a port, return 1 */
> +	if (of_node_cmp(np->name, "port") == 0)
> +		return 1;
> +
> +	for_each_child_of_node(np, child)
> +		if (of_node_cmp(child->name, "port") == 0)
> +			num++;
> +
> +	return num;
> +}

If this is extended to handle the ports subnode properly, it could be
moved into drivers/of/base.c.

regards
Philipp

