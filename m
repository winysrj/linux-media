Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45913 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932719AbcAYMsv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 07:48:51 -0500
Date: Mon, 25 Jan 2016 10:48:42 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	Enrico Butera <ebutera@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Eduard Gavin <egavinc@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 03/10] [media] tvp5150: Add pad-level subdev
 operations
Message-ID: <20160125104842.26ca46cf@recife.lan>
In-Reply-To: <1452170810-32346-4-git-send-email-javier@osg.samsung.com>
References: <1452170810-32346-1-git-send-email-javier@osg.samsung.com>
	<1452170810-32346-4-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  7 Jan 2016 09:46:43 -0300
Javier Martinez Canillas <javier@osg.samsung.com> escreveu:

> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> This patch enables the tvp5150 decoder driver to be used with the media
> controller framework by adding pad-level subdev operations and init the
> media entity pad.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> ---
> 
> Changes in v2: None
> 
>  drivers/media/i2c/tvp5150.c | 60 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 45 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index b3b34e24db13..82fba9d46f30 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -35,6 +35,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
>  
>  struct tvp5150 {
>  	struct v4l2_subdev sd;
> +	struct media_pad pad;
>  	struct v4l2_ctrl_handler hdl;
>  	struct v4l2_rect rect;
>  
> @@ -818,17 +819,6 @@ static v4l2_std_id tvp5150_read_std(struct v4l2_subdev *sd)
>  	}
>  }
>  
> -static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
> -		struct v4l2_subdev_pad_config *cfg,
> -		struct v4l2_subdev_mbus_code_enum *code)
> -{
> -	if (code->pad || code->index)
> -		return -EINVAL;
> -
> -	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
> -	return 0;
> -}
> -
>  static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
>  		struct v4l2_subdev_pad_config *cfg,
>  		struct v4l2_subdev_format *format)
> @@ -841,13 +831,11 @@ static int tvp5150_fill_fmt(struct v4l2_subdev *sd,
>  
>  	f = &format->format;
>  
> -	tvp5150_reset(sd, 0);
> -
>  	f->width = decoder->rect.width;
> -	f->height = decoder->rect.height;
> +	f->height = decoder->rect.height / 2;
>  
>  	f->code = MEDIA_BUS_FMT_UYVY8_2X8;
> -	f->field = V4L2_FIELD_SEQ_TB;
> +	f->field = V4L2_FIELD_ALTERNATE;
>  	f->colorspace = V4L2_COLORSPACE_SMPTE170M;

I don't think that the above changes belong to this patch. They look
to be a fix, so they should be on a separate patch.

>  
>  	v4l2_dbg(1, debug, sd, "width = %d, height = %d\n", f->width,
> @@ -948,6 +936,39 @@ static int tvp5150_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
>  	return 0;
>  }
>  
> + /****************************************************************************
> +			V4L2 subdev pad ops
> + ****************************************************************************/
> +
> +static int tvp5150_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index)
> +		return -EINVAL;
> +
> +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +	return 0;
> +}
> +
> +static int tvp5150_enum_frame_size(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct tvp5150 *decoder = to_tvp5150(sd);
> +
> +	if (fse->index >= 8 || fse->code != MEDIA_BUS_FMT_UYVY8_2X8)
> +		return -EINVAL;
> +
> +	fse->code = MEDIA_BUS_FMT_UYVY8_2X8;
> +	fse->min_width = decoder->rect.width;
> +	fse->max_width = decoder->rect.width;
> +	fse->min_height = decoder->rect.height / 2;
> +	fse->max_height = decoder->rect.height / 2;
> +
> +	return 0;
> +}
> +
>  /****************************************************************************
>  			I2C Command
>   ****************************************************************************/
> @@ -1088,6 +1109,7 @@ static const struct v4l2_subdev_vbi_ops tvp5150_vbi_ops = {
>  
>  static const struct v4l2_subdev_pad_ops tvp5150_pad_ops = {
>  	.enum_mbus_code = tvp5150_enum_mbus_code,
> +	.enum_frame_size = tvp5150_enum_frame_size,
>  	.set_fmt = tvp5150_fill_fmt,
>  	.get_fmt = tvp5150_fill_fmt,
>  };
> @@ -1165,6 +1187,14 @@ static int tvp5150_probe(struct i2c_client *c,
>  		return -ENOMEM;
>  	sd = &core->sd;
>  	v4l2_i2c_subdev_init(sd, c, &tvp5150_ops);
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	core->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	res = media_entity_pads_init(&sd->entity, 1, &core->pad);
> +	if (res < 0)
> +		return res;
> +#endif

Actually, you need to create two pads, one source and one sink.

At the sink pad, the will be the connectors: RF, S-Video and/or
Composite, depending on the board that has it.

Ok, adding support for it is not trivial, as it would likely
require some new callback, as the tvp5150 driver doesn't know how
this is wired on non-DT drivers.

The best would be to add MC support on em28xx, as there are some
devices there with tvp5150. I'll see if I find some time to write
such patches along the week.

>  
>  	res = tvp5150_detect_version(core);
>  	if (res < 0)
