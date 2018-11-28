Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:38980 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbeK2EMr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 23:12:47 -0500
Message-ID: <4158fda782575fbbe2c6abeab0f04ebed50efed4.camel@v3.sk>
Subject: Re: [PATCH v3 01/14] media: ov7670: split register setting from
 set_fmt() logic
From: Lubomir Rintel <lkundrak@v3.sk>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Date: Wed, 28 Nov 2018 18:10:13 +0100
In-Reply-To: <20181122183730.GE3808@w540>
References: <20181120100318.367987-1-lkundrak@v3.sk>
         <20181120100318.367987-2-lkundrak@v3.sk> <20181122183730.GE3808@w540>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-11-22 at 19:37 +0100, jacopo mondi wrote:
> Hi Lubomir,
> 
> On Tue, Nov 20, 2018 at 11:03:06AM +0100, Lubomir Rintel wrote:
> > This will allow us to restore the last set format after the device
> > returns
> > from a power off.
> > 
> > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > 
> > ---
> > Changes since v2:
> > - This patch was added to the series
> > 
> >  drivers/media/i2c/ov7670.c | 80 ++++++++++++++++++++++----------
> > ------
> >  1 file changed, 46 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/ov7670.c
> > b/drivers/media/i2c/ov7670.c
> > index bc68a3a5b4ec..ee2302fbdeee 100644
> > --- a/drivers/media/i2c/ov7670.c
> > +++ b/drivers/media/i2c/ov7670.c
> > @@ -240,6 +240,7 @@ struct ov7670_info {
> >  	};
> >  	struct v4l2_mbus_framefmt format;
> >  	struct ov7670_format_struct *fmt;  /* Current format */
> > +	struct ov7670_win_size *wsize;
> >  	struct clk *clk;
> >  	struct gpio_desc *resetb_gpio;
> >  	struct gpio_desc *pwdn_gpio;
> > @@ -1003,48 +1004,20 @@ static int ov7670_try_fmt_internal(struct
> > v4l2_subdev *sd,
> >  	return 0;
> >  }
> > 
> > -/*
> > - * Set a format.
> > - */
> > -static int ov7670_set_fmt(struct v4l2_subdev *sd,
> > -		struct v4l2_subdev_pad_config *cfg,
> > -		struct v4l2_subdev_format *format)
> > +static int ov7670_apply_fmt(struct v4l2_subdev *sd)
> >  {
> > -	struct ov7670_format_struct *ovfmt;
> > -	struct ov7670_win_size *wsize;
> >  	struct ov7670_info *info = to_state(sd);
> > -#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > -	struct v4l2_mbus_framefmt *mbus_fmt;
> > -#endif
> > +	struct ov7670_win_size *wsize = info->wsize;
> >  	unsigned char com7, com10 = 0;
> >  	int ret;
> > 
> > -	if (format->pad)
> > -		return -EINVAL;
> > -
> > -	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> > -		ret = ov7670_try_fmt_internal(sd, &format->format,
> > NULL, NULL);
> > -		if (ret)
> > -			return ret;
> > -#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > -		mbus_fmt = v4l2_subdev_get_try_format(sd, cfg, format-
> > >pad);
> > -		*mbus_fmt = format->format;
> > -		return 0;
> > -#else
> > -		return -ENOTTY;
> > -#endif
> > -	}
> > -
> > -	ret = ov7670_try_fmt_internal(sd, &format->format, &ovfmt,
> > &wsize);
> > -	if (ret)
> > -		return ret;
> >  	/*
> >  	 * COM7 is a pain in the ass, it doesn't like to be read then
> >  	 * quickly written afterward.  But we have everything we need
> >  	 * to set it absolutely here, as long as the format-specific
> >  	 * register sets list it first.
> >  	 */
> > -	com7 = ovfmt->regs[0].value;
> > +	com7 = info->fmt->regs[0].value;
> >  	com7 |= wsize->com7_bit;
> >  	ret = ov7670_write(sd, REG_COM7, com7);
> >  	if (ret)
> > @@ -1066,7 +1039,7 @@ static int ov7670_set_fmt(struct v4l2_subdev
> > *sd,
> >  	/*
> >  	 * Now write the rest of the array.  Also store start/stops
> >  	 */
> > -	ret = ov7670_write_array(sd, ovfmt->regs + 1);
> > +	ret = ov7670_write_array(sd, info->fmt->regs + 1);
> >  	if (ret)
> >  		return ret;
> > 
> > @@ -1081,8 +1054,6 @@ static int ov7670_set_fmt(struct v4l2_subdev
> > *sd,
> >  			return ret;
> >  	}
> > 
> > -	info->fmt = ovfmt;
> > -
> >  	/*
> >  	 * If we're running RGB565, we must rewrite clkrc after setting
> >  	 * the other parameters or the image looks poor.  If we're
> > *not*
> > @@ -1100,6 +1071,46 @@ static int ov7670_set_fmt(struct v4l2_subdev
> > *sd,
> >  	return 0;
> >  }
> > 
> > +/*
> > + * Set a format.
> > + */
> > +static int ov7670_set_fmt(struct v4l2_subdev *sd,
> > +		struct v4l2_subdev_pad_config *cfg,
> > +		struct v4l2_subdev_format *format)
> > +{
> > +	struct ov7670_info *info = to_state(sd);
> > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > +	struct v4l2_mbus_framefmt *mbus_fmt;
> > +#endif
> > +	int ret;
> > +
> > +	if (format->pad)
> > +		return -EINVAL;
> > +
> > +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> > +		ret = ov7670_try_fmt_internal(sd, &format->format,
> > NULL, NULL);
> > +		if (ret)
> > +			return ret;
> > +#ifdef CONFIG_VIDEO_V4L2_SUBDEV_API
> > +		mbus_fmt = v4l2_subdev_get_try_format(sd, cfg, format-
> > >pad);
> 
> This #ifdef CONFIG_VIDEO_V4L2_SUBDEV_API seems to be quite in some
> drivers... Maybe stubs should be defined in v4l2-subdev.h.

Actually, I've also thought it's sorta ugly. I'll send out a patch that
does what you suggest.

> Anway, that's unrealted, the patch seems fine to me:
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

Thanks
Lubo

> 
> Thanks
>   j
> 
> 
> > +		*mbus_fmt = format->format;
> > +		return 0;
> > +#else
> > +		return -ENOTTY;
> > +#endif
> > +	}
> > +
> > +	ret = ov7670_try_fmt_internal(sd, &format->format, &info->fmt,
> > &info->wsize);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = ov7670_apply_fmt(sd);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> >  static int ov7670_get_fmt(struct v4l2_subdev *sd,
> >  			  struct v4l2_subdev_pad_config *cfg,
> >  			  struct v4l2_subdev_format *format)
> > @@ -1847,6 +1858,7 @@ static int ov7670_probe(struct i2c_client
> > *client,
> > 
> >  	info->devtype = &ov7670_devdata[id->driver_data];
> >  	info->fmt = &ov7670_formats[0];
> > +	info->wsize = &info->devtype->win_sizes[0];
> > 
> >  	ov7670_get_default_format(sd, &info->format);
> > 
> > --
> > 2.19.1
> > 
