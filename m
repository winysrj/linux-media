Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57667 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1H2MSw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 08:18:52 -0400
Date: Mon, 29 Aug 2011 14:18:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Bastian Hecht <hechtb@googlemail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the
 ov5642 camera driver
In-Reply-To: <201108281949.05551.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1108291409300.31184@axis700.grange>
References: <alpine.DEB.2.02.1108171551040.17540@ipanema>
 <201108281949.05551.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Sun, 28 Aug 2011, Laurent Pinchart wrote:

[snip]

> > @@ -593,8 +639,7 @@ static struct ov5642 *to_ov5642(const struct i2c_client
> > *client) }
> > 
> >  /* Find a data format by a pixel code in an array */
> > -static const struct ov5642_datafmt
> > -			*ov5642_find_datafmt(enum v4l2_mbus_pixelcode code)
> > +static const struct ov5642_datafmt *ov5642_find_datafmt(enum
> > v4l2_mbus_pixelcode code) {
> 
> checkpatch.pl won't be happy.

Since the lift of the hard 80-char limit, I often find lines of 86 characters 
more acceptable than their split versions.

[snip]

> > @@ -774,17 +839,27 @@ static int ov5642_s_fmt(struct v4l2_subdev *sd,
> > 
> >  	ov5642_try_fmt(sd, mf);
> > 
> > +	priv->out_size.width		= mf->width;
> > +	priv->out_size.height		= mf->height;
> 
> It looks like to me (but I may be wrong) that you achieve different 
> resolutions using cropping, not scaling. If that's correct you should 
> implement s_crop support and refuse changing the resolution through s_fmt.

As the patch explains (I think) on several occasions, currently only the 
1:1 scale is supported, and it was our deliberate choice to implement this 
using the scaling API

> > @@ -793,10 +868,12 @@ static int ov5642_g_fmt(struct v4l2_subdev *sd,
> > 
> >  	mf->code	= fmt->code;
> >  	mf->colorspace	= fmt->colorspace;
> > -	mf->width	= OV5642_WIDTH;
> > -	mf->height	= OV5642_HEIGHT;
> > +	mf->width	= priv->out_size.width;
> > +	mf->height	= priv->out_size.height;
> >  	mf->field	= V4L2_FIELD_NONE;
> > 
> > +	dev_dbg(sd->v4l2_dev->dev, "%s return width: %u heigth: %u\n", __func__,
> > +			mf->width, mf->height);
> 
> Isn't that a bit too verbose ? Printing the format in a debug message in the 
> s_fmt handler is useful, but maybe doing it in g_fmt is a bit too much.

This is a dev_dbg()... Personally, as long as they don't clutter the source 
code needlessly, compile without warnings and have their typos fixed (;-)) 
I don't have problems with an odd instance, even if I don't really perceive 
its output as particularly useful:-)

[snip]

> > +	dev_dbg(sd->v4l2_dev->dev, "%s crop width: %u heigth: %u\n", __func__,
> > +			rect->width, rect->height);
> 
> Same comment as for g_fmt.

same reply:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
