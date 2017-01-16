Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38831 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751212AbdAPNtV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 08:49:21 -0500
Message-ID: <1484574468.8415.136.camel@pengutronix.de>
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
Date: Mon, 16 Jan 2017 14:47:48 +0100
In-Reply-To: <a94025b4-c4dd-de51-572e-d2615a7246e4@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
         <1484320822.31475.96.camel@pengutronix.de>
         <a94025b4-c4dd-de51-572e-d2615a7246e4@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2017-01-14 at 14:46 -0800, Steve Longerbeam wrote:
[...]
> >> +Unprocessed Video Capture:
> >> +--------------------------
> >> +
> >> +Send frames directly from sensor to camera interface, with no
> >> +conversions:
> >> +
> >> +-> ipu_smfc -> camif
> > I'd call this capture interface, this is not just for cameras. Or maybe
> > idmac if you want to mirror hardware names?
> 
> Camif is so named because it is the V4L2 user interface for video
> capture. I suppose it could be named "capif", but that doesn't role
> off the tongue quite as well.

Agreed, capif sounds weird. I find camif a bit confusing though, because
Samsung S3C has a camera interface that is actually called "CAMIF".

> >> +Note the ipu_smfc can do pixel reordering within the same colorspace.
> > That isn't a feature of the SMFC, but of the IDMAC (FCW & FCR).
> 
> yes, the doc is re-worded to make that more clear.
> 
> >> +For example, its sink pad can take UYVY2X8, but its source pad can
> >> +output YUYV2X8.
> > I don't think this is correct. Re-reading "37.4.3.7 Packing to memory"
> > in the CSI chapter, for 8-bit per component data, the internal format
> > between CSI, SMFC, and IDMAC is always some 32-bit RGBx/YUVx variant
> > (or "bayer/generic data"). In either case, the internal format does not
> > change along the way.
> 
> these are pixels in memory buffers, not the IPU internal formats.

As long as we are talking about the CSI -> SMFC -> IDMAC path, these
should be IPU internal formats. How else would one choose between 8-bit
companded RGB, and 16-bit expanded RGB for a 10-bit per component input
signal? This is the same issue as in the next comment.

> >> +   media-ctl -V "\"camif0\":0 [fmt:UYVY2X8/640x480]"
> >> +   media-ctl -V "\"camif0\":1 [fmt:UYVY2X8/640x480]"
> >> +   # Configure pads for OV5640 pipeline
> >> +   media-ctl -V "\"ov5640_mipi 1-0040\":0 [fmt:UYVY2X8/640x480]"
> >> +   media-ctl -V "\"imx-mipi-csi2\":0 [fmt:UYVY2X8/640x480]"
> >> +   media-ctl -V "\"imx-mipi-csi2\":2 [fmt:UYVY2X8/640x480]"
> >> +   media-ctl -V "\"ipu1_csi1\":0 [fmt:UYVY2X8/640x480]"
> >> +   media-ctl -V "\"ipu1_csi1\":1 [fmt:UYVY2X8/640x480]"
> > [...]
> >> +   media-ctl -V "\"camif1\":0 [fmt:UYVY2X8/640x480]"
> > I agree this looks very intuitive, but technically correct for the
> > csi1:1 and camif1:0 pads would be a 32-bit YUV format.
> > (MEDIA_BUS_FMT_YUV8_1X32_PADLO doesn't exist yet).
> >
> > I think it would be better to use the correct format
> 
> I'm not sure I follow you here.

The ov5640 sends UYVY2X8 on the wire, so pads "ov5640_mipi 1-0040":0
up to "ipu1_csi1":0 are correct. But the CSI writes 32-bit YUV values
into the SMFC, so the CSI output pad and the IDMAC input pad should have
a YUV8_1X32 format.

Chapter 37.4.2.3 "FCW & FCR - Format converter write and read" in the
IDMAC chapter states that all internal submodules only work on 8-bit per
component formats with four components: YUVA or RGBA.

> > [...]
> > Is this a whole software buffer queue implementation? I thought the
> > whole point of putting the custom mem2mem framework into the capture
> > driver was to use the hardware FSU channel linking?
> 
>   see below.
> 
> > What is the purpose of this if the sink should be triggered by the FSU?
> 
> Ok, here is where I need to make an admission.
> 
> The only FSU links I have attempted (and which currently have entries
> in the fsu_link_info[] table), are the enc/vf/pp --> IRT links for rotation.

Which are not described as media entity links because the rotation units
do not have separate media entities. So me arguing against handling
mem2mem chaining via media entity links doesn't concern these implicit
links.

> There does not appear to be support in the FSU for linking a write channel
> to the VDIC read channels (8, 9, 10) according to VDI_SRC_SEL field. There
> is support for the direct link from CSI (which I am using), but that's 
> not an
> IDMAC channel link.
> 
> There is a PRP_SRC_SEL field, with linking from IDMAC (SMFC) channels
> 0..2 (and 3? it's not clear, and not clear whether this includes channel 1).

As I read it, that is 0 and 2 only, no idea why. But since there are
only 2 CSIs, that shouldn't be a problem.

> But I think this links to channel 12, and not to channels 8,9,10 to the 
> VDIC.
> Or will it? It's worth experimenting. It would have helped if FSL listed 
> which
> IDMAC channels these FSU links correspond to, instead of making us guess
> at it.

I would have assumed that the FSU triggering only works on 1:1 channels
and the VDIC with its three input channels is different. But then
there's the alleged VDOA link to ch8/9/10 ro ch9, depending on
VDI_MOT_SEL.

This makes me more convinced that the CSI -> VDIC link should only
describe the direct path (real-time mode, single field).

> In any event, the docs are not clear enough to implement a real FSU
> link to the VDIC read channels, if it's even possible. And trying to get
> programming help from FSL can be difficult, and no coding examples
> for this link AFAIK.
> 
> So I ended resorted to linking to VDIC channels 8,9,10 with a software
> approach, instead of attempting a hardware FSU link.
> 
> The EOF interrupt handler for the SMFC channels informs the VDIC
> entity via a v4l2_subdev_ioctl() call that a buffer is available. The
> VDIC then manually kicks off its read channels to bring that buffer
> (and a previous buffer for F(n-1) field) into the VDIC.
> 
> There is a small amount of extra overhead going this route compared
> to a FSU hardware link: there is the EOF irq latency (a few usec), and
> the CPU overhead for the VDIC to manually start the read channels,
> which is also a few usec at most (see prepare_vdi_in_buffers() in
> imx-vdic.c). So in total at most ~10 usec of extra overhead (CPU
> use plus irq latency) under normal system load.

That the same low overhead could be reached by linking videobuf2 queues
of different video devices, that would be a lot more flexible.

> Of course, in order to implement this software link, I had to implement
> a straightforward FIFO dma buffer ring. The sink (VDIC) allocates the ring
> at stream on, and the source requests a pointer to this ring in its own
> stream on. Passing buffers from source to sink then follows a 
> straightforward
> FIFO queue/done/dequeue/queue model: sink queues buffers to src, src
> grabs queued buffers and makes them active, src signals completed
> buffers to sink, sink dequeues buffers in response, and sink queues
> buffers back when it is finished with them.

Thank you for the explanation.

[...]
> >> +static const u32 power_off_seq[] = {
> >> +	IMX_MEDIA_GRP_ID_IC_PP,
> >> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
> >> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
> >> +	IMX_MEDIA_GRP_ID_SMFC,
> >> +	IMX_MEDIA_GRP_ID_CSI,
> >> +	IMX_MEDIA_GRP_ID_VIDMUX,
> >> +	IMX_MEDIA_GRP_ID_SENSOR,
> >> +	IMX_MEDIA_GRP_ID_CSI2,
> >> +};
> > This seems somewhat arbitrary. Why is a power sequence needed?
> 
> The CSI-2 receiver must be powered up before the sensor, that's the
> only requirement IIRC. The others have no s_power requirement. So I
> can probably change this to power up in the frontend -> backend order
> (IC_PP to sensor). And vice-versa for power off.

Yes, I think that should work (see below).

> > [...]
> >> +/*
> >> + * Turn current pipeline power on/off starting from start_entity.
> >> + * Must be called with mdev->graph_mutex held.
> >> + */
> >> +int imx_media_pipeline_set_power(struct imx_media_dev *imxmd,
> >> +				 struct media_entity_graph *graph,
> >> +				 struct media_entity *start_entity, bool on)
> >> +{
> >> +	struct media_entity *entity;
> >> +	struct v4l2_subdev *sd;
> >> +	int i, ret = 0;
> >> +	u32 id;
> >> +
> >> +	for (i = 0; i < NUM_POWER_ENTITIES; i++) {
> >> +		id = on ? power_on_seq[i] : power_off_seq[i];
> >> +		entity = find_pipeline_entity(imxmd, graph, start_entity, id);
> >> +		if (!entity)
> >> +			continue;
> >> +
> >> +		sd = media_entity_to_v4l2_subdev(entity);
> >> +
> >> +		ret = v4l2_subdev_call(sd, core, s_power, on);
> >> +		if (ret && ret != -ENOIOCTLCMD)
> >> +			break;
> >> +	}
> >> +
> >> +	return (ret && ret != -ENOIOCTLCMD) ? ret : 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(imx_media_pipeline_set_power);
> > This should really be handled by v4l2_pipeline_pm_use.
> 
> I thought about this earlier, but v4l2_pipeline_pm_use() seems to be
> doing some other stuff that bothered me, at least that's what I remember.
> I will revisit this.

I have used it with a tc358743 -> mipi-csi2 pipeline, it didn't cause
any problems. It would be better to reuse and, if necessary, fix the
existing infrastructure where available.

> >> +int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
> >> +				   struct imx_media_subdev *csi[4])
> >> +{
> >> +	int ret;
> >> +
> >> +	/* there must be at least one CSI in first IPU */
> > Why?
> 
> Well yeah, imx-media doesn't necessarily need a CSI if things
> like the VDIC or post-processor are being used by an output
> overlay pipeline, for example. I'll fix this.

I haven't even thought that far, but there could be boards with only a
parallel sensor connected to IPU2 CSI1 and IPU1 disabled for power
saving reasons.

regards
Philipp

