Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2687 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZLBDEN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 22:04:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2/2 v2] soc-camera: convert to the new mediabus API
Date: Wed, 2 Dec 2009 08:32:27 +0530
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Paul Mundt <lethal@linux-sh.org>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange> <200912011545.24634.hverkuil@xs4all.nl> <Pine.LNX.4.64.0912011153170.4701@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0912011153170.4701@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912020832.27424.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 01 December 2009 16:33:08 Guennadi Liakhovetski wrote:
> On Tue, 1 Dec 2009, Hans Verkuil wrote:
> > On Monday 30 November 2009 15:48:24 Guennadi Liakhovetski wrote:
> > > On Mon, 30 Nov 2009, Hans Verkuil wrote:
> > > > On Fri, 27 Nov 2009, Guennadi Liakhovetski wrote:
> > > > > On Fri, 27 Nov 2009, Hans Verkuil wrote:
> > > > > > Hi Guennadi,
> > > > > >
> > > > > > > Convert soc-camera core and all soc-camera drivers to the new
> > > > > > > mediabus API. This also takes soc-camera client drivers one
> > > > > > > step closer to also be
> > > > > > > usable with generic v4l2-subdev host drivers.
> > > > > >
> > > > > > Just a quick question:
> > > > > > > @@ -323,28 +309,39 @@ static int mt9m001_s_fmt(struct
> > > > > > > v4l2_subdev *sd, struct v4l2_format *f)
> > > > > > >  	/* No support for scaling so far, just crop. TODO: use
> > > > > > > skipping */ ret = mt9m001_s_crop(sd, &a);
> > > > > > >  	if (!ret) {
> > > > > > > -		pix->width = mt9m001->rect.width;
> > > > > > > -		pix->height = mt9m001->rect.height;
> > > > > > > -		mt9m001->fourcc = pix->pixelformat;
> > > > > > > +		mf->width	= mt9m001->rect.width;
> > > > > > > +		mf->height	= mt9m001->rect.height;
> > > > > > > +		mt9m001->fmt	= soc_mbus_find_datafmt(mf->code,
> > > > > > > +					mt9m001->fmts, mt9m001->num_fmts);
> > > > > > > +		mf->colorspace	= mt9m001->fmt->colorspace;
> > > > > > >  	}
> > > > > > >
> > > > > > >  	return ret;
> > > > > > >  }
> > > > > > >
> > > > > > > -static int mt9m001_try_fmt(struct v4l2_subdev *sd, struct
> > > > > > > v4l2_format *f)
> > > > > > > +static int mt9m001_try_fmt(struct v4l2_subdev *sd,
> > > > > > > +			   struct v4l2_mbus_framefmt *mf)
> > > > > > >  {
> > > > > > >  	struct i2c_client *client = sd->priv;
> > > > > > >  	struct mt9m001 *mt9m001 = to_mt9m001(client);
> > > > > > > -	struct v4l2_pix_format *pix = &f->fmt.pix;
> > > > > > > +	const struct soc_mbus_datafmt *fmt;
> > > > > > >
> > > > > > > -	v4l_bound_align_image(&pix->width, MT9M001_MIN_WIDTH,
> > > > > > > +	v4l_bound_align_image(&mf->width, MT9M001_MIN_WIDTH,
> > > > > > >  		MT9M001_MAX_WIDTH, 1,
> > > > > > > -		&pix->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
> > > > > > > +		&mf->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
> > > > > > >  		MT9M001_MAX_HEIGHT + mt9m001->y_skip_top, 0, 0);
> > > > > > >
> > > > > > > -	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
> > > > > > > -	    pix->pixelformat == V4L2_PIX_FMT_SBGGR16)
> > > > > > > -		pix->height = ALIGN(pix->height - 1, 2);
> > > > > > > +	if (mt9m001->fmts == mt9m001_colour_fmts)
> > > > > > > +		mf->height = ALIGN(mf->height - 1, 2);
> > > > > > > +
> > > > > > > +	fmt = soc_mbus_find_datafmt(mf->code, mt9m001->fmts,
> > > > > > > +				    mt9m001->num_fmts);
> > > > > > > +	if (!fmt) {
> > > > > > > +		fmt = mt9m001->fmt;
> > > > > > > +		mf->code = fmt->code;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	mf->colorspace	= fmt->colorspace;
> > > > > > >
> > > > > > >  	return 0;
> > > > > > >  }
> > > > > >
> > > > > > Why do the sensor drivers use soc_mbus_find_datafmt? They only
> > > > > > seem to be interested in the colorspace field, but I don't see
> > > > > > the reason for that. Most if not all sensors have a fixed
> > > > > > colorspace depending on the pixelcode, so they can just ignore
> > > > > > the colorspace that the caller requested and replace it with
> > > > > > their own.
> > > > >
> > > > > Right, that's exactly what's done here. mt9m001 and mt9v022 drivers
> > > > > support different formats, depending on the exact detected or
> > > > > specified by the user model. That's why they have to search for the
> > > > > requested format in supported list. and then - yes, they just put
> > > > > the found format into user
> > > > >
> > > > > request:
> > > > > > > +	mf->colorspace	= fmt->colorspace;
> > > > > >
> > > > > > I didn't have time for a full review, so I might have missed
> > > > > > something.
> > > >
> > > > I looked at this more closely and I realized that I did indeed miss
> > > > that soc_mbus_find_datafmt just searched in the pixelcode ->
> > > > colorspace mapping array.
> > > >
> > > > I also realized that there is no need for that data structure and
> > > > function to be soc-camera specific. I believe I said otherwise in an
> > > > earlier review. My apologies for that, all I can say is that I had
> > > > very little time to do the reviews...
> > >
> > > No, you did not say otherwise about _these_ struct and function - they
> > > only appeared in v2 of the mediabus API, after you'd suggested to move
> > > colorspace into struct v4l2_mbus_framefmt.
> > >
> > > > That said, there is no need for both the soc_mbus_datafmt struct and
> > > > the soc_mbus_find_datafmt function. These can easily be replaced by
> > > > something like this as a local function in each subdev:
> > > >
> > > > static enum v4l2_colorspace mt9m111_g_colorspace(enum
> > > > v4l2_mbus_pixelcode code)
> > > > {
> > > > 	switch (code) {
> > > > 	case V4L2_MBUS_FMT_YUYV:
> > > > 	case V4L2_MBUS_FMT_YVYU:
> > > > 	case V4L2_MBUS_FMT_UYVY:
> > > > 	case V4L2_MBUS_FMT_VYUY:
> > > > 		return V4L2_COLORSPACE_JPEG;
> > > >
> > > > 	case V4L2_MBUS_FMT_RGB555:
> > > > 	case V4L2_MBUS_FMT_RGB565:
> > > > 	case V4L2_MBUS_FMT_SBGGR8:
> > > > 	case V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE:
> > > > 		return V4L2_COLORSPACE_SRGB;
> > > >
> > > > 	default:
> > > > 		return 0;
> > > > 	}
> > > > }
> > > >
> > > > So if mt9m111_g_colorspace() returns 0, then the format wasn't found.
> > > > (Note that the compiler might give a warning for the return 0, so
> > > > that might need some editing)
> > > >
> > > > Much simpler and much easier to understand.
> > >
> > > Drivers are not forced to use that small and trivial function -
> > > everyone is welcome to reinvent the wheel:-) In many cases it is indeed
> > > an overkill, like mt9t031, which only supports one format. However, in
> > > some other drivers this is not that trivial. First, as I said, mt9m001
> > > and mt9v022 generate that array dynamically, depending on the chip
> > > version and platform configuration. So, you anyway would have to
> > > iterate over the array. In other drivers, like ov772x and the recently
> > > submitted mt9t112 this function is also used to retrieve register
> > > configuration for a specific pixel code. So, I still think that
> > > function is useful, and being kept under soc-camera mediabus
> > > extensions, and being inline, it shouldn't cause too many problems.
> >
> > It definitely shouldn't be in a soc-camera header. If this is going to be
> > used as a common utility, then it should be in v4l2-mediabus.h.
>
> Sorry, I don't understand. IMHO soc_mbus_get_fmtdesc() and
> soc_mbus_bytes_per_line() are much more likely to be useful for non
> soc-camera drivers, and still you wanted them to remain soc-camera
> specific. Now this small and trivial function, which, as you say, only
> very few need, so, I made it soc-camera specific, now you want it to be
> available to all...

It's very simple: i2c subdev drivers should not depend on anything but v4l2 
core headers/modules because they have to be reusable and not tied to any 
specific bridge driver. So when I see them including a soc header I 
immediately trigger on that. I am not (much) interested in what happens inside 
the soc-camera bridge driver, but I am very interested in what happens inside 
i2c subdev drivers.

> > But frankly the only two places where I think it is useful are mt9m001
> > and mt9v022. In all other cases is can be replaced by simpler code. For
> > ov772x I would just add the pixelcode and colorspace fields to the
> > ov772x_color_format struct instead and you iterate of the elements of the
> > ov772x_cfmts array to find the one that matches the desired pixelcode.
> >
> > I think the usefulness of the datastructure and utility function depends
> > very much on the sensor driver which is why I prefer to have this being
> > just part of the driver source itself rather than in a generic header.
> > That gives the impression that driver writers *have* to do it that way,
> > when often it can be done much simpler.
>
> Ok, how about this: I preserve the function as is in soc-camera, and leave
> it as is in mt9m001, mt9v022, and ov772x (and in the forthcoming mt9t112).
> In other drivers with constant format lists, where this function is only
> used to find the colorspace, I'll replace it with a switch-case.

For the reason stated above it should *not* be a soc-camera function. Just 
copy the datastruct and function directly into those drivers that actually 
need it. And I really urge you change the way the 0v772x uses it since it 
makes that driver unnecessarily complicated.

> I _really_ do not understand why soc-camera internal APIs now suddenly
> receive such attention.

I triggered on the use of a soc header, and then I started reviewing what that 
code actually did. And I didn't really like the way it was used.

I probably wouldn't have given it much notice if it was in v4l2-mediabus.h 
from the start...

Another reason is that I am trying to do more code reviews before new drivers 
are merged. Too many of our existing drivers are in pretty poor shape in part 
because of insufficient attention to code quality. And I have a particular 
interest in anything touching subdevs.

Regards,

	Hans

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

