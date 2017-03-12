Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55770 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755697AbdCLMPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 08:15:34 -0400
Date: Sun, 12 Mar 2017 13:15:08 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv5 09/16] ov2640: fix colorspace handling
In-Reply-To: <20170311112328.11802-10-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1703121313390.22698@axis700.grange>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
 <20170311112328.11802-10-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 11 Mar 2017, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The colorspace is independent of whether YUV or RGB is sent to the SoC.
> Fix this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I'm not sure why the first hunk is needed and how it is related :-) But it 
doesn't break anything. I understand, this patch should better go in as a 
part of a series, so

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/i2c/soc_camera/ov2640.c | 23 +++++++----------------
>  1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> index 56de18263359..b9a0069f5b33 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -794,10 +794,11 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
>  		dev_dbg(&client->dev, "%s: Selected cfmt YUYV (YUV422)", __func__);
>  		selected_cfmt_regs = ov2640_yuyv_regs;
>  		break;
> -	default:
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
> +	default:
>  		dev_dbg(&client->dev, "%s: Selected cfmt UYVY", __func__);
>  		selected_cfmt_regs = ov2640_uyvy_regs;
> +		break;
>  	}
>  
>  	/* reset hardware */
> @@ -865,17 +866,7 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
>  	mf->width	= priv->win->width;
>  	mf->height	= priv->win->height;
>  	mf->code	= priv->cfmt_code;
> -
> -	switch (mf->code) {
> -	case MEDIA_BUS_FMT_RGB565_2X8_BE:
> -	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> -		mf->colorspace = V4L2_COLORSPACE_SRGB;
> -		break;
> -	default:
> -	case MEDIA_BUS_FMT_YUYV8_2X8:
> -	case MEDIA_BUS_FMT_UYVY8_2X8:
> -		mf->colorspace = V4L2_COLORSPACE_JPEG;
> -	}
> +	mf->colorspace	= V4L2_COLORSPACE_SRGB;
>  	mf->field	= V4L2_FIELD_NONE;
>  
>  	return 0;
> @@ -897,17 +888,17 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
>  	ov2640_select_win(&mf->width, &mf->height);
>  
>  	mf->field	= V4L2_FIELD_NONE;
> +	mf->colorspace	= V4L2_COLORSPACE_SRGB;
>  
>  	switch (mf->code) {
>  	case MEDIA_BUS_FMT_RGB565_2X8_BE:
>  	case MEDIA_BUS_FMT_RGB565_2X8_LE:
> -		mf->colorspace = V4L2_COLORSPACE_SRGB;
> +	case MEDIA_BUS_FMT_YUYV8_2X8:
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
>  		break;
>  	default:
>  		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
> -	case MEDIA_BUS_FMT_YUYV8_2X8:
> -	case MEDIA_BUS_FMT_UYVY8_2X8:
> -		mf->colorspace = V4L2_COLORSPACE_JPEG;
> +		break;
>  	}
>  
>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> -- 
> 2.11.0
> 
