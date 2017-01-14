Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35516 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750721AbdANWqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jan 2017 17:46:48 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
 <1484320822.31475.96.camel@pengutronix.de>
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
Message-ID: <a94025b4-c4dd-de51-572e-d2615a7246e4@gmail.com>
Date: Sat, 14 Jan 2017 14:46:45 -0800
MIME-Version: 1.0
In-Reply-To: <1484320822.31475.96.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(sorry sending again w/o html)


On 01/13/2017 07:20 AM, Philipp Zabel wrote:
> Am Freitag, den 06.01.2017, 18:11 -0800 schrieb Steve Longerbeam:
>> +For image capture, the IPU contains the following internal subunits:
>> +
>> +- Image DMA Controller (IDMAC)
>> +- Camera Serial Interface (CSI)
>> +- Image Converter (IC)
>> +- Sensor Multi-FIFO Controller (SMFC)
>> +- Image Rotator (IRT)
>> +- Video De-Interlace Controller (VDIC)
> Nitpick: Video De-Interlacing or Combining Block (VDIC)

done.

>> +
>> +The IDMAC is the DMA controller for transfer of image frames to and from
>> +memory. Various dedicated DMA channels exist for both video capture and
>> +display paths.
>> +
>> +The CSI is the frontend capture unit that interfaces directly with
>> +capture sensors over Parallel, BT.656/1120, and MIPI CSI-2 busses.
>> +
>> +The IC handles color-space conversion, resizing, and rotation
>> +operations.
> And horizontal flipping.

done.


>> There are three independent "tasks" within the IC that can
>> +carry out conversions concurrently: pre-processing encoding,
>> +pre-processing preview, and post-processing.
> s/preview/viewfinder/ seems to be the commonly used name.

replaced everywhere in the doc.

> This paragraph could mention that a single hardware unit is used
> transparently time multiplexed by the three tasks at different
> granularity for the downsizing, main processing, and rotation sections.
> The downscale unit switches between tasks at 8-pixel burst granularity,
> the main processing unit at line granularity. The rotation units switch
> only at frame granularity.

I've added that info.

>> +The SMFC is composed of four independent channels that each can transfer
>> +captured frames from sensors directly to memory concurrently.
>> +
>> +The IRT carries out 90 and 270 degree image rotation operations.
> ... on 8x8 pixel blocks, supported by the IDMAC which handles block
> transfers, block reordering, and vertical flipping.

done.

>> +The VDIC handles the conversion of interlaced video to progressive, with
>> +support for different motion compensation modes (low, medium, and high
>> +motion). The deinterlaced output frames from the VDIC can be sent to the
>> +IC pre-process preview task for further conversions.
>> +
>> +In addition to the IPU internal subunits, there are also two units
>> +outside the IPU that are also involved in video capture on i.MX:
>> +
>> +- MIPI CSI-2 Receiver for camera sensors with the MIPI CSI-2 bus
>> +  interface. This is a Synopsys DesignWare core.
>> +- A video multiplexer for selecting among multiple sensor inputs to
>> +  send to a CSI.
> Two of them, actually.

done.

>> +
>> +- Includes a Frame Interval Monitor (FIM) that can correct vertical sync
>> +  problems with the ADV718x video decoders. See below for a description
>> +  of the FIM.
> Could this also be used to calculate more precise capture timestamps?

An input capture function could do that, triggered off a VSYNC or FIELD
signal such as on the ADV718x. The FIM is only used to calculate
frame intervals at this point, but its input capture method could be
used to also record more accurate timestamps.


>> +Capture Pipelines
>> +-----------------
>> +
>> +The following describe the various use-cases supported by the pipelines.
>> +
>> +The links shown do not include the frontend sensor, video mux, or mipi
>> +csi-2 receiver links. This depends on the type of sensor interface
>> +(parallel or mipi csi-2). So in all cases, these pipelines begin with:
>> +
>> +sensor -> ipu_csi_mux -> ipu_csi -> ...
>> +
>> +for parallel sensors, or:
>> +
>> +sensor -> imx-mipi-csi2 -> (ipu_csi_mux) -> ipu_csi -> ...
>> +
>> +for mipi csi-2 sensors. The imx-mipi-csi2 receiver may need to route
>> +to the video mux (ipu_csi_mux) before sending to the CSI, depending
>> +on the mipi csi-2 virtual channel, hence ipu_csi_mux is shown in
>> +parenthesis.
>> +
>> +Unprocessed Video Capture:
>> +--------------------------
>> +
>> +Send frames directly from sensor to camera interface, with no
>> +conversions:
>> +
>> +-> ipu_smfc -> camif
> I'd call this capture interface, this is not just for cameras. Or maybe
> idmac if you want to mirror hardware names?

Camif is so named because it is the V4L2 user interface for video
capture. I suppose it could be named "capif", but that doesn't role
off the tongue quite as well.

>> +Note the ipu_smfc can do pixel reordering within the same colorspace.
> That isn't a feature of the SMFC, but of the IDMAC (FCW & FCR).

yes, the doc is re-worded to make that more clear.

>> +For example, its sink pad can take UYVY2X8, but its source pad can
>> +output YUYV2X8.
> I don't think this is correct. Re-reading "37.4.3.7 Packing to memory"
> in the CSI chapter, for 8-bit per component data, the internal format
> between CSI, SMFC, and IDMAC is always some 32-bit RGBx/YUVx variant
> (or "bayer/generic data"). In either case, the internal format does not
> change along the way.

these are pixels in memory buffers, not the IPU internal formats.


>> +IC Direct Conversions:
>> +----------------------
>> +
>> +This pipeline uses the preprocess encode entity to route frames directly
>> +from the CSI to the IC (bypassing the SMFC), to carry out scaling up to
>> +1024x1024 resolution, CSC, and image rotation:
>> +
>> +-> ipu_ic_prpenc -> camif
>> +
>> +This can be a useful capture pipeline for heavily loaded memory bus
>> +traffic environments, since it has minimal IDMAC channel usage.
> Note that if rotation is enabled, transfers between IC processing and
> rotation still have to go through memory once.

yep.

>> +Post-Processing Conversions:
>> +----------------------------
>> +
>> +This pipeline routes frames from the SMFC to the post-processing
>> +entity.
> No, frames written by the CSI -> SMFC -> IDMAC path are read back into
> the post-processing entity.

that's true. The post-processing entity kicks off its read channels
to transfer those frames into the post-processor. Anyway this wording
will change after doing away with the SMFC entity.


>> +   media-ctl -V "\"ipu1_csi0\":1 [fmt:YUYV2X8/640x480]"
>> +   media-ctl -V "\"ipu1_smfc0\":0 [fmt:YUYV2X8/640x480]"
>> +   media-ctl -V "\"ipu1_smfc0\":1 [fmt:UYVY2X8/640x480]"
> I think the smfc entities should be dropped.

yes working on that.

>> +   media-ctl -V "\"camif0\":0 [fmt:UYVY2X8/640x480]"
>> +   media-ctl -V "\"camif0\":1 [fmt:UYVY2X8/640x480]"
>> +   # Configure pads for OV5640 pipeline
>> +   media-ctl -V "\"ov5640_mipi 1-0040\":0 [fmt:UYVY2X8/640x480]"
>> +   media-ctl -V "\"imx-mipi-csi2\":0 [fmt:UYVY2X8/640x480]"
>> +   media-ctl -V "\"imx-mipi-csi2\":2 [fmt:UYVY2X8/640x480]"
>> +   media-ctl -V "\"ipu1_csi1\":0 [fmt:UYVY2X8/640x480]"
>> +   media-ctl -V "\"ipu1_csi1\":1 [fmt:UYVY2X8/640x480]"
> [...]
>> +   media-ctl -V "\"camif1\":0 [fmt:UYVY2X8/640x480]"
> I agree this looks very intuitive, but technically correct for the
> csi1:1 and camif1:0 pads would be a 32-bit YUV format.
> (MEDIA_BUS_FMT_YUV8_1X32_PADLO doesn't exist yet).
>
> I think it would be better to use the correct format

I'm not sure I follow you here.

>   as that will allow
> to chose the regular vs. companded packings in the future for formats
> with more than 8 bits per component.
>
>> +   media-ctl -V "\"camif1\":1 [fmt:UYVY2X8/640x480]"
>> +
>> +Streaming can then begin independently on device nodes /dev/video0
>> +and /dev/video1.
>> +
>> +SabreAuto with ADV7180 decoder
>> +------------------------------
>> +
>> +On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
>> +parallel bus input on the internal video mux to IPU1 CSI0.
>> +
>> +The following example configures a pipeline to capture from the ADV7180
>> +video decoder, assuming NTSC 720x480 input signals, with Motion
>> +Compensated de-interlacing (not shown: all pad field types should be set
>> +as indicated). $outputfmt can be any format supported by the
>> +ipu1_ic_prpvf entity at its output pad:
>> +
>> +.. code-block:: none
>> +
>> +   # Setup links
>> +   media-ctl -l '"adv7180 3-0021":0 -> "ipu1_csi0_mux":1[1]'
>> +   media-ctl -l '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
>> +   media-ctl -l '"ipu1_csi0":1 -> "ipu1_smfc0":0[1]'
>> +   media-ctl -l '"ipu1_smfc0":1 -> "ipu1_ic_prpvf":0[1]'
>> +   media-ctl -l '"ipu1_ic_prpvf":1 -> "camif0":0[1]'
>> +   media-ctl -l '"camif0":1 -> "camif0 devnode":0[1]'
>> +   # Configure pads
>> +   # pad field types for below pads must be an interlaced type
>> +   # such as "ALTERNATE"
> I think alternate should only extend as far as the CSI, since the CSI
> can only capture NTSC/PAL fields in a fixed order.

Agreed, I'm doing the translation from alternate to seq_bt/seq_tb depending
on sensor std in imx-vdic.c, but it should move upstream. Will fix.

>> +   media-ctl -V "\"adv7180 3-0021\":0 [fmt:UYVY2X8/720x480]"
>> +   media-ctl -V "\"ipu1_csi0_mux\":1 [fmt:UYVY2X8/720x480]"
>  From here the interlaced field type should be sequential in the correct
> order depending on NTSC/PAL.

right.

>> +
>> +Frame Interval Monitor
>> +----------------------
>> +
>> +The adv718x decoders can occasionally send corrupt fields during
>> +NTSC/PAL signal re-sync (too little or too many video lines). When
>> +this happens, the IPU triggers a mechanism to re-establish vertical
>> +sync by adding 1 dummy line every frame, which causes a rolling effect
>> +from image to image, and can last a long time before a stable image is
>> +recovered. Or sometimes the mechanism doesn't work at all, causing a
>> +permanent split image (one frame contains lines from two consecutive
>> +captured images).
> Is it only SabreAuto on which the FIM mechanism can be used due to the
> pad routing?

No, FIM can be used on any target, the fim child node of ipu_csi just
needs to be enabled via status property.

> [...]
>> +/*
>> + * DMA buffer ring handling
>> + */
>> +struct imx_media_dma_buf_ring {
>> +	struct imx_media_dev *imxmd;
>> +
>> +	/* the ring */
>> +	struct imx_media_dma_buf buf[IMX_MEDIA_MAX_RING_BUFS];
>> +	/* the scratch buffer for underruns */
>> +	struct imx_media_dma_buf scratch;
>> +
>> +	/* buffer generator */
>> +	struct media_entity *src;
>> +	/* buffer receiver */
>> +	struct media_entity *sink;
>> +
>> +	spinlock_t lock;
>> +
>> +	int num_bufs;
>> +	unsigned long last_seq;
>> +};
> I don't think this belongs in the capture driver at all.
> Memory-to-memory transfers should be handled at the videobuf2 level.

see below.

> [...]
>> +static struct imx_media_dma_buf *
>> +__dma_buf_queue(struct imx_media_dma_buf_ring *ring, int index)
>> +{
>> +	struct imx_media_dma_buf *buf;
>> +
>> +	if (index >= ring->num_bufs)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	buf = &ring->buf[index];
>> +	if (WARN_ON(buf->state != IMX_MEDIA_BUF_STATUS_PREPARED))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	buf->state = IMX_MEDIA_BUF_STATUS_QUEUED;
>> +	buf->seq = ring->last_seq++;
>> +
>> +	return buf;
>> +}
> Is this a whole software buffer queue implementation? I thought the
> whole point of putting the custom mem2mem framework into the capture
> driver was to use the hardware FSU channel linking?

  see below.

> What is the purpose of this if the sink should be triggered by the FSU?

Ok, here is where I need to make an admission.

The only FSU links I have attempted (and which currently have entries
in the fsu_link_info[] table), are the enc/vf/pp --> IRT links for rotation.

There does not appear to be support in the FSU for linking a write channel
to the VDIC read channels (8, 9, 10) according to VDI_SRC_SEL field. There
is support for the direct link from CSI (which I am using), but that's 
not an
IDMAC channel link.

There is a PRP_SRC_SEL field, with linking from IDMAC (SMFC) channels
0..2 (and 3? it's not clear, and not clear whether this includes channel 1).
But I think this links to channel 12, and not to channels 8,9,10 to the 
VDIC.
Or will it? It's worth experimenting. It would have helped if FSL listed 
which
IDMAC channels these FSU links correspond to, instead of making us guess
at it.

In any event, the docs are not clear enough to implement a real FSU
link to the VDIC read channels, if it's even possible. And trying to get
programming help from FSL can be difficult, and no coding examples
for this link AFAIK.

So I ended resorted to linking to VDIC channels 8,9,10 with a software
approach, instead of attempting a hardware FSU link.

The EOF interrupt handler for the SMFC channels informs the VDIC
entity via a v4l2_subdev_ioctl() call that a buffer is available. The
VDIC then manually kicks off its read channels to bring that buffer
(and a previous buffer for F(n-1) field) into the VDIC.

There is a small amount of extra overhead going this route compared
to a FSU hardware link: there is the EOF irq latency (a few usec), and
the CPU overhead for the VDIC to manually start the read channels,
which is also a few usec at most (see prepare_vdi_in_buffers() in
imx-vdic.c). So in total at most ~10 usec of extra overhead (CPU
use plus irq latency) under normal system load.

Of course, in order to implement this software link, I had to implement
a straightforward FIFO dma buffer ring. The sink (VDIC) allocates the ring
at stream on, and the source requests a pointer to this ring in its own
stream on. Passing buffers from source to sink then follows a 
straightforward
FIFO queue/done/dequeue/queue model: sink queues buffers to src, src
grabs queued buffers and makes them active, src signals completed
buffers to sink, sink dequeues buffers in response, and sink queues
buffers back when it is finished with them.


> [...]
>> +/*
>> + * The subdevs have to be powered on/off, and streaming
>> + * enabled/disabled, in a specific sequence.
>> + */
>> +static const u32 stream_on_seq[] = {
>> +	IMX_MEDIA_GRP_ID_IC_PP,
>> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
>> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
>> +	IMX_MEDIA_GRP_ID_SMFC,
>> +	IMX_MEDIA_GRP_ID_SENSOR,
>> +	IMX_MEDIA_GRP_ID_CSI2,
>> +	IMX_MEDIA_GRP_ID_VIDMUX,
>> +	IMX_MEDIA_GRP_ID_CSI,
>> +};
>> +
>> +static const u32 stream_off_seq[] = {
>> +	IMX_MEDIA_GRP_ID_IC_PP,
>> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
>> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
>> +	IMX_MEDIA_GRP_ID_SMFC,
>> +	IMX_MEDIA_GRP_ID_CSI,
>> +	IMX_MEDIA_GRP_ID_VIDMUX,
>> +	IMX_MEDIA_GRP_ID_CSI2,
>> +	IMX_MEDIA_GRP_ID_SENSOR,
>> +};
>> +
>> +#define NUM_STREAM_ENTITIES ARRAY_SIZE(stream_on_seq)
>> +
>> +static const u32 power_on_seq[] = {
>> +	IMX_MEDIA_GRP_ID_CSI2,
>> +	IMX_MEDIA_GRP_ID_SENSOR,
>> +	IMX_MEDIA_GRP_ID_VIDMUX,
>> +	IMX_MEDIA_GRP_ID_CSI,
>> +	IMX_MEDIA_GRP_ID_SMFC,
>> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
>> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
>> +	IMX_MEDIA_GRP_ID_IC_PP,
>> +};
>> +
>> +static const u32 power_off_seq[] = {
>> +	IMX_MEDIA_GRP_ID_IC_PP,
>> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
>> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
>> +	IMX_MEDIA_GRP_ID_SMFC,
>> +	IMX_MEDIA_GRP_ID_CSI,
>> +	IMX_MEDIA_GRP_ID_VIDMUX,
>> +	IMX_MEDIA_GRP_ID_SENSOR,
>> +	IMX_MEDIA_GRP_ID_CSI2,
>> +};
> This seems somewhat arbitrary. Why is a power sequence needed?

The CSI-2 receiver must be powered up before the sensor, that's the
only requirement IIRC. The others have no s_power requirement. So I
can probably change this to power up in the frontend -> backend order
(IC_PP to sensor). And vice-versa for power off.


> [...]
>> +/*
>> + * Turn current pipeline power on/off starting from start_entity.
>> + * Must be called with mdev->graph_mutex held.
>> + */
>> +int imx_media_pipeline_set_power(struct imx_media_dev *imxmd,
>> +				 struct media_entity_graph *graph,
>> +				 struct media_entity *start_entity, bool on)
>> +{
>> +	struct media_entity *entity;
>> +	struct v4l2_subdev *sd;
>> +	int i, ret = 0;
>> +	u32 id;
>> +
>> +	for (i = 0; i < NUM_POWER_ENTITIES; i++) {
>> +		id = on ? power_on_seq[i] : power_off_seq[i];
>> +		entity = find_pipeline_entity(imxmd, graph, start_entity, id);
>> +		if (!entity)
>> +			continue;
>> +
>> +		sd = media_entity_to_v4l2_subdev(entity);
>> +
>> +		ret = v4l2_subdev_call(sd, core, s_power, on);
>> +		if (ret && ret != -ENOIOCTLCMD)
>> +			break;
>> +	}
>> +
>> +	return (ret && ret != -ENOIOCTLCMD) ? ret : 0;
>> +}
>> +EXPORT_SYMBOL_GPL(imx_media_pipeline_set_power);
> This should really be handled by v4l2_pipeline_pm_use.

I thought about this earlier, but v4l2_pipeline_pm_use() seems to be
doing some other stuff that bothered me, at least that's what I remember.
I will revisit this.

>> +/*
>> + * Inherit the v4l2 controls from all entities in a pipeline
>> + * to the given video device.
>> + * Must be called with mdev->graph_mutex held.
>> + */
>> +int imx_media_inherit_controls(struct imx_media_dev *imxmd,
>> +			       struct video_device *vfd,
>> +			       struct media_entity *start_entity)
>> +{
>> +	struct media_entity_graph graph;
>> +	struct media_entity *entity;
>> +	struct v4l2_subdev *sd;
>> +	int ret;
>> +
>> +	ret = media_entity_graph_walk_init(&graph, &imxmd->md);
>> +	if (ret)
>> +		return ret;
>> +
>> +	media_entity_graph_walk_start(&graph, start_entity);
>> +
>> +	while ((entity = media_entity_graph_walk_next(&graph))) {
>> +		if (is_media_entity_v4l2_video_device(entity))
>> +			continue;
>> +
>> +		sd = media_entity_to_v4l2_subdev(entity);
>> +
>> +		dev_dbg(imxmd->dev, "%s: adding controls from %s\n",
>> +			__func__, sd->name);
>> +
>> +		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
>> +					    sd->ctrl_handler,
>> +					    NULL);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	media_entity_graph_walk_cleanup(&graph);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(imx_media_inherit_controls);
>> +
>> +MODULE_DESCRIPTION("i.MX5/6 v4l2 media controller driver");
>> +MODULE_AUTHOR("Steve Longerbeam<steve_longerbeam@mentor.com>");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
>> new file mode 100644
>> index 0000000..357654d
>> --- /dev/null
>> +++ b/drivers/staging/media/imx/imx-media-dev.c
> This file is full of code that should live in the v4l2 core.

Agreed. Stuff like imx_media_inherit_controls() really should be widely
available.

>> +int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
>> +				   struct imx_media_subdev *csi[4])
>> +{
>> +	int ret;
>> +
>> +	/* there must be at least one CSI in first IPU */
> Why?

Well yeah, imx-media doesn't necessarily need a CSI if things
like the VDIC or post-processor are being used by an output
overlay pipeline, for example. I'll fix this.

>> +
>> +/* parse inputs property from a sensor node */
>> +static void of_parse_sensor_inputs(struct imx_media_dev *imxmd,
>> +				   struct imx_media_subdev *sensor,
>> +				   struct device_node *sensor_np)
>> +{
>> +	struct imx_media_sensor_input *sinput = &sensor->input;
>> +	int ret, i;
>> +
>> +	for (i = 0; i < IMX_MEDIA_MAX_SENSOR_INPUTS; i++) {
>> +		const char *input_name;
>> +		u32 val;
>> +
>> +		ret = of_property_read_u32_index(sensor_np, "inputs", i, &val);
>> +		if (ret)
>> +			break;
>> +
>> +		sinput->value[i] = val;
>> +
>> +		ret = of_property_read_string_index(sensor_np, "input-names",
>> +						    i, &input_name);
>> +		/*
>> +		 * if input-names not provided, they will be set using
>> +		 * the subdev name once the sensor is known during
>> +		 * async bind
>> +		 */
>> +		if (!ret)
>> +			strncpy(sinput->name[i], input_name,
>> +				sizeof(sinput->name[i]));
>> +	}
>> +
>> +	sinput->num = i;
>> +
>> +	/* if no inputs provided just assume a single input */
>> +	if (sinput->num == 0)
>> +		sinput->num = 1;
>> +}
> This should be parsed by the sensor driver, not imx-media.

you're probably right. I'll submit a patch for adv7180.c.


>> +static void of_parse_sensor(struct imx_media_dev *imxmd,
>> +			    struct imx_media_subdev *sensor,
>> +			    struct device_node *sensor_np)
>> +{
>> +	struct device_node *endpoint;
>> +
>> +	of_parse_sensor_inputs(imxmd, sensor, sensor_np);
>> +
>> +	endpoint = of_graph_get_next_endpoint(sensor_np, NULL);
>> +	if (endpoint) {
>> +		v4l2_of_parse_endpoint(endpoint, &sensor->sensor_ep);
>> +		of_node_put(endpoint);
>> +	}
>> +}
>> +
>> +static int of_get_port_count(const struct device_node *np)
>> +{
>> +	struct device_node *child;
>> +	int num = 0;
>> +
>> +	/* if this node is itself a port, return 1 */
>> +	if (of_node_cmp(np->name, "port") == 0)
>> +		return 1;
>> +
>> +	for_each_child_of_node(np, child)
>> +		if (of_node_cmp(child->name, "port") == 0)
>> +			num++;
>> +
>> +	return num;
>> +}
> If this is extended to handle the ports subnode properly, it could be
> moved into drivers/of/base.c.

More that eventually needs exporting, agreed.


Steve

