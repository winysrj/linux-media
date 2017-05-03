Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:34541 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751825AbdECIf7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 04:35:59 -0400
Message-ID: <1493800556.3599.15.camel@pengutronix.de>
Subject: Re: [PATCH 2/2] [media] platform: add video-multiplexer subdevice
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-media@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pavel Machek <pavel@ucw.cz>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Date: Wed, 03 May 2017 10:35:56 +0200
In-Reply-To: <74bfa70b-3407-9484-9717-bb2d07356f70@axentia.se>
References: <20170428141330.16187-1-p.zabel@pengutronix.de>
         <20170428141330.16187-2-p.zabel@pengutronix.de>
         <beb9f7c4-4959-1bb2-03e2-c5ccecbb8368@axentia.se>
         <df5f38c4-b0e8-64c6-d6ba-c554133f4bbf@axentia.se>
         <1493738491.2391.20.camel@pengutronix.de>
         <74bfa70b-3407-9484-9717-bb2d07356f70@axentia.se>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-05-02 at 19:42 +0200, Peter Rosin wrote:
> On 2017-05-02 17:21, Philipp Zabel wrote:
> > On Sat, 2017-04-29 at 23:42 +0200, Peter Rosin wrote:
> >> On 2017-04-29 23:29, Peter Rosin wrote:
> >>> On 2017-04-28 16:13, Philipp Zabel wrote:
> >>>> This driver can handle SoC internal and external video bus multiplexers,
> >>>> controlled by mux controllers provided by the mux controller framework,
> >>>> such as MMIO register bitfields or GPIOs. The subdevice passes through
> >>>> the mbus configuration of the active input to the output side.
> >>>>
> >>>> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> >>>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> >>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> >>>> ---
> >>>> This has been last sent as part of the i.MX media series.
> >>>>
> >>>> Changes since https://patchwork.kernel.org/patch/9647869/:
> >>>>  - Split out the actual mux operation to be provided by the mux controller
> >>>>    framework [1]. GPIO and MMIO control can be provided by individual mux
> >>>>    controller drivers [2][3].
> >>>>    [1] https://patchwork.kernel.org/patch/9695837/
> >>>>    [2] https://patchwork.kernel.org/patch/9695839/
> >>>>    [3] https://patchwork.kernel.org/patch/9704509/
> >>>>  - Shortened 'video-multiplexer' to 'video-mux', replaced all instances of
> >>>>    vidsw with video_mux.
> >>>>  - Made the mux inactive by default, only activated by user interaction.
> >>>>  - Added CONFIG_OF and CONFIG_MULTIPLEXER dependencies.
> >>>>  - Reuse subdev.entity.num_pads instead of keeping our own count.
> >>>>  - Removed implicit link disabling. Instead, trying to enable a second
> >>>>    sink pad link yields -EBUSY.
> >>>>  - Merged _async_init into _probe.
> >>>>  - Removed superfluous pad index check from _set_format.
> >>>>  - Added is_source_pad helper to tell source and sink pads apart.
> >>>>  - Removed test for status property in endpoint nodes. Disable the remote
> >>>>    device or sever the endpoint link to disable a sink pad.
> >>>> ---
> >>>>  drivers/media/platform/Kconfig     |   6 +
> >>>>  drivers/media/platform/Makefile    |   2 +
> >>>>  drivers/media/platform/video-mux.c | 341 +++++++++++++++++++++++++++++++++++++
> >>>>  3 files changed, 349 insertions(+)
> >>>>  create mode 100644 drivers/media/platform/video-mux.c
> >>>>
> >>>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> >>>> index c9106e105baba..b046a6d39fee5 100644
> >>>> --- a/drivers/media/platform/Kconfig
> >>>> +++ b/drivers/media/platform/Kconfig
> >>>> @@ -74,6 +74,12 @@ config VIDEO_M32R_AR_M64278
> >>>>  	  To compile this driver as a module, choose M here: the
> >>>>  	  module will be called arv.
> >>>>  
> >>>> +config VIDEO_MUX
> >>>> +	tristate "Video Multiplexer"
> >>>> +	depends on OF && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER && MULTIPLEXER
> >>>> +	help
> >>>> +	  This driver provides support for N:1 video bus multiplexers.
> >>>> +
> >>>>  config VIDEO_OMAP3
> >>>>  	tristate "OMAP 3 Camera support"
> >>>>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && ARCH_OMAP3
> >>>> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> >>>> index 349ddf6a69da2..fd2735ca3ff75 100644
> >>>> --- a/drivers/media/platform/Makefile
> >>>> +++ b/drivers/media/platform/Makefile
> >>>> @@ -27,6 +27,8 @@ obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
> >>>>  
> >>>>  obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
> >>>>  
> >>>> +obj-$(CONFIG_VIDEO_MUX)			+= video-mux.o
> >>>> +
> >>>>  obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
> >>>>  obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
> >>>>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
> >>>> diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
> >>>> new file mode 100644
> >>>> index 0000000000000..419541729f67e
> >>>> --- /dev/null
> >>>> +++ b/drivers/media/platform/video-mux.c
> >>>> @@ -0,0 +1,341 @@
> >>>> +/*
> >>>> + * video stream multiplexer controlled via mux control
> >>>> + *
> >>>> + * Copyright (C) 2013 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
> >>>> + * Copyright (C) 2016 Pengutronix, Philipp Zabel <kernel@pengutronix.de>
> >>>
> >>> 2017?
> >>>
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or
> >>>> + * modify it under the terms of the GNU General Public License
> >>>> + * as published by the Free Software Foundation; either version 2
> >>>> + * of the License, or (at your option) any later version.
> >>>> + * This program is distributed in the hope that it will be useful,
> >>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>> + * GNU General Public License for more details.
> >>>> + */
> >>>> +
> >>>> +#include <linux/err.h>
> >>>> +#include <linux/module.h>
> >>>> +#include <linux/mux/consumer.h>
> >>>> +#include <linux/of.h>
> >>>> +#include <linux/of_graph.h>
> >>>> +#include <linux/platform_device.h>
> >>>> +#include <media/v4l2-async.h>
> >>>> +#include <media/v4l2-device.h>
> >>>> +#include <media/v4l2-subdev.h>
> >>>> +#include <media/v4l2-of.h>
> >>>> +
> >>>> +struct video_mux {
> >>>> +	struct v4l2_subdev subdev;
> >>>> +	struct media_pad *pads;
> >>>> +	struct v4l2_mbus_framefmt *format_mbus;
> >>>> +	struct v4l2_of_endpoint *endpoint;
> >>>> +	struct mux_control *mux;
> >>>> +	int active;
> >>>> +};
> >>>> +
> >>>> +static inline struct video_mux *v4l2_subdev_to_video_mux(struct v4l2_subdev *sd)
> >>>> +{
> >>>> +	return container_of(sd, struct video_mux, subdev);
> >>>> +}
> >>>> +
> >>>> +static inline bool is_source_pad(struct video_mux *vmux, unsigned int pad)
> >>>> +{
> >>>> +	return pad == vmux->subdev.entity.num_pads - 1;
> >>>> +}
> >>>> +
> >>>> +static int video_mux_link_setup(struct media_entity *entity,
> >>>> +				const struct media_pad *local,
> >>>> +				const struct media_pad *remote, u32 flags)
> >>>> +{
> >>>> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
> >>>> +	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
> >>>> +	int ret;
> >>>> +
> >>>> +	/*
> >>>> +	 * The mux state is determined by the enabled sink pad link.
> >>>> +	 * Enabling or disabling the source pad link has no effect.
> >>>> +	 */
> >>>> +	if (is_source_pad(vmux, local->index))
> >>>> +		return 0;
> >>>> +
> >>>> +	dev_dbg(sd->dev, "link setup '%s':%d->'%s':%d[%d]",
> >>>> +		remote->entity->name, remote->index, local->entity->name,
> >>>> +		local->index, flags & MEDIA_LNK_FL_ENABLED);
> >>>> +
> >>>> +	if (flags & MEDIA_LNK_FL_ENABLED) {
> >>>> +		if (vmux->active == local->index)
> >>>
> >>> Here, you shortcut the mux_control_select_trylock test and return "OK"
> >>> based on a driver-local variable that is intended to keep track of mux
> >>> ownership.
> >>>
> >>>> +			return 0;
> >>>> +
> >>>> +		if (vmux->active >= 0)
> >>>
> >>> Here too (and this check is not needed, the situation will be covered by
> >>> the mux_control_try_select call).
> >>>
> >>>> +			return -EBUSY;
> >>>> +
> >>>> +		dev_dbg(sd->dev, "setting %d active\n", local->index);
> >>>> +		ret = mux_control_try_select(vmux->mux, local->index);
> >>>> +		if (ret < 0)
> >>>> +			return ret;
> >>>> +		vmux->active = local->index;
> >>>> +	} else {
> >>>> +		if (vmux->active != local->index)
> >>>> +			return 0;
> >>>> +
> >>>> +		dev_dbg(sd->dev, "going inactive\n");
> >>>> +		mux_control_deselect(vmux->mux);
> >>>
> >>> But here you let go of the mux *before* you clear the driver-local
> >>> ownership indicator. That looks suspicious. My guess is that this is
> >>> "safe" because the upper layers has some serialization, but I don't
> >>> know. Anyway, even if there is something saving you in the upper
> >>> layers, it looks out of order and unneeded. I would have moved the
> >>> below vmux->active = -1; statement up to before the above deselect.
> >>>
> >>> With that fixed, mux usage looks good to me, so you can add an Acked-
> >>> by from me if you wish (goes for the bindings patch as well).
> >>
> >> Ouch, that was a bit too soon. If there is *no* serialization in the
> >> upper layers, this is *not* ok, even with my reordering. There must be
> >> only one call to mux_control_deselect, and w/o serialization there
> >> is a race where you might get multiple deselect calls when several
> >> callers makes it through the active != index check before any of them
> >> manages to set active = -1. That race must be taken care of!
> > 
> > Thank you, I've resent a version with a mutex lock around vmux->active.
> 
> I had a bunch of ifs in the above message, so I'm not sure it's needed.
> I would expect there to be a lock outside somewhere in the media layer.
> A cursory look gets me to media-entity.c and media_entity_setup_link()
> which does have a mutex. But I'm no media expert, so maybe there are other
> ways of getting to video_mux_link_setup that I'm not aware of?

link_setup is always called under the graph mutex of the /dev/media
device. That is why I didn't think about locking too hard. In fact, I
initially wrote this expecting mux_control_get_exclusive to exist and
the mux select/deselect not to be locked at all.

But set_format is called from an unlocked ioctl on a /dev/v4l-subdev
device. Until your comments I didn't notice that it would be possible to
let link_setup set active = -1 in the middle of the set_format call,
causing it to return garbage.

> If you do end up relying on external locking, a comment saying so would
> be nice. Or even better, some __must_hold markup if possible?
> 
> Cheers,
> peda

regards
Philipp
