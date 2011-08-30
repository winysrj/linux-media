Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56889 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab1H3IzO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 04:55:14 -0400
Date: Tue, 30 Aug 2011 10:55:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Bastian Hecht <hechtb@googlemail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the
 ov5642 camera driver
In-Reply-To: <201108291448.15139.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1108301051410.19151@axis700.grange>
References: <alpine.DEB.2.02.1108171551040.17540@ipanema>
 <201108291426.57501.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108291433090.31184@axis700.grange>
 <201108291448.15139.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Aug 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Monday 29 August 2011 14:34:53 Guennadi Liakhovetski wrote:
> > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
> > > On Monday 29 August 2011 14:18:50 Guennadi Liakhovetski wrote:
> > > > On Sun, 28 Aug 2011, Laurent Pinchart wrote:
> > > > 
> > > > [snip]
> > > > 
> > > > > > @@ -774,17 +839,27 @@ static int ov5642_s_fmt(struct v4l2_subdev
> > > > > > *sd,
> > > > > > 
> > > > > >  	ov5642_try_fmt(sd, mf);
> > > > > > 
> > > > > > +	priv->out_size.width		= mf->width;
> > > > > > +	priv->out_size.height		= mf->height;
> > > > > 
> > > > > It looks like to me (but I may be wrong) that you achieve different
> > > > > resolutions using cropping, not scaling. If that's correct you should
> > > > > implement s_crop support and refuse changing the resolution through
> > > > > s_fmt.
> > > > 
> > > > As the patch explains (I think) on several occasions, currently only
> > > > the 1:1 scale is supported, and it was our deliberate choice to
> > > > implement this using the scaling API
> > > 
> > > If you implement cropping, you should use the crop API, not the scaling
> > > API
> > > 
> > > :-)
> > 
> > It's changing both - input and output sizes.
> 
> Sure, but it's still cropping.

Why? Isn't it a matter of the PoV? It changes the output window, i.e., 
implements S_FMT. And S_FMT is by far more important / widely used than 
S_CROP. Refusing to change the output window and always just returning the 
== crop size wouldn't be polite, IMHO. Don't think many users would guess 
to use S_CROP. Standard applications a la mplayer don't use S_CROP at all.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
