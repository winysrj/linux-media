Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34685 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdAWCbl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Jan 2017 21:31:41 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 16/24] media: Add i.MX media core driver
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-17-git-send-email-steve_longerbeam@mentor.com>
 <1484320822.31475.96.camel@pengutronix.de>
 <a94025b4-c4dd-de51-572e-d2615a7246e4@gmail.com>
 <1484574468.8415.136.camel@pengutronix.de>
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
Message-ID: <e38feca9-ed6f-8288-e006-768d6ba2fe5a@gmail.com>
Date: Sun, 22 Jan 2017 18:31:37 -0800
MIME-Version: 1.0
In-Reply-To: <1484574468.8415.136.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/16/2017 05:47 AM, Philipp Zabel wrote:
> On Sat, 2017-01-14 at 14:46 -0800, Steve Longerbeam wrote:
> [...]
>>>> +Unprocessed Video Capture:
>>>> +--------------------------
>>>> +
>>>> +Send frames directly from sensor to camera interface, with no
>>>> +conversions:
>>>> +
>>>> +-> ipu_smfc -> camif
>>> I'd call this capture interface, this is not just for cameras. Or maybe
>>> idmac if you want to mirror hardware names?
>> Camif is so named because it is the V4L2 user interface for video
>> capture. I suppose it could be named "capif", but that doesn't role
>> off the tongue quite as well.
> Agreed, capif sounds weird. I find camif a bit confusing though, because
> Samsung S3C has a camera interface that is actually called "CAMIF".

how about simply "capture" ?


<snip>

>>> +   media-ctl -V "\"camif1\":0 [fmt:UYVY2X8/640x480]"
>> I agree this looks very intuitive, but technically correct for the
>> csi1:1 and camif1:0 pads would be a 32-bit YUV format.
>> (MEDIA_BUS_FMT_YUV8_1X32_PADLO doesn't exist yet).
>>
>> I think it would be better to use the correct format
>> I'm not sure I follow you here.
> The ov5640 sends UYVY2X8 on the wire, so pads "ov5640_mipi 1-0040":0
> up to "ipu1_csi1":0 are correct. But the CSI writes 32-bit YUV values
> into the SMFC, so the CSI output pad and the IDMAC input pad should have
> a YUV8_1X32 format.
>
> Chapter 37.4.2.3 "FCW & FCR - Format converter write and read" in the
> IDMAC chapter states that all internal submodules only work on 8-bit per
> component formats with four components: YUVA or RGBA.

Right, the "direct" IPU internal (that do not transfer buffers to/from
memory via IDMAC channels) should only allow the IPU internal
formats YUVA and RGBA. I get you now.

The "direct" pads now only accept MEDIA_BUS_FMT_AYUV8_1X32 and
MEDIA_BUS_FMT_ARGB8888_1X32.

Those pads are:

ipu_csi:1
ipu_vdic:1
ipu_ic_prp:0
ipu_ic_prp:1
ipu_ic_prpenc:0
ipu_ic_prpenc:1
ipu_ic_prpvf:0
ipu_ic_prpvf:1


<snip>
>
>> There does not appear to be support in the FSU for linking a write channel
>> to the VDIC read channels (8, 9, 10) according to VDI_SRC_SEL field. There
>> is support for the direct link from CSI (which I am using), but that's
>> not an
>> IDMAC channel link.
>>
>> There is a PRP_SRC_SEL field, with linking from IDMAC (SMFC) channels
>> 0..2 (and 3? it's not clear, and not clear whether this includes channel 1).
> As I read it, that is 0 and 2 only, no idea why. But since there are
> only 2 CSIs, that shouldn't be a problem.

ipu_csi1 is now transferring on IDMAC/SMFC channel 2 (ipu_csi0 still
at channel 0).

<snip>

>>>> +static const u32 power_off_seq[] = {
>>>> +	IMX_MEDIA_GRP_ID_IC_PP,
>>>> +	IMX_MEDIA_GRP_ID_IC_PRPVF,
>>>> +	IMX_MEDIA_GRP_ID_IC_PRPENC,
>>>> +	IMX_MEDIA_GRP_ID_SMFC,
>>>> +	IMX_MEDIA_GRP_ID_CSI,
>>>> +	IMX_MEDIA_GRP_ID_VIDMUX,
>>>> +	IMX_MEDIA_GRP_ID_SENSOR,
>>>> +	IMX_MEDIA_GRP_ID_CSI2,
>>>> +};
>>> This seems somewhat arbitrary. Why is a power sequence needed?
>> The CSI-2 receiver must be powered up before the sensor, that's the
>> only requirement IIRC. The others have no s_power requirement. So I
>> can probably change this to power up in the frontend -> backend order
>> (IC_PP to sensor). And vice-versa for power off.
> Yes, I think that should work (see below).

Actually there are problems using this, see below.

>>> [...]
>>>> +/*
>>>> + * Turn current pipeline power on/off starting from start_entity.
>>>> + * Must be called with mdev->graph_mutex held.
>>>> + */
>>>> +int imx_media_pipeline_set_power(struct imx_media_dev *imxmd,
>>>> +				 struct media_entity_graph *graph,
>>>> +				 struct media_entity *start_entity, bool on)
>>>> +{
>>>> +	struct media_entity *entity;
>>>> +	struct v4l2_subdev *sd;
>>>> +	int i, ret = 0;
>>>> +	u32 id;
>>>> +
>>>> +	for (i = 0; i < NUM_POWER_ENTITIES; i++) {
>>>> +		id = on ? power_on_seq[i] : power_off_seq[i];
>>>> +		entity = find_pipeline_entity(imxmd, graph, start_entity, id);
>>>> +		if (!entity)
>>>> +			continue;
>>>> +
>>>> +		sd = media_entity_to_v4l2_subdev(entity);
>>>> +
>>>> +		ret = v4l2_subdev_call(sd, core, s_power, on);
>>>> +		if (ret && ret != -ENOIOCTLCMD)
>>>> +			break;
>>>> +	}
>>>> +
>>>> +	return (ret && ret != -ENOIOCTLCMD) ? ret : 0;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(imx_media_pipeline_set_power);
>>> This should really be handled by v4l2_pipeline_pm_use.
>> I thought about this earlier, but v4l2_pipeline_pm_use() seems to be
>> doing some other stuff that bothered me, at least that's what I remember.
>> I will revisit this.
> I have used it with a tc358743 -> mipi-csi2 pipeline, it didn't cause
> any problems. It would be better to reuse and, if necessary, fix the
> existing infrastructure where available.

I tried this API, by switching to v4l2_pipeline_pm_use() in camif 
open/release,
and switched to v4l2_pipeline_link_notify() instead of 
imx_media_link_notify()
in the media driver's media_device_ops.

This API assumes the video device has an open file handle while the media
links are being established. This doesn't work for me, I want to be able to
establish the links using 'media-ctl -l', and that won't work unless 
there is an
open file handle on the video capture device node.

Also, I looked into calling v4l2_pipeline_pm_use() during 
imx_media_link_notify(),
instead of imx_media_pipeline_set_power(). Again there are problems with 
that.

First, v4l2_pipeline_pm_use() acquires the graph mutex, so it can't be 
called inside
link_notify which already acquires that lock. The header for this 
function also
clearly states it should only be called in open/release.

Second, ignoring the above locking issue for a moment, 
v4l2_pipeline_pm_use()
will call s_power on the sensor _first_, then the mipi csi-2 s_power, 
when executing
media-ctl -l '"ov5640 1-003c":0 -> "imx6-mipi-csi2":0[1]'. Which is the 
wrong order.
In my version which enforces the correct power on order, the mipi csi-2 
s_power
is called first in that link setup, followed by the sensor.



>>>> +int imx_media_add_internal_subdevs(struct imx_media_dev *imxmd,
>>>> +				   struct imx_media_subdev *csi[4])
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	/* there must be at least one CSI in first IPU */
>>> Why?
>> Well yeah, imx-media doesn't necessarily need a CSI if things
>> like the VDIC or post-processor are being used by an output
>> overlay pipeline, for example. I'll fix this.
> I haven't even thought that far, but there could be boards with only a
> parallel sensor connected to IPU2 CSI1 and IPU1 disabled for power
> saving reasons.

done! A very simple change to imx_media_add_internal_subdevs(),
and now no CSI's are necessary, but the remaining IPU internal entities
are loaded and linked just fine without them, so for example with no
CSI's in IPU2, the VDIC entity in IPU2 is still present in the graph and
could still be used in the future by a mem2mem device for instance.

Steve

