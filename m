Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2382 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbZK0OZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 09:25:01 -0500
Message-ID: <9776d18eb5595d838cae99e1837d401c.squirrel@webmail.xs4all.nl>
In-Reply-To: <Pine.LNX.4.64.0911271349360.4383@axis700.grange>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange>
    <dc06c2b1fe49c7b64007ec24817e190a.squirrel@webmail.xs4all.nl>
    <Pine.LNX.4.64.0911261822520.5450@axis700.grange>
    <Pine.LNX.4.64.0911271349360.4383@axis700.grange>
Date: Fri, 27 Nov 2009 15:25:01 +0100
Subject: Re: [PATCH 2/2 v2] soc-camera: convert to the new mediabus API
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"Paul Mundt" <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

> Convert soc-camera core and all soc-camera drivers to the new mediabus
> API. This also takes soc-camera client drivers one step closer to also be
> usable with generic v4l2-subdev host drivers.

Just a quick question:

> @@ -323,28 +309,39 @@ static int mt9m001_s_fmt(struct v4l2_subdev *sd,
> struct v4l2_format *f)
>  	/* No support for scaling so far, just crop. TODO: use skipping */
>  	ret = mt9m001_s_crop(sd, &a);
>  	if (!ret) {
> -		pix->width = mt9m001->rect.width;
> -		pix->height = mt9m001->rect.height;
> -		mt9m001->fourcc = pix->pixelformat;
> +		mf->width	= mt9m001->rect.width;
> +		mf->height	= mt9m001->rect.height;
> +		mt9m001->fmt	= soc_mbus_find_datafmt(mf->code,
> +					mt9m001->fmts, mt9m001->num_fmts);
> +		mf->colorspace	= mt9m001->fmt->colorspace;
>  	}
>
>  	return ret;
>  }
>
> -static int mt9m001_try_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
> +static int mt9m001_try_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_mbus_framefmt *mf)
>  {
>  	struct i2c_client *client = sd->priv;
>  	struct mt9m001 *mt9m001 = to_mt9m001(client);
> -	struct v4l2_pix_format *pix = &f->fmt.pix;
> +	const struct soc_mbus_datafmt *fmt;
>
> -	v4l_bound_align_image(&pix->width, MT9M001_MIN_WIDTH,
> +	v4l_bound_align_image(&mf->width, MT9M001_MIN_WIDTH,
>  		MT9M001_MAX_WIDTH, 1,
> -		&pix->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
> +		&mf->height, MT9M001_MIN_HEIGHT + mt9m001->y_skip_top,
>  		MT9M001_MAX_HEIGHT + mt9m001->y_skip_top, 0, 0);
>
> -	if (pix->pixelformat == V4L2_PIX_FMT_SBGGR8 ||
> -	    pix->pixelformat == V4L2_PIX_FMT_SBGGR16)
> -		pix->height = ALIGN(pix->height - 1, 2);
> +	if (mt9m001->fmts == mt9m001_colour_fmts)
> +		mf->height = ALIGN(mf->height - 1, 2);
> +
> +	fmt = soc_mbus_find_datafmt(mf->code, mt9m001->fmts,
> +				    mt9m001->num_fmts);
> +	if (!fmt) {
> +		fmt = mt9m001->fmt;
> +		mf->code = fmt->code;
> +	}
> +
> +	mf->colorspace	= fmt->colorspace;
>
>  	return 0;
>  }

Why do the sensor drivers use soc_mbus_find_datafmt? They only seem to be
interested in the colorspace field, but I don't see the reason for that.
Most if not all sensors have a fixed colorspace depending on the
pixelcode, so they can just ignore the colorspace that the caller
requested and replace it with their own.

I didn't have time for a full review, so I might have missed something.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

