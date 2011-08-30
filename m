Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:43633 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1H3Mdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 08:33:46 -0400
Date: Tue, 30 Aug 2011 15:33:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Bastian Hecht <hechtb@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the
 ov5642 camera driver
Message-ID: <20110830123340.GA12316@valkosipuli.localdomain>
References: <alpine.DEB.2.02.1108171551040.17540@ipanema>
 <201108281949.05551.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1108291409300.31184@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108291409300.31184@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 29, 2011 at 02:18:50PM +0200, Guennadi Liakhovetski wrote:
> Hi Laurent
> 
> On Sun, 28 Aug 2011, Laurent Pinchart wrote:
> 
> [snip]
> 
> > > @@ -593,8 +639,7 @@ static struct ov5642 *to_ov5642(const struct i2c_client
> > > *client) }
> > > 
> > >  /* Find a data format by a pixel code in an array */
> > > -static const struct ov5642_datafmt
> > > -			*ov5642_find_datafmt(enum v4l2_mbus_pixelcode code)
> > > +static const struct ov5642_datafmt *ov5642_find_datafmt(enum
> > > v4l2_mbus_pixelcode code) {
> > 
> > checkpatch.pl won't be happy.
> 
> Since the lift of the hard 80-char limit, I often find lines of 86 characters 
> more acceptable than their split versions.

It's not lifted, and it's still a rule. It's only that exceptions are
nowadays allowed to that rule where they make sense.

> > > @@ -774,17 +839,27 @@ static int ov5642_s_fmt(struct v4l2_subdev *sd,
> > > 
> > >  	ov5642_try_fmt(sd, mf);
> > > 
> > > +	priv->out_size.width		= mf->width;
> > > +	priv->out_size.height		= mf->height;
> > 
> > It looks like to me (but I may be wrong) that you achieve different 
> > resolutions using cropping, not scaling. If that's correct you should 
> > implement s_crop support and refuse changing the resolution through s_fmt.
> 
> As the patch explains (I think) on several occasions, currently only the 
> 1:1 scale is supported, and it was our deliberate choice to implement this 
> using the scaling API

As there is a subdev op to implement crop (s_crop) it should be used instead.
Otherwise any application thinks that the hardware can actually do scaling
but instead it crops. The above looks like gross misuse of the API to me.

Is there any particular reason why you think it should be implemented this
way?

-- 
Sakari Ailus
sakari.ailus@iki.fi
