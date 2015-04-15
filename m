Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54410 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbbDOUJK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Apr 2015 16:09:10 -0400
Date: Wed, 15 Apr 2015 22:08:53 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 1/7] v4l2: replace enum_mbus_fmt by enum_mbus_code
In-Reply-To: <1428574888-46407-2-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1504152204330.32631@axis700.grange>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
 <1428574888-46407-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 9 Apr 2015, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Replace all calls to the enum_mbus_fmt video op by the pad
> enum_mbus_code op and remove the duplicate video op.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kamil Debski <k.debski@samsung.com>
> ---

[snip]

> diff --git a/drivers/media/i2c/soc_camera/mt9m111.c b/drivers/media/i2c/soc_camera/mt9m111.c
> index 441e0fd..ef8682c 100644
> --- a/drivers/media/i2c/soc_camera/mt9m111.c
> +++ b/drivers/media/i2c/soc_camera/mt9m111.c
> @@ -839,13 +839,14 @@ static struct v4l2_subdev_core_ops mt9m111_subdev_core_ops = {
>  #endif
>  };
>  
> -static int mt9m111_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
> -			    u32 *code)
> +static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
> +		struct v4l2_subdev_pad_config *cfg,
> +		struct v4l2_subdev_mbus_code_enum *code)
>  {
> -	if (index >= ARRAY_SIZE(mt9m111_colour_fmts))
> +	if (code->code || code->index >= ARRAY_SIZE(mt9m111_colour_fmts))

Didn't you mean 

+	if (code->pad || code->index >= ARRAY_SIZE(mt9m111_colour_fmts))

?

>  		return -EINVAL;
>  
> -	*code = mt9m111_colour_fmts[index].code;
> +	code->code = mt9m111_colour_fmts[code->index].code;
>  	return 0;
>  }
>  
> @@ -871,13 +872,17 @@ static struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
>  	.s_crop		= mt9m111_s_crop,
>  	.g_crop		= mt9m111_g_crop,
>  	.cropcap	= mt9m111_cropcap,
> -	.enum_mbus_fmt	= mt9m111_enum_fmt,
>  	.g_mbus_config	= mt9m111_g_mbus_config,
>  };
>  
> +static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
> +	.enum_mbus_code = mt9m111_enum_mbus_code,
> +};
> +
>  static struct v4l2_subdev_ops mt9m111_subdev_ops = {
>  	.core	= &mt9m111_subdev_core_ops,
>  	.video	= &mt9m111_subdev_video_ops,
> +	.pad	= &mt9m111_subdev_pad_ops,
>  };
>  
>  /*

[snip]

Apart from that for soc-camera:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
