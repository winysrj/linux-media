Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:49680 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934826AbcIVVzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 17:55:03 -0400
Date: Thu, 22 Sep 2016 16:52:18 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] media: i2c: tvp514x: Reported mbus format should be
 MEDIA_BUS_FMT_UYVY8_2X8
Message-ID: <20160922215218.GD23415@ti.com>
References: <20160914200313.13334-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20160914200313.13334-1-bparrot@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gentle ping!

Benoit

Benoit Parrot <bparrot@ti.com> wrote on Wed [2016-Sep-14 15:03:13 -0500]:
> The advertised V4L2 pixel format and Media Bus code don't match.
> The current media bud code advertised is MEDIA_BUS_FMT_YUYV8_2X8
> which does not reflect what the encoder actually outputs.
> This encoder generate MEDIA_BUS_FMT_UYVY8_2X8 so advertise as such.
> 
> Signed-off-by: Benoit Parrot <bparrot@ti.com>
> ---
>  drivers/media/i2c/tvp514x.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 7cf749fc7143..b611eefa1a97 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -894,7 +894,7 @@ static int tvp514x_enum_mbus_code(struct v4l2_subdev *sd,
>  	if (index != 0)
>  		return -EINVAL;
>  
> -	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
> +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
>  
>  	return 0;
>  }
> @@ -922,7 +922,7 @@ static int tvp514x_get_pad_format(struct v4l2_subdev *sd,
>  		return 0;
>  	}
>  
> -	format->format.code = MEDIA_BUS_FMT_YUYV8_2X8;
> +	format->format.code = MEDIA_BUS_FMT_UYVY8_2X8;
>  	format->format.width = tvp514x_std_list[decoder->current_std].width;
>  	format->format.height = tvp514x_std_list[decoder->current_std].height;
>  	format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
> @@ -946,7 +946,7 @@ static int tvp514x_set_pad_format(struct v4l2_subdev *sd,
>  	struct tvp514x_decoder *decoder = to_decoder(sd);
>  
>  	if (fmt->format.field != V4L2_FIELD_INTERLACED ||
> -	    fmt->format.code != MEDIA_BUS_FMT_YUYV8_2X8 ||
> +	    fmt->format.code != MEDIA_BUS_FMT_UYVY8_2X8 ||
>  	    fmt->format.colorspace != V4L2_COLORSPACE_SMPTE170M ||
>  	    fmt->format.width != tvp514x_std_list[decoder->current_std].width ||
>  	    fmt->format.height != tvp514x_std_list[decoder->current_std].height)
> -- 
> 2.9.0
> 
