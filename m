Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33821 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750941AbdEDHHf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 03:07:35 -0400
Message-ID: <1493881652.2381.6.camel@pengutronix.de>
Subject: Re: [PATCH v2 2/2] [media] platform: add video-multiplexer
 subdevice driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Peter Rosin <peda@axentia.se>, Pavel Machek <pavel@ucw.cz>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 04 May 2017 09:07:32 +0200
In-Reply-To: <20170503192836.GN7456@valkosipuli.retiisi.org.uk>
References: <20170502150913.2168-1-p.zabel@pengutronix.de>
         <20170502150913.2168-2-p.zabel@pengutronix.de>
         <20170503192836.GN7456@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-05-03 at 22:28 +0300, Sakari Ailus wrote:
> Hi Philipp,
> 
> Thanks for continuing working on this!
> 
> I have some minor comments below...

Thank you for the comments.

[...]
> Could you rebase this on the V4L2 fwnode patchset here, please?
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-acpi>
>
> The conversion is rather simple, as shown here:
> 
> <URL:https://git.linuxtv.org/sailus/media_tree.git/commit/?h=v4l2-acpi&id=679035e11bfdbea146fed5d52fb794b34dc9cea6>

What is the status of this patchset? Will this be merged soon?

[...]
> > +static inline bool is_source_pad(struct video_mux *vmux, unsigned int pad)
> 
> It's a common practice to test pad flags rather than the pad number.
> Although the pad number here implicitly tells this, too, testing pad flags
> is cleaner.
> 
> The matter was discussed in the past and it was decided not to add helper
> functions to the framework for the purpose as testing the flags is trivial.

Ok, I'll drop is_source_pad and check (pad->flags & MEDIA_PAD_FL_SOURCE)
instead in the next version.

[...]
> > +static int video_mux_set_format(struct v4l2_subdev *sd,
> > +			    struct v4l2_subdev_pad_config *cfg,
> > +			    struct v4l2_subdev_format *sdformat)
> > +{
> > +	struct video_mux *vmux = v4l2_subdev_to_video_mux(sd);
> > +	struct v4l2_mbus_framefmt *mbusformat;
> > +
> > +	mbusformat = __video_mux_get_pad_format(sd, cfg, sdformat->pad,
> > +					    sdformat->which);
> > +	if (!mbusformat)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&vmux->lock);
> > +
> > +	/* Source pad mirrors active sink pad, no limitations on sink pads */
> > +	if (is_source_pad(vmux, sdformat->pad) && vmux->active >= 0)
> > +		sdformat->format = vmux->format_mbus[vmux->active];
> > +
> > +	mutex_unlock(&vmux->lock);
> > +
> > +	*mbusformat = sdformat->format;
> 
> Shouldn't you do this before releasing the mutex? The assignment won't be
> an atomic operation. Same for get_format; you should take the mutex.

Yes, I'll extend the mutex to cover the mbus formats.

[...]
> > +static struct v4l2_subdev_pad_ops video_mux_pad_ops = {
> > +	.get_fmt = video_mux_get_format,
> > +	.set_fmt = video_mux_set_format,
> > +};
> > +
> > +static struct v4l2_subdev_ops video_mux_subdev_ops = {
> 
> Const for both of the structs?

Will do, thanks.

regards
Philipp
