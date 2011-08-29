Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41231 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab1H2Mrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 08:47:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the ov5642 camera driver
Date: Mon, 29 Aug 2011 14:48:14 +0200
Cc: Bastian Hecht <hechtb@googlemail.com>, linux-media@vger.kernel.org
References: <alpine.DEB.2.02.1108171551040.17540@ipanema> <201108291426.57501.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1108291433090.31184@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108291433090.31184@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108291448.15139.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 29 August 2011 14:34:53 Guennadi Liakhovetski wrote:
> On Mon, 29 Aug 2011, Laurent Pinchart wrote:
> > On Monday 29 August 2011 14:18:50 Guennadi Liakhovetski wrote:
> > > On Sun, 28 Aug 2011, Laurent Pinchart wrote:
> > > 
> > > [snip]
> > > 
> > > > > @@ -593,8 +639,7 @@ static struct ov5642 *to_ov5642(const struct
> > > > > i2c_client *client) }
> > > > > 
> > > > >  /* Find a data format by a pixel code in an array */
> > > > > 
> > > > > -static const struct ov5642_datafmt
> > > > > -			*ov5642_find_datafmt(enum v4l2_mbus_pixelcode code)
> > > > > +static const struct ov5642_datafmt *ov5642_find_datafmt(enum
> > > > > v4l2_mbus_pixelcode code) {
> > > > 
> > > > checkpatch.pl won't be happy.
> > > 
> > > Since the lift of the hard 80-char limit, I often find lines of 86
> > > characters more acceptable than their split versions.
> > 
> > When has that been lifted ?
> 
> Sorry, don't have a link at hand, a few months ago, either beginning of
> this or end of last year, perhaps. There has been a lengthy discussion on
> multiple lists, mainly lkml, the common mood was, that 80 chars wasn't
> meaningful anymore, but I'm not sure what exact actions have been executed
> to document this.

I remember the discussion but I wasn't sure if anything had been decided and 
set in stone.

> > > [snip]
> > > 
> > > > > @@ -774,17 +839,27 @@ static int ov5642_s_fmt(struct v4l2_subdev
> > > > > *sd,
> > > > > 
> > > > >  	ov5642_try_fmt(sd, mf);
> > > > > 
> > > > > +	priv->out_size.width		= mf->width;
> > > > > +	priv->out_size.height		= mf->height;
> > > > 
> > > > It looks like to me (but I may be wrong) that you achieve different
> > > > resolutions using cropping, not scaling. If that's correct you should
> > > > implement s_crop support and refuse changing the resolution through
> > > > s_fmt.
> > > 
> > > As the patch explains (I think) on several occasions, currently only
> > > the 1:1 scale is supported, and it was our deliberate choice to
> > > implement this using the scaling API
> > 
> > If you implement cropping, you should use the crop API, not the scaling
> > API
> > 
> > :-)
> 
> It's changing both - input and output sizes.

Sure, but it's still cropping.

-- 
Regards,

Laurent Pinchart
